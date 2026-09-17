Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5F74F68BA;
	Thu, 17 Sep 2026 16:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663941; cv=none; b=TCOEAWOLx1qWU49PFkC5vnmal8aPiKSRGGqqinBt+j4lGKRP1nub/JHlhbbCp+gQOQ1JXIByH4IvQIvKxIla6ujE81n2yGDxnkBkFjGFOFzmisJgKIPa/GSlbMZ3MKJMboN8uAeh+U7Ox4gY/KdAqYdOQ9TltKO/q9A3k+e8oJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663941; c=relaxed/simple;
	bh=ZYQLsbHVtqvM9Ca6SXwfiOoR4nK4CEnIor9oajFhCuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sBKNBc515LG2WBPaQgB6UsjVIhht2IDlPvE8iF9dzfYTah0Eho6+s/AFjMIsizuYX1pxQ/+BhKSbfLpgs0g84/73KKpHm+Gww+YtOwvo0RUG476/9XNa4Q9gWSyp7gSmGlk//J2DHfJ7ETp3DvNEVTykPMp4dfmFwplLB3pOlCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVPu3eSU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVPu3eSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024DF1F000FF;
	Thu, 17 Sep 2026 16:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663939;
	bh=xFN1K29Cp+S/pKErGZaFINR7fAmYBOCih5V9+qE3xnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVPu3eSUeso2oVbUuK8cfbh/TK5idCgtO2W5wbVx5DbEy7NUsIaQpS8zLx79zQcSy
	 WRRZwM3PnBgGksmBT0Mv6AkPZqtVqJy1P1VZbkYw4HTy7BsEXdk1s0xzf9Qaj2/dqn
	 qtLkZZVZDyqAUEyPhIHWSBi8T8ssw6nr7FDGBXkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0204/1250] RDMA/counter: Fix num_counters leak on bind_qp failure in alloc_and_bind()
Date: Thu, 17 Sep 2026 15:59:59 +0100
Message-ID: <20260917151557.650337159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/infiniband/core/counters.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 5dfd64b0449dc..a2c85840c501a 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -198,12 +198,20 @@ static struct rdma_counter *alloc_and_bind(struct ib_device *dev, u32 port,
 
 	ret = __rdma_counter_bind_qp(counter, qp, port);
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
+		__counter_set_mode(port_counter, RDMA_COUNTER_MODE_NONE, 0,
+				   false);
+	mutex_unlock(&port_counter->lock);
 err_mode:
 	rdma_free_hw_stats_struct(counter->stats);
 err_stats:
-- 
2.53.0



