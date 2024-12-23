Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228197E0FF;
	Mon, 23 Dec 2024 16:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969748; cv=none; b=mnVMB7CaPivTir3ihtT94+F6rJsBZOVHuNse6Xm9BYEBgfC3b52/uB7kAEL7XsJiBVEXPtvQo8tEUklw00rZ4HMF+aRU7IaKQ3BdOrVA4XwHJMP2BVtw3ZsnLmY9OdClmoQOfrEt99ko/7hwNLy8WM39+YijJPA2WtUN0RN2VLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969748; c=relaxed/simple;
	bh=JjiTqUC53i+/Sjkf7C2nVAdlMo7knkFCuAdbtLBdLQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEKZnH3Fcvs7AenvVvJZ672O2gy3A3Os2ZhuQoTzmcuX+fDWkrSvj5oI1bJXM2Csjq0kT3vVX2NzVFgvYrXMqHnZZumUCgQEPLMH02jpwvXUEqMfRKCz+KYhH7wJWtg9w8O/UM5LVtdiJ8/QZWE+BD2D9wGCUrvsJJo+eKSW78E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIByoOKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIByoOKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42873C4CED3;
	Mon, 23 Dec 2024 16:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969747;
	bh=JjiTqUC53i+/Sjkf7C2nVAdlMo7knkFCuAdbtLBdLQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIByoOKD/QZDwWknSehPqXgf73NVRqFV4KxcV/s8n0DCKcU71ObMgTMQsGy4c7Wzd
	 Zw4XSh2gtNlz98p6GG2GWJq/uUoFkAP1fZcYdNsEDIRKgA+E4AkFH44j2FzlhmBm6g
	 IL4FpGa4DZ2kJInN+8jW7V77WKLv+X8K2dYmDbW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/160] ionic: use ee->offset when returning sprom data
Date: Mon, 23 Dec 2024 16:57:33 +0100
Message-ID: <20241223155410.298250605@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit b096d62ba1323391b2db98b7704e2468cf3b1588 ]

Some calls into ionic_get_module_eeprom() don't use a single
full buffer size, but instead multiple calls with an offset.
Teach our driver to use the offset correctly so we can
respond appropriately to the caller.

Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20241212213157.12212-4-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index dda22fa4448c..9b7f78b6cdb1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -961,8 +961,8 @@ static int ionic_get_module_eeprom(struct net_device *netdev,
 	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
 
 	do {
-		memcpy(data, xcvr->sprom, len);
-		memcpy(tbuf, xcvr->sprom, len);
+		memcpy(data, &xcvr->sprom[ee->offset], len);
+		memcpy(tbuf, &xcvr->sprom[ee->offset], len);
 
 		/* Let's make sure we got a consistent copy */
 		if (!memcmp(data, tbuf, len))
-- 
2.39.5



