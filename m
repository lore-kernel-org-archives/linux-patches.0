Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916B937F8C2;
	Wed,  8 Apr 2026 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671786; cv=none; b=h3/4orwQF/MN5j74PaL2dNP3VHnpTJXGm9YPkI/LZ3oWp6XG4qspBcEIt4o1X4nuxh6C+gu1pGM8oUGOCWyAiVzJLgiKXGEa4jNRI3AlGo0xlrmxo24/vTx7pyAMsPbvgwIGD4aaa9xw205XeTr3QcJhOONBOapQJSyTy6CHqv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671786; c=relaxed/simple;
	bh=HtYndsOOYQjaCHfHXg2GAMUctOTtnoAwbfME82x1+JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5HZfDZtZ0jz5oCYEbKQCbgrJG2Sq/peQTcqYeF9ZXHWHyFcdCmMNfLNqeW9qsFNvryAGFslcHbcwieCXzVaybq7dW8t/m4rv8je8ONW/1EQsIxHvKgyxPikKDEPic/r7DCtSrZngN9io4mby65u9OCahZjHKVo+QHZqJtS1xXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BU9+1Vc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BU9+1Vc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284D4C19421;
	Wed,  8 Apr 2026 18:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671786;
	bh=HtYndsOOYQjaCHfHXg2GAMUctOTtnoAwbfME82x1+JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BU9+1Vc/+f2gSoAIItegSfpUFx2nR77nXJdmTBvsa2IprZ490peL+8DAjy8acCV2N
	 GQvU6F6gBl5Hd2Us4l1uqpgeeHATc/KimwqtLQ53YjjESpt6rL6RSkMLcIGBbMxxRH
	 IXG/g0nYyXJpzjuCnaVyXqOdS/d8XnVf5u+XDIzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/312] RDMA/irdma: Remove a NOP wait_event() in irdma_modify_qp_roce()
Date: Wed,  8 Apr 2026 19:59:45 +0200
Message-ID: <20260408175936.278971559@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tatyana Nikolova <tatyana.e.nikolova@intel.com>

[ Upstream commit 5e8f0239731a83753473b7aa91bda67bbdff5053 ]

Remove a NOP wait_event() in irdma_modify_qp_roce() which is relevant
for iWARP and likely a copy and paste artifact for RoCEv2. The wait event
is for sending a reset on a TCP connection, after the reset has been
requested in irdma_modify_qp(), which occurs only in iWarp mode.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 5bd4062fa82ff..6d1ca8a1717c4 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1341,8 +1341,6 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			roce_info->rd_en = true;
 	}
 
-	wait_event(iwqp->mod_qp_waitq, !atomic_read(&iwqp->hw_mod_qp_pend));
-
 	ibdev_dbg(&iwdev->ibdev,
 		  "VERBS: caller: %pS qp_id=%d to_ibqpstate=%d ibqpstate=%d irdma_qpstate=%d attr_mask=0x%x\n",
 		  __builtin_return_address(0), ibqp->qp_num, attr->qp_state,
-- 
2.53.0



