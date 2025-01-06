Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038B914D28C;
	Mon,  6 Jan 2025 15:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177820; cv=none; b=egt/Gbhw7Kz9c8AX41BH7g/7LuYYasHiVTAhgnFBVE1AxzZv8UzjSsAIaJ+jHlM2wsr+RIfGGl8VTZjp8uBRH6TtHxAFcim9L6tAdltQMUJxgM/CIrq4lC2JoXKT8WCb4wg8f9g51gkpoW2l1K0rhFE/TngeadAEDej51E001Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177820; c=relaxed/simple;
	bh=x119f9Qp3tLDCK8b33LvBIZXErZclCMKJETt0WU57tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLZzs1Zo8oM2hCQT1295n3T4O3BhVTkx+vIeB4qOvc4xUZgmPblDyFKU59+cDNchjr9yisRNwI3GdQCELzMkuZp1NZtgect2Yboa4OVucsTaXkKQnlrEYEUXzH0n2xWIis937HzqyvjffkEfO1SKIEutX6EyQpTb0xRT6I0XTBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l94KLoY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l94KLoY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5695FC4CEE1;
	Mon,  6 Jan 2025 15:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177819;
	bh=x119f9Qp3tLDCK8b33LvBIZXErZclCMKJETt0WU57tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l94KLoY/qvnnV6fBxEqOswKzwRD2fd4J8xoC8EB3nR309Zk3ZxQ9Mjz9yjVzxhy3c
	 3BGZV0yu1Bg8wbX3rzZqDeNvzPt946tXyHTRqjOAyJoFzFSCyC0ap8LjGLTCeM7rNO
	 8S0DPvR8o0oroDhKTyQgrDEdbhTMxucKFNTnR94A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Jie <liangjie@lixiang.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/156] net: sfc: Correct key_len for efx_tc_ct_zone_ht_params
Date: Mon,  6 Jan 2025 16:15:53 +0100
Message-ID: <20250106151144.259306595@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Jie <liangjie@lixiang.com>

[ Upstream commit a8620de72e5676993ec3a3b975f7c10908f5f60f ]

In efx_tc_ct_zone_ht_params, the key_len was previously set to
offsetof(struct efx_tc_ct_zone, linkage). This calculation is incorrect
because it includes any padding between the zone field and the linkage
field due to structure alignment, which can vary between systems.

This patch updates key_len to use sizeof_field(struct efx_tc_ct_zone, zone)
, ensuring that the hash table correctly uses the zone as the key. This fix
prevents potential hash lookup errors and improves connection tracking
reliability.

Fixes: c3bb5c6acd4e ("sfc: functions to register for conntrack zone offload")
Signed-off-by: Liang Jie <liangjie@lixiang.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://patch.msgid.link/20241230093709.3226854-1-buaajxlj@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/tc_conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/tc_conntrack.c b/drivers/net/ethernet/sfc/tc_conntrack.c
index d90206f27161..c0603f54cec3 100644
--- a/drivers/net/ethernet/sfc/tc_conntrack.c
+++ b/drivers/net/ethernet/sfc/tc_conntrack.c
@@ -16,7 +16,7 @@ static int efx_tc_flow_block(enum tc_setup_type type, void *type_data,
 			     void *cb_priv);
 
 static const struct rhashtable_params efx_tc_ct_zone_ht_params = {
-	.key_len	= offsetof(struct efx_tc_ct_zone, linkage),
+	.key_len	= sizeof_field(struct efx_tc_ct_zone, zone),
 	.key_offset	= 0,
 	.head_offset	= offsetof(struct efx_tc_ct_zone, linkage),
 };
-- 
2.39.5



