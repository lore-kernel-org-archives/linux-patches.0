Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30791344DBD;
	Sat, 12 Sep 2026 17:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232853; cv=none; b=Qgu/vfcSF4wgTEQAEaLkaOFrwBJp7QYyNr2kd+0bRpEOVn6CkuJgEcTaIodjj/rhfbgEDqKnMCu6glSeLU7Ns7SOyKdVq74HUp7asB16pbczTLxGNK0TfG7RaizFckN13Rsfu0c0Ek+6rrwrpI/ohQQQ4yR+hhXYbqITp6rUCOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232853; c=relaxed/simple;
	bh=YtpNgKC7F7yi5WYvFNgL9IqkBza5WGBgOFpdB4kkxW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCXNoNZlHfMZX/dFQxLYaHL2cf2DN3X+P54a5jwel/ONoMqrPS4RSZNqkIpZi6WxiaOvtQlMhNIC0aqi9qDzSIPhC4c+RBcgzO0x2XdWYQFU1vZBLnFA46isSx0j8SmdyVpdNq2recfSkxEwOYffxOBwdK3mz5neUh88Eyj+U/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JA9xO5QY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JA9xO5QY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501771F000FF;
	Sat, 12 Sep 2026 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232852;
	bh=LOXxPZ7P/3L1zO1mh4uQIbEE/pJiEtY1e/JpE/klckk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JA9xO5QY4NMYAZaEC6M65BJs+g/NdpHK0BYQHq2Cy/DWNvi8x8sCOZHz8arQMiTZM
	 XLj5LKVCQulXU3nTM1IqGbd3PVOYt8P0UTRbo3sq0IwnThFqnrsHCrpUDnVKKxQYOY
	 eKoZYR9a13WlLawAgCb705xEoMf1I0afeHW9lMM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 095/935] Bluetooth: RFCOMM: serialize security confirmation handling
Date: Sat, 12 Sep 2026 08:52:05 +0200
Message-ID: <20260912065529.001936209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2203,9 +2203,13 @@ static void rfcomm_security_cfm(struct h
 
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
@@ -2237,6 +2241,8 @@ static void rfcomm_security_cfm(struct h
 			set_bit(RFCOMM_AUTH_REJECT, &d->flags);
 	}
 
+	rfcomm_unlock();
+
 	rfcomm_schedule();
 }
 


