Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F6B46E004;
	Tue, 21 Jul 2026 19:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661223; cv=none; b=SVfH+a5sLwoRrgPyr/6IRR+qKaXa1ZPCBWnRlaje044KI4uUBc2j5MTZgQVunsV2C/N2JLisbR0GR9D/Wt0QuWXmx+7hbLWhz5CN4O5EBM8qzKyeuX4zvLmnAoRY4gtE5CoaKMcwtnZEStOdT56Qb0b+9IaKpslssHcQzC5pYJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661223; c=relaxed/simple;
	bh=LKDlcCvn4KlqyWgcNbKRfjKWcfKiXmKZh4sBIG8/vzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICuaJxzP7oA+G+SgaloLvDsST4SzJVAWi9Gp8uQyo878gZR5R/+Ghybg3qL2CQnqMIobaFXE4qxFyc6pJfqkfva+QQcIHIs6W6zNLXbtOlUhjSdjTVcARXBmOo9vhZL7E8FAhiLTWHeTpaA9pQloquS1I+qmHJ1S7g2XtnWl2JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjuhDGdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjuhDGdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8829B1F000E9;
	Tue, 21 Jul 2026 19:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661222;
	bh=+hEep4PXCWFMz6+SG9/7XApp1KurC/kVuMlsYxIN110=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjuhDGdwvA0NXzdqOLUkhTgWItZLAjYP5aIdtAQ/5glppSr2znrbDBDW6IxWpO3T/
	 clNHanKx2V1/Q/1SQxw66O0Wto4qDXAtqEYlQyyDMbsvdvHhnzFMZyt61pVXFr+tM8
	 nNA5C+taeHk/dtde9HqAofAlhbTnDfHkFiYZRv7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1276/2077] net: mana: Fall back to standard MTU when PF reports adapter_mtu of 0
Date: Tue, 21 Jul 2026 17:15:49 +0200
Message-ID: <20260721152622.913583359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit 6bd81a5b4e0dbec2feb94a456bca9d9f00bc14b3 ]

Commit d7709812e13d ("net: mana: hardening: Validate adapter_mtu from
MANA_QUERY_DEV_CONFIG") rejected any adapter_mtu value smaller than
ETH_MIN_MTU + ETH_HLEN, including 0, returning -EPROTO and failing
mana_probe().

Some older PF firmware versions still in the field report
adapter_mtu as 0 in the MANA_QUERY_DEV_CONFIG response. With the
hardening check in place, the MANA VF driver now fails to load on
those hosts, breaking networking entirely for guests.

MANA hardware always supports the standard Ethernet MTU. Treat a
reported adapter_mtu of 0 as "the PF did not advertise a value" and
fall back to ETH_FRAME_LEN, the same value used for the pre-V2
message version path. Only jumbo frames remain unavailable until
the PF reports a valid MTU.

Other small-but-nonzero bogus values are still rejected, preserving
the original protection against the unsigned-subtraction wrap that
would otherwise let ndev->max_mtu underflow to a huge value.

Fixes: d7709812e13d ("net: mana: hardening: Validate adapter_mtu from MANA_QUERY_DEV_CONFIG")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260619055348.467224-1-ernis@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_bpf.c |  3 ++-
 drivers/net/ethernet/microsoft/mana/mana_en.c  | 16 ++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 7697c9b52ed346..d59dec89a80774 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -237,7 +237,8 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 		bpf_prog_put(old_prog);
 
 	if (prog)
-		ndev->max_mtu = MANA_XDP_MTU_MAX;
+		ndev->max_mtu = min_t(unsigned int, MANA_XDP_MTU_MAX,
+				      gc->adapter_mtu - ETH_HLEN);
 	else
 		ndev->max_mtu = gc->adapter_mtu - ETH_HLEN;
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index d7de4c4d25bbe5..8c66290e9ed6d7 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1215,12 +1215,24 @@ static int mana_query_device_cfg(struct mana_context *ac, u32 proto_major_ver,
 	*max_num_vports = resp.max_num_vports;
 
 	if (resp.hdr.response.msg_version >= GDMA_MESSAGE_V2) {
-		if (resp.adapter_mtu < ETH_MIN_MTU + ETH_HLEN) {
+		if (resp.adapter_mtu == 0) {
+			/*
+			 * Some older PF firmware versions report an
+			 * adapter_mtu of 0. MANA hardware always supports the
+			 * standard Ethernet MTU, so fall back to ETH_FRAME_LEN.
+			 * Jumbo frames will not be available in this case.
+			 */
+			dev_info(dev,
+				 "PF reported adapter_mtu of 0, falling back to %u (jumbo frames disabled)\n",
+				 ETH_FRAME_LEN);
+			gc->adapter_mtu = ETH_FRAME_LEN;
+		} else if (resp.adapter_mtu < ETH_MIN_MTU + ETH_HLEN) {
 			dev_err(dev, "Adapter MTU too small: %u\n",
 				resp.adapter_mtu);
 			return -EPROTO;
+		} else {
+			gc->adapter_mtu = resp.adapter_mtu;
 		}
-		gc->adapter_mtu = resp.adapter_mtu;
 	} else {
 		gc->adapter_mtu = ETH_FRAME_LEN;
 	}
-- 
2.53.0



