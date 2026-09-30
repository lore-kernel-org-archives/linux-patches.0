Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C9E5616CC;
	Wed, 30 Sep 2026 17:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790413; cv=none; b=s+NLDPo8hVybJAYt5ClURPpXSr091qaOtXgNlE9bvTAdqEnhZMxreCCIaYGLwRky3++FrsqYlGW3wp58KAg1VUVnBoSIDP0rhIVMwMJ3pIs55mvsl7HFUqwc9DXEPNRPQ69gOP97/dpaFyGFVMhqxiZhc38qmJA7C/0tUc3QQIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790413; c=relaxed/simple;
	bh=Pji2rvV6uTqjYOyBiOLtOdmb9+hoJSRXfWDp9+Eec30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B34lFWW30ER0gp7Pm9gXog+8DSibD4L5/Zys8mQneiCN3bZvhogw9h8KgDxR53r6saUWruiUpyCHe+UfxG3gX88Xx8Dkrfxa2njv6Hz9cb4N5d3HkF1tmPyp+W50rQTqkDE9k42ZxHYQkBMFOBiT0rbfvT0edYw/BPcfEcjQBhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvA/tnhN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvA/tnhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827BA1F000FF;
	Wed, 30 Sep 2026 17:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790412;
	bh=RrJIrtNUKHR1qUbedMIED+Nt6tgHYwOa4F9dL6ccQpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvA/tnhNVCU/uRbkjWGBjZU9A7wj+RVkzfTpd+KPCL9i/9l9A+cS2EzQNZYuL2vOM
	 Q4LdxMUOlZvN71uqMzhYC8MemervFnEt9zFWh+tBc8OWe0sNL0K56bjHmCzwwsduU9
	 jp9OappEot6X85dY9dlu8mGi/SasMDBzs80wr60I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <wufan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 819/877] ipe: fix use-after-free when auditing a newly loaded policy
Date: Wed, 30 Sep 2026 17:28:50 +0200
Message-ID: <20260930152432.401559026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Fan Wu <wufan@kernel.org>

[ Upstream commit 9814077275eca36ebf8d510d2f076d235ff9f51a ]

new_policy() audits the policy after ipe_new_policyfs_node() publishes it
and drops the new directory's inode lock. A concurrent delete can free
the policy while ipe_audit_policy_load() is still using it.

Audit the successful load under that lock.

Fixes: f44554b5067b ("audit,ipe: add IPE auditing support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
[FW: remove model name according to latest guideline]
Signed-off-by: Fan Wu <wufan@kernel.org>
[ adapted new_policy() changes to the older success-only auditing implementation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/ipe/fs.c        |    4 ----
 security/ipe/policy_fs.c |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/security/ipe/fs.c
+++ b/security/ipe/fs.c
@@ -155,10 +155,6 @@ static ssize_t new_policy(struct file *f
 	}
 
 	rc = ipe_new_policyfs_node(p);
-	if (rc)
-		goto out;
-
-	ipe_audit_policy_load(p);
 
 out:
 	if (rc < 0)
--- a/security/ipe/policy_fs.c
+++ b/security/ipe/policy_fs.c
@@ -12,6 +12,7 @@
 #include "policy.h"
 #include "eval.h"
 #include "fs.h"
+#include "audit.h"
 
 #define MAX_VERSION_SIZE ARRAY_SIZE("65535.65535.65535")
 
@@ -463,6 +464,9 @@ int ipe_new_policyfs_node(struct ipe_pol
 	inode_lock(root);
 	p->policyfs = policyfs;
 	root->i_private = p;
+	/* Only audit signed policies from userspace */
+	if (p->pkcs7)
+		ipe_audit_policy_load(p);
 	inode_unlock(root);
 
 	return 0;


