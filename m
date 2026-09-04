Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D62377EDC;
	Fri,  4 Sep 2026 05:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500987; cv=none; b=MjVbf0q1D80oSzukO0RGmCUwSoehw0Gt76zkIEA6mt66WzoRbmhhpDyt2rVhue0gDohmvNHvHlVGpqxCAjkQ6ho7mvFcxOqtEtn3uiHUM6kFy3eVUYHJJBmuoPK52GjGv2Iky8sqnbNA+viIM6BHLiTCR1vo6olmK6k7ekTtuE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500987; c=relaxed/simple;
	bh=FEgewRjtvDMOXFdvyaGlYBqnZEJ6pL6sUTJCfM7hQoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kg7YdAx8BBFFKgOxc1KtYISCPBBa+c1EomOvEznHtP9lJBbdMLZsUmsOIILZ2PjTz5O382PjCSEDHlvFt1BjAvYKI6IQnSkWn3OZ4gLVespt9nqs1iEOeaduUXMufNwkk7eYR8G/t8cdte0KSMdByZ6w9mtjMxTorxIwxRpQK4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIbYfyoy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIbYfyoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF921F00A3D;
	Fri,  4 Sep 2026 05:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500986;
	bh=KYVZgYAf050lICegJzALph46sU5N9WCsroQAJ1rC54A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIbYfyoy7sOQnURsEcJo62aHn4Tk47GqgYwYOGIA5v6l8b1nl6lo6ncVB95H1S/BX
	 1pNdQ2cBzp1e+tUFeNPejR23922KhCmQio5JWYGYpGM1D5PIkKV9s6OXP7tZox0tCo
	 EjqIptTIkcPL61dIbbMXVlxp7RGsaOuV4hQqBUsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 248/552] Bluetooth: RFCOMM: serialize security confirmation handling
Date: Fri,  4 Sep 2026 06:56:45 +0200
Message-ID: <20260904045755.204137394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

commit 759c185d0bbdb131357408f50b8735e04ed3caff upstream.

rfcomm_security_cfm() looks up a session on session_list and then walks
its DLC list without holding rfcomm_mutex. Since RFCOMM session teardown
uses rfcomm_mutex, krfcommd can close and free the same session and DLCs
concurrently:

  hci_rx_work                    krfcommd
  -----------                    ---------
  rfcomm_session_get()
                                 rfcomm_lock()
                                 rfcomm_session_close()
                                   rfcomm_dlc_unlink()
                                   rfcomm_session_del()
                                     kfree(s)
                                 rfcomm_unlock()
  walk s->dlcs

The callback can then read a freed session list head and touch freed DLCs
while updating their flags or timers.

Serialize the session lookup and DLC traversal in rfcomm_security_cfm()
with rfcomm_mutex. This matches the existing RFCOMM session lifetime
rules and prevents concurrent rfcomm_session_del() / rfcomm_dlc_unlink()
from tearing the objects down while the callback is using them.

KASAN reported:

  BUG: KASAN: slab-use-after-free in rfcomm_security_cfm+0x41c/0x440
  Read of size 8 at addr ffff888111fb3960 by task kworker/u17:1/89
  Workqueue: hci0 hci_rx_work
  Call Trace:
   rfcomm_security_cfm+0x41c/0x440
   hci_encrypt_cfm+0x139/0x590
   hci_encrypt_change_evt+0x37b/0xc40
   hci_event_packet+0x71b/0xb20
   hci_rx_work+0x293/0x730
  Allocated by task 69:
   rfcomm_session_add+0x9e/0x2f0
   rfcomm_run+0x44b/0x41e0
  Freed by task 69:
   kfree+0x131/0x3c0
   rfcomm_session_del+0x188/0x220
   rfcomm_run+0x1985/0x41e0

Fixes: 08c30aca9e698faddebd34f81e1196295f9dc063 ("Bluetooth: Remove RFCOMM session refcnt")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -2208,9 +2208,13 @@ static void rfcomm_security_cfm(struct h
 
 	BT_DBG("conn %p status 0x%02x encrypt 0x%02x", conn, status, encrypt);
 
+	rfcomm_lock();
+
 	s = rfcomm_session_get(&conn->hdev->bdaddr, &conn->dst);
-	if (!s)
+	if (!s) {
+		rfcomm_unlock();
 		return;
+	}
 
 	list_for_each_entry_safe(d, n, &s->dlcs, list) {
 		if (test_and_clear_bit(RFCOMM_SEC_PENDING, &d->flags)) {
@@ -2242,6 +2246,8 @@ static void rfcomm_security_cfm(struct h
 			set_bit(RFCOMM_AUTH_REJECT, &d->flags);
 	}
 
+	rfcomm_unlock();
+
 	rfcomm_schedule();
 }
 


