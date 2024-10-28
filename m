Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DA018EFF3;
	Mon, 28 Oct 2024 06:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098471; cv=none; b=XYc20HmrijGpRaasFwtlJtXc6Jk3vL7w+pNxUrETDVo8aqje1chOuQO17TQaMi7BE1qOeUjoflhV47GvFCZcdngynI64ogGiBPiHTPL2RNpbeiJ/a6PYgoO2MInIhMVuVXpoM+mCcKYQn7KUVYzrlNbDTRduvLz849vkOWKNJr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098471; c=relaxed/simple;
	bh=OAdOKIkFM5GUr/iCQK8zpG06+n1O72wE2e3+ngc4p9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHmrzc+qsGiIIroVbdztSvbxIV7Fy5KNEaUyb7cfxlgKtCEo76r8Et76xOu/7Jt0tQfm2xHmDXHHoJFAWPk0ItgNhYnDWmhfyxXtwgusyl1uMCjVmheEj7aHNFANaP+TRa0HJDaDi7rZ12g83PBeZNtvnktQa7SKw9kkQCVVVQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDP88udz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDP88udz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8208C4CEC3;
	Mon, 28 Oct 2024 06:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098471;
	bh=OAdOKIkFM5GUr/iCQK8zpG06+n1O72wE2e3+ngc4p9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDP88udzN3gqE3PD6bbkr9D72E+z1lgW813V5FE39gZpc2LI6QQRQSy+F30UifH89
	 liGiTqCy3jXS956PFt2tcVTWolTyzgA5/m95e/sxf5/uSf3y3QVo0O6ifuk3ghyzjB
	 A3C1ymeo6E9JUsuBZYgvDl1p5DcQccKsliCldMEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+985ada84bf055a575c07@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.11 214/261] nilfs2: fix kernel bug due to missing clearing of buffer delay flag
Date: Mon, 28 Oct 2024 07:25:56 +0100
Message-ID: <20241028062317.453386145@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -77,7 +77,8 @@ void nilfs_forget_buffer(struct buffer_h
 	const unsigned long clear_bits =
 		(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
 		 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
-		 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected));
+		 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected) |
+		 BIT(BH_Delay));
 
 	lock_buffer(bh);
 	set_mask_bits(&bh->b_state, clear_bits, 0);
@@ -414,7 +415,8 @@ void nilfs_clear_folio_dirty(struct foli
 		const unsigned long clear_bits =
 			(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
 			 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
-			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected));
+			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected) |
+			 BIT(BH_Delay));
 
 		bh = head;
 		do {


