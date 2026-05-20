Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BC52046BA;
	Wed, 20 May 2026 17:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298245; cv=none; b=TXWSg5dZRs5FSNKhNITM4DmCaLs5F+rvxrAX5VLS6ug2+v9cDc0SrRWxw1IJmj1idzBXg4f4/9eoTFiyMBitk+hYT/u+7ylvcjnBuSz8Qrw7z2Wfh5MiSCIO4G/AvWhjpUxfFEOM11cTu2n0N0XQIeAs7eBuH9vZcHiLnsz4krw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298245; c=relaxed/simple;
	bh=bdOJgVzMgdmGRz3rNfGPACoU/FzVhCiCmFRvmHT5now=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JH3sDRZ3pdtZCQV0JDOlU3jCTt2HZjC7H9bSUVa+F5U0d+AaYCK//uNeR7ydhFK+VutZLA+zhhnb3D80ZTEoVlL9zJxt9sBY4oOB8iGVF5khVXbjRyWdFsMI1U1HbB+76+BfhoPTroeCO6CY9LgK0XrmTxRRl2ES6QOOjleZoRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+M/V5E6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+M/V5E6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67821F000E9;
	Wed, 20 May 2026 17:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298244;
	bh=0rq3EVaPQywBPOkjaBqeQQP3cN5fm6NK/j1owxVO98c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+M/V5E6Ujx9x3KzAwEFF6BohxLYBPFeD0RESc1J2cKCwzNYW/mwlePxzRCOKAxG4
	 5lGcqxY2JYF0qhx3g45XdD3STeD88piRt+6r6NBm78jdNoxNTwPCa6+5zC6EQc5pjC
	 ASm8X6cGVhR8sLDonBVfD7g5QQWHLFbskgmiptnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 336/957] sched_ext: Track @ps rq lock across set_cpus_allowed_scx -> ops.set_cpumask
Date: Wed, 20 May 2026 18:13:39 +0200
Message-ID: <20260520162141.818928393@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 177bbf31116d0..17905ad77598c 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2606,7 +2606,7 @@ static void set_cpus_allowed_scx(struct task_struct *p,
 	 * designation pointless. Cast it away when calling the operation.
 	 */
 	if (SCX_HAS_OP(sch, set_cpumask))
-		SCX_CALL_OP_TASK(sch, SCX_KF_REST, set_cpumask, NULL,
+		SCX_CALL_OP_TASK(sch, SCX_KF_REST, set_cpumask, task_rq(p),
 				 p, (struct cpumask *)p->cpus_ptr);
 }
 
-- 
2.53.0



