Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D01823A9;
	Wed,  7 Aug 2024 15:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043458; cv=none; b=lmv1Ztafb2DPHfN9PnY6ux4aFeNT6db4s6aTsvaQfQvUlMeCo3d7j1ba9zqJoxvrMXJS2Q2jqdAOjsJStqcunXoONwfWjJPsxqwNUlLlC6KxMIA0nFXRAtcfbkbY4Yt1RPp5iJaz1b5PlXBhHmMdHypR837tHGK0OFxmA58OV4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043458; c=relaxed/simple;
	bh=FrkFCZH1Y4/nMmK42RH999nGllSNp8Zj6CumgJZrtlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKwAJsw01AplIHNKWZV70yLOLZF3Pqpglua/mEt8ckwUHOtaQGZHRGJw3qoTG3B5NxGCiJN36e4CemixyhGA7whf4b4mWRk6i/RMYw3WMChJTTFguvFUTjEFr5SkAtkzEdL7g3kfAjCwzZHPfUK8XZhfUBJ/ygG+9TTpEkYl2SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgGkS2gl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgGkS2gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B989C32781;
	Wed,  7 Aug 2024 15:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043458;
	bh=FrkFCZH1Y4/nMmK42RH999nGllSNp8Zj6CumgJZrtlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgGkS2glcGhG9M3DkWuaRiFYM8czg/AFvRH/gyPQ/KNYAstU+UtY36q78myXA+aQd
	 DbcNSVUUgKOHVjaQHnM9PTVibkrHyoH9MoGPi7Qric0eUGDG1/wXbuamBtRxO9/yKD
	 UbGbyzQVMTejdnE5JUwYrU52xCNk1L8Ubcc2pS6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.6 099/121] protect the fetch of ->fd[fd] in do_dup2() from mispredictions
Date: Wed,  7 Aug 2024 17:00:31 +0200
Message-ID: <20240807150022.635978319@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1124,6 +1124,7 @@ __releases(&files->file_lock)
 	 * tables and this condition does not arise without those.
 	 */
 	fdt = files_fdtable(files);
+	fd = array_index_nospec(fd, fdt->max_fds);
 	tofree = fdt->fd[fd];
 	if (!tofree && fd_is_open(fd, fdt))
 		goto Ebusy;


