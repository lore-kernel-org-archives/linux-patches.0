Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08CB4F391E;
	Thu, 17 Sep 2026 17:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667264; cv=none; b=hZrVPbX3l+fTOfDY8tHOEqFjScCwGpZHmWLhwRlhG3eFZnPxUVa2z2TJnu4he1QWXpKszkG0BtBsGSL9iAfLKjJgL/L22SkEN7vY6wArR1JocBTiqHmygza/KeZl+fpcZLLKBZH1zz23mID1TdmsUnIRmlkUO8p3Alsd6a4YDBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667264; c=relaxed/simple;
	bh=VmybTJpKbVoGBVoEOLxLYEXosac1Dd05VmrltQnSmfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxlqXBuClkhiIyo/6mTT1Ly5PJPCPoAM50EKNzkMKaq/tsIsE4IPkbIjhGo7qc5lWuUD+WUF9CkDdKpYX9UJrnIqOt5/05T+SxKZp0dtZNTTgaiQKEb1A/sPSx2dbqXeP1A9vh9XpTmeQYjXuq1Ym5j4lUe9X6mVQ3iy5RksS/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5omUu6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5omUu6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2143C1F00893;
	Thu, 17 Sep 2026 17:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667262;
	bh=E8ZsOjUwtzC3R/JQkPbFL614Oi0bscjDm7OLEFhrYF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b5omUu6SBGP/uM2S4CGN/PGfzF5LyID6MB6NRMYxYdmbmxga8WgDjBCe2bTGggugY
	 HYZpDuFFvINtxdRrBCKbybb0bp1GwAFOODF5ECnFpgpom3fPIx2c9Ydya138D7tnht
	 D3Mwqjupgz/IIY6mtlmI0xn2Dq4GYX3Z/xBV/a88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0033/1102] net: mana: hardening: Reject zero max_num_queues from MANA_QUERY_VPORT_CONFIG
Date: Thu, 17 Sep 2026 15:59:36 +0100
Message-ID: <20260917151540.271796321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit 93ca1575dd1f43e24ad85663305e13114f9acdf1 ]

As a part of MANA hardening for CVM, validate that max_num_sq and
max_num_rq returned by MANA_QUERY_VPORT_CONFIG are not zero. These
values flow into apc->num_queues, which is used as an allocation count
and loop bound. A zero value would result in zero-size allocations and
incorrect driver behavior.

Return -EPROTO if either value is zero.

Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Link: https://patch.msgid.link/20260430085638.1875400-1-ernis@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 70fe4d837a0b6..d64ea270dca26 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -959,6 +959,12 @@ static int mana_query_vport_cfg(struct mana_port_context *apc, u32 vport_index,
 
 	*max_sq = resp.max_num_sq;
 	*max_rq = resp.max_num_rq;
+
+	if (*max_sq == 0 || *max_rq == 0) {
+		netdev_err(apc->ndev, "Invalid max queues from vPort config\n");
+		return -EPROTO;
+	}
+
 	if (resp.num_indirection_ent > 0 &&
 	    resp.num_indirection_ent <= MANA_INDIRECT_TABLE_MAX_SIZE &&
 	    is_power_of_2(resp.num_indirection_ent)) {
-- 
2.53.0



