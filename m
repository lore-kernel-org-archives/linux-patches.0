Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0F547CC83;
	Mon, 31 Aug 2026 13:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184766; cv=none; b=mIWbFJcUHpXQBmKSuoNpq8V5aYj4qsNKB60/IOS32NySR63Df+4NME6ztoNEyK6d6p9Cb0p5xPpnMWoUa+7F6PNfy5vKvhDO9nZ+cj2Kh+j9v/AP/yJSn3qj3hgTMQbZ/nnWi4AIfebqLD+5ogqrDgykQR6Wyq0YC2eLWzq2JnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184766; c=relaxed/simple;
	bh=io6LoaIIaRZokdCexPIM0Mq37+bxzRxOBiATHzYk50o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVMx72anQ3/qCI80BGfoTK2bF35umLh2qpfwTxlCEay9dse8xPsgKtitNHwhZ0iqPtzgZSOzPeC8kOPG6hvddvT2MUVYHM+5tndVDj6yWD6k8dofKyHdS7p0sYAuzhjhyVW10BKKhRpjzWzjQCesMYaeA0Ff7gY2yeInW7hTyvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUxdoamt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUxdoamt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A478F1F000E9;
	Mon, 31 Aug 2026 13:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184765;
	bh=5l5ZUveJn1KZX0cih01NnTdLAn2Jka/e68yPLtUrPBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wUxdoamtMgPNka2G+fcrnk0D8gOM0no7h20KC1a4OZ3NXtQ/VpEZrUzY5JheOdv0m
	 idx8c5K+Gy3nnFuWbv9j4+/Pad7XlZ1XCfdCLLfvgRSUEGKAHAMKCu3H8fi7ZbMtFH
	 vx8MXMQtiAhDKQxypo5jkabfWn7/V40f+L9YSCBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/92] selinux: switch two allocations to use kzalloc_objs()
Date: Mon, 31 Aug 2026 15:34:29 +0200
Message-ID: <20260831133401.305534831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

From: Stephen Smalley <stephen.smalley.work@gmail.com>

[ Upstream commit cf6a513f1937581eb012a217b29817e025a1a0ef ]

These were the only two allocations in the policy loading logic
that were not already using kzalloc_objs() for the policy
data structures. Fix these to be consistent with the rest and
to protect against ill-formed policy.

Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/ss/conditional.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
index e11219fdf9f75..6c8a5465776c7 100644
--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -166,9 +166,9 @@ void cond_policydb_destroy(struct policydb *p)
 int cond_init_bool_indexes(struct policydb *p)
 {
 	kfree(p->bool_val_to_struct);
-	p->bool_val_to_struct = kmalloc_array(p->p_bools.nprim,
-					      sizeof(*p->bool_val_to_struct),
-					      GFP_KERNEL);
+	p->bool_val_to_struct = kcalloc(p->p_bools.nprim,
+					sizeof(*p->bool_val_to_struct),
+					GFP_KERNEL);
 	if (!p->bool_val_to_struct)
 		return -ENOMEM;
 	return 0;
@@ -714,9 +714,9 @@ static int duplicate_policydb_bools(struct policydb *newdb,
 	struct cond_bool_datum **cond_bool_array;
 	int rc;
 
-	cond_bool_array = kmalloc_array(orig->p_bools.nprim,
-					sizeof(*orig->bool_val_to_struct),
-					GFP_KERNEL);
+	cond_bool_array = kcalloc(orig->p_bools.nprim,
+				  sizeof(*orig->bool_val_to_struct),
+				  GFP_KERNEL);
 	if (!cond_bool_array)
 		return -ENOMEM;
 
-- 
2.53.0



