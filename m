Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E1CA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB13C433EF;
	Tue, 10 Jan 2023 18:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374611;
	bh=xbv9mDpcDrHE+3MaMvq7hoVRF/3NzkaZCOxsgp8lXiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slCfSttzgkMdwXpLme7osIRYuTuZAZO9ilXGBzSOnpmRVJ+CsQJLT/MG0nvszvwzv
	 vSPpY84Hy7HO+40CjZHQyghyiSwmvs/u5789jNFH6kd+J/tnstTP6iFhPL9hziHU5Q
	 SpHfiISl/BctCPBLTsausReiR77spDI5v9nRoRuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Johnny S. Lee" <foss@jsl.io>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/159] net: dsa: mv88e6xxx: depend on PTP conditionally
Date: Tue, 10 Jan 2023 19:03:02 +0100
Message-Id: <20230110180019.395912489@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johnny S. Lee <foss@jsl.io>

[ Upstream commit 30e725537546248bddc12eaac2fe0a258917f190 ]

PTP hardware timestamping related objects are not linked when PTP
support for MV88E6xxx (NET_DSA_MV88E6XXX_PTP) is disabled, therefore
NET_DSA_MV88E6XXX should not depend on PTP_1588_CLOCK_OPTIONAL
regardless of NET_DSA_MV88E6XXX_PTP.

Instead, condition more strictly on how NET_DSA_MV88E6XXX_PTP's
dependencies are met, making sure that it cannot be enabled when
NET_DSA_MV88E6XXX=y and PTP_1588_CLOCK=m.

In other words, this commit allows NET_DSA_MV88E6XXX to be built-in
while PTP_1588_CLOCK is a module, as long as NET_DSA_MV88E6XXX_PTP is
prevented from being enabled.

Fixes: e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")
Signed-off-by: Johnny S. Lee <foss@jsl.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/Kconfig
index 7a2445a34eb7..e3181d5471df 100644
--- a/drivers/net/dsa/mv88e6xxx/Kconfig
+++ b/drivers/net/dsa/mv88e6xxx/Kconfig
@@ -2,7 +2,6 @@
 config NET_DSA_MV88E6XXX
 	tristate "Marvell 88E6xxx Ethernet switch fabric support"
 	depends on NET_DSA
-	depends on PTP_1588_CLOCK_OPTIONAL
 	select IRQ_DOMAIN
 	select NET_DSA_TAG_EDSA
 	select NET_DSA_TAG_DSA
@@ -13,7 +12,8 @@ config NET_DSA_MV88E6XXX
 config NET_DSA_MV88E6XXX_PTP
 	bool "PTP support for Marvell 88E6xxx"
 	default n
-	depends on NET_DSA_MV88E6XXX && PTP_1588_CLOCK
+	depends on (NET_DSA_MV88E6XXX = y && PTP_1588_CLOCK = y) || \
+	           (NET_DSA_MV88E6XXX = m && PTP_1588_CLOCK)
 	help
 	  Say Y to enable PTP hardware timestamping on Marvell 88E6xxx switch
 	  chips that support it.
-- 
2.35.1



