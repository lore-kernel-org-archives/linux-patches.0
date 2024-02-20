Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9860A14F9DA;
	Tue, 20 Feb 2024 21:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462930; cv=none; b=hN8RrEEPbm1rgCwJmxZ5FuBZqs+wAjCDiwsROVvSIvLw7RgaTHgYxMqdD+o/1880PP5pXzxEOACkERcPboB14rAVQvSFe1xcmp5c1fjJ4HkwRiymIplv2fmNRxRUVBq3ETF6lThkm7gcoRULrRsRsEtYhOjW3QortJqHxmHw/pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462930; c=relaxed/simple;
	bh=HsJiSL0063UpZasl5RJn5HOWIHiJG50bk0x65ZBzJSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhI4K6Iye2ejdpf44ojkep5IA4XTSiJsAJu9CTdpycRzliyh4S4M2EF0kWZUyUb55bLl/nk0LR4K5aWxijn0CiqLrBxYtjQbCsdFsCdOJ3wKx9nzBMpTOJIpvOlDS71SJZWULZKBl0KpW93cGigsHG0C3WeH+H6MI4WrqQZXtbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/LfPGUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/LfPGUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63ADCC433C7;
	Tue, 20 Feb 2024 21:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462930;
	bh=HsJiSL0063UpZasl5RJn5HOWIHiJG50bk0x65ZBzJSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/LfPGUWJmVvAahDHGsFrs/3hAl4cnS/eh29mycIrkdD3Ct6WbxUmeNl5s55J4Kna
	 9a2tTE4LVMI8/e5r22qd/rx4H1i0VgRsEQNSmxMJfRoMf/qkwAMRpRP8cc8FbDcyw/
	 mbmygWXtyu2KBhUYFm5xbr/Stbcb+S3uWiLxeDVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6b7c68d9c21e4ee4251b@syzkaller.appspotmail.com,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 082/197] nfc: nci: free rx_data_reassembly skb on NCI device cleanup
Date: Tue, 20 Feb 2024 21:50:41 +0100
Message-ID: <20240220204843.541410802@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1207,6 +1207,10 @@ void nci_free_device(struct nci_dev *nde
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


