Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA3E5674D;
	Tue, 10 Sep 2024 10:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964712; cv=none; b=B2uXPwME7L6WjaCj6augzZtFmWrDH+EkSwDtYJt5swS7/GIjEpR2bvAtcU9zO0BbFSfOtH2D68UwGzneYTgSW/2D+CPuW+hfj5WNkRngZXldTscNXEotXYOJr7NgLBrDybC+SgM6Z2kDcsdpm+ob+ei2jp5Fu0oKFnioG9bxfzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964712; c=relaxed/simple;
	bh=9bHAWhjYA3cQnQS5eRIOii8rOtd5WkQqFMh2TPmA50I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGUS+iBM3HpgtyjKQD5bPmX3+bHZIyPSt7c1GoLKbkGzZxB2dWXnT6jEBpl5Ls8K24bePn4PSeepxImjlcaOl2hknruina+SOThJNK8T6LF65eLv3LdXdibCRBvpMrGDqEeN/h4MFaBHxRJWUUkOlt4IFHl3Kucwgj4JEvo6kno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDbi0Y1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDbi0Y1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98023C4CEC3;
	Tue, 10 Sep 2024 10:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964712;
	bh=9bHAWhjYA3cQnQS5eRIOii8rOtd5WkQqFMh2TPmA50I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDbi0Y1/APEo0o3Pr4629eMxTfO0trKbptiCiv9fa3KvqwnwuXJBN1VcnMtld1zSl
	 k5QrMuI9vwFco91ndO7+3otIdUsX1PT548AYYgCnOTPq47tufKQH9Hi4IKN/m27NxG
	 utZa2+fOiRBzAaVEooGfqZdx6yfFAS+wRmeoeCSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 268/269] Bluetooth: hci_sync: Fix UAF on create_le_conn_complete
Date: Tue, 10 Sep 2024 11:34:15 +0200
Message-ID: <20240910092617.287527396@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit f7cbce60a38a6589f0dade720d4c2544959ecc0e upstream.

While waiting for hci_dev_lock the hci_conn object may be cleanup
causing the following trace:

BUG: KASAN: slab-use-after-free in hci_connect_le_scan_cleanup+0x29/0x350
Read of size 8 at addr ffff888001a50a30 by task kworker/u3:1/111

CPU: 0 PID: 111 Comm: kworker/u3:1 Not tainted
6.8.0-rc2-00701-g8179b15ab3fd-dirty #6418
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc38
04/01/2014
Workqueue: hci0 hci_cmd_sync_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x21/0x70
 print_report+0xce/0x620
 ? preempt_count_sub+0x13/0xc0
 ? __virt_addr_valid+0x15f/0x310
 ? hci_connect_le_scan_cleanup+0x29/0x350
 kasan_report+0xdf/0x110
 ? hci_connect_le_scan_cleanup+0x29/0x350
 hci_connect_le_scan_cleanup+0x29/0x350
 create_le_conn_complete+0x25c/0x2c0

Fixes: 881559af5f5c ("Bluetooth: hci_sync: Attempt to dequeue connection attempt")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6824,6 +6824,9 @@ static void create_le_conn_complete(stru
 
 	hci_dev_lock(hdev);
 
+	if (!hci_conn_valid(hdev, conn))
+		goto done;
+
 	if (!err) {
 		hci_connect_le_scan_cleanup(conn, 0x00);
 		goto done;


