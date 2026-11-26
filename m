Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705821;
	b=5Tf18BODYdqlzCcf3FDBSvR3PHBdJryQt1ZAQCppqPv8WoEg1eoKi0WzUiR9P2OJ/YZq
	 n3gmbmgnnH96WyUCRPBqQpNTFookktJ4DhRcyoTEEUEC66o1Qd7jm9+8RJJBFuh3Wlm0u
	 EiwQgdqj1lwdaH/S1xbZhhYY4NIRNAljhzVwMT1VWKstBgs8vuZIGOotahtukU5YdzIs4
	 VcznPn3omhdp2VnvcYaaIvs365hAQ5S8XJPppOCv8roCb91QcAh4xZeH2uSyCC2mLzVfR
	 3yJ55AKcpU3R1r7FDfcVsueWjxdmiKjqw1JPZGgl4lhEFau403grZesDa+24vLiQufg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3aSOviuSHUAqNo6Lo//KAFDfpZc90fsuIcGhIk+X0Ew=;
	b=AQrd24+dlVUCcjfnD8b5OxRwuealFIy0Elu4VxM3OJn13wEen0Xz5q/9w2TcXJdd7Nas
	 Ubq/ph7JRHwoC/x8JIHX8PB8YgnVnGcgPpqb4R1ZHgnDbcDQ78vl7nDi546nXtdRBF7Rr
	 7wukiFZ9XwGUw17SqupL/+zPMpiVAWmFs8GQ119p7vyI7sRSed4WlkZq79xGcjrFglajW
	 7pubUmJyeMz0w04FOjjKoOiTPWjH4LHIvKUoaPcXCdYys+eVCY7hpASvkQ4HFoWf1fJI2
	 3fSKhH/Ryqd/hggcYZv60FE8FsdpvGFa6407gtWEk9N3XfVhoYip783J1V4GPkJek+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zc9+MwRn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE48606A31C;
	Thu, 26 Nov 2026 15:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zc9+MwRn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5211F0093C;
	Thu, 26 Nov 2026 15:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705821;
	bh=3aSOviuSHUAqNo6Lo//KAFDfpZc90fsuIcGhIk+X0Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zc9+MwRnk4LtVrqFKAMVtmx0F1wyi6OP1/DIZN25Zuhv+3/MqYhFjUeg9Y0sgtsBk
	 vFlr0HTmfV37yOw1UC/dOnBZeZzvc/kuBRKvyADAQGZlwNuslv6JAPCYJxK0002tIY
	 qVaKcQd+82/7f8YG0KKdeooj7PNHFdgwgJcgGWn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Petr Vaganov <petrvaganoff@gmail.com>
Subject: [PATCH 5.15 319/319] Bluetooth: hci_core: Fix not checking skb length on hci_scodata_packet
Date: Thu, 26 Nov 2026 15:41:27 +0100
Message-ID: <20261126144013.960207615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4906,18 +4906,22 @@ drop:
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
 
@@ -4935,6 +4939,7 @@ static void hci_scodata_packet(struct hc
 			   handle);
 	}
 
+drop:
 	kfree_skb(skb);
 }
 


