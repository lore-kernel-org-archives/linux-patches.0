Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C1214389A;
	Tue, 23 Apr 2024 21:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908474; cv=none; b=pkHId16vPXBOpl6htcEfMbkyoAiLMluMmnLwxxjF3oMa4CFSOFx7hnhTtBIeIg8/BT7m9Yta/tbn3OEmlX1pMqcOpnFaCo2Jax+2O5QFC4XnaRV+etXYyc98yWC3C8c9xUUBnF+ivMlAwQ7yMTk4nwyNrouPO7tO8k/+Dc+Ruww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908474; c=relaxed/simple;
	bh=D/RAtUzINKMj8uAhS4D6wF+rtYFFVNMD4zio75A4SY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rnfxKURD5lAExrvcUtqtjur8P7FaPmoazUMmOMWYj1H+SWrmMXiNB6cXqnOdz3bgPJV6vMY6YpjaLVy4LovrxiLW+kaahEkXElCPYKhj8VxNJsrkaBZz+Uw06DAWPjupB5WpyqMt1CFdUEbzvRlTCbJYJhJ+kfm/bzW/6+oCgNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwtiE60X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwtiE60X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC101C116B1;
	Tue, 23 Apr 2024 21:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908474;
	bh=D/RAtUzINKMj8uAhS4D6wF+rtYFFVNMD4zio75A4SY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwtiE60XAxevXSh49XQsEqq+RYibhzwHhiOjXSUf3FrxiRh8EhsFxCywpaxDRA1MX
	 wucK5eD7rPwJCoIsRkf5uFqu3qCfAVtZ2ZkGcoHYnjD4EDK52STZGHnRYJuq+KPcW0
	 iM3n7NjfTmIh0Tc+Oehno9tajJ5Mi+DtlLXSF/78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 041/158] net: dsa: mt7530: fix mirroring frames received on local port
Date: Tue, 23 Apr 2024 14:37:43 -0700
Message-ID: <20240423213857.241897446@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit d59cf049c8378677053703e724808836f180888e ]

This switch intellectual property provides a bit on the ARL global control
register which controls allowing mirroring frames which are received on the
local port (monitor port). This bit is unset after reset.

This ability must be enabled to fully support the port mirroring feature on
this switch intellectual property.

Therefore, this patch fixes the traffic not being reflected on a port,
which would be configured like below:

  tc qdisc add dev swp0 clsact

  tc filter add dev swp0 ingress matchall skip_sw \
  action mirred egress mirror dev swp0

As a side note, this configuration provides the hairpinning feature for a
single port.

Fixes: 37feab6076aa ("net: dsa: mt7530: add support for port mirroring")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 6 ++++++
 drivers/net/dsa/mt7530.h | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 22b97505fa536..14f1b8d08153f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2517,6 +2517,9 @@ mt7530_setup(struct dsa_switch *ds)
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
+	/* Allow mirroring frames received on the local port (monitor port). */
+	mt7530_set(priv, MT753X_AGC, LOCAL_EN);
+
 	/* Setup VLAN ID 0 for VLAN-unaware bridges */
 	ret = mt7530_setup_vlan0(priv);
 	if (ret)
@@ -2625,6 +2628,9 @@ mt7531_setup_common(struct dsa_switch *ds)
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
+	/* Allow mirroring frames received on the local port (monitor port). */
+	mt7530_set(priv, MT753X_AGC, LOCAL_EN);
+
 	/* Flush the FDB table */
 	ret = mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);
 	if (ret < 0)
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ddefeb69afda1..9388c1205bea2 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -32,6 +32,10 @@ enum mt753x_id {
 #define SYSC_REG_RSTCTRL		0x34
 #define  RESET_MCM			BIT(2)
 
+/* Register for ARL global control */
+#define MT753X_AGC			0xc
+#define  LOCAL_EN			BIT(7)
+
 /* Registers to mac forward control for unknown frames */
 #define MT7530_MFC			0x10
 #define  BC_FFP(x)			(((x) & 0xff) << 24)
-- 
2.43.0



