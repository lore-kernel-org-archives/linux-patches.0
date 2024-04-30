Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC16128816;
	Tue, 30 Apr 2024 10:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474693; cv=none; b=jgtVva/sD08g1VL3jySe4p9jdNj3YoooEO7KogCVPl6bsgeDoP5FkXBxTC1fHggSXX1GumUVgq2Om8Vjj6qw6c+AZj6GpITZ2d4/cmfoQhmwsR8lU68+KreWkWcMAPU9lqkhZyKuyakkT5c0j8UrQUfaSadEDrpbLS+0fMDXFCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474693; c=relaxed/simple;
	bh=sVNrfHH8Gw53TRd8SrCLd2co5Vr7hRPlnnfye1u5/7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5rW5GQ8HgoteqW2aNLWdEflWZypkJ4c+yHypyh4qZRFIE/d3sRWMvygjTYGYbT7HTTGMpcKQ4MHkRBtYtyvW5FPXl9Zs0v5ScP4QaIuPtljRzcWYryKOe/KJVqYirMAihGaBRthdnqfE6XtruRoBw1+s4j52qHb+yJkGdNBHtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IU/8w3zC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IU/8w3zC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58B4C2BBFC;
	Tue, 30 Apr 2024 10:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474693;
	bh=sVNrfHH8Gw53TRd8SrCLd2co5Vr7hRPlnnfye1u5/7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IU/8w3zC0Eh5qbyp+1bwKK35DO0faDXCz65f65VPmUhAt9rAnZFdM3X3dJXSBUH1E
	 LfIcWpH9XSppgNUw7ZbtI6/EKy7WfUZof5XgWCq7Yg55q9JQuKqlrWSlo0poKnMMdg
	 gR0PMu2cfsJUtN8c4MGAaMIsFmtqwpEyHFXqu8uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 228/228] Bluetooth: hci_sync: Fix UAF on hci_abort_conn_sync
Date: Tue, 30 Apr 2024 12:40:06 +0200
Message-ID: <20240430103110.381831659@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 7453847fb22c7c45334c43cc6a02ea5df5b9961d upstream.

Fixes the following trace where hci_acl_create_conn_sync attempts to
call hci_abort_conn_sync after timeout:

BUG: KASAN: slab-use-after-free in hci_abort_conn_sync
(net/bluetooth/hci_sync.c:5439)
Read of size 2 at addr ffff88800322c032 by task kworker/u3:2/36

Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc38
04/01/2014
Workqueue: hci0 hci_cmd_sync_work
Call Trace:
<TASK>
dump_stack_lvl (./arch/x86/include/asm/irqflags.h:26
./arch/x86/include/asm/irqflags.h:67 ./arch/x86/include/asm/irqflags.h:127
lib/dump_stack.c:107)
print_report (mm/kasan/report.c:378 mm/kasan/report.c:488)
? preempt_count_sub (kernel/sched/core.c:5889)
? __virt_addr_valid (./arch/x86/include/asm/preempt.h:103 (discriminator 1)
./include/linux/rcupdate.h:865 (discriminator 1)
./include/linux/mmzone.h:2026 (discriminator 1)
arch/x86/mm/physaddr.c:65 (discriminator 1))
? hci_abort_conn_sync (net/bluetooth/hci_sync.c:5439)
kasan_report (mm/kasan/report.c:603)
? hci_abort_conn_sync (net/bluetooth/hci_sync.c:5439)
hci_abort_conn_sync (net/bluetooth/hci_sync.c:5439)
? __pfx_hci_abort_conn_sync (net/bluetooth/hci_sync.c:5433)
hci_acl_create_conn_sync (net/bluetooth/hci_sync.c:6681)

Fixes: 45340097ce6e ("Bluetooth: hci_conn: Only do ACL connections sequentially")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6735,15 +6735,10 @@ static int hci_acl_create_conn_sync(stru
 	else
 		cp.role_switch = 0x00;
 
-	err = __hci_cmd_sync_status_sk(hdev, HCI_OP_CREATE_CONN,
-				       sizeof(cp), &cp,
-				       HCI_EV_CONN_COMPLETE,
-				       conn->conn_timeout, NULL);
-
-	if (err == -ETIMEDOUT)
-		hci_abort_conn_sync(hdev, conn, HCI_ERROR_LOCAL_HOST_TERM);
-
-	return err;
+	return __hci_cmd_sync_status_sk(hdev, HCI_OP_CREATE_CONN,
+					sizeof(cp), &cp,
+					HCI_EV_CONN_COMPLETE,
+					conn->conn_timeout, NULL);
 }
 
 int hci_connect_acl_sync(struct hci_dev *hdev, struct hci_conn *conn)


