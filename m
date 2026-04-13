Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3006A238D27;
	Mon, 13 Apr 2026 16:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097979; cv=none; b=C3RnrIlYCg7yK0jxWklRtrp5eFGBkNtDe9OHkuerHCep0RGkYgGq8Qof1FkU3malvZ+hHUOJITMvlEwFJpl9NHgYmHxJOkdrBV75DN65tnqwACqIgfYDgTtip1V7MLArs7fXSx7Tyu/XVIYY6Q6RhO5zBbYQQwOwwA+LmM7EGYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097979; c=relaxed/simple;
	bh=AR0OfFrbcN93XiQdDnCw69iBJ4LshWaiXsWbRQKfbFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+YqGtfsolNRW9Va2hkgl9n5t7921KQLmng+b2o4rAQyFHsRg/JYdePCMjRFfMQOuAmf/e48SOMrMzQm9h3GdxF9vVhrGTqxQnV/sIg9lnw+1o8aprK90ffnCoQ53AMS4uLJcT37djfEe77LtNrX/wKa+BZvy3DRZuEhEVrQhvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mt9/Etoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mt9/Etoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76939C2BCAF;
	Mon, 13 Apr 2026 16:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097978;
	bh=AR0OfFrbcN93XiQdDnCw69iBJ4LshWaiXsWbRQKfbFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mt9/EtojJ4L6nMXRPuAf0CWi/iDBROgPLqITtmxRzmY4Um4mlLcyN3MLK8JKGLuhM
	 CJ3o9giWaMdEYyNI14XZ2REO48Qyx5PZ1ybrJrMz66dKmyUkES4ufeMjHobWXCT+Hh
	 x4/EXMpRdd2rB1QKqpi0+aw38Y3DUsebXDm0B3pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 347/570] RDMA/irdma: Update ibqp state to error if QP is already in error state
Date: Mon, 13 Apr 2026 17:57:58 +0200
Message-ID: <20260413155843.487651922@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 40960f0803fbc..f1924e84d2568 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1353,6 +1353,7 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		case IB_QPS_ERR:
 		case IB_QPS_RESET:
 			if (iwqp->iwarp_state == IRDMA_QP_STATE_ERROR) {
+				iwqp->ibqp_state = attr->qp_state;
 				spin_unlock_irqrestore(&iwqp->lock, flags);
 				if (udata) {
 					if (ib_copy_from_udata(&ureq, udata,
@@ -1549,6 +1550,7 @@ int irdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 		case IB_QPS_ERR:
 		case IB_QPS_RESET:
 			if (iwqp->iwarp_state == IRDMA_QP_STATE_ERROR) {
+				iwqp->ibqp_state = attr->qp_state;
 				spin_unlock_irqrestore(&iwqp->lock, flags);
 				if (udata) {
 					if (ib_copy_from_udata(&ureq, udata,
-- 
2.53.0



