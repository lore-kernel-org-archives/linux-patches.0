Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69644151CF0;
	Tue, 20 Feb 2024 21:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463714; cv=none; b=EE15pT92XKL1f4VfATAxS1SW7UB1HaL4NmGSFknie2XuiPMeOprYi/2jWpI9itHbFwkJG8KMe6a7p1qm/k7Fc/+p8YXdKOAw4fQPCdj1yISBpBVpBp0Q2at37vDxu8YG6bd22WJxkTu65QLPXtbFWoe1q71t2JSlBW3eaJD+Z7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463714; c=relaxed/simple;
	bh=CbX6O14PuiKez1zxdNKbrS3UMW/SN7euiTxqN1uY/7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzizFGyb5cIrA+t15JHFDUONU0t8sBtYm8mC5HrMNbiVzqDwAtxR2HbkqnXoRUA7MmdYrn1FNDqRTv6ALG4uJTyYQubzGVyS5Ib2pDJP9O91m90de2c7edqKfg+0gOYm7KkRGw34VHDW2tw+jyBdukM5ouyCe/DIAAhSkHJxfmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ci5STyZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ci5STyZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91762C433F1;
	Tue, 20 Feb 2024 21:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463714;
	bh=CbX6O14PuiKez1zxdNKbrS3UMW/SN7euiTxqN1uY/7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ci5STyZ4UpKL/9Eili4JTMXiYP0+7FDVlt+fKPd1CCWRBVQRn/7YrqU+xyOEMmsyw
	 zOEduU2WvFEeYJHHryqOlGZutxAPTcDgOGAz3g7B5mt8Rc19xWFVKkUSWzazW0Pxlr
	 aqXimCjD7TXwbD9nZVGLNm4bbSiQyHPPWANKdL9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6b7c68d9c21e4ee4251b@syzkaller.appspotmail.com,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 130/331] nfc: nci: free rx_data_reassembly skb on NCI device cleanup
Date: Tue, 20 Feb 2024 21:54:06 +0100
Message-ID: <20240220205641.666401719@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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


