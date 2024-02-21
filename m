Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BD23C2F;
	Wed, 21 Feb 2024 13:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523261; cv=none; b=TfZOrH/hZQgmUBwIrJYotAzLDPCyKwEkgavfzCfDOt3SR8f78xEgUYT3ZDEAgEE/RrB4qxIVhKDFl9vOcDr1Qz1kzJ7SVfHfYz9Od94uiouciUWpWoD9oXjgHlcnQyyUpg7WEv8EcO+fKg2U7Fm71/I9DxbgQnLLzCQcXYn1nno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523261; c=relaxed/simple;
	bh=w1qY7GR38049UlpB11d0f5rb1NMa0VpqnUSHI35+ufw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXkKRU8AuP0Kt4Okk5AALY7nWvKVJme+P+wXKg6xqrvc8Ya4HPUm32kFURppob+3j4B1a2UinEIPI2UZdwrd8ntHdd4/p+HLx7cF0Napo4fmzkUIPg248OKtJ85cgtWCJc+bcktvl7b36MBlFzIOgiUK6mDUXOaaekj7EHh1MNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTYP2w0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTYP2w0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100E1C433F1;
	Wed, 21 Feb 2024 13:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523261;
	bh=w1qY7GR38049UlpB11d0f5rb1NMa0VpqnUSHI35+ufw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTYP2w0EFC1WgW+wxNqtjNmFXQXHwkw79/YYF5tez9e9h0fyzsTRtsbOc1I9gY40U
	 BETUtaJj0Ng/swMDPBz7N2n4NJvclhW77C1kt3NCRQgnJWKPGHYdcXiwhFePPpkSrF
	 M2u4hrBm2oTQU38AquhCKKj0iWBJ1S4F/uN6crk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6b7c68d9c21e4ee4251b@syzkaller.appspotmail.com,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 381/476] nfc: nci: free rx_data_reassembly skb on NCI device cleanup
Date: Wed, 21 Feb 2024 14:07:12 +0100
Message-ID: <20240221130022.134574847@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1211,6 +1211,10 @@ void nci_free_device(struct nci_dev *nde
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


