Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5023419F470;
	Thu, 15 Aug 2024 13:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730228; cv=none; b=blTHb1WclsjeOo95+5n8yW4SzWz6FWYaQ/Id3JtKwZyksw40GLAE248y/NgGXeAoBxWHr05OBQJFnuGDmm6e56cC+JmYEArMDCfU4rDofARC+PBUlr8VtcencJ23ECg0mK0k5d/VLhCW4DYfxeI0HvG7aXd3nnWEfaDJbctN5sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730228; c=relaxed/simple;
	bh=EeglIGJJta+nA9c3vmml8ules9kKrs4TMVZIoMuXvTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1E7p0gv09QA23TQ4OKEw5gEmu+nbijbWqjumy6ill/TWmGHGxiqqdfsvnMhWQJraJRXnhEVW/VrD9kO4j/g85jTGGYAf+dqojzWo8+H0+hG0ViAjFKD0bNT9hZi5Wwda+zGhWOzE9v9NxZuNswDViLhHJShHyXy/ajx/UbuRoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGZt04aV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGZt04aV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1EFC32786;
	Thu, 15 Aug 2024 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730228;
	bh=EeglIGJJta+nA9c3vmml8ules9kKrs4TMVZIoMuXvTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGZt04aVFYRiYwANJtSQ1mY8i99j06qNQWGHRoCn3bE4kGs0+AxrqlwjHM+t3CRGA
	 tKxdaoRHxUEv9edMiyEoH/Fbn+R2YkBd1p2D6/rYIL+ETrvBz197/k6Q2Ik05et1ln
	 4hJLqKHvehDhsjT77vjj4yDlYvWiwWu03BcmIvZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.15 344/484] protect the fetch of ->fd[fd] in do_dup2() from mispredictions
Date: Thu, 15 Aug 2024 15:23:22 +0200
Message-ID: <20240815131954.707901929@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1148,6 +1148,7 @@ __releases(&files->file_lock)
 	 * tables and this condition does not arise without those.
 	 */
 	fdt = files_fdtable(files);
+	fd = array_index_nospec(fd, fdt->max_fds);
 	tofree = fdt->fd[fd];
 	if (!tofree && fd_is_open(fd, fdt))
 		goto Ebusy;


