Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CE0339866;
	Thu, 28 May 2026 20:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999136; cv=none; b=A+ypWEtOEg5sZg2tGx/vQz1egfsDDmNj3gqgRb1mgJPGfR25CO5lPla3G214ugpFROYvgOlgsl27gHurHmBs4e9z94pAq/9x2MEh2CH2kT4XtGmVkbg2dAa7SFgmUE4EzS/z4ELcGjC0HSy/F/RUunuWboeVsyD9ut60rC59mJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999136; c=relaxed/simple;
	bh=ZHdqtb0oq+d2PYkArJ++Q1upEUSFgwNXkOzzC1s0/Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etUVLIw0vU3hXg9XStUnuGDqChFFGXNQDSt9nn3bfjuFX5GZlVKmCh7ELRhj2D1NZ/Q/TmF24v/ugY7kVgO59XQzx3i507NDmbBYwRSBoZvFlA4vzHbGSlVS4cIuHg8L+p36MrRzjrMjM2loPhzvZ8rc8uwwf62wbzrlgE8vUkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOFDsaDC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOFDsaDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021871F000E9;
	Thu, 28 May 2026 20:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999135;
	bh=dlg5Mepgd2r7EKSvDedEk3RNkuKOoFFu6Jg/3+tCVsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BOFDsaDCfZI0m6cXZTS50TmSajbM5/Vidagokk+3pIWkTGdnZD4DgargHT4od9Wro
	 0ldZ4q8DZ3+EX7BP3kjAAwu5IoVRCQK2rRH8kgzUEYvExvESpJPYoym/47aHFakAaw
	 VYQd9zrid4kTvRehvIcT/pRpHf062Slwvc1PCtmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 420/461] Bluetooth: btintel_pcie: Fix incorrect MAC access programming
Date: Thu, 28 May 2026 21:49:09 +0200
Message-ID: <20260528194659.657575257@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 88365d04fdc821dc4e9eb0cc00fdf6905430d172 ]

btintel_pcie_get_mac_access() and btintel_pcie_release_mac_access()
were programming STOP_MAC_ACCESS_DIS and XTAL_CLK_REQ in addition to
the MAC_ACCESS_REQ handshake. These bits are not part of the host
MAC-access handshake on the supported parts; the driver was
programming them incorrectly. Drop the writes so the register update
contains only the bits the controller actually consumes.

Fixes: b9465e6670a2 ("Bluetooth: btintel_pcie: Read hardware exception data")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 20 ++++++--------------
 drivers/bluetooth/btintel_pcie.h |  3 ---
 2 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 37b744e35bc45..8dbd72895cb23 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -568,12 +568,10 @@ static int btintel_pcie_get_mac_access(struct btintel_pcie_data *data)
 
 	reg = btintel_pcie_rd_reg32(data, BTINTEL_PCIE_CSR_FUNC_CTRL_REG);
 
-	reg |= BTINTEL_PCIE_CSR_FUNC_CTRL_STOP_MAC_ACCESS_DIS;
-	reg |= BTINTEL_PCIE_CSR_FUNC_CTRL_XTAL_CLK_REQ;
-	if ((reg & BTINTEL_PCIE_CSR_FUNC_CTRL_MAC_ACCESS_STS) == 0)
+	if (!(reg & BTINTEL_PCIE_CSR_FUNC_CTRL_MAC_ACCESS_REQ)) {
 		reg |= BTINTEL_PCIE_CSR_FUNC_CTRL_MAC_ACCESS_REQ;
-
-	btintel_pcie_wr_reg32(data, BTINTEL_PCIE_CSR_FUNC_CTRL_REG, reg);
+		btintel_pcie_wr_reg32(data, BTINTEL_PCIE_CSR_FUNC_CTRL_REG, reg);
+	}
 
 	do {
 		reg = btintel_pcie_rd_reg32(data, BTINTEL_PCIE_CSR_FUNC_CTRL_REG);
@@ -593,16 +591,10 @@ static void btintel_pcie_release_mac_access(struct btintel_pcie_data *data)
 
 	reg = btintel_pcie_rd_reg32(data, BTINTEL_PCIE_CSR_FUNC_CTRL_REG);
 
-	if (reg & BTINTEL_PCIE_CSR_FUNC_CTRL_MAC_ACCESS_REQ)
+	if (reg & BTINTEL_PCIE_CSR_FUNC_CTRL_MAC_ACCESS_REQ) {
 		reg &= ~BTINTEL_PCIE_CSR_FUNC_CTRL_MAC_ACCESS_REQ;
-
-	if (reg & BTINTEL_PCIE_CSR_FUNC_CTRL_STOP_MAC_ACCESS_DIS)
-		reg &= ~BTINTEL_PCIE_CSR_FUNC_CTRL_STOP_MAC_ACCESS_DIS;
-
-	if (reg & BTINTEL_PCIE_CSR_FUNC_CTRL_XTAL_CLK_REQ)
-		reg &= ~BTINTEL_PCIE_CSR_FUNC_CTRL_XTAL_CLK_REQ;
-
-	btintel_pcie_wr_reg32(data, BTINTEL_PCIE_CSR_FUNC_CTRL_REG, reg);
+		btintel_pcie_wr_reg32(data, BTINTEL_PCIE_CSR_FUNC_CTRL_REG, reg);
+	}
 }
 
 static void *btintel_pcie_copy_tlv(void *dest, enum btintel_pcie_tlv_type type,
diff --git a/drivers/bluetooth/btintel_pcie.h b/drivers/bluetooth/btintel_pcie.h
index e3d941ffef4aa..34aa092bfbe33 100644
--- a/drivers/bluetooth/btintel_pcie.h
+++ b/drivers/bluetooth/btintel_pcie.h
@@ -34,9 +34,6 @@
 #define BTINTEL_PCIE_CSR_FUNC_CTRL_MAC_ACCESS_STS	(BIT(20))
 
 #define BTINTEL_PCIE_CSR_FUNC_CTRL_MAC_ACCESS_REQ	(BIT(21))
-/* Stop MAC Access disconnection request */
-#define BTINTEL_PCIE_CSR_FUNC_CTRL_STOP_MAC_ACCESS_DIS	(BIT(22))
-#define BTINTEL_PCIE_CSR_FUNC_CTRL_XTAL_CLK_REQ		(BIT(23))
 
 #define BTINTEL_PCIE_CSR_FUNC_CTRL_BUS_MASTER_STS	(BIT(28))
 #define BTINTEL_PCIE_CSR_FUNC_CTRL_BUS_MASTER_DISCON	(BIT(29))
-- 
2.53.0



