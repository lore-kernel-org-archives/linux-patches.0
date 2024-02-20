Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FEB446C9;
	Tue, 20 Feb 2024 21:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464811; cv=none; b=EMCxs6RWCcplJ9/AwrNpH8vQch/An/qDdDYvSj0/trObSas74jOvkNQqRLtvVEzK09WEPF59tzrhNCoiQC53qEOcxtBKcQaGxFGkimT9gNeIiko4syasM2sXD81aoZMw2IhE6jEmXUG81qgJkGXsw834hsZbkiJYVf2xdPV/M/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464811; c=relaxed/simple;
	bh=ci14LgtGFxmJAGwRxPjgDf/dA2wrLTG3IRo4LmJ1coI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MG2J1BEldZraPIsldVBDlHx3ZSkhsehzEWNI1OTfMnoQ2q0v8dCaVpOB+YKS2vswfT6pvrPPMO8UkgUil6SdVXmxYJURkkyuasUVUpjSF6ojP1lq6i2MlnHWhn61zCcHWX65HnGuR6ditb5WgcwZ5JEcSeMP6JfUG5OfkOvLgJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=de60NzGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="de60NzGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B19C433F1;
	Tue, 20 Feb 2024 21:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464811;
	bh=ci14LgtGFxmJAGwRxPjgDf/dA2wrLTG3IRo4LmJ1coI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=de60NzGtdrnwBx2e65hDZ2s12a1slM4jixT5c8wmVXGzj76ga1jbPCpRYQH/98QmZ
	 g5PU9FL1hswH204Eu5Ol6rBQHuySGzNGnxWyQZtH0sbLyp5ygPB/Kdo0PARgiqFBjZ
	 /x5CG/mtzx93SpRiIXLVHO4roVRewgxb8Aekzn4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6b7c68d9c21e4ee4251b@syzkaller.appspotmail.com,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 144/309] nfc: nci: free rx_data_reassembly skb on NCI device cleanup
Date: Tue, 20 Feb 2024 21:55:03 +0100
Message-ID: <20240220205637.672845930@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit bfb007aebe6bff451f7f3a4be19f4f286d0d5d9c upstream.

rx_data_reassembly skb is stored during NCI data exchange for processing
fragmented packets. It is dropped only when the last fragment is processed
or when an NTF packet with NCI_OP_RF_DEACTIVATE_NTF opcode is received.
However, the NCI device may be deallocated before that which leads to skb
leak.

As by design the rx_data_reassembly skb is bound to the NCI device and
nothing prevents the device to be freed before the skb is processed in
some way and cleaned, free it on the NCI device cleanup.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
Cc: stable@vger.kernel.org
Reported-by: syzbot+6b7c68d9c21e4ee4251b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/000000000000f43987060043da7b@google.com/
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1208,6 +1208,10 @@ void nci_free_device(struct nci_dev *nde
 {
 	nfc_free_device(ndev->nfc_dev);
 	nci_hci_deallocate(ndev);
+
+	/* drop partial rx data packet if present */
+	if (ndev->rx_data_reassembly)
+		kfree_skb(ndev->rx_data_reassembly);
 	kfree(ndev);
 }
 EXPORT_SYMBOL(nci_free_device);


