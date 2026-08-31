Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCC647ACF6;
	Mon, 31 Aug 2026 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184608; cv=none; b=aV9Cbq1rc8lU9RZitqaL75xPqef+tQcJ/HUtB2SYVs7ps5Omc4mtxYRl3aIjVyKTE5igBW8P3eD6v1tU8BqnC17EoxoHektKABW4qAprCIy2zNWixpGquJjRqgSrWpck3pBlVvu5u90WLDLQJknu2spw+/WPlsy+K+GVrHhs+xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184608; c=relaxed/simple;
	bh=oV09JT564KqIDZ3ud9Y0J/KDtJ6XfY0ogBtd81INzGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNvrWvaYd7qr/Wkq0NTQkAd7Gnhw2CeaevFcdKBbzAA+nT9T+OKBqk5byFUu+zn5+7bs2cGP41vyAwbgFl8aml+XPqe6fx84Bibru7T2Ir3grVhiddPda3enzwGt/n3mr3YkLU95O43D07CgbOjHncOa1W2q4YUS55Cngtc/itA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sd6ituEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sd6ituEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D129A1F000E9;
	Mon, 31 Aug 2026 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184606;
	bh=GPubb674/2NBMvLJMvVPIIPSSkCkOu5KS5Fnoq8+eF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sd6ituEXhijdaH9t1YnEuD3BJR3EVGwcSUa9LpjZ21Hvk7Dyrgx8LEwh27sdAxnAR
	 FcrSASDkmzpFfmnotGD5M6+JwArghOyBANULsFfebOZporOMb94kgUoNphIVSbhak9
	 N4FeqkRJt3s3n96xvG3jCjTo+PrUkzTErYlrCelE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 29/91] selinux: switch two allocations to use kzalloc_objs()
Date: Mon, 31 Aug 2026 15:34:17 +0200
Message-ID: <20260831133401.203695201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 81ff676f209a8..4cd908913b379 100644
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



