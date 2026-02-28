Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F14332EA7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301269; cv=none; b=rtokICxHBbwYqa1wFfkz0DD7D4l/w9hcZRZvBNniYMx1I9T3fgCkl3CxfJeSD8+X1jwfioT+HOsUnZTsMMrj8LRDlslqM3uJVaNwos6itmAM8AQpCa1fHkNWShJvBBTmKidVnjiIqDLVINFGuHuxHfI67nrqJG0JtG9fWLLGrAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301269; c=relaxed/simple;
	bh=NRKqTnUJObOPjyQErjImIDJZ46r1K3jPKEhgdD/B0tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFJfXHxjoP9+2VSLXkSUpc0qXHxtz2U2FTVQX4whrKKTmXimGUhSTPREFq8yUJTQcEKBAVLFYmle4xo60XNaPRfnyba4TB6hwnfpMtQL+mZEOPus1pyja1YgoGR7UBB3bZPbs7KcSJazvovdhCpU9WokZDaEFRakQwzAWZ8rm+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Txj+zXhO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Txj+zXhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09BDC116D0;
	Sat, 28 Feb 2026 17:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301269;
	bh=NRKqTnUJObOPjyQErjImIDJZ46r1K3jPKEhgdD/B0tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Txj+zXhOjq+oMkF0cKuKebDQF9pew5s8rrYBh3q960gcYFb27xnphQ4UhAZXpvxd2
	 eij8kLXXXgB0k1wgF2iyQ8NbuCDZj6BuEgDAtDMdQZir63edo4WAkpT9Led6UYgLoS
	 LsB9xjVXkLhXY0zHIza+hcCD8WxdEQpKryODx5qZQMS3SjCq51o60XxQzkv/fZNhe4
	 /LEhNcKXoWl3E85NSHBpLJEPtsENp6mT9XpsVmV9C7oFWzLDgAXecnjS4F/EJ1pZjv
	 beCDfppCPpveRr6rJ9DqYMm6pfDcDp1coKUD4abafvqXRfdp9zYafL+odJb8EckCq6
	 jbVvBc1m9KyZQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Junrui Luo <moonafterrain@outlook.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 453/752] dpaa2-switch: validate num_ifs to prevent out-of-bounds write
Date: Sat, 28 Feb 2026 12:42:44 -0500
Message-ID: <20260228174750.1542406-453-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 8a5752c6dcc085a3bfc78589925182e4e98468c5 ]

The driver obtains sw_attr.num_ifs from firmware via dpsw_get_attributes()
but never validates it against DPSW_MAX_IF (64). This value controls
iteration in dpaa2_switch_fdb_get_flood_cfg(), which writes port indices
into the fixed-size cfg->if_id[DPSW_MAX_IF] array. When firmware reports
num_ifs >= 64, the loop can write past the array bounds.

Add a bound check for num_ifs in dpaa2_switch_init().

dpaa2_switch_fdb_get_flood_cfg() appends the control interface (port
num_ifs) after all matched ports. When num_ifs == DPSW_MAX_IF and all
ports match the flood filter, the loop fills all 64 slots and the control
interface write overflows by one entry.

The check uses >= because num_ifs == DPSW_MAX_IF is also functionally
broken.

build_if_id_bitmap() silently drops any ID >= 64:
      if (id[i] < DPSW_MAX_IF)
          bmap[id[i] / 64] |= ...

Fixes: 539dda3c5d19 ("staging: dpaa2-switch: properly setup switching domains")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/SYBPR01MB78812B47B7F0470B617C408AAF74A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 66240c340492c..78e21b46a5ba8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3034,6 +3034,13 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 		goto err_close;
 	}
 
+	if (ethsw->sw_attr.num_ifs >= DPSW_MAX_IF) {
+		dev_err(dev, "DPSW num_ifs %u exceeds max %u\n",
+			ethsw->sw_attr.num_ifs, DPSW_MAX_IF);
+		err = -EINVAL;
+		goto err_close;
+	}
+
 	err = dpsw_get_api_version(ethsw->mc_io, 0,
 				   &ethsw->major,
 				   &ethsw->minor);
-- 
2.51.0

