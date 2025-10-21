Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5C02737E7;
	Tue, 21 Oct 2025 19:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076457; cv=none; b=rPJVBAtGaJwyMIyaeNX81aQj5dgVTcCOgR/eNkSCqmutBmPjr85ex/IxOZ9xrsswdx+/PXCHbp6Sh85ro+Iy+fR+iJNjm0WDWqLU1/DvUkqrPuMPI3e0ZkzQGrV7Z28GzaWL/fkcgOmRPKGr7It1ukrS3imkU/ac1DZA1wHsCno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076457; c=relaxed/simple;
	bh=xcpDKlqExEsh2Ug+tkuLx9TBGPn6fWtp7XumeflEqxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJmHnMPqW88pXpIrzC1rmnQDl0YF0REuHg6Qasr+g+xnmo7W5/tE59YROkt7fKZ432randnQE6A/wh4hvYQm6e+NIQJTFUeaxQ9sSn4zI1y4m60i7z7CsFqIJJuAQb1ITWqWQlorS4VctFcHpZtBU639f9dJp7YtezfkkcGmfbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4QEFj/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4QEFj/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C551BC4CEF7;
	Tue, 21 Oct 2025 19:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076457;
	bh=xcpDKlqExEsh2Ug+tkuLx9TBGPn6fWtp7XumeflEqxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4QEFj/GqZvlx1FC3A/fsTpLdGhCgbbS3G28FzpQ8sCJxTOEiFWi4tThg+XETXch6
	 m1IfMgi2aAededeOqu7XYgEkoDiKLxTTAZZXZPgFFpuUfuQJ4fWtl68vMpJGwqRiVx
	 kUjWnFxlpzlaycmAZLbLhOBp1nFnVCVJtNlhVvL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/105] r8169: fix packet truncation after S4 resume on RTL8168H/RTL8111H
Date: Tue, 21 Oct 2025 21:50:48 +0200
Message-ID: <20251021195022.617605046@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 70f92ab97042f243e1c8da1c457ff56b9b3e49f1 ]

After resume from S4 (hibernate), RTL8168H/RTL8111H truncates incoming
packets. Packet captures show messages like "IP truncated-ip - 146 bytes
missing!".

The issue is caused by RxConfig not being properly re-initialized after
resume. Re-initializing the RxConfig register before the chip
re-initialization sequence avoids the truncation and restores correct
packet reception.

This follows the same pattern as commit ef9da46ddef0 ("r8169: fix data
corruption issue on RTL8402").

Fixes: 6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/20251009122549.3955845-1-lilinmao@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5af932a5e70c4..3b90f257e94f8 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4919,8 +4919,9 @@ static int rtl8169_resume(struct device *device)
 	if (!device_may_wakeup(tp_to_dev(tp)))
 		clk_prepare_enable(tp->clk);
 
-	/* Reportedly at least Asus X453MA truncates packets otherwise */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
+	/* Some chip versions may truncate packets without this initialization */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_37 ||
+	    tp->mac_version == RTL_GIGA_MAC_VER_46)
 		rtl_init_rxcfg(tp);
 
 	return rtl8169_runtime_resume(device);
-- 
2.51.0



