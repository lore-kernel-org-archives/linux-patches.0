Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDF154765;
	Wed,  6 Nov 2024 13:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898982; cv=none; b=R4nYuYgcwi/MFIr6mLq2DAadAl9+sLw9oSPu7UIHgvEY/EcIHFNa/+iis1p1TZpRxD74Rum1ITOQAx0tIK4CzXhFJl5xTv+P/Uhv/0+uQQGNCO+sZOtCNINs2FSGHjpnjgONwJiK4hP0ywWly3PyTD58q+UJIXXNteh+jfXlijc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898982; c=relaxed/simple;
	bh=meTliNa0z++TCe4t3OBSoy1Bbu0v6FgyO1150xzl8FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiZnQ6zLzgQ+IHaHcRortlhYUdU4x9pswP10ueQG8+thXh13lXd0LBF2f+R+CdpSROfxjarCaeYKysCfl7rIsT072i9ZMla/CdNh1nFMlVfQ8iESZRQJIeioPBu1QJhmsgDZp93VlIGAYA/hjcn3ZB3sKrvvTmvTgcGwloRM1+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0/EIYHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0/EIYHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17792C4CECD;
	Wed,  6 Nov 2024 13:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898982;
	bh=meTliNa0z++TCe4t3OBSoy1Bbu0v6FgyO1150xzl8FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0/EIYHsFx+soVxAXSrgbHZ0gXnLyy+RVkPNryB7l14XGZymIJW0JqUI4cDNncKyd
	 QNU15OwYlzchLoT4gIuIfq4l/CDATNeFb6mOvPvB/aKijEzvw8dflHDb0UDfuIZur3
	 9XDYOLKsXTC09ibLbPaY9gVDmRgWAqoGlZJmMBwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+985ada84bf055a575c07@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.4 420/462] nilfs2: fix kernel bug due to missing clearing of buffer delay flag
Date: Wed,  6 Nov 2024 13:05:13 +0100
Message-ID: <20241106120341.889262769@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 6ed469df0bfbef3e4b44fca954a781919db9f7ab upstream.

Syzbot reported that after nilfs2 reads a corrupted file system image
and degrades to read-only, the BUG_ON check for the buffer delay flag
in submit_bh_wbc() may fail, causing a kernel bug.

This is because the buffer delay flag is not cleared when clearing the
buffer state flags to discard a page/folio or a buffer head. So, fix
this.

This became necessary when the use of nilfs2's own page clear routine
was expanded.  This state inconsistency does not occur if the buffer
is written normally by log writing.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Link: https://lore.kernel.org/r/20241015213300.7114-1-konishi.ryusuke@gmail.com
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Reported-by: syzbot+985ada84bf055a575c07@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=985ada84bf055a575c07
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/page.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -78,7 +78,8 @@ void nilfs_forget_buffer(struct buffer_h
 	const unsigned long clear_bits =
 		(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
 		 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
-		 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected));
+		 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected) |
+		 BIT(BH_Delay));
 
 	lock_buffer(bh);
 	set_mask_bits(&bh->b_state, clear_bits, 0);
@@ -410,7 +411,8 @@ void nilfs_clear_dirty_page(struct page
 		const unsigned long clear_bits =
 			(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
 			 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
-			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected));
+			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected) |
+			 BIT(BH_Delay));
 
 		bh = head = page_buffers(page);
 		do {


