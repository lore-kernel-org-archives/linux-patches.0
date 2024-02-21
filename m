Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D741E1E4B2;
	Wed, 21 Feb 2024 13:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522989; cv=none; b=K2mXAjtaR53drz7/GqcbLXEoBGr1r7kaqrZP4eEsttv0BBOqdYvT5qizomvgNLdXLRl0B4tQ7phB+SFjU4aiSnKO9BdAiztJ6ia7D4Wj7a4plmmtGf39V/TZYuudFPB+V5dBwQ187Q+alpA/RVdv5H2W+EJrxeIDdcwHq7wH328=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522989; c=relaxed/simple;
	bh=Jr3YYsiHNTghKnHLTF71i1tUMHZwLtqVIvHuJkxZd6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfG32JbJjxtpoXdOkNkgBJeILUP1xLLbOfIHCnYYbUuVEaP6tRRHaUS8nekv8zKRSp30QWxTkBla9709pzSOJyHESYEDHl98Y+2o+e6A+pgHkqMwGLrev67hw3BkEU1ErZT92dap+6/AnKPJZMFzv2y5mozIjr7ZOJoUps6Kz2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBf17v8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBf17v8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61462C433F1;
	Wed, 21 Feb 2024 13:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522989;
	bh=Jr3YYsiHNTghKnHLTF71i1tUMHZwLtqVIvHuJkxZd6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBf17v8IdZfMKnJ8Yo40YCEPjHNZ3BHvxEPeRc1HjSfrZso0O5yS9raVoC+/VV3z9
	 rwtzRoD1oHU4KXVgBvW2W0AfCCdpttbJiyNTKA3KEL0q/oFyiJsy+ZvlZz76X6RKzk
	 wCG5u7Ox/ZMWqi3LnHDaJT6DHw36qhqF1pa9icSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 309/476] octeontx2-pf: Fix a memleak otx2_sq_init
Date: Wed, 21 Feb 2024 14:06:00 +0100
Message-ID: <20240221130019.435087479@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit b09b58e31b0f43d76f79b9943da3fb7c2843dcbb ]

When qmem_alloc and pfvf->hw_ops->sq_aq_init fails, sq->sg should be
freed to prevent memleak.

Fixes: c9c12d339d93 ("octeontx2-pf: Add support for PTP clock")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Acked-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 572c981171ba..6b024d29eaf3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -856,8 +856,11 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	if (pfvf->ptp) {
 		err = qmem_alloc(pfvf->dev, &sq->timestamps, qset->sqe_cnt,
 				 sizeof(*sq->timestamps));
-		if (err)
+		if (err) {
+			kfree(sq->sg);
+			sq->sg = NULL;
 			return err;
+		}
 	}
 
 	sq->head = 0;
@@ -872,7 +875,14 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	sq->stats.bytes = 0;
 	sq->stats.pkts = 0;
 
-	return pfvf->hw_ops->sq_aq_init(pfvf, qidx, sqb_aura);
+	err = pfvf->hw_ops->sq_aq_init(pfvf, qidx, sqb_aura);
+	if (err) {
+		kfree(sq->sg);
+		sq->sg = NULL;
+		return err;
+	}
+
+	return 0;
 
 }
 
-- 
2.43.0



