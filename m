Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610BE3C2F;
	Wed, 21 Feb 2024 13:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523252; cv=none; b=lFaGrUQIZjSLM2IwOYKbQl5zfJKEXNcdB75fw9Se2xTBYFQx3XVIUti3qmL1wDJirL8KQYy5wlrd3QO5uSN2PPj+aUQYQBhIPVb1JxK4NviPrWtgpHdvJyWzYVhhhCxanFaxCuyuJ+k7VBQAzqPxrWLJet138IWbCjlSynS5So8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523252; c=relaxed/simple;
	bh=sa4+mQ9Qs2ftqKbegkxpDkpJA4foh685rJTprthpEUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xt6khL2swzEihUtwhRhKZd+aAAWgzYck5tc8D9BcoCQANvUPKtLArTwJdE6pNfWjP1Sn1B9qpKn70T63eROUBGhh3DrgjP6xPEqUFoVmo3xJBI99JbuWJVWRcRldS90SwRWeYdUzWeR7YAbI+oOWBcrHiq1GmJE8WSgkd+Bq1UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rew3LaW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rew3LaW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D6DC433F1;
	Wed, 21 Feb 2024 13:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523252;
	bh=sa4+mQ9Qs2ftqKbegkxpDkpJA4foh685rJTprthpEUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rew3LaW/ts8poWVI+9007o8msH3XCmf0o52AJ6qDEXQCMBiUjFP4uTAqgKYeMiPcA
	 UKqc30GMjSE1tn7kxp3pc9oiSZWbTHhz5ADs3/xysmn+qvmeRTikW+GmZLnFFrBZYz
	 cI7iHhrX5/6hUk0Kg4lSVCe50lkuul64SaSo1ngs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 378/476] lsm: fix the logic in security_inode_getsecctx()
Date: Wed, 21 Feb 2024 14:07:09 +0100
Message-ID: <20240221130022.022814722@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 99b817c173cd213671daecd25ca27f56b0c7c4ec upstream.

The inode_getsecctx LSM hook has previously been corrected to have
-EOPNOTSUPP instead of 0 as the default return value to fix BPF LSM
behavior. However, the call_int_hook()-generated loop in
security_inode_getsecctx() was left treating 0 as the neutral value, so
after an LSM returns 0, the loop continues to try other LSMs, and if one
of them returns a non-zero value, the function immediately returns with
said value. So in a situation where SELinux and the BPF LSMs registered
this hook, -EOPNOTSUPP would be incorrectly returned whenever SELinux
returned 0.

Fix this by open-coding the call_int_hook() loop and making it use the
correct LSM_RET_DEFAULT() value as the neutral one, similar to what
other hooks do.

Cc: stable@vger.kernel.org
Reported-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Link: https://lore.kernel.org/selinux/CAEjxPJ4ev-pasUwGx48fDhnmjBnq_Wh90jYPwRQRAqXxmOKD4Q@mail.gmail.com/
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2257983
Fixes: b36995b8609a ("lsm: fix default return value for inode_getsecctx")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
[PM: subject line tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/security.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/security/security.c
+++ b/security/security.c
@@ -2163,7 +2163,19 @@ EXPORT_SYMBOL(security_inode_setsecctx);
 
 int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 {
-	return call_int_hook(inode_getsecctx, -EOPNOTSUPP, inode, ctx, ctxlen);
+	struct security_hook_list *hp;
+	int rc;
+
+	/*
+	 * Only one module will provide a security context.
+	 */
+	hlist_for_each_entry(hp, &security_hook_heads.inode_getsecctx, list) {
+		rc = hp->hook.inode_getsecctx(inode, ctx, ctxlen);
+		if (rc != LSM_RET_DEFAULT(inode_getsecctx))
+			return rc;
+	}
+
+	return LSM_RET_DEFAULT(inode_getsecctx);
 }
 EXPORT_SYMBOL(security_inode_getsecctx);
 


