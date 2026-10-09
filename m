Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E9D46D2A3;
	Fri,  9 Oct 2026 14:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555745; cv=none; b=rF4sU5YpGp6UPGKC6ruHkmV+grkYSheWFV6h6nxaAxUaBTirQop/BiQtdlcnSZZUhDKWSPvp1xjMyLQCeOOMaNaM3VPib7m1q1xvF6nyhxka0MLa5A20/jxVM2YFpDyAW6E1mGUgnYIMnKgQsmSCt/RBEp47LZdf/gECClJbpXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555745; c=relaxed/simple;
	bh=tNajtaz3arMQyVjEV20wHU2a+OwARptevT9Ff/Avo/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiirmUMIWMyck+IzoyxbWn98ZCVRD39KOhv3inuqZwCoCvQZJKqFfhnR0rBw1tITx1Boelv+akevI50BCjd2MUsgK7q15Q3SKsdMy/0oXVOeTsusXlWFSI4ZrDN8QemynV6QSMOkgT+WL6l3RoiIx9SR+KFnaQHuYwG21Mhy7SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQ/DG5bs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQ/DG5bs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947C31F000FF;
	Fri,  9 Oct 2026 14:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555744;
	bh=mifLnTkw1Y5y2glRtly/R+2EfVJgGqb9NEd7UEL9pDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQ/DG5bsxuyenTTm/HApgq0JaFIYO/4OrDc/WtUZV+LvpBDu+BWDqQ3+/yFbGfCTB
	 g6U5UfuKXK8TNRpuhVDbQ/zb7xvplLKUQSj2CZa3qkBRd8xs/DSVvklOHqfNbwUTFj
	 U2CGruY5CaZxeseTF7+CujDtUximjcoFEa9rG2es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yi Yang <yiyang13@huawei.com>
Subject: [PATCH 7.2 058/428] vc_screen: reload vc pointer before if (ret) in vcs_write() to avoid UAF
Date: Fri,  9 Oct 2026 16:06:35 +0200
Message-ID: <20261009140947.412227213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

commit 226bd5603371cd9f6642cbb9e9a677f445de3530 upstream.

The reload of 'vc' added by commit 8fb9ea65c9d1 ("vc_screen: reload load
of struct vc_data pointer in vcs_write() to avoid UAF") sits after the
'if (ret)' block, so the copy-failure break path exits the loop without
reloading vc. If the vc was kfree()'d via vc_port_destruct during the
unlocked copy_from_user() window, the post-loop
'if (written && vc) vcs_scr_updated(vc)' is reached with a stale
non-NULL vc. The '&& vc' guard from commit a287620312dc ("vc_screen:
fix null-ptr-deref in vcs_notifier() during concurrent vcs_write") only
handles the NULL case, not this stale-non-NULL case; vcs_notifier() then
reads param->vc->vc_num from freed memory:

  BUG: KASAN: slab-use-after-free in vcs_notifier+0x7c/0xd0
  Read of size 2 at addr ffff888007149190
  Call Trace:
   vcs_notifier+0x7c/0xd0
   atomic_notifier_call_chain+0x70/0xa0
   vcs_scr_updated+0x77/0xa0
   vcs_write+0x71b/0x7e0
  Allocated by task: vc_allocate -> con_install -> tty_open
  Freed by task: kfree <- vt_ioctl (VT_DISALLOCATE -> vc_port_destruct)

Move the reload to immediately after console_lock(), before 'if (ret)',
so every break path below passes a fresh vc to the post-loop
vcs_scr_updated().

Fixes: a287620312dc ("vc_screen: fix null-ptr-deref in vcs_notifier() during concurrent vcs_write")
Cc: stable@kernel.org
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Link: https://patch.msgid.link/20260901113131.2760010-1-yiyang13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vc_screen.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -633,6 +633,18 @@ vcs_write(struct file *file, const char
 		ret = copy_from_user(con_buf, buf, this_round);
 		console_lock();
 
+		/* The vc might have been freed or vcs_size might have changed
+		 * while we slept to grab the user buffer; recheck here, before
+		 * if (ret), so every break path below passes a fresh vc to the
+		 * post-loop vcs_scr_updated(). Return data written so far.
+		 */
+		vc = vcs_vc(inode, &viewed);
+		if (!vc) {
+			if (written)
+				break;
+			return -ENXIO;
+		}
+
 		if (ret) {
 			this_round -= ret;
 			if (!this_round) {
@@ -644,17 +656,6 @@ vcs_write(struct file *file, const char
 				return -EFAULT;
 			}
 		}
-
-		/* The vc might have been freed or vcs_size might have changed
-		 * while we slept to grab the user buffer, so recheck.
-		 * Return data written up to now on failure.
-		 */
-		vc = vcs_vc(inode, &viewed);
-		if (!vc) {
-			if (written)
-				break;
-			return -ENXIO;
-		}
 		size = vcs_size(vc, attr, false);
 		if (size < 0) {
 			if (written)


