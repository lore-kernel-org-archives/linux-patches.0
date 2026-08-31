Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1D943F4D7;
	Mon, 31 Aug 2026 14:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185179; cv=none; b=nkuiheXs5FyFVZ0h6+wKQeQiq2iS+e39e/O38dmbuA/T/gP8AoX6QgXsmtlcpeXfsYIwGtdFNibc1CLaSUQ4+NkR0jpX1f9LkxF+oboVB6BE2C93gmOwELNCTzkXA0N/TSjuXYNoxIde7DRaekSIl/ok8AgGDIgds0RJq3yg/no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185179; c=relaxed/simple;
	bh=EUUQUPfMveQVNYrMsJKJTd1DRI8nWmpu4OeBoL8tRmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5Kaeu0CZuSS32ED5rh/r0ssSgJ/6lGTgLX7MsEPg/ch2i5YjjQD7cBhD8yspP2No+zEAsIlhJfFs2heE6QTdcQwWYZAlq+4WjJkfVIUgBhlA2EBX2TastYD1Ye0J2hcGZDw1ODpu1/SjocfU8DqTwiOTy2gobSd/4JgTtkRE6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+n6aDqp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+n6aDqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB1F1F000E9;
	Mon, 31 Aug 2026 14:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185178;
	bh=+aabYPeG1cGUC+7ixzVxdKbIOCTy7O9vLlTHVG7UcfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R+n6aDqpSe6VX40ZfIws6x7fA4lAxcGLOjS2bVtMjVeZ0c5U3smzGm3ELgEvj48fL
	 x5Qd29gqxtdLmuxWYIlzQYlUCvWwwi0sXAEuHFdEoHy8Nf8m4cSWnOBIoBQicPnmiy
	 Ua/qaupl10cLTk/o4faFljyH5v7otxBBbttfOtZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/43] selinux: switch two allocations to use kzalloc_objs()
Date: Mon, 31 Aug 2026 15:35:20 +0200
Message-ID: <20260831133359.076019404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 865611127357e..240b350f23270 100644
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



