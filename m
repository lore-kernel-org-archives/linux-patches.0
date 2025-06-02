Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF30223DFD;
	Mon,  2 Jun 2025 14:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874662; cv=none; b=nrcRWzm9IothR19bZPk9mUSQuUZoFkeBRnYsB1VntSMVSHg46hoQ1j1iAYsjbmgmugKpx3gH8fMpJzq2Apql+H/bxTYz/Th7h8SLbiO3fZQHYjZPFLO2Eh/GNyMfAcbr1imZebtK3Ny7JRp9l2mSSciOdpymx5VxFU8xA+Tbxgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874662; c=relaxed/simple;
	bh=56S1dU18OmZ5BOM3+ARh5SjyJ6ab2bbr3B1iq9Vtwto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arSrfr5rFLr5rImkYLBkAzJ68g8/VzkjA8eUfAHeeskNjy7M66r5937/fgU0/a0wcZrYxoLUKrIr1pLToVCZYk2rDCTMfu4eUnaQ2O1QeAy/54VQ0WKZcyGxm/UX5pFpfC5Xligh+m+KSpIfxX/SklNOS4a3m0qT2sl3Lfc9Rpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZHArqtv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZHArqtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02C6C4CEEB;
	Mon,  2 Jun 2025 14:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874662;
	bh=56S1dU18OmZ5BOM3+ARh5SjyJ6ab2bbr3B1iq9Vtwto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZHArqtv9/qx+G3i28Of8MeefbVEV5LK+QoW2Mi+Qq8R3uLoeMBaMdj0ywjNDKjB4
	 uJZR5YMmKSAkyx+0z8z04U8GKKutli7b7w3VbrVzOo/KboZQsiGdA9OHty/ZudNCwS
	 wZBgs/06sZyilACDQi6U6v+dkvrI2CFASEtnxs5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Su <jingsusu@didiglobal.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/204] dql: Fix dql->limit value when reset.
Date: Mon,  2 Jun 2025 15:47:08 +0200
Message-ID: <20250602134259.391392166@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jing Su <jingsusu@didiglobal.com>

[ Upstream commit 3a17f23f7c36bac3a3584aaf97d3e3e0b2790396 ]

Executing dql_reset after setting a non-zero value for limit_min can
lead to an unreasonable situation where dql->limit is less than
dql->limit_min.

For instance, after setting
/sys/class/net/eth*/queues/tx-0/byte_queue_limits/limit_min,
an ifconfig down/up operation might cause the ethernet driver to call
netdev_tx_reset_queue, which in turn invokes dql_reset.

In this case, dql->limit is reset to 0 while dql->limit_min remains
non-zero value, which is unexpected. The limit should always be
greater than or equal to limit_min.

Signed-off-by: Jing Su <jingsusu@didiglobal.com>
Link: https://patch.msgid.link/Z9qHD1s/NEuQBdgH@pilot-ThinkCentre-M930t-N000
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/dynamic_queue_limits.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/dynamic_queue_limits.c b/lib/dynamic_queue_limits.c
index e659a027036ec..f6807062b32a3 100644
--- a/lib/dynamic_queue_limits.c
+++ b/lib/dynamic_queue_limits.c
@@ -116,7 +116,7 @@ EXPORT_SYMBOL(dql_completed);
 void dql_reset(struct dql *dql)
 {
 	/* Reset all dynamic values */
-	dql->limit = 0;
+	dql->limit = dql->min_limit;
 	dql->num_queued = 0;
 	dql->num_completed = 0;
 	dql->last_obj_cnt = 0;
-- 
2.39.5



