Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE571A3029;
	Tue, 21 Oct 2025 20:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076980; cv=none; b=c5i3hHS8aqajh5XNIkn130CF+1ErgAGHGt/Zcg0WBiNH3ox1wYXgpH8/mq2yKP9Z3d87wL+v96xrvQM1Hc94B5Mk3jhGWw62soeXDLaQRzjtcRjijs+L2wUsAu5Fkm6r607A8FbMv2nEuGYs/QtwwrYrVEP+K8DEUju4zA6rvPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076980; c=relaxed/simple;
	bh=iLqa7WmHDRNuOvU1B6yntRaSPtpGaSeC+Pw2oouLztE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcIoHKtSfmwM7g1P7RJVQwRO+S/v/UK1EUClhs0/tFb4MxjP6nDHamjjLF2e1WrjSU39s0XHEtMs3X9ym3tT+hxtbE0K/R19VRxJcFp+paBybNJp/Sfe2v6yzv+is4hqQNnmTdmGD7xZ2W52srgAJPmW1c5lRzyWTHObttZf46o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hk9KP3hT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hk9KP3hT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0143EC4CEF1;
	Tue, 21 Oct 2025 20:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076980;
	bh=iLqa7WmHDRNuOvU1B6yntRaSPtpGaSeC+Pw2oouLztE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hk9KP3hTJkbzb0d8cej3dm7dgEjG8XyoeEefbwdHcswhjZT28oDwCq0Mt6ZTt3fqK
	 ZYoYUGNId82Eqs1UsjK4Ox6tV2JP9MFKCF0v0Cr2AqDS2pQnJ5wX7NOelCww6KMIKb
	 u2bqm3PI9Ow88IWB8ciAaJ4ML2IdDLaJRUmw0FsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/136] r8169: fix packet truncation after S4 resume on RTL8168H/RTL8111H
Date: Tue, 21 Oct 2025 21:50:41 +0200
Message-ID: <20251021195037.256462382@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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
index 7b82779e4cd5d..80b5262d0d572 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5060,8 +5060,9 @@ static int rtl8169_resume(struct device *device)
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



