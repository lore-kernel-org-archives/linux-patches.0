Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784E63EC805;
	Fri,  9 Oct 2026 14:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556445; cv=none; b=eN22kPl5vjUjVKI7u3SWw/F0/tGJUKWW9MM++JcA8pOOcpwqV4a71sEI/yG3OBrAMIOsZk/oO2k0uAUdXeB3iRSOgELOnxv9T2CvBhxJxNwQFRiL9pQg2rR/KYY4mn+v789eiuFADWW3n3sJkAeeNkxKRy39iJ4Dajbof96cr10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556445; c=relaxed/simple;
	bh=486GHakO/XeOuToGY3JDbK6auu/YdEL2+nhinYqTX/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3Dw7gv8E3MSawDr8oFpksngKUhQ04wJ+Gc/JcwnZIs4fnUvpqEPJwZ/3CrHs3IySgLXlC1/S03G4q9+i2Zyq/5NcUUMnfbSLxMgdQXLT7s8ltCRg+TIxGFxKmgLX+hk2r+/OvSAKINvt8sqGnqOeYUfNFmpiZTalixN3yJQ9es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuTH28Df; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuTH28Df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4471F000FF;
	Fri,  9 Oct 2026 14:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556442;
	bh=rIeIdaJ3e+elqXmFXCrn3QnuapU+sfDe14vtAegaInA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuTH28Dfxa4f7K694VERJ2f/67t1ITWOI8DVhQCwpS6ORoZ4TvqfbyHO3eGdn9bsF
	 oWsWXdFa1JDRbjMWX1QJvuZ8x9zviTIVB83ZZ4uXTIQGbGN/mZc+Vv+HWK28eZGLDr
	 usfP44WaJ8H5VhiFLoHfqXYnycun904PIUZBCafU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 234/403] Bluetooth: btintel_pcie: fix plen overflow in btintel_pcie_recv_frame()
Date: Fri,  9 Oct 2026 16:09:55 +0200
Message-ID: <20261009140957.631229496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

commit 7dbeb6935ac331b0cba6c41cabd8e9d02d5f64ea upstream.

plen is u16 and computed as HDR_SIZE + dlen. For ACL/ISO frames dlen
is a 16-bit field, so a value >= 0xFFFC wraps the sum, bypassing the
"skb->len < plen" check and letting skb_trim() truncate the packet.

Widen plen to u32 so the addition cannot wrap.

Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Cc: stable@vger.kernel.org
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel_pcie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1116,7 +1116,7 @@ static int btintel_pcie_recv_frame(struc
 {
 	int ret;
 	u8 pkt_type;
-	u16 plen;
+	u32 plen;
 	u32 pcie_pkt_type;
 	void *pdata;
 	struct hci_dev *hdev = data->hdev;


