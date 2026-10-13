Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F32C41E6DC;
	Tue, 13 Oct 2026 12:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894494; cv=none; b=KepRIaeKPGGj3jHobwhiRyyH4Cq2uY5j2k/6YiWbwnlC0JuMWW+gkKxGpBZ9i5oivr04BlmrvPLDtsi6OJ0mEMFmCUcFTRV4k3eLa/RUA6rEbHplK9Rah/keuOtBP1WwjlQIKKSHKuax9z3jZGPz4v+wcra+tGyFPMvzpPlgWfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894494; c=relaxed/simple;
	bh=/gZ6uP3G9AhpJhB3nAiti7t6t0TXz5LiEVjtPrMC6Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwHIfxxT94nYfLyb9qPxsyuezrGL8fMNO1IPJQdm7iA2oUaWOSLbzCgidRMODV2KL8fDhSPQkJ6V638ARz1uucpQ9COm5tuMJb6fHGcu0ZQBoCW+lbmo7T34c2PERw+xp8DUO3ANF5iqIGXqPrxr4da9WDMM/SyUbADcBVE8X/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2gLN7tP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2gLN7tP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F0B1F000FF;
	Tue, 13 Oct 2026 12:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894493;
	bh=zhB6kQz1I14zbxFjBulWo0v7d849lRCgitpJNiT8SWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j2gLN7tPGWylgD3czRUtBnHzX1n1eqIqDrk04UKNF+Z1Zcxwbr13Rn5AA4I92pYEI
	 /RBRuC6hG4T8uLBMlcU42M6u34BgWgbKGAGAhv3BLrzIyZpWY45Z0XCPczk5NL14Lt
	 C+H2tqGYqkHPMK8tf6z3PJ8g8HxAzmL44UzVKKV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravindra <ravindra@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 535/621] Bluetooth: btintel_pcie: fix TX descriptor bounds check
Date: Tue, 13 Oct 2026 13:38:50 +0200
Message-ID: <20261013112933.514985015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Ravindra <ravindra@intel.com>

[ Upstream commit baa53af641c9e3644e717b8dfd1b95a55a0c111b ]

btintel_pcie_prepare_tx() uses tfd_index to access the TFD and data
buffer arrays before the index is advanced modulo txq->count. An index
equal to txq->count is one past the end of both arrays, so reject it in
the bounds check.

Fixes: 6e65a09f9275 ("Bluetooth: btintel_pcie: Add *setup* function to download firmware")
Signed-off-by: Ravindra <ravindra@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index d298b4ab7245e..87f8b8b93f2ed 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -358,7 +358,7 @@ static int btintel_pcie_send_sync(struct btintel_pcie_data *data,
 
 	tfd_index = data->ia.tr_hia[BTINTEL_PCIE_TXQ_NUM];
 
-	if (tfd_index > txq->count)
+	if (tfd_index >= txq->count)
 		return -ERANGE;
 
 	if (skb->len > BTINTEL_PCIE_BUFFER_SIZE - BTINTEL_PCIE_HCI_TYPE_LEN) {
-- 
2.53.0



