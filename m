Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB06582D70;
	Wed,  7 Aug 2024 15:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043706; cv=none; b=ETHgNqab5Ys5XiBvltiibbcCkNqwhc7BzPilMFDAPDkjkuvAh+n7Wd8owXpitFhcW0K38jNsMSRswc0nUjT9NXkMvH1xZcg0ikuJySPXvMJkD0kRl9IlE5je9zZm03GtS+WoxWkI2m6sl2yjUhQ8KW5MkRtnw2VS4p1Q1i8Ejvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043706; c=relaxed/simple;
	bh=uFn6ociwLVuUh9NhFczluQWN8lJyjdyiuU3MsIKcEMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZzcypWKnZ0689UWgR0OpJxihmaJQhcCZR4g42L5khIlQjgQaGzKpWWxUW7MrFTt4YAiEJFb3bnzCSfmGmjjvrgkNj6nfhwuiulIsXhLAMBri4ZuRJezda8Wqlco3BtD9QAPyo7bqG2x42FWiD3WYIJvddg/9InoxHxQ7Fzb/7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYueFgjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYueFgjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDDAC32781;
	Wed,  7 Aug 2024 15:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043705;
	bh=uFn6ociwLVuUh9NhFczluQWN8lJyjdyiuU3MsIKcEMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYueFgjRUvXv5x7Du0oph3FZRdBTkU4lNhEdQDdR+yQzIVxxvKCPvpqchOdF7W39x
	 qY8l3zbajFjxEMxF4fCvsXtbXwmbtQ//wmhPaa062epKvg3DxRRTQNiIvJ3Rat7tKI
	 QPmEtRQU2RiaOOC9YlsfT2agQ62/oaovQfXKEOko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.1 70/86] protect the fetch of ->fd[fd] in do_dup2() from mispredictions
Date: Wed,  7 Aug 2024 17:00:49 +0200
Message-ID: <20240807150041.575513462@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1122,6 +1122,7 @@ __releases(&files->file_lock)
 	 * tables and this condition does not arise without those.
 	 */
 	fdt = files_fdtable(files);
+	fd = array_index_nospec(fd, fdt->max_fds);
 	tofree = fdt->fd[fd];
 	if (!tofree && fd_is_open(fd, fdt))
 		goto Ebusy;


