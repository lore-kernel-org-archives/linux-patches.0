Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A31971742;
	Mon,  8 Apr 2024 13:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582098; cv=none; b=E5O2j0OPAlMN7Pfedr0vXtVk/LykufcA8yFrp+63yhPm4CZtPBwl9tUBgq6RJR5Xml8pzoXgQxiGtdl5CVI5+TgNUpkxSXJGU9G4X9ts/O2ND+jsRTG6NPVh1DxWHyfrh37aQSeT5z6AEp6+bdN2ure9jLVu1OCa5uV2eg4sE/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582098; c=relaxed/simple;
	bh=zxVolm5yqEW6hFs4y5PGHRvOosTBaYDdvsfeea08IJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hh4giWw6nQVruNwM/kUqQOYIWGvd5DUgx+phkk9TGTbFpjo4NnzSoJ8VGqFjRccaiep7QD4KcereQ803NzmNmqwLfPuNcHe9OTFICu28GsnI9jorBnsizATfU4EKNpEGMEh1myhW+HNUfg/APGAZ2tm6zHQXZ6VqfQ4Ly0yUu7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMmx4M2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMmx4M2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025FAC433F1;
	Mon,  8 Apr 2024 13:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582098;
	bh=zxVolm5yqEW6hFs4y5PGHRvOosTBaYDdvsfeea08IJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMmx4M2YJYyYGewrKEMobymopXa0IDa7Znfa9okE4LvB/qIQXzJ95/t6rZkU/HsaT
	 PySrw7g4BL/FTsbqWpnWN2AAYe2cZeQy5R21HPBh7/mdrAL2iSRAFeRRCcZemDNyxy
	 jbcVZI3bvoe6ikuMNBIk5u5ISxARGLN6k2l+9a3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Simon Horman <simon.horman@corigine.com>,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/138] r8169: prepare rtl_hw_aspm_clkreq_enable for usage in atomic context
Date: Mon,  8 Apr 2024 14:58:12 +0200
Message-ID: <20240408125258.653918178@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 49ef7d846d4bd77b0b9f1f801fc765b004690a07 ]

Bail out if the function is used with chip versions that don't support
ASPM configuration. In addition remove the delay, it tuned out that
it's not needed, also vendor driver r8125 doesn't have it.

Suggested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5e864d90b208 ("r8169: skip DASH fw status checks when DASH is disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4a1710b2726ce..256630f57ffe1 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2772,6 +2772,9 @@ static void rtl_disable_exit_l1(struct rtl8169_private *tp)
 
 static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 {
+	if (tp->mac_version < RTL_GIGA_MAC_VER_32)
+		return;
+
 	/* Don't enable ASPM in the chip if OS can't control ASPM */
 	if (enable && tp->aspm_manageable) {
 		rtl_mod_config5(tp, 0, ASPM_en);
@@ -2801,8 +2804,6 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 		rtl_mod_config2(tp, ClkReqEn, 0);
 		rtl_mod_config5(tp, ASPM_en, 0);
 	}
-
-	udelay(10);
 }
 
 static void rtl_set_fifo_size(struct rtl8169_private *tp, u16 rx_stat,
-- 
2.43.0



