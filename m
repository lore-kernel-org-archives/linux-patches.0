Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6369D13BC38;
	Thu, 23 May 2024 13:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470174; cv=none; b=bH5EiTljQ8c0mF6jTFtbkN0xh56EMPlrMl6NilIQV4pIOM1ZvmRDpEqfGKzLFwAa6ml8ETaAVG9IugDibAPAJRH0Vc7QvCXgNFGHtTeLf5dktNvEhIoWOiK3dGYJ/J8dy0TiImex1TVAWh0df0AYBM5gVH/G0wjGho2Z16kz+lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470174; c=relaxed/simple;
	bh=R1NvdflBn+znU0HAU3EcWFUPbkXI69rhxt+bnF7Lf0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tl3YZJnFSMoeFz/mloD91bbfg/3ZKlAUmNltblwwMuNl/03qfh44/mqMruT7TvdL0wEOWpcBSOUg72IkFtVnYVzAJbJH5je72x8wHyVM2q9NOWLv9exfkUJFy3z704QR0Ekm8f3p6U8AIp2VtspnaALyq7eXg6lDZAGA4JXo3QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rij0uOE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rij0uOE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D515FC2BD10;
	Thu, 23 May 2024 13:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470174;
	bh=R1NvdflBn+znU0HAU3EcWFUPbkXI69rhxt+bnF7Lf0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rij0uOE/kpe231I0u9KzUjyHBiWvtUtxXih1xSLVgNLYHUR1c7+viwIlpM8+KwJ/k
	 pxOzcMztFBTdJ4S/xUL2VRbHsAZS1V9vZeV1ri5FZ1y4a6uUGT/6K9HdUOGKNGZ/sh
	 81cPag4JXUYwDLa7PK2HTUwRQFj37GK6ZByLRe+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@denx.de>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 11/15] btrfs: add missing mutex_unlock in btrfs_relocate_sys_chunks()
Date: Thu, 23 May 2024 15:12:53 +0200
Message-ID: <20240523130326.882403497@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130326.451548488@linuxfoundation.org>
References: <20240523130326.451548488@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <dominique.martinet@atmark-techno.com>

commit 9af503d91298c3f2945e73703f0e00995be08c30 upstream.

The previous patch that replaced BUG_ON by error handling forgot to
unlock the mutex in the error path.

Link: https://lore.kernel.org/all/Zh%2fHpAGFqa7YAFuM@duo.ucw.cz
Reported-by: Pavel Machek <pavel@denx.de>
Fixes: 7411055db5ce ("btrfs: handle chunk tree lookup error in btrfs_relocate_sys_chunks()")
CC: stable@vger.kernel.org
Reviewed-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3194,6 +3194,7 @@ again:
 			 * alignment and size).
 			 */
 			ret = -EUCLEAN;
+			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
 			goto error;
 		}
 


