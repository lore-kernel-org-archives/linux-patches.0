Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CB035E955;
	Tue, 13 Oct 2026 12:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895310; cv=none; b=JjngO9JugPh+cWWVUuHMHDN989veQKcMHw9ustnFDzJKj1WZ/6oCZ6E6MeNL7DJTNjZ4VLcv5nYd84z+T/BiIFH1My/k53agdZPMJzvyQQgnYyU2rHJBBaY7laSv0wLjc6qq8yg7g9aa/7OjROKF4OMVkL0ItSg/CbjpRSRau8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895310; c=relaxed/simple;
	bh=PXs5TcFvpfNOxha7UyoFxEeI70OBFZ/LMc8nZxklVDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNNvHtZW0Mg+LhjiWr+7iaPdAI5CA5du7Anr7e/zakIDaxm8BNi0SyVaRW063nugxtirbSKab6bRGDYciH3pJubmQhlii1kQFV6MJUysAPJGCbE4hYRtasmyyfX8rHzN/gewcrGbB790vTs5wg9TPZ6uYimWK5El6psfiULnyX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxOncVTI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxOncVTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8B11F000FF;
	Tue, 13 Oct 2026 12:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895309;
	bh=6e26nsrQlbIV3I9qu0AWxNvGNzkkTtFTTdv9Zexo9Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxOncVTICF6/KRv6f4+6oJ3sUotI36FG1W4IpfzDDS+FEszU9UCHrL5yg+Rv96wNB
	 owEM/Jweq0w/RJLfTfx9dO+tKkenqUFPuwULSNzXQ7fYkF3byOkaqvf/OkVOWkLQnm
	 z+N7Lh0uLjCz3cMiXkes0vQ/9XGYeociIV3ZEn1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 187/497] Bluetooth: btintel_pcie: fix plen overflow in btintel_pcie_recv_frame()
Date: Tue, 13 Oct 2026 13:35:54 +0200
Message-ID: <20261013112912.329250962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -621,7 +621,7 @@ static int btintel_pcie_recv_frame(struc
 {
 	int ret;
 	u8 pkt_type;
-	u16 plen;
+	u32 plen;
 	u32 pcie_pkt_type;
 	void *pdata;
 	struct hci_dev *hdev = data->hdev;


