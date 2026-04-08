Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B2337F8C2;
	Wed,  8 Apr 2026 18:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671784; cv=none; b=InJ5qXl8IHt/CSJIbbdADsFUGuLIaSTEpcwe9cEkWrK+otK4qRDD+Kqrr2euHfNCI8jywk8tEOQThakmjuC2KVa8L8KBf6Bdm4TjWawh/DbZbZK3kWpprPrqhgVnAmxkWQsMc3gkpbnBjSnxLk5ruYggzBY8CymdcSU9AId9Gmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671784; c=relaxed/simple;
	bh=PcOcU6oKEwfepJIWZh2xzT5xxn8Z+YtEtOOAU70/j+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isw28G/nqj2NYjWJx61JCQeOt0uvfBbnUZUdrHHFjh0TClhOU65JIRX6jzN7BMgRKThWFLpt2b0I8sOhfC2GFXeL8cSQg1nt5OOQBzRYidCI8Kk/PO29bS2/sgMERsBJeUJsSzBi2jOwix5edSGWpOI535uxVQxRHADPpqwiRqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1K68X/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1K68X/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925A3C19421;
	Wed,  8 Apr 2026 18:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671783;
	bh=PcOcU6oKEwfepJIWZh2xzT5xxn8Z+YtEtOOAU70/j+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1K68X/Dz2scNKkNtUPK6ZH3Kh6E89dWoDZcjnBMryL/ZbqVHipT3RuNfPWQDpRua
	 WTDio3KTi2XwEgyDcWEjM2/8vqZygv6UrX7/ViuEP4dgF+Z/WtTUFauz8PvBKaPCqP
	 viBup9oQEpVfX6wBr3bdB+IRqSZaMqzhFNvd9g0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/312] RDMA/irdma: Update ibqp state to error if QP is already in error state
Date: Wed,  8 Apr 2026 19:59:44 +0200
Message-ID: <20260408175936.241757079@linuxfoundation.org>
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

[ Upstream commit 8c1f19a2225cf37b3f8ab0b5a8a5322291cda620 ]

In irdma_modify_qp() update ibqp state to error if the irdma QP is already
in error state, otherwise the ibqp state which is visible to the consumer
app remains stale.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 2f5299c9d9ed3..5bd4062fa82ff 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1419,6 +1419,7 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		case IB_QPS_ERR:
 		case IB_QPS_RESET:
 			if (iwqp->iwarp_state == IRDMA_QP_STATE_ERROR) {
+				iwqp->ibqp_state = attr->qp_state;
 				spin_unlock_irqrestore(&iwqp->lock, flags);
 				if (udata && udata->inlen) {
 					if (ib_copy_from_udata(&ureq, udata,
@@ -1624,6 +1625,7 @@ int irdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 		case IB_QPS_ERR:
 		case IB_QPS_RESET:
 			if (iwqp->iwarp_state == IRDMA_QP_STATE_ERROR) {
+				iwqp->ibqp_state = attr->qp_state;
 				spin_unlock_irqrestore(&iwqp->lock, flags);
 				if (udata && udata->inlen) {
 					if (ib_copy_from_udata(&ureq, udata,
-- 
2.53.0



