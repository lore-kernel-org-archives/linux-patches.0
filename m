Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25EB1885A5;
	Wed, 28 Jan 2026 15:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614424; cv=none; b=J6OsO/scYmOH7lDX3psUgNIKuFTOqiQzqLcETqrCUNht/hD1zqkA38Keoekd4deX6nBa7Wb3/ypT1fRCPqPZhtJW7x7zoeZFesmqk2n7YgN68Lr51sAZ0ZlqzPEVqb8ctuYjZBj9zS86rxCPw5+5AzQNEqNmhcujIHy0UScM4j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614424; c=relaxed/simple;
	bh=SXaWfdMrcRhvXy79Ynl3zfdvv0Tfr2xyJj470SQLC6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mg8PZAyMM9p2o9jGX7Fm0LFQpza9tMI5SR87dWy83G+LomxAVDJMejKDr3Lk7Y8G+RBnJnuvPcLABqdj7HJKaczlvgTeps5rjqu+Dm62K9xqZfyZFJOJq2Q5Pvf1qlqky596bvqorUweJTFZ+yqoNq8baG51zK2BpzyJRhyEq4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNVMA9wK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNVMA9wK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80531C4CEF1;
	Wed, 28 Jan 2026 15:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614423;
	bh=SXaWfdMrcRhvXy79Ynl3zfdvv0Tfr2xyJj470SQLC6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNVMA9wKuywINoHj0DDH+FiVzszyCTvEWFgNiXq6UZYQAWPel9BX58Qb0VoVka0sy
	 J82BKiM99F+FSP6AtFZ/Q+FtQAytEwqwZXOkoh5qEOGv95qwVeDdw2Is1Sn/wS3sn+
	 9Be8DJW5tRVcSdew+QeEIJrh3BZQD7vp04wE8Ff4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/254] octeontx2: cn10k: fix RX flowid TCAM mask handling
Date: Wed, 28 Jan 2026 16:21:47 +0100
Message-ID: <20260128145349.535644845@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit ab9b218a1521133a4410722907fa7189566be9bc ]

The RX flowid programming initializes the TCAM mask to all ones, but
then overwrites it when clearing the MAC DA mask bits. This results
in losing the intended initialization and may affect other match fields.

Update the code to clear the MAC DA bits using an AND operation, making
the handling of mask[0] consistent with mask[1], where the field-specific
bits are cleared after initializing the mask to ~0ULL.

Fixes: 57d00d4364f3 ("octeontx2-pf: mcs: Match macsec ethertype along with DMAC")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/20260116164724.2733511-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 74953f67a2bf9..3af58bc9f533c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -330,7 +330,7 @@ static int cn10k_mcs_write_rx_flowid(struct otx2_nic *pfvf,
 
 	req->data[0] = FIELD_PREP(MCS_TCAM0_MAC_DA_MASK, mac_da);
 	req->mask[0] = ~0ULL;
-	req->mask[0] = ~MCS_TCAM0_MAC_DA_MASK;
+	req->mask[0] &= ~MCS_TCAM0_MAC_DA_MASK;
 
 	req->data[1] = FIELD_PREP(MCS_TCAM1_ETYPE_MASK, ETH_P_MACSEC);
 	req->mask[1] = ~0ULL;
-- 
2.51.0



