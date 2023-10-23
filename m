Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F0C15E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yb5byYvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8606C433C7;
	Mon, 23 Oct 2023 11:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060653;
	bh=5AM8PdHl6lKg++EsXsS048ZOXocXGEqI1YcQrSXoYc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yb5byYvD18iFMR5DPGUhX7Pi+gWHzI5zxV6np4G2BwdPi6K0m9F2WTscdb01zWBt4
	 R4gGiaHRI7qgM4UQxVXy8f2PS3Zi7YVFr+1L6fPhqFU7WgapsWs/tTFhBtcl0r2rQQ
	 jkDY4IHRBUzGULMiS6Tja3/GSFdHitvEY7L1P460=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.4 048/123] Bluetooth: Fix a refcnt underflow problem for hci_conn
Date: Mon, 23 Oct 2023 12:56:46 +0200
Message-ID: <20231023104819.324554857@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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

From: Ziyang Xuan <william.xuanziyang@huawei.com>

commit c7f59461f5a78994613afc112cdd73688aef9076 upstream.

Syzbot reports a warning as follows:

WARNING: CPU: 1 PID: 26946 at net/bluetooth/hci_conn.c:619
hci_conn_timeout+0x122/0x210 net/bluetooth/hci_conn.c:619
...
Call Trace:
 <TASK>
 process_one_work+0x884/0x15c0 kernel/workqueue.c:2630
 process_scheduled_works kernel/workqueue.c:2703 [inline]
 worker_thread+0x8b9/0x1290 kernel/workqueue.c:2784
 kthread+0x33c/0x440 kernel/kthread.c:388
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
 </TASK>

It is because the HCI_EV_SIMPLE_PAIR_COMPLETE event handler drops
hci_conn directly without check Simple Pairing whether be enabled. But
the Simple Pairing process can only be used if both sides have the
support enabled in the host stack.

Add hci_conn_ssp_enabled() for hci_conn in HCI_EV_IO_CAPA_REQUEST and
HCI_EV_SIMPLE_PAIR_COMPLETE event handlers to fix the problem.

Fixes: 0493684ed239 ("[Bluetooth] Disable disconnect timer during Simple Pairing")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4474,7 +4474,7 @@ static void hci_io_capa_request_evt(stru
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
-	if (!conn)
+	if (!conn || !hci_conn_ssp_enabled(conn))
 		goto unlock;
 
 	hci_conn_hold(conn);
@@ -4709,7 +4709,7 @@ static void hci_simple_pair_complete_evt
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
-	if (!conn)
+	if (!conn || !hci_conn_ssp_enabled(conn))
 		goto unlock;
 
 	/* Reset the authentication requirement to unknown */


