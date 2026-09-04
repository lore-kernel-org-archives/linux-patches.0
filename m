Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218FB40F72E;
	Fri,  4 Sep 2026 05:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499226; cv=none; b=RwpHXQ9iHuXYhiTe8CKWZWuKZrWwsIkJWnJvLJaBFZBuwT8SHvhqAqwRG+9SV3kL9yJjsCfgu5rYuls4fQcoyMY4UT+LCKxx4Ts2z42sHrNslulNscEbvSczSQTqF5FKKNF4pGI1xSMiZHjFf8Zwrn6pYkpw0lPLoYWW3QEgNSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499226; c=relaxed/simple;
	bh=1GrZlVIyvU3QI4/aqkNf13LOo275NjrMb7lBram+ziI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByGCQFOVb5Q9IAFILeA2gQCm4fvaE14+3QFnmSTbiHkl57qvh4Lq7nF49/Qes1NZ475ds2HxdZpC1vXYTBXmTvtnkIaKTjkNZxtrzxH+NvI2idks0wB/MD1mQViRYqlb9BmFh2RGE+RENSP2k6+6HCYNlyBjlCElPQ5HWpxaY6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVoL0e9R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVoL0e9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6901F00A3D;
	Fri,  4 Sep 2026 05:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499225;
	bh=qDuolUOIII6x3WCYrsHj4YpK09MJOOs7WUn5T4W/jcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVoL0e9RkLAKN+jimlGikhkSLkamNSbnnLZNGAbVNlMuwgMB3yVychyCFxgZ0gJ6t
	 o3b/9r8Vh/3cKr7uVYU8kL7A2xet8PxZ9l2+9qm3SjfT8tSlbNFYUlBkfzUWEUX3QR
	 Q6LbjEV7SQTfc7XtcxkKm5y0FSTiGa9t45Vn+4MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 341/713] Bluetooth: RFCOMM: serialize security confirmation handling
Date: Fri,  4 Sep 2026 06:55:09 +0200
Message-ID: <20260904045811.470242386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -2213,9 +2213,13 @@ static void rfcomm_security_cfm(struct h
 
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
@@ -2247,6 +2251,8 @@ static void rfcomm_security_cfm(struct h
 			set_bit(RFCOMM_AUTH_REJECT, &d->flags);
 	}
 
+	rfcomm_unlock();
+
 	rfcomm_schedule();
 }
 


