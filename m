Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B2F2FA650;
	Tue, 17 Jun 2025 16:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179066; cv=none; b=e2xLoKzrPgB/LDCrrdRo2vujb25dqAjQLrpZHghlHfrWeG0/BVY8CKf3xftKuOZRkjjdd9xRRkk9hIFJve8hxvcQU3y6sqai497boLaC9mG12s2ipFCgKyAPjmVAUsg667kO5k8GmIk3fogvZHkzwr/WvPOSK1OaYwuZ/BVRil0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179066; c=relaxed/simple;
	bh=Ot0tEJs+/IhpDRu85wM2xGlGIV86EYkJpX2dmmfNT6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBmIUcn6u1qtq77698EMkyjFtTbWNZQ1+WPakmj3UuQRqfvJxr/7CiSAj6WDvltMR8ksH7kAb2SgszCyEnxwQRgXXMjLGokMQ0zjJjHA3M5GhlvAYyol/HltIjcoe+nkPmVqbcyr2tR3y9teohf57f7+tAR0RTxDTzilBtDlTO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AO4wRbbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AO4wRbbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A42C4CEE3;
	Tue, 17 Jun 2025 16:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179066;
	bh=Ot0tEJs+/IhpDRu85wM2xGlGIV86EYkJpX2dmmfNT6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AO4wRbbdckkdszIm4byk9o2dse3EVN9cgzu68Qj6jJUQJ8hiUwNzqUOYBehjb2Vhn
	 x/0bZHQLbG+DOrqRKFB/O4uIgvt3NOfK71nqvHxhihOVt0RDJjCSQCL45HGb3qp1Yo
	 wkZ71yZTM3QPaPJc6ZJZwfGGmBvLbvamqHRPh2fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 609/780] net: ti: icssg-prueth: Fix swapped TX stats for MII interfaces.
Date: Tue, 17 Jun 2025 17:25:17 +0200
Message-ID: <20250617152516.281735963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit 919d763d609428c2680ec8159257d9655f002f89 ]

In MII mode, Tx lines are swapped for port0 and port1, which means
Tx port0 receives data from PRU1 and the Tx port1 receives data from
PRU0. This is an expected hardware behavior and reading the Tx stats
needs to be handled accordingly in the driver. Update the driver to
read Tx stats from the PRU1 for port0 and PRU0 for port1.

Fixes: c1e10d5dc7a1 ("net: ti: icssg-prueth: Add ICSSG Stats")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250603052904.431203-1-m-malladi@ti.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_stats.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_stats.c b/drivers/net/ethernet/ti/icssg/icssg_stats.c
index 6f0edae38ea24..172ae38381b45 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_stats.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_stats.c
@@ -29,6 +29,14 @@ void emac_update_hardware_stats(struct prueth_emac *emac)
 	spin_lock(&prueth->stats_lock);
 
 	for (i = 0; i < ARRAY_SIZE(icssg_all_miig_stats); i++) {
+		/* In MII mode TX lines are swapped inside ICSSG, so read Tx stats
+		 * from slice1 for port0 and slice0 for port1 to get accurate Tx
+		 * stats for a given port
+		 */
+		if (emac->phy_if == PHY_INTERFACE_MODE_MII &&
+		    icssg_all_miig_stats[i].offset >= ICSSG_TX_PACKET_OFFSET &&
+		    icssg_all_miig_stats[i].offset <= ICSSG_TX_BYTE_OFFSET)
+			base = stats_base[slice ^ 1];
 		regmap_read(prueth->miig_rt,
 			    base + icssg_all_miig_stats[i].offset,
 			    &val);
-- 
2.39.5



