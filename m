Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5501A357A4A;
	Tue, 17 Mar 2026 17:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767179; cv=none; b=S3rHGqPHvZ8OXsubxI+s2xjbTIhoC5gPEdb5feKwISiuJTWcgNfM+jL+07X5rVLXEY/C506AvNfrCgnv+M1mLD94A3/VynV0JksvIA8v7otEUXa4hXT/e27+Y+ngWJQzn7R1L+E0wqjAdJeiZSyXak3x0RLPEii7zG77OdUUj04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767179; c=relaxed/simple;
	bh=ZL4+bgK8itTtMfvfrje4GPdirVNBaSrx+dX2qPFoYmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4vEt1CDM/efWK8Tm7dcUBPMJMA458JH1fQ1n/59s4nOLeN4qcHLGhCQtV6qyTA7bP0BZ1677JfFZv8BEWWRMPFTF3FidhHNaZUtw3ciWTSzCAJ3r2+Wvs5P1y3BbmDFRH9SBJ5r/VJyMzOBU5sYq58NJDTM9b2MoLF5EFlbGxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQ4rx9et; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQ4rx9et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0C1C4CEF7;
	Tue, 17 Mar 2026 17:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767178;
	bh=ZL4+bgK8itTtMfvfrje4GPdirVNBaSrx+dX2qPFoYmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQ4rx9etYWC1Uz32ybIxitWJ+jRfG5cQP3ronIiSIg5OCM85iigjCoogDiIZChRBm
	 Lf2QBOMYRg37m7LxZ8f5CXyajpVVxUIpnP/8ese9VxLYrgABdFHyEKV+5f8IJ4uo6z
	 56XJRrFajk3XL4wtNey0c0wMxjNv3cy1EjS1DRhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Song Liu <song@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/333] workqueue: Use POOL_BH instead of WQ_BH when checking pool flags
Date: Tue, 17 Mar 2026 17:30:59 +0100
Message-ID: <20260317163000.479800045@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit f42f9091be9e5ff57567a3945cfcdd498f475348 ]

pr_cont_worker_id() checks pool->flags against WQ_BH, which is a
workqueue-level flag (defined in workqueue.h). Pool flags use a
separate namespace with POOL_* constants (defined in workqueue.c).
The correct constant is POOL_BH. Both WQ_BH and POOL_BH are defined
as (1 << 0) so this has no behavioral impact, but it is semantically
wrong and inconsistent with every other pool-level BH check in the
file.

Fixes: 4cb1ef64609f ("workqueue: Implement BH workqueues to eventually replace tasklets")
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 885a8b31f855b..9111ef6ccfe65 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -6269,7 +6269,7 @@ static void pr_cont_worker_id(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
 
-	if (pool->flags & WQ_BH)
+	if (pool->flags & POOL_BH)
 		pr_cont("bh%s",
 			pool->attrs->nice == HIGHPRI_NICE_LEVEL ? "-hi" : "");
 	else
-- 
2.51.0



