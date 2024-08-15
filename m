Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A28817CA1D;
	Thu, 15 Aug 2024 13:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728836; cv=none; b=SxvlOx8xCkYpceSjfhrCLMf1GZQL6ASIPI0jwLZF5gFnZfC/Y3lY7UEV9ns2UuQSAph+RLclncODTTBAdVb5ks7uWk6HgZVCsfXd/Y5Fe/dFbLb7Id+zV1p5PCB3xduLVh5z3MdyN8j41hO4NY6ccs4yBnmc6M2zDqbN4kBqZsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728836; c=relaxed/simple;
	bh=o5yAfhIEhXWqgat/wTBk/aBdHtmaGPkbA1C0UBsf6AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZdVqRa5JmtvbGJHimBe9Rue3gBQMw5j9FAvhXIswPhJqNQML3+uxqBpbe5Zgri2I+6er0kWllAREEeucXMUUpK9rfupxqoqqrpnvfZOBJ/Ng0bM+e57Hizo7ZvZVqdv1WMH+Vl23mgLNeSS26lNpkI52OWesPTJwdXGqkwWNqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFjx6qD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFjx6qD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81C0C32786;
	Thu, 15 Aug 2024 13:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728836;
	bh=o5yAfhIEhXWqgat/wTBk/aBdHtmaGPkbA1C0UBsf6AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFjx6qD/FFATdshZnFtc+embikqPq+3ptsPwYWd+PJYEQEqkHgNjrwwR9gTc5b/ip
	 hWCATuGWcRE5qCKDYAirYIKks/iMRcCa2U9t0jnMw55LT4ftjjIsgtGetdI9mAjZUF
	 6nsEcT5XokAWeUKeHOf3ZKAgwDIDnM9NRluyLPQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.19 126/196] protect the fetch of ->fd[fd] in do_dup2() from mispredictions
Date: Thu, 15 Aug 2024 15:24:03 +0200
Message-ID: <20240815131856.897342172@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 8aa37bde1a7b645816cda8b80df4753ecf172bf1 upstream.

both callers have verified that fd is not greater than ->max_fds;
however, misprediction might end up with
        tofree = fdt->fd[fd];
being speculatively executed.  That's wrong for the same reasons
why it's wrong in close_fd()/file_close_fd_locked(); the same
solution applies - array_index_nospec(fd, fdt->max_fds) could differ
from fd only in case of speculative execution on mispredicted path.

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/file.c
+++ b/fs/file.c
@@ -879,6 +879,7 @@ __releases(&files->file_lock)
 	 * tables and this condition does not arise without those.
 	 */
 	fdt = files_fdtable(files);
+	fd = array_index_nospec(fd, fdt->max_fds);
 	tofree = fdt->fd[fd];
 	if (!tofree && fd_is_open(fd, fdt))
 		goto Ebusy;


