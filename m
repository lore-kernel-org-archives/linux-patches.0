Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891D93AEF55;
	Sat, 17 Oct 2026 16:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255303; cv=none; b=YQPogOu0qWqfHF7QsOXhF99TLFM/qBjWBCFDZvtl1fjnRpRPHX30fr8foGMS7+Qddjvz/wVJ7EZJIcgiyflBfYQNizSKSN6cdPSkMRPSAeYnSkvhX3mI2YzPCCuwY7wHAyFvnNIpl444vbqTtkrMVIYCaruIHhMbt/Xi4a8U+Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255303; c=relaxed/simple;
	bh=2FMBrrY7H5h3LnSICWVkNUswa0wushgSBiz272HqZAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uMKs45MMvzfHY0PAZWpyIt2WCtDhW7tTEAlgs9MokoQ1xB5F+ZKS5YZHMrNmHZ7zya/Q7IgHIWL5I3jQ5/+SWtiuWUDWZC3X4xVqCiEcmCnYUHOLg4ufypv3eba7hA454VFBdpll5Ohnc1zqON1xo7A7IeJ+Bk+Ql8vcT3jfd7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q35TurDl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q35TurDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FF41F000C6;
	Sat, 17 Oct 2026 16:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255302;
	bh=DX7Sf2BCs6FPNpyGtB+0O3YuEgTiW1GWOHOPpiFel0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q35TurDl+Tt4+CMPipWsc2maW6R7G9kKxqyVSByATO7ofqqa+DqiURxg3R/11XnCo
	 cdPVvDTtsCKr5R2DX3mVEYI7HqaH/YJ0XNH0PdG8EYu14DrpBYAwJPDB3eRMWwIs0C
	 34f13wfYBo35D+MaAjbvDd8FieOIIoD4eFXjG3c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 730/869] RDMA/counter: Fix num_counters leak on bind_qp failure in alloc_and_bind()
Date: Sat, 17 Oct 2026 17:59:31 +0200
Message-ID: <20261017160055.663391577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit 4fbc8230009f5b1bcd13cc74c5a6a43ddba141fd ]

When __rdma_counter_bind_qp() fails in alloc_and_bind(), the error path
jumps to err_mode which frees the counter without decrementing
port_counter->num_counters. The only place that decrements is
rdma_counter_free(), which is unreachable since the counter was never
successfully bound.

This leak accumulates across repeated failures, permanently preventing
the port from switching to AUTO mode (-EBUSY in __counter_set_mode())
and blocking the MANUAL→NONE auto-revert in rdma_counter_free(). When
the mode was NONE before the call, the MANUAL mode set by
__counter_set_mode() also leaks since the revert logic is never
reached.

Add an err_bind label between the num_counters increment and the
existing err_mode label. It decrements num_counters and mirrors the
MANUAL→NONE revert from rdma_counter_free(), ensuring the port state
is fully restored on bind failure.

Link: https://patch.msgid.link/r/20260520104546.1776253-2-cuitao@kylinos.cn
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/counters.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 8cbca897fc531..78a76b4fa6f68 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -190,12 +190,19 @@ static struct rdma_counter *alloc_and_bind(struct ib_device *dev, u32 port,
 
 	ret = __rdma_counter_bind_qp(counter, qp);
 	if (ret)
-		goto err_mode;
+		goto err_bind;
 
 	rdma_restrack_parent_name(&counter->res, &qp->res);
 	rdma_restrack_add(&counter->res);
 	return counter;
 
+err_bind:
+	mutex_lock(&port_counter->lock);
+	port_counter->num_counters--;
+	if (!port_counter->num_counters &&
+	    port_counter->mode.mode == RDMA_COUNTER_MODE_MANUAL)
+		__counter_set_mode(port_counter, RDMA_COUNTER_MODE_NONE, 0);
+	mutex_unlock(&port_counter->lock);
 err_mode:
 	rdma_free_hw_stats_struct(counter->stats);
 err_stats:
-- 
2.53.0



