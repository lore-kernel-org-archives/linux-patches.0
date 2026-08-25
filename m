Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A8047DF85;
	Tue, 25 Aug 2026 13:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665098; cv=none; b=XRuj7s4SEzPlNtI02oFVtpmxWJzU/Ag4IrnlU7cHrgBCTBtPNJeMCYtFK+yrNJ2E2SASmrQqsOTXH2qEm0Se0XsKDp00KIk+fOnMVY8YYvFWgPHdI7ez5itTaRTS1Ck82oCcw7cVVplxs5BbT+UhkzLhPOA7RdBDBZDLF43Uc3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665098; c=relaxed/simple;
	bh=r2N5w1gZD2UPWEMzBV/TNqFYqNrV6B/BhLOWLeEbARo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emNp9DNIPklRnSzeJ292+3PvYAN1aRWDztdKM6RHCOqIx9+R94wfY605+wC9ZZNmp28ks5Vo1cN/2KPXf/hyXsASoI0CcRr5uUBZ8TmQ4fRIJimrj2yksD4VX8Mucqb4gvvpa084Z3btcupSyaQMTWp7fMiIK05dbnU1LikjIKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXRAPXgG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXRAPXgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADC61F000E9;
	Tue, 25 Aug 2026 13:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665096;
	bh=C0tpMoC8mj6MoIl/InNgnmKS41rD1UtYfRtnY+CfAq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pXRAPXgGsY+lUeRAt4yRMx8QerE4MhHtUhK9dkrIAObAnhI3ImXcrlKnb7bj+jA8S
	 HaldejP5L/oaftrYnIdEFyH7kOefg3BFyHcyXbAugouR+bCVJJIStL9lxkIiWWavcK
	 QA1wpYL7UeYBHoguYbWRwW7onFGakKoy5utYJzyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 095/101] Bluetooth: hci_event: fix LE list UAF on reset
Date: Tue, 25 Aug 2026 15:26:13 +0200
Message-ID: <20260825132545.527422929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 33af47e847fe4a28b109673affb5874015d54f5a upstream.

hci_cc_reset() clears the LE accept and resolving lists without taking
hdev->lock. Other command-complete handlers serialize updates to these
lists with that lock, and the debugfs readers hold it while walking them.

This permits the reset completion and a debugfs read to interleave as
follows:

  hci_rx_work                 debugfs reader
  -----------                 --------------
                              lock hdev->lock
                              fetch current entry
  list_del(entry)
  kfree(entry)
                              read entry fields

The reader then dereferences a freed list entry and may follow its stale
next pointer.

KASAN reported:

  BUG: KASAN: slab-use-after-free in white_list_show+0x15f/0x180
  Read of size 1 at addr ffff8881015dab16 by task poc/95

  Call Trace:
   white_list_show+0x15f/0x180
   seq_read_iter+0x3ff/0x1190
   seq_read+0x267/0x3d0
   vfs_read+0x177/0xa20
   ksys_read+0xf7/0x1c0

  Allocated by task 91:
   hci_bdaddr_list_add+0x1a6/0x3a0
   hci_cc_le_add_to_accept_list+0xab/0x140
   hci_cmd_complete_evt+0x26c/0x9a0
   hci_event_packet+0x454/0xb20
   hci_rx_work+0x293/0x730

  Freed by task 90:
   kfree+0x131/0x3c0
   hci_bdaddr_list_clear+0xd8/0x160
   hci_cc_reset+0x28a/0x370
   hci_cmd_complete_evt+0x26c/0x9a0
   hci_event_packet+0x454/0xb20
   hci_rx_work+0x293/0x730

Take hdev->lock around both list clears. This matches the existing
mutation and traversal locking convention.

Fixes: a4d5504d5c39 ("Bluetooth: Clear LE white list when resetting controller")
Fixes: cfdb0c2d095a ("Bluetooth: Store Resolv list size")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -297,8 +297,10 @@ static u8 hci_cc_reset(struct hci_dev *h
 
 	hdev->ssp_debug_mode = 0;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_clear(&hdev->le_accept_list);
 	hci_bdaddr_list_clear(&hdev->le_resolv_list);
+	hci_dev_unlock(hdev);
 
 	return rp->status;
 }


