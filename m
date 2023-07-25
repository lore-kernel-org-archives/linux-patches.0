Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9C614263
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFF4C433C7;
	Tue, 25 Jul 2023 10:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282544;
	bh=ae90yvnGnzhD7OiFIlPbQ1huHAIjAno99FfQuqm3174=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fa1qWoXOPO+faM6UAPzttIrJZHxV6zLcKLDkCdTi2nxCpaNk+5+fCg92+h45cLwz0
	 AQ1wIzWSReDf6EklzI5z1LPYLtmOlpV9E3MvUV/VIRJ5Y/VsIHEA1Y7CUbNh6nmWQQ
	 BLkx+/4EMK9HVk9upusFZ67W66k0M+drK/GFc7R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 168/227] r8169: fix ASPM-related problem for chip version 42 and 43
Date: Tue, 25 Jul 2023 12:45:35 +0200
Message-ID: <20230725104521.855285652@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 162d626f3013215b82b6514ca14f20932c7ccce5 ]

Referenced commit missed that for chip versions 42 and 43 ASPM
remained disabled in the respective rtl_hw_start_...() routines.
This resulted in problems as described in the referenced bug
ticket. Therefore re-instantiate the previous logic.

Fixes: 5fc3f6c90cca ("r8169: consolidate disabling ASPM before EPHY access")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217635
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index ca0140963ff3a..b69122686407d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2747,6 +2747,13 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 		return;
 
 	if (enable) {
+		/* On these chip versions ASPM can even harm
+		 * bus communication of other PCI devices.
+		 */
+		if (tp->mac_version == RTL_GIGA_MAC_VER_42 ||
+		    tp->mac_version == RTL_GIGA_MAC_VER_43)
+			return;
+
 		rtl_mod_config5(tp, 0, ASPM_en);
 		rtl_mod_config2(tp, 0, ClkReqEn);
 
-- 
2.39.2



