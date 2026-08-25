Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEF625393E;
	Tue, 25 Aug 2026 13:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665849; cv=none; b=hrVqdwUN/zYd5u5C4SpANNulbycOOJ43dKoGhQK63ac4sJOCfVU8I2zCuAEMGRT3jyPwCmkFL8cNUbxFgUjzAPanQQYXANAB9TCS+CJFeGBs/cx7ioz1lIep8KmeqTCr3Rh+6K6df8YY/qsxfBl3v89eB/XAGUh0ecrVxT7dWCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665849; c=relaxed/simple;
	bh=G2svGJm7XOIQAGG31LdtGakf2tXtzjYxJ0kRPjhD1IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edODpSAEBnnCLrIaG5vHJwhpf4grySf1JM7SeLltes2+BNHLLjKJEDeyIDSzuAkWaFqPoflSIYsxnFcTkaXt1e9WpWnSJq12AtxJNCNUwpONmWl83GQq35Hw2gZOHdsudaWRuzCYmM+G4cLkA85EndSuq+c7vrzeZbfG1gop6I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTPQy6td; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTPQy6td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746E51F000E9;
	Tue, 25 Aug 2026 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665848;
	bh=OzVyqpWYaVZADlMYtE8D5U+OjtSNeWFfwA9OvR0Xsqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTPQy6tdPNXtdOMD9GQNRpyBmr4dkCa3MLX7hQ1usTbkrCqGOmLJesHy89h1RWGYa
	 gfnuqdNA1BYf25310quRwptTGjustvbRTCnJXPRtSzqcXR/SWELVnx8y67Xcd1RaLI
	 bWUdBGe3jfeJqHIZYet3oKhPniTxIUdjihmQVZG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 86/87] Bluetooth: hci_event: fix LE list UAF on reset
Date: Tue, 25 Aug 2026 15:26:49 +0200
Message-ID: <20260825132545.144131218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -294,8 +294,10 @@ static u8 hci_cc_reset(struct hci_dev *h
 
 	hdev->ssp_debug_mode = 0;
 
+	hci_dev_lock(hdev);
 	hci_bdaddr_list_clear(&hdev->le_accept_list);
 	hci_bdaddr_list_clear(&hdev->le_resolv_list);
+	hci_dev_unlock(hdev);
 
 	return rp->status;
 }


