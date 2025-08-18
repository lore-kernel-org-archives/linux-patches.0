Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A352B322547;
	Mon, 18 Aug 2025 13:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525523; cv=none; b=aaxFvkW2xcVpoebE2oJzS9DaRaQnfd80fSm9ffSJooz3YYHyqcHJUVwBtDA0ZxbIBOse9IGRYw8QbcWPTwgvrmoiN2d8BKARQj/eXUvn4qsTwXFmnDMCD0BvYQOKT2Uzoi85KdQEb0r5Fkv+rojngUQvfDwufRJjtPyRZa5BEnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525523; c=relaxed/simple;
	bh=/Ip08QfkOD2/hradlHhlGtHBvZdK2+bzcJFSto5RGCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZSXv+02AHethpGnsxe/+Gg4rebFKDleewJDrlA7ou+D8eKDkLMjFW4BbAv3I1oxi7ZSn7V4q6XhNZuzITd3ua0stbXkWiQNWlidLVyOTN5kraIVQrlQEDCwRnF4GC+TuTbxQiIXJX0ockQPQIw2/ctuhyCoYWRnIh0iRVxzoSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+aYxmjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+aYxmjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13110C4CEEB;
	Mon, 18 Aug 2025 13:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525523;
	bh=/Ip08QfkOD2/hradlHhlGtHBvZdK2+bzcJFSto5RGCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+aYxmjMeV47wv/KV8raHRMxNsU+aaZcd0yC3G5h4/69uJSXwy4UgbFjfk2cEIFiw
	 u/CQUYIrnnmALdHdJSr+8bz7dqZ+S/6WmJlLSfCifLUoDjqsm5RofFPoWCHa+Ri/gt
	 fv+rOZymIrPPApqgAUC1OJpU9Y5ji5Ywn8GVkagM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 289/570] net: enetc: separate 64-bit counters from enetc_port_counters
Date: Mon, 18 Aug 2025 14:44:36 +0200
Message-ID: <20250818124516.976702926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 9fe5f7145ad746e1b8e7522b8a955f642ff1b404 ]

Some counters in enetc_port_counters are 32-bit registers, and some are
64-bit registers. But in the current driver, they are all read through
enetc_port_rd(), which can only read a 32-bit value. Therefore, separate
64-bit counters (enetc_pm_counters) from enetc_port_counters and use
enetc_port_rd64() to read the 64-bit statistics.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250627021108.3359642-3-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/enetc/enetc_ethtool.c  | 15 ++++++++++++++-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h   |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index d38cd36be4a6..c0773dfbfb18 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -142,7 +142,7 @@ static const struct {
 static const struct {
 	int reg;
 	char name[ETH_GSTRING_LEN] __nonstring;
-} enetc_port_counters[] = {
+} enetc_pm_counters[] = {
 	{ ENETC_PM_REOCT(0),	"MAC rx ethernet octets" },
 	{ ENETC_PM_RALN(0),	"MAC rx alignment errors" },
 	{ ENETC_PM_RXPF(0),	"MAC rx valid pause frames" },
@@ -194,6 +194,12 @@ static const struct {
 	{ ENETC_PM_TSCOL(0),	"MAC tx single collisions" },
 	{ ENETC_PM_TLCOL(0),	"MAC tx late collisions" },
 	{ ENETC_PM_TECOL(0),	"MAC tx excessive collisions" },
+};
+
+static const struct {
+	int reg;
+	char name[ETH_GSTRING_LEN] __nonstring;
+} enetc_port_counters[] = {
 	{ ENETC_UFDMF,		"SI MAC nomatch u-cast discards" },
 	{ ENETC_MFDMF,		"SI MAC nomatch m-cast discards" },
 	{ ENETC_PBFDSIR,	"SI MAC nomatch b-cast discards" },
@@ -240,6 +246,7 @@ static int enetc_get_sset_count(struct net_device *ndev, int sset)
 		return len;
 
 	len += ARRAY_SIZE(enetc_port_counters);
+	len += ARRAY_SIZE(enetc_pm_counters);
 
 	return len;
 }
@@ -266,6 +273,9 @@ static void enetc_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 		for (i = 0; i < ARRAY_SIZE(enetc_port_counters); i++)
 			ethtool_cpy(&data, enetc_port_counters[i].name);
 
+		for (i = 0; i < ARRAY_SIZE(enetc_pm_counters); i++)
+			ethtool_cpy(&data, enetc_pm_counters[i].name);
+
 		break;
 	}
 }
@@ -302,6 +312,9 @@ static void enetc_get_ethtool_stats(struct net_device *ndev,
 
 	for (i = 0; i < ARRAY_SIZE(enetc_port_counters); i++)
 		data[o++] = enetc_port_rd(hw, enetc_port_counters[i].reg);
+
+	for (i = 0; i < ARRAY_SIZE(enetc_pm_counters); i++)
+		data[o++] = enetc_port_rd64(hw, enetc_pm_counters[i].reg);
 }
 
 static void enetc_pause_stats(struct enetc_hw *hw, int mac,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 53e8d18c7a34..c84872ab6c8f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -533,6 +533,7 @@ static inline u64 _enetc_rd_reg64_wa(void __iomem *reg)
 /* port register accessors - PF only */
 #define enetc_port_rd(hw, off)		enetc_rd_reg((hw)->port + (off))
 #define enetc_port_wr(hw, off, val)	enetc_wr_reg((hw)->port + (off), val)
+#define enetc_port_rd64(hw, off)	_enetc_rd_reg64_wa((hw)->port + (off))
 #define enetc_port_rd_mdio(hw, off)	_enetc_rd_mdio_reg_wa((hw)->port + (off))
 #define enetc_port_wr_mdio(hw, off, val)	_enetc_wr_mdio_reg_wa(\
 							(hw)->port + (off), val)
-- 
2.39.5



