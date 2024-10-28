Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E35915B10D;
	Mon, 28 Oct 2024 06:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097416; cv=none; b=LyPyIexmP/OMfvhw5jSBQ6R6tgsM5CBgpsSTRbvvEZT2J48WZolExuDM5iIdqrW1DR5htVEiIxmq/Grs79FKbCZDd9BkIBv/GegJTE6hxqJ+rDBh/begjmTbaUGkd6iGOYxK9jkcU5qyj9zPZkQz76oHMT4yWd0JnAtqw1hJr1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097416; c=relaxed/simple;
	bh=+llCJNDaDPrW2BX7QaoZRgha8PT+QKuwV1tn+HpDEDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFpTSDHKNwmGYsitU801Nc+xDT/x0YrYoczyTKeFmOvLcj4HLcFX1IGEzHbNuk9M5ZhInvpgnaSr6KOk49dxMhU4kJMg9dy12HQ1KkX1ZearQT/m+l4NFN8OMBYy+Fw6GqV90eQmhXvzhloZybmMBy+/Z+Cte2Tr27fEj23ronQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5U6+6XA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5U6+6XA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18FCC4CEC3;
	Mon, 28 Oct 2024 06:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097416;
	bh=+llCJNDaDPrW2BX7QaoZRgha8PT+QKuwV1tn+HpDEDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5U6+6XAaDszu9dtvEJkVLIkd45aKeNoQjSrsVFrSXiIHbwzZAUiR1835x1nb3mQZ
	 PYVBV27VbHXU1DwlCn9vHgmoadzbs7JxXsHO6Lcnn6D+8CzWyx/J7wDbcJqJJVn0Ye
	 fDSn1P6hdgtyU4xdluLhyY2Bs7X+gneyCYQyUNRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+985ada84bf055a575c07@syzkaller.appspotmail.com,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 121/137] nilfs2: fix kernel bug due to missing clearing of buffer delay flag
Date: Mon, 28 Oct 2024 07:25:58 +0100
Message-ID: <20241028062302.090678456@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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
@@ -409,7 +410,8 @@ void nilfs_clear_dirty_page(struct page
 		const unsigned long clear_bits =
 			(BIT(BH_Uptodate) | BIT(BH_Dirty) | BIT(BH_Mapped) |
 			 BIT(BH_Async_Write) | BIT(BH_NILFS_Volatile) |
-			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected));
+			 BIT(BH_NILFS_Checked) | BIT(BH_NILFS_Redirected) |
+			 BIT(BH_Delay));
 
 		bh = head = page_buffers(page);
 		do {


