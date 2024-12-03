Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C35381B1;
	Tue,  3 Dec 2024 15:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241369; cv=none; b=JvN/PRcdfsot4gbYErCGZVLAjh3hYWywVY56LnxWXkaF/B2vAfGp3uKr05XNA2gfTJiOwgEvS35dZLAgNGqTTfB54pkN9b0ArGUJefZ9wSatKaC4MoENrb6bDsFDDm5BHPCjMoGDevx7kYxGJgBBPPO3Km1DzkZBRauEvdXlTdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241369; c=relaxed/simple;
	bh=r4+w8pBfCdZfwaalBZAVSHMgqAa1SaNMkBfIxw22SRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxCcSahNKAGq01PWkTwmhX20DvWgQMPk1WIq6y4VOAslnjgpBe3tmHko9SpIIiZcI6hxYUu4vYM9dcFjNdKgUb56Uq2fAYyezxnekgWFlCRFCnD5JmyTxoAFNJKun9v2/pQjdQbWOiYGnx6hatHOZ9n+vLCtpyOmlDI7qXKkPjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8P5B+pU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8P5B+pU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8640AC4CECF;
	Tue,  3 Dec 2024 15:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241369;
	bh=r4+w8pBfCdZfwaalBZAVSHMgqAa1SaNMkBfIxw22SRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8P5B+pUsk5apf9QnOtoT85guXHDsgmVPuqmFPczeMjkk4vRAiqocYinANO37XPaY
	 NjgXoufT/dIJ7COq3CmTYfXnLV2axSoEh1ZlzFea0wkF2+86Qiew3WWSwNYEkS1Stp
	 vhwWekhFfznsJ4W5Ppm9AHnLiWwMxUshdnDD0lHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 399/826] RDMA/rxe: Set queue pair cur_qp_state when being queried
Date: Tue,  3 Dec 2024 15:42:06 +0100
Message-ID: <20241203144759.326181778@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 775e6d3c8fda41083b16c26d05163fd69f029a62 ]

Same with commit e375b9c92985 ("RDMA/cxgb4: Set queue pair state when
 being queried"). The API for ib_query_qp requires the driver to set
cur_qp_state on return, add the missing set.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Link: https://patch.msgid.link/20241031092019.2138467-1-liujian56@huawei.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index d2f7b5195c19d..91d329e903083 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -775,6 +775,7 @@ int rxe_qp_to_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask)
 	 * Yield the processor
 	 */
 	spin_lock_irqsave(&qp->state_lock, flags);
+	attr->cur_qp_state = qp_state(qp);
 	if (qp->attr.sq_draining) {
 		spin_unlock_irqrestore(&qp->state_lock, flags);
 		cond_resched();
-- 
2.43.0



