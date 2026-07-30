Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB793AA187;
	Thu, 30 Jul 2026 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424801; cv=none; b=N/GFjqYcgCk/Me/T4v2IOBpsqcoWOlys0Fu48FFrxc6FZjkgj9oa27ZhO8/EoifYbIlQNvwfGZ7+be8+cLmtZ/lDASW1EkfUKkeR9fcVLUzaS9Zsd02u5ug6faIJIzgI6tvnBsRyKaDxz9I2sq/8v08lECorhddrJOw125mM/P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424801; c=relaxed/simple;
	bh=bXiuiTmmmmOTUyJHPUztP+oLTvqOxP/6wHV2HK78T5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYsY2zPVU8MR7wLkeUDiSMAUZylBr5RVn9DdelMkiau0nXuxveII4kcTK9ciBSchPVkssB5ulvfnd78wmaeBAwD/roH7dTWrHP+II43Ti/NtRvlAS1S1nE/CKhpRcoC6KBuN4TcOy0QUC7P5GyqWskLfty2MyRvpmUTLIPkKr0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3AYGYoz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3AYGYoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53FC1F000E9;
	Thu, 30 Jul 2026 15:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424800;
	bh=ytW6hAzXr8qyq0GX2txbDsvR1WL6vrKMMIKe5+gCo6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3AYGYozm8P3Tcsceo8aixtExrsoal9FpEZw2r1FctovGcz2Yz0dPvLF+LL5wX9qf
	 aMCkqAfy7K9z8w3HzAibh+d3OdOuyK5fRM6Xg+sKGdcgWO0PWqLfNKFme9r/K6dSNH
	 eCkdbZAAmio4LUJ0XosiTNJIJZmiYkP3RWOdl/is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 504/675] afs: Fix afs_edit_dir_remove() to get, not find, block 0
Date: Thu, 30 Jul 2026 16:13:54 +0200
Message-ID: <20260730141455.839076418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 62d9853aa4ce6e9797b6949804891be14b219752 upstream.

Fix afs_edit_dir_remove() to use afs_dir_get_block() to get block 0 rather
than afs_dir_find_block() as the latter caches the found block in the
afs_dir_iter and may[*] switch out the page it's on if another
afs_dir_find_block() is done.  This parallels what afs_edit_dir_add() does.

[*] There's more than one block per page.

Fixes: a5b5beebcf96 ("afs: Use the contained hashtable to search a directory")
Closes: https://sashiko.dev/#/patchset/20260706153408.1231650-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/2380759.1783956175@warthog.procyon.org.uk
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/dir_edit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/afs/dir_edit.c
+++ b/fs/afs/dir_edit.c
@@ -415,7 +415,7 @@ void afs_edit_dir_remove(struct afs_vnod
 	if (!afs_dir_init_iter(&iter, name))
 		return;
 
-	meta = afs_dir_find_block(&iter, 0);
+	meta = afs_dir_get_block(&iter, 0);
 	if (!meta)
 		return;
 


