Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB14946EF8D;
	Wed, 30 Sep 2026 18:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793484; cv=none; b=HO0TDoIRDoEsGzK/7cDvRsMs+Ci6S3XPvfNrFVQ57nB/U0HBwucyEoykEjKjZFBxQwzjTPAfG7MiwPEkCj1jGBkCHR4ujMEkKqYa5NP98bez7w1Ml/msofzFj5z3KyoHyNv29lBHebrj47VTwKDTrtsJJPTPqIlLPX+546J0xDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793484; c=relaxed/simple;
	bh=cuHu+XA5SAOYU5zd8oN0NafXmdCVbXBBImk+4YfQYHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXFbyZRjO+AIugLFoofiIIp0K8WAIhdb3kzBYQrxOlAksR2WZxaJ9Xxt7rCgEipd1ByAUOwtaayA0U4cSMpU8SXfr5bCCSzj3iZPg6zX18IzFHY+qtZCrydcXY+3F+V8f+RHfnyvhz4sowmaRHL7hhzTVSyqjPmeuvbZrQeC6Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4YT/+YZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4YT/+YZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178D31F000FF;
	Wed, 30 Sep 2026 18:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793483;
	bh=rokcyKvLDbkO8FOIArGHXOe4w38D6sUxPM5QT4IW+HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4YT/+YZWD/wFsd9NBeSaUxIa1Fl7e7Yp52lmb175qOC1whfKWEUHMIUNUoYlWnrj
	 s6D0bCDr9psLVn8rkMPkfIgSg13u8gvTIPes2Um02ty7oiyoMp0qGthvePK1pwfnDm
	 USPKKsBEr0Kn+hGMPHCGQO/xEsuDWeuwr6fRaKhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <wufan@kernel.org>
Subject: [PATCH 6.18 226/395] ipe: fix use-after-free when auditing a newly loaded policy
Date: Wed, 30 Sep 2026 17:28:08 +0200
Message-ID: <20260930152345.565462197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Fan Wu <wufan@kernel.org>

commit 9814077275eca36ebf8d510d2f076d235ff9f51a upstream.

new_policy() audits the policy after ipe_new_policyfs_node() publishes it
and drops the new directory's inode lock. A concurrent delete can free
the policy while ipe_audit_policy_load() is still using it.

Audit the successful load under that lock.

Fixes: f44554b5067b ("audit,ipe: add IPE auditing support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
[FW: remove model name according to latest guideline]
Signed-off-by: Fan Wu <wufan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/ipe/fs.c        |    8 +++-----
 security/ipe/policy_fs.c |    3 +++
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/security/ipe/fs.c
+++ b/security/ipe/fs.c
@@ -159,18 +159,16 @@ static ssize_t new_policy(struct file *f
 	}
 
 	rc = ipe_new_policyfs_node(p);
-	if (rc)
-		goto out;
 
 out:
 	kfree(copy);
 	if (rc < 0) {
 		ipe_free_policy(p);
 		ipe_audit_policy_load(ERR_PTR(rc));
-	} else {
-		ipe_audit_policy_load(p);
+		return rc;
 	}
-	return (rc < 0) ? rc : len;
+
+	return len;
 }
 
 static const struct file_operations np_fops = {
--- a/security/ipe/policy_fs.c
+++ b/security/ipe/policy_fs.c
@@ -481,6 +481,9 @@ int ipe_new_policyfs_node(struct ipe_pol
 	inode_lock(root);
 	p->policyfs = policyfs;
 	root->i_private = p;
+	/* Only audit signed policies from userspace */
+	if (p->pkcs7)
+		ipe_audit_policy_load(p);
 	inode_unlock(root);
 
 	return 0;


