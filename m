Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED93F388E65;
	Tue, 10 Mar 2026 11:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142151; cv=none; b=Xg2qxtfEzTLOUAjDam4ZIlOnDKBzsDykZrkpnk2MH4jqK5uY/UfdduBWKkAU6TpYLC3CS9KFicRHbY0FzqJR1qu+mfuiHeCKglhRB8w7pJTZPdvvvVP4RjM+eS2U5+ciTyb2bFaTPggRzOXWmx8foYaxJ07yD+5G4LflyAOOGbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142151; c=relaxed/simple;
	bh=0c+Od6ZZdnC+YU4zMpRFDnSrcbwI57Z0cAbZXkl6P+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVevVYenfBudpPBygbRslly0+uWC4feVDEJ8Cv3NpeuL/ngn6dlFM/O6MdwNaeZMMmW1ElHnCI1OnYcpPgxf4T8s/PUwJ9kS+UQsC317lSyUm3qlE7M4GGv7hdDj8UDDlHraoBlpv4LY7CwnzGyD9NtSinqnaU0M5JbsS4NJgyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7kIfxSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7kIfxSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFE8C2BC9E;
	Tue, 10 Mar 2026 11:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142150;
	bh=0c+Od6ZZdnC+YU4zMpRFDnSrcbwI57Z0cAbZXkl6P+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7kIfxSFIKmU3W/ye9nG5h3L25vMYW8cOjQ3Y/XpzU9se1WGP+bSzwala1ZIaD5op
	 ZuTJ+kfBOwl31SRYP620M+pd7LtKiyYiV9MxLSUnlbd2DXkf8fnd9b1ySWUdD0JbuF
	 3u7kKlxTnZTWLxLsGm3ESZi0PX4WdIF+rH919SS/HO2RMnXbXELg4ZrkxVhTr74wW3
	 NbkWj6ioNRgCwR5q07qVoouzatqapXlViIAWnwbBazJF3otBTs2+vpXhC3m3JzfnZU
	 D/0ituXw0Jh86u2d//8U2Xp8e1PdzZeMSf3FKL+dyphrDdZ3dC76OtV9R6WIc76tu+
	 L8EKVHKgbM6Og==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Raju Rangoju <Raju.Rangoju@amd.com>,
	Guruvendra Punugupati <Guruvendra.Punugupati@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 238/314] amd-xgbe: fix MAC_TCR_SS register width for 2.5G and 10M speeds
Date: Tue, 10 Mar 2026 07:18:17 -0400
Message-ID: <b0bff8a1f5ced710c3657a4fe0cf2882d455b035.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 9439a661c2e80485406ce2c90b107ca17858382d ]

Extend the MAC_TCR_SS (Speed Select) register field width from 2 bits
to 3 bits to properly support all speed settings.

The MAC_TCR register's SS field encoding requires 3 bits to represent
all supported speeds:
  - 0x00: 10Gbps (XGMII)
  - 0x02: 2.5Gbps (GMII) / 100Mbps
  - 0x03: 1Gbps / 10Mbps
  - 0x06: 2.5Gbps (XGMII) - P100a only

With only 2 bits, values 0x04-0x07 cannot be represented, which breaks
2.5G XGMII mode on newer platforms and causes incorrect speed select
values to be programmed.

Fixes: 07445f3c7ca1 ("amd-xgbe: Add support for 10 Mbps speed")
Co-developed-by: Guruvendra Punugupati <Guruvendra.Punugupati@amd.com>
Signed-off-by: Guruvendra Punugupati <Guruvendra.Punugupati@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Link: https://patch.msgid.link/20260226170753.250312-1-Raju.Rangoju@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
index 62b01de93db49..826c5caa70d71 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
@@ -431,7 +431,7 @@
 #define MAC_SSIR_SSINC_INDEX		16
 #define MAC_SSIR_SSINC_WIDTH		8
 #define MAC_TCR_SS_INDEX		29
-#define MAC_TCR_SS_WIDTH		2
+#define MAC_TCR_SS_WIDTH		3
 #define MAC_TCR_TE_INDEX		0
 #define MAC_TCR_TE_WIDTH		1
 #define MAC_TCR_VNE_INDEX		24
-- 
2.51.0

