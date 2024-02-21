Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06B669942;
	Wed, 21 Feb 2024 14:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524772; cv=none; b=TZ4FrstsbW3p717dvjuvX6GTwj7ZZhjQRC1oAX2Vkz3q5yYMgRiHsSmJyA2H0rOT8Ur/JAkPzkxpIrzDb7qsfeeWvH7mRieE8QejC6oILz66dFpxLduJu7Q30Ex75jIDvIDbQhaXEJEk6ZWDbe6P+HHZlLQQI1z3OeawohIlWFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524772; c=relaxed/simple;
	bh=MjxYe7NoAr9PbPGOv+U6Q0hc0OM2jwrMpuDauoueFH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQl2B39w4gH+UmYMAFWSt2jDprapiN7kwUtR7YcGw/GK1qU3NVLWSDytoPXEkzumCTp3BsEUIZPBteu9ZwkG7unB5HK8FwXQLn4iDNVvpaBlyn343siwTV9pSLRktkyf/D/nu1C02+lUO8SPPWJEBgRVvF+JOUVnzxqpnFqML/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CILSNe19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CILSNe19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301F2C433F1;
	Wed, 21 Feb 2024 14:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524772;
	bh=MjxYe7NoAr9PbPGOv+U6Q0hc0OM2jwrMpuDauoueFH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CILSNe192EgyIVu3dbrLzw+Pt23u7SYBWt3TZS92bVk84r80c3NtaU/nU8HioAuld
	 IRbqQg6YMPC/wse7EsqGrOXXowAEZh0aEG+F6f17dy54A45VJeC7T8b4mBXgRR4b6V
	 jvfmqEZEH3sFdqJUsCKv8Q/oI1iwUBFOccZ2nLS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6b7c68d9c21e4ee4251b@syzkaller.appspotmail.com,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 315/379] nfc: nci: free rx_data_reassembly skb on NCI device cleanup
Date: Wed, 21 Feb 2024 14:08:14 +0100
Message-ID: <20240221130004.250265951@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1197,6 +1197,10 @@ void nci_free_device(struct nci_dev *nde
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


