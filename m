Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434E6362143;
	Wed, 20 May 2026 16:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295483; cv=none; b=a6K06/s3mxe8KlBPZlVBxHnaS02+z1AEgv/xMMiLXIem8G/fSChzKEiyHpDG6QruFcktkMIgfGU5VS6hKTSDrLD7eE+x/jGIaXKXcFUc1B3/FtfnUa68poS7Rh3BR3NwdyI6pHdHPpBFX/mQV+0tsn70xvHRVWLrTzns3J3taTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295483; c=relaxed/simple;
	bh=SaWvM3XQQr5gH6hzhRAv99vX8kHAU96FF6vqTw0q6jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJEEYJyAKn3MhZ8cPEc8nnN/p1itWwXh4LIfuzfehIeytrGmtHcthzK31fvTRQLuTAaAHTqFbpSuRjyWLi62Aumuu+CpK7RqC7+DTF3GgaobEX5eQ/ee6s09Eg0lOetAYmytoJt8kFBCRGaWJ049BxbzQlTeQ7Wjp7tG8A2PVsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkdHdLh7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkdHdLh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4451F000E9;
	Wed, 20 May 2026 16:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295482;
	bh=Lg98v+l/R1Y+D08Tc3Ffx/HoPb9rqvP+1IyNlkftqa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkdHdLh7OxjKTo7bbjL1UF/XpaQggdBJDGupw4YGr9wkHHohW9nBV++CxGOio1x3W
	 mH77SeLOcg0nIgk9m1GEU9Zu3kmcW1XwmUrM+wJF+ednGsRHAUvFmLx5OfJkOLGj6M
	 j0T3d/APwA2vAfEMwhA4XG1q921F6ZU+CfIq9LCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0437/1146] sched_ext: Track @ps rq lock across set_cpus_allowed_scx -> ops.set_cpumask
Date: Wed, 20 May 2026 18:11:27 +0200
Message-ID: <20260520162158.088234378@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 9fb457074f6d118b30458624223abef985725a88 ]

The SCX_CALL_OP_TASK call site passes rq=NULL incorrectly, leaving
scx_locked_rq() unset. Pass task_rq(p) instead so update_locked_rq()
reflects reality.

v2: Add Fixes: tag (Andrea Righi).

Fixes: 18853ba782be ("sched_ext: Track currently locked rq")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 9c7ff5179e4f1..29ee463ec9bc4 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2742,7 +2742,7 @@ static void set_cpus_allowed_scx(struct task_struct *p,
 	 * designation pointless. Cast it away when calling the operation.
 	 */
 	if (SCX_HAS_OP(sch, set_cpumask))
-		SCX_CALL_OP_TASK(sch, SCX_KF_REST, set_cpumask, NULL,
+		SCX_CALL_OP_TASK(sch, SCX_KF_REST, set_cpumask, task_rq(p),
 				 p, (struct cpumask *)p->cpus_ptr);
 }
 
-- 
2.53.0



