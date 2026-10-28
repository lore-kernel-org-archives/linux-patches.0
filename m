Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208807;
	b=U3x+5h9EyUXB8PevXcNBhn2jxdcBDN5dqv1s7+Pv/juks/t0AyvAs56QMWBMB0K/hj/U
	 JWQsBGoMZfvF+ILuKMfDALnZn1R32wnEEsLplgi5OwDFhR3fQAgImFB8wlOcZbyKvfrji
	 tKSlFSKYgxPRffCMextIAOhRfEPVP+MPpBwTejUwPsHefHlyDMYYOGKVP1GbmvjoJ1ebJ
	 p89rN2iCNBfsC1i3CbojwBtm9MA7yd4dnFU8LBajIu4yMEIxTnp+RYp++GazNfQu0XEN5
	 ESsvSPaNjR3Xzqovcc14cv+eidv9uxpJ+6meGYLv5ymrAOV3GgVoARKgZzqs4XqAlUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=49FWUFhGB3bm5zLn6zrz4/Yk/EG7xtyI4GRgwb7JqQU=;
	b=m9+QLkN42MTYRDg3aXVVGRRP1n72e5gwhf7rF+Gw9lTRHbDwgzb0h8qZ1tOhVCTd/cTz
	 +lfAEZmusrNyk3I6jfhiyrJHg3pZD1oR+7XUjrlLwYzOReJSqlivHLktdRIjxUQIRv3P6
	 ObGSHlcFCxoXbEyDR9rtMPb3dwslvg9J4of7xu9Dt34IUk0n8vIt0u9CcxXQiH2uy5nTn
	 VuZt6dutz7yFHzA7WvmdOVOMnwpQbw6oYbj2pWRk09d5ZY7wOIvcOisxe/+I6lsISaGBA
	 zJ4s2ZW3oirA6HRPErxgwvGC5G66wnCn/Ue8YZPyEZZVEHk3F1v5WUQRxruUhSiltcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkrIqxhx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83876606A31A;
	Wed, 28 Oct 2026 17:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkrIqxhx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5C81F01825;
	Wed, 28 Oct 2026 17:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208807;
	bh=49FWUFhGB3bm5zLn6zrz4/Yk/EG7xtyI4GRgwb7JqQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkrIqxhx14Wrman5krDJmXoIgWz18D8Ot3cZHazPGL+NM8Cvog9jf8BPH/gvMcgPo
	 qYe2AhOz8Mffxno7iYoDSte4aYSTp4+tHDxPgRM0uNEYrTdspaZ7yvAxK+9mdoxilR
	 xHyAect8dvc6FGmVE/TUMoNJi0wTCBiqay4IH0H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yi Yang <yiyang13@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 250/516] vc_screen: reload vc pointer before if (ret) in vcs_write() to avoid UAF
Date: Wed, 28 Oct 2026 17:56:42 +0100
Message-ID: <20261028170009.419256980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit 226bd5603371cd9f6642cbb9e9a677f445de3530 ]

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
[ sashal: Adapted the -ENXIO error return to use the existing unlock_out cleanup path. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vc_screen.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 27b44dc123859..22735ca14395a 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -643,6 +643,19 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
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
+			ret = -ENXIO;
+			goto unlock_out;
+		}
+
 		if (ret) {
 			this_round -= ret;
 			if (!this_round) {
@@ -655,18 +668,6 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 				goto unlock_out;
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
-			ret = -ENXIO;
-			goto unlock_out;
-		}
 		size = vcs_size(vc, attr, false);
 		if (size < 0) {
 			if (written)
-- 
2.53.0



