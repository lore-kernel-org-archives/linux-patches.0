Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197724FC8E2;
	Mon, 31 Aug 2026 13:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183693; cv=none; b=OJmsJZV72CNvrJQUYlBDFmFNYzUbk9cIKMeCltAsNrjAXm8p6TU5PwKlyzHyesJbxB+gn5skcsxUuk14avsCBx3v4rbi0OJV8/za1DlkKCh8N1253bbCSV6rjvAL7jDlSAD9NorhW1xCJ/PAPBruTNZAyQCJMTpX/NO1uegb2Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183693; c=relaxed/simple;
	bh=XoKGZiqgfqU8dGQZLFDSzlCdvGqHtikNENP0IvztfK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3ikITyk8iWn9iCQcD9QJ92YN9OkzIN569aE/klx+fhgH0qiBW6mswQ72E6iMmjc3IWmG7o6MoISPL1cvaNm6btT0Z6DnkpoGjOVD5c4Vpy7M3a9eOPxSFkt6tcPpVCjQAVryP8Oont87ju1pbOhGabm2ajCV0YF5LVWjpyCzSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRTbStfH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRTbStfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C201F00A3D;
	Mon, 31 Aug 2026 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183691;
	bh=gkAVC0RG9y96Wj5f8HKOMkq+HDarGS4DHCU8vf2RBV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRTbStfHMYS9A+JKORMsjKB5zWGcy1rYSdyoz/E5uPqys2uv20+0GzC180LbQH47v
	 9ZVQqPEEPakJbcT24dQbxKB1k7N0+wspfGUxFFjFFYU97W/coWmuDCox6GmNnFQy6u
	 TFzce/C5t8jDVRHuttLfp5km8sJ8IxslBMNsCMkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 11/76] selinux: switch two allocations to use kzalloc_objs()
Date: Mon, 31 Aug 2026 15:33:43 +0200
Message-ID: <20260831133359.735829166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 security/selinux/ss/conditional.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
index f0a9866f01659..e2be39c10b8a0 100644
--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -165,7 +165,7 @@ void cond_policydb_destroy(struct policydb *p)
 int cond_init_bool_indexes(struct policydb *p)
 {
 	kfree(p->bool_val_to_struct);
-	p->bool_val_to_struct = kmalloc_objs(*p->bool_val_to_struct,
+	p->bool_val_to_struct = kzalloc_objs(*p->bool_val_to_struct,
 					     p->p_bools.nprim);
 	if (!p->bool_val_to_struct)
 		return -ENOMEM;
@@ -705,7 +705,7 @@ static int duplicate_policydb_bools(struct policydb *newdb,
 	struct cond_bool_datum **cond_bool_array;
 	int rc;
 
-	cond_bool_array = kmalloc_objs(*orig->bool_val_to_struct,
+	cond_bool_array = kzalloc_objs(*orig->bool_val_to_struct,
 				       orig->p_bools.nprim);
 	if (!cond_bool_array)
 		return -ENOMEM;
-- 
2.53.0



