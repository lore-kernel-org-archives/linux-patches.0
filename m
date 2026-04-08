Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AD033121F;
	Wed,  8 Apr 2026 18:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673930; cv=none; b=bPtddJrhs4Pd45XzTabMQXgXqSX/UOI+RoNAfJRbUHsN9t2HgbuCZLoJ0xiMGi++LxxWC2iuMAeaSEhwXzzUzg9hHJGqq/LX0StEdeLOukoIlwP3k7wgpFXhfsd/E5Ux8sttTIknZ8rXZKB0kZztuNNMRVwyybqBuCP992OrA/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673930; c=relaxed/simple;
	bh=pKgmOuFKGeuCyjwAevWhhPfP+8GN38cFWTMViNjA+zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jr3GEdsxp4/cDcuiMJuiBakYkHHF5+QfK5/NYrM5zqKxuUmmmfrJ+y/jvj/XVKrfrShZY0GnY0sPNMqBjMa+aetw2DZ1YFuKBi9VZ15zducO4uGlhouzyUM70cqp5bu2O12nN/fdoxSoCnMy1HvrNWWT45qZo+whW3b34S3oM2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vf4jk6qH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vf4jk6qH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DCAC19421;
	Wed,  8 Apr 2026 18:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673929;
	bh=pKgmOuFKGeuCyjwAevWhhPfP+8GN38cFWTMViNjA+zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vf4jk6qHHpeDCdEij1KeE/lR8e58RI/RONJU0j9SoRn9EcWgTgbXhIfHCm3Hz6vX6
	 +CtO/JgBWq8nTgCk8psYC9O4IGRTFH48E/rdYeK3IQWChT27oCiwe0BnlK/VpRvoM4
	 5mZNyDtlv+INGnmR7fOu0p9JglTojxNBcLBqmlnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Dhaval Giani (AMD)" <dhaval@gianis.ca>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/242] sched/fair: Use protect_slice() instead of direct comparison
Date: Wed,  8 Apr 2026 20:02:31 +0200
Message-ID: <20260408175931.241700518@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 9cdb4fe20cd239c848b5c3f5753d83a9443ba329 ]

Replace the test by the relevant protect_slice() function.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dhaval Giani (AMD) <dhaval@gianis.ca>
Link: https://lkml.kernel.org/r/20250708165630.1948751-2-vincent.guittot@linaro.org
Stable-dep-of: 1319ea57529e ("sched/fair: Fix zero_vruntime tracking fix")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index efd3cbefb5a22..fff27f3378cbf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1181,7 +1181,7 @@ static inline bool did_preempt_short(struct cfs_rq *cfs_rq, struct sched_entity
 	if (!sched_feat(PREEMPT_SHORT))
 		return false;
 
-	if (curr->vlag == curr->deadline)
+	if (protect_slice(curr))
 		return false;
 
 	return !entity_eligible(cfs_rq, curr);
-- 
2.53.0



