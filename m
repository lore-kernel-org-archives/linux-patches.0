Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E509A6BB52;
	Wed, 21 Feb 2024 13:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521693; cv=none; b=ihXu9pVPL/1JCP/fuDC3ZINX6wb5eo41oqnhHl6yuIxNDlNW9qHaclAJkI6Rps0dyrWwqRdttKL9vwtPdwqLFruggIKBpZduBMSBGdt+MAeMWOn3TOAs4uxbfvtH96pD36EFUz6ceO8JeCD/0TBBZsdR2anC3IGdhskgD0SJ1Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521693; c=relaxed/simple;
	bh=2A6iy4DkqEguZ0wXRUfjhrICHxv9XaHhvOHqN4hqivs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oibj2ImGVVQ5nvFAsKYn+0FQDP19hq3GeT4CxUbQoJBXkVpPpkLnfO9MklaM94gsRXSPKCMKmVyJki+ibHywj/KFqtB1WWM/FJDbCY5LfDTWqijTidb4ssVZajX+OFQRHY/LEjYutLJheCb+Xp/uj4CRlB/lL03mNmx9drxDnSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CScen9T4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CScen9T4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FA6C433C7;
	Wed, 21 Feb 2024 13:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521692;
	bh=2A6iy4DkqEguZ0wXRUfjhrICHxv9XaHhvOHqN4hqivs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CScen9T4DYSshB5+7DCRqUZHegogJ1gJZBQqf0/hoXqsrCDtm/wNCp0fFQERlIBFI
	 1yjrRFfuoMrMccwnf3azY3KqawcxnBEjuOTqb9nUqG8ONH18lqPFJSZ+VwAYO/Bcxh
	 6pBw0+GwoeDtneh+aEIXZZUUin3l+jTq+b7Wccf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6b7c68d9c21e4ee4251b@syzkaller.appspotmail.com,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 181/202] nfc: nci: free rx_data_reassembly skb on NCI device cleanup
Date: Wed, 21 Feb 2024 14:08:02 +0100
Message-ID: <20240221125937.672219112@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1209,6 +1209,10 @@ void nci_free_device(struct nci_dev *nde
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


