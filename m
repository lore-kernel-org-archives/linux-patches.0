Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297C0399377;
	Thu, 17 Sep 2026 16:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661008; cv=none; b=L2BAAR2QaAxTSujGztXoMXxEkvgLUt6dBNXrrkvPnH3MOWtIeIDVsmIl6IcNa2o+d4SUUYUbPHzGp2CmBd9eIdFxXkjGAJR1jqppHtSzj7CckxNn5IbsKdRD7kpE8HIOWoAs2h1rPfc5k7NDFbtqmougw4BJ5YvHZ91mQqwpf+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661008; c=relaxed/simple;
	bh=UNdk66oz8fLRomiZ0SglyslTDL84Uxutd4w0Sl1nFko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZnHa3CL8ncvbwGnZ/7YM6fAWOwEuGasrMa3QQ0p9EtJEQaxzzYd0BPVXxnJMMpNec3szME5veOmBh+4t+Wy5ATeMTNKbYYW321j+fEsJyRUCvyvssNYf4/thttlqOQIJq3Q6mgk3jTwRjujphC7T2mZvwXeFoT0b2L/mR9EHrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsvtCSPM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsvtCSPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2D51F000FF;
	Thu, 17 Sep 2026 16:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661006;
	bh=SsE3Co6wcU+ZaMRVMUuZSwXCz1WpUfJWE9sszd/2XZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VsvtCSPM+kfpcszzhuaOvA7Jy8KhiS858YRtK4V4lGbL3EstZhFvhaXhYcOimrGeY
	 YGdgJTDpWqJL/1n2+3WB7TKAimsypgs3D5ncDdutoTF8Mk0xdiV/rRQwVjnrvfexAV
	 M6JSOmGpVWjra87uTyhrxwN9mOOI94b+REPEE8bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0051/1250] net: mana: hardening: Reject zero max_num_queues from MANA_QUERY_VPORT_CONFIG
Date: Thu, 17 Sep 2026 15:57:26 +0100
Message-ID: <20260917151553.321306361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index adf25acb0d46f..b61da240ac1bb 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1262,6 +1262,12 @@ static int mana_query_vport_cfg(struct mana_port_context *apc, u32 vport_index,
 
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



