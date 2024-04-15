Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D36757EA;
	Mon, 15 Apr 2024 14:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191227; cv=none; b=OEVPfPMZmm2z/M8jmQIElJMLiLwpvya5K4zo5RcZQgaJfDhwpa5eQ8IPlGPzXSJ0VW9CZweXOeIjMjT2AADUwzXT2Yk1IovinSs2Qq6TdexDpEPZ5J/i5KtGWZRhhOrRQsI321ITZp8Sm8wf+CPTJtPTgkD4XEBmKgsYXuvf5Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191227; c=relaxed/simple;
	bh=jJSQToY6eMG2VeDxsbiOGmV8eLNaTHbC365rqFwJhDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBSwQugXIKryOFAzfr9zosVhGsqrxM8CFPjsPNUTD5CLXB7czAu3jO0rdNuA+Eor1pCDjmIO/xj/RmpSM5we9MnlmvA1tdK8VarUsW3jwXPmz6zdi6KsPyeqXkY/aKQQGGav+39Ln+CBGXEQbbcR+z+aSOdTy9urK+AU1Sv1/Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDwbCzG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDwbCzG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FD2C3277B;
	Mon, 15 Apr 2024 14:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191227;
	bh=jJSQToY6eMG2VeDxsbiOGmV8eLNaTHbC365rqFwJhDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDwbCzG7g+NSzPv2TGXPsi2UngZk2VOfVKgmQECNJqPt00PuR8APoYzPxpFYuNSU7
	 7NbXEy9pFTZeSklqVJzDEarHwvaBBN7bU5dvTjuURHtAmTmga9Y4Mj+41wCYRU9wLL
	 U8CsQ/MHNJpaJW21ltySodEPSFp3P6poQwjhg0FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 074/172] Bluetooth: hci_sync: Fix using the same interval and window for Coded PHY
Date: Mon, 15 Apr 2024 16:19:33 +0200
Message-ID: <20240415142002.651683433@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 53cb4197e63ab2363aa28c3029061e4d516e7626 ]

Coded PHY recommended intervals are 3 time bigger than the 1M PHY so
this aligns with that by multiplying by 3 the values given to 1M PHY
since the code already used recommended values for that.

Fixes: 288c90224eec ("Bluetooth: Enable all supported LE PHY by default")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 89bd1c1a3e0e8..e1050d7d21a59 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2664,8 +2664,8 @@ static int hci_le_set_ext_scan_param_sync(struct hci_dev *hdev, u8 type,
 				if (qos->bcast.in.phy & BT_ISO_PHY_CODED) {
 					cp->scanning_phys |= LE_SCAN_PHY_CODED;
 					hci_le_scan_phy_params(phy, type,
-							       interval,
-							       window);
+							       interval * 3,
+							       window * 3);
 					num_phy++;
 					phy++;
 				}
@@ -2685,7 +2685,7 @@ static int hci_le_set_ext_scan_param_sync(struct hci_dev *hdev, u8 type,
 
 	if (scan_coded(hdev)) {
 		cp->scanning_phys |= LE_SCAN_PHY_CODED;
-		hci_le_scan_phy_params(phy, type, interval, window);
+		hci_le_scan_phy_params(phy, type, interval * 3, window * 3);
 		num_phy++;
 		phy++;
 	}
-- 
2.43.0



