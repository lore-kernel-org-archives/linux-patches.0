Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704854;
	b=Q7FQwdwpmkCt6FYpIhywTHFwnwBRBZS+WoX2LjJCPgiYEs1dBbQkjxfSUGPSAee4+sUc
	 xPIyHAK3eQaaeSMpHNkrHrxeO1G2JBgq9xtVMMguqwIqHU0H0nhjTGI0DKJC7g+FaZjOx
	 Ux05tqJZmo76hQri5jZh21wBK34+bEq7dIoNSQy+42teBXxoXvDq4XM6TRUycPC2vWJiL
	 v9R+OhVa125/wzzskt1RIw/qgp4SDfuEIEn+a5bw5T94LJsa39nSRltUISVnduVvLklc8
	 siwxQ8b5AGi/SckIg9kAf2mdWpV4BNjNp2CN0sX1JEnirmQXlntNbF2zBBmDXgTztMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6+Eyec06xQZeGZkL7Xf+vNe8KVP2TEvEmuzK4eEVsWQ=;
	b=OWmwzJQSRL4ojqXwAtIef1krgpZXyPzWsCRDtG3kGlTmr64vznyf3Zn+0xopGiYJ4iU/
	 65iJhyS07BKhcYiRrdQ/BbrJkCNZiG27+buUGRQq1VB/rFibI9CET/HB6Mj282CQm+gXE
	 b5ZkCbCaaeHnc6nMGooy+w0UQy2znKWDWO7UzBMsvf6EFr86n0SNbjuEejIdLCGc4SXup
	 kUFDrV8IXww1y2S4qfAPT7HWNZ4BvuwCyJDKPgblwVW86sJD9okyatv2MDHYxmVfRWQBC
	 5fObSK6dt/TjyHP/xInRcLhCvLqNBlhNglFmY9rK4P4bpmEW1c9I6hGu92SrkgTEzcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYVQGkkk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBF7606A31C;
	Thu, 26 Nov 2026 14:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYVQGkkk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40B11F000EB;
	Thu, 26 Nov 2026 14:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704853;
	bh=6+Eyec06xQZeGZkL7Xf+vNe8KVP2TEvEmuzK4eEVsWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYVQGkkkO9otMj7MrnsHwlLABku5vbROfsKqQVozJ6MnhDDKsuKEbaqH3fvazVlHz
	 kQQEXtYCuf2d2cgEdofAL+1QGffs5dN0fuhzki7vaCF7Elb4XBki+QY6JNSheHQ+EU
	 gXM6rNuYeTjpYtMx9i4IRW0wgh8Pqsi+Ms1JIwMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Petr Vaganov <petrvaganoff@gmail.com>
Subject: [PATCH 5.10 264/265] Bluetooth: hci_core: Fix not checking skb length on hci_scodata_packet
Date: Thu, 26 Nov 2026 15:39:54 +0100
Message-ID: <20261126143623.699185528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 59437cbb5781227567dec226aaa88c66a09ccc5a upstream.

This fixes not checking if skb really contains an SCO header otherwise
the code may attempt to access some uninitilized/invalid memory past the
valid skb->data.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Petr Vaganov <petrvaganoff@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4706,18 +4706,22 @@ static void hci_acldata_packet(struct hc
 /* SCO data packet */
 static void hci_scodata_packet(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_sco_hdr *hdr = (void *) skb->data;
+	struct hci_sco_hdr *hdr;
 	struct hci_conn *conn;
 	__u16 handle, flags;
 
-	skb_pull(skb, HCI_SCO_HDR_SIZE);
+	hdr = skb_pull_data(skb, sizeof(*hdr));
+	if (!hdr) {
+		bt_dev_err(hdev, "SCO packet too small");
+		goto drop;
+	}
 
 	handle = __le16_to_cpu(hdr->handle);
 	flags  = hci_flags(handle);
 	handle = hci_handle(handle);
 
-	BT_DBG("%s len %d handle 0x%4.4x flags 0x%4.4x", hdev->name, skb->len,
-	       handle, flags);
+	bt_dev_dbg(hdev, "len %d handle 0x%4.4x flags 0x%4.4x", skb->len,
+		   handle, flags);
 
 	hdev->stat.sco_rx++;
 
@@ -4735,6 +4739,7 @@ static void hci_scodata_packet(struct hc
 			   handle);
 	}
 
+drop:
 	kfree_skb(skb);
 }
 


