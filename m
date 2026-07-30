Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB7B39A801;
	Thu, 30 Jul 2026 15:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424639; cv=none; b=GIuEhSToU3dRkjsRaK5sIiskD5inqSvub3UF5H+aA1ARSi5jir6okJRH7H+IPMoLoz+ofahvnPFdB6SvVsr0bYe4+FmxFeklY6pdwpqKH7PRi1nkSle8VyF9aDzoeHoW/7o8jbJX3i+NKM7PkQkurUejVdJPZE6Ppdz84/AkTtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424639; c=relaxed/simple;
	bh=d6mBGWyp0o3SUpy0g5WyljvzDN9ZbrEsU4Dv34xRfVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/NX0MBDHuLcUtAnwjiHU2C1Ey2yQnhPWosK0nczCJo1zLtcbs1WjJendVMFRlMgD+hrf4cmKe7Qlkpnak45o7TpqxOqxBkBEQfsdZev6CY7tsw67T5BtXNMD/7jUvAGy3Zt56UMRuLOF59VG9C0f3qYbyaGlzrv0pY8mHhkoFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhquQwR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhquQwR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662FF1F000E9;
	Thu, 30 Jul 2026 15:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424637;
	bh=1gzsJ7I8sJjZWFnn0NVWFawDPQ+x5cFHHSzkqYGczmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhquQwR/wY2TKIUbINfObVwLge2X0ltS9eRVYAe7XDno2LedUTwsgXjC+IsIClh6Q
	 utBgy4g9dn48L0WNna8rbk/8XBSIVYJ5pdQLDWXaNCatQR8myFWxIapQVuv3hukXdJ
	 1f/OIuqBoSkzALa4EGJgoniYiFdUbboRJCB/SB5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 465/675] Bluetooth: RFCOMM: Fix session UAF in set_termios
Date: Thu, 30 Jul 2026 16:13:15 +0200
Message-ID: <20260730141455.013971181@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit c783399efc22d035443f1dfbf2a09bf9562aaa5e upstream.

rfcomm_tty_set_termios() tests dlc->session without rfcomm_mutex and
later passes the pointer to rfcomm_send_rpn(). The latter dereferences
both session->initiator and session->sock. Meanwhile, krfcommd can
unlink the DLC and free the session while holding rfcomm_mutex.

The race can proceed as follows:

  TTY ioctl task                 krfcommd
  --------------                 --------
  load dlc->session
  enter rfcomm_send_rpn()
                                 lock rfcomm_mutex
                                 clear dlc->session
                                 free session
                                 unlock rfcomm_mutex
  read session->initiator

KASAN reported:

  BUG: KASAN: slab-use-after-free in rfcomm_send_rpn+0x297/0x2a0
  Read of size 4 at addr ffff88810012a850 by task poc/92

  Call Trace:
   rfcomm_send_rpn+0x297/0x2a0
   rfcomm_tty_set_termios+0x50d/0x850
   tty_set_termios+0x596/0x950
   set_termios+0x46a/0x6e0
   tty_mode_ioctl+0x152/0xbd0
   tty_ioctl+0x915/0x1240
   __x64_sys_ioctl+0x134/0x1c0

  Allocated by task 92:
   rfcomm_session_add+0x9e/0x2e0
   rfcomm_dlc_open+0x8b1/0xe00
   rfcomm_dev_activate+0x85/0x1a0
   rfcomm_tty_open+0x90/0x280

  Freed by task 68:
   kfree+0x131/0x3c0
   rfcomm_session_del+0x119/0x180
   rfcomm_run+0x737/0x4710

Add rfcomm_dlc_send_rpn(), which holds rfcomm_mutex while it verifies
that the DLC is still attached and sends the RPN frame. Have the TTY
path use the helper and drop its unlocked session check. This keeps the
session valid through both the frame construction and socket send.

Fixes: 3a5e903c09ae ("[Bluetooth]: Implement RFCOMM remote port negotiation")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/rfcomm.h |    3 +++
 net/bluetooth/rfcomm/core.c    |   17 +++++++++++++++++
 net/bluetooth/rfcomm/tty.c     |    7 +++----
 3 files changed, 23 insertions(+), 4 deletions(-)

--- a/include/net/bluetooth/rfcomm.h
+++ b/include/net/bluetooth/rfcomm.h
@@ -229,6 +229,9 @@ int rfcomm_send_rpn(struct rfcomm_sessio
 			u8 bit_rate, u8 data_bits, u8 stop_bits,
 			u8 parity, u8 flow_ctrl_settings,
 			u8 xon_char, u8 xoff_char, u16 param_mask);
+int rfcomm_dlc_send_rpn(struct rfcomm_dlc *d, u8 bit_rate, u8 data_bits,
+			u8 stop_bits, u8 parity, u8 flow_ctrl_settings,
+			u8 xon_char, u8 xoff_char, u16 param_mask);
 
 /* ---- RFCOMM DLCs (channels) ---- */
 struct rfcomm_dlc *rfcomm_dlc_alloc(gfp_t prio);
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1031,6 +1031,23 @@ int rfcomm_send_rpn(struct rfcomm_sessio
 	return rfcomm_send_frame(s, buf, ptr - buf);
 }
 
+int rfcomm_dlc_send_rpn(struct rfcomm_dlc *d, u8 bit_rate, u8 data_bits,
+			u8 stop_bits, u8 parity, u8 flow_ctrl_settings,
+			u8 xon_char, u8 xoff_char, u16 param_mask)
+{
+	int err = -ENOTCONN;
+
+	rfcomm_lock();
+	if (d->session)
+		err = rfcomm_send_rpn(d->session, 1, d->dlci, bit_rate,
+				      data_bits, stop_bits, parity,
+				      flow_ctrl_settings, xon_char, xoff_char,
+				      param_mask);
+	rfcomm_unlock();
+
+	return err;
+}
+
 static int rfcomm_send_rls(struct rfcomm_session *s, int cr, u8 dlci, u8 status)
 {
 	struct rfcomm_hdr *hdr;
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -861,7 +861,7 @@ static void rfcomm_tty_set_termios(struc
 
 	BT_DBG("tty %p termios %p", tty, old);
 
-	if (!dev || !dev->dlc || !dev->dlc->session)
+	if (!dev || !dev->dlc)
 		return;
 
 	/* Handle turning off CRTSCTS */
@@ -982,9 +982,8 @@ static void rfcomm_tty_set_termios(struc
 	}
 
 	if (changes)
-		rfcomm_send_rpn(dev->dlc->session, 1, dev->dlc->dlci, baud,
-				data_bits, stop_bits, parity,
-				RFCOMM_RPN_FLOW_NONE, x_on, x_off, changes);
+		rfcomm_dlc_send_rpn(dev->dlc, baud, data_bits, stop_bits, parity,
+				    RFCOMM_RPN_FLOW_NONE, x_on, x_off, changes);
 }
 
 static void rfcomm_tty_throttle(struct tty_struct *tty)


