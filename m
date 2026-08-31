Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D228953B604;
	Mon, 31 Aug 2026 13:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183939; cv=none; b=SHJir8Q24g1r0dvETyEgJru7m3u1nmjn+L36m7a26wU8ztaW74ok/W8uCUIUGDDy3hAWKvf9MYYiJqNbuyngHccNitYy3N0gixJPhzGMmVirlS4uRl51ndlc5Ql4h+BPVT0IQDxkld5YfHgPWSepbQQGaVL1RSUN/5h04J+NadI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183939; c=relaxed/simple;
	bh=BMVlkVsGbem4ObLzGXUvCl1JoKNFRBDQSpuaBOhGIZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beTbyeHFzDmItBz9+ye6qbovod7DOpJKGjfju6SF5CFqUyY+KhYiBwKNYD9Xo31k6wEQEK9nSAoUYxBPdFNiMFNFEiqmE/+VxyMIss9FMJbbm+br9S5Kv34MMOCrqp3XaumBgtixLL7PofxP10bpljANEJ288RQ8i3iHRPpUYsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kU/8pxHe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kU/8pxHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDDB1F00A3D;
	Mon, 31 Aug 2026 13:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183935;
	bh=UBP4zQin3eU7GHcvkjI7Pho/PngEKfm84Ei33TTo8uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kU/8pxHe23NPgEw8ztpQa41VDtX2bTgiN6clNbF8FIXqgIc1/fpZ24dSmi9bC7872
	 0yzmQdwgAWqNukw7T5JYXDg0pDQkgt7v2XW+MM3dYm5E581tI6dcMZ7MANf3njxaFb
	 1iyPPwkTuynJBEfQwlNCzXONkdKWB1RDXr6oOazI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 17/83] selinux: switch two allocations to use kzalloc_objs()
Date: Mon, 31 Aug 2026 15:33:53 +0200
Message-ID: <20260831133400.105697441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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
 security/selinux/ss/conditional.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
index db30462ed6a32..280dc57df8d39 100644
--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -165,7 +165,7 @@ void cond_policydb_destroy(struct policydb *p)
 int cond_init_bool_indexes(struct policydb *p)
 {
 	kfree(p->bool_val_to_struct);
-	p->bool_val_to_struct = kmalloc_array(
+	p->bool_val_to_struct = kcalloc(
 		p->p_bools.nprim, sizeof(*p->bool_val_to_struct), GFP_KERNEL);
 	if (!p->bool_val_to_struct)
 		return -ENOMEM;
@@ -706,9 +706,8 @@ static int duplicate_policydb_bools(struct policydb *newdb,
 	struct cond_bool_datum **cond_bool_array;
 	int rc;
 
-	cond_bool_array = kmalloc_array(orig->p_bools.nprim,
-					sizeof(*orig->bool_val_to_struct),
-					GFP_KERNEL);
+	cond_bool_array = kcalloc(orig->p_bools.nprim,
+				  sizeof(*orig->bool_val_to_struct), GFP_KERNEL);
 	if (!cond_bool_array)
 		return -ENOMEM;
 
-- 
2.53.0



