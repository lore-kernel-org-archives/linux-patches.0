Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACF67F7FD;
	Mon, 15 Apr 2024 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191797; cv=none; b=tFLFhJt0oT2uYw36dZjgSqnKSjLh+Ub8gVklPn0domePg89QCyPDMfTm/CsYXku2YM3U0GiLLRQOfA3AmmrbiXIrGsO9hAJssE2pkZNuKkfDjcPn4VYPQwKQNvYxmleIz+nrzfe3IX0/0E09JxjKRECWFSmWGd6vGoJnHJARRiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191797; c=relaxed/simple;
	bh=FkW1tf3bfH4Fe1etZSgeCJtjiF4lAAGYiIr7kq7LPpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8HeHQjlJG4znZYAj6V68kWnxM5ovx4g+9gf6cp80hJmQY3GSxYk69dUgbSeGtgrb20vGIzSD9H71dv0knLhaUWzj2fqP0ap4ERrTd0xCsqlTOf4c7vZQWObXqqaUOryjZuBC7grrIa68Nvt6iY4PRO2zle9uOYhYFibzeYqagM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z22gqSv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z22gqSv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4700C2BD10;
	Mon, 15 Apr 2024 14:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191797;
	bh=FkW1tf3bfH4Fe1etZSgeCJtjiF4lAAGYiIr7kq7LPpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z22gqSv94DgFwn5awyQg5+BNL3AblPRqc2kdq/RRiDaauiZV/rLh+zsx+upyyjx7A
	 +pEaTlGm6C2dJD0f1AyrJkZeId2cQi5WMMMFewN3cSmK5i+i2rHDNrnwleSfs4Kuyt
	 60dPdsZus28k93CKi984N4tFdVNH+ovoH47x6AJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/122] Bluetooth: hci_sync: Fix using the same interval and window for Coded PHY
Date: Mon, 15 Apr 2024 16:20:16 +0200
Message-ID: <20240415141954.903019357@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f462e3fb5af05..1bc58b324b73e 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2732,8 +2732,8 @@ static int hci_le_set_ext_scan_param_sync(struct hci_dev *hdev, u8 type,
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
@@ -2753,7 +2753,7 @@ static int hci_le_set_ext_scan_param_sync(struct hci_dev *hdev, u8 type,
 
 	if (scan_coded(hdev)) {
 		cp->scanning_phys |= LE_SCAN_PHY_CODED;
-		hci_le_scan_phy_params(phy, type, interval, window);
+		hci_le_scan_phy_params(phy, type, interval * 3, window * 3);
 		num_phy++;
 		phy++;
 	}
-- 
2.43.0



