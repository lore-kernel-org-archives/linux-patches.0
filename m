Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6934446C9;
	Tue, 20 Feb 2024 21:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464795; cv=none; b=n2u6OiGmC1dnXIux/TfGTmBp4Op1gflzx3YvF9bZ46uAR2QTOQ50JLLfrD+KlFEEaYV8/MywLW811qiKlvfSHX95FxDicq/YQSJCYwFf47eM+cgDntaQTlqfkTfahd0rcjO1D7JK2sL/zrQQchQ8VCtBILpmprFDsFW814SV5B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464795; c=relaxed/simple;
	bh=gLuNkKqu5DIeh9cDGGpSfJRD7bmFJZ3EtTjp5lCd2jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TD/72U7j/L0zTX2sqhp8zJeJIU5BmmA6cGKBhzr0nqvdcwaHXJTrCWW28cZEqqS+CDEkZs1qiKUlMJ+uztoQs19b0knYQYgmbmpR9yiRcgFvIvtUv+Qw/iMTZOpkSogEbsRaIxpDFKcm/6ZIIQBH3Tx6Cdgx8wtApn3e+GNLKsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKHRNAkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKHRNAkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31991C433C7;
	Tue, 20 Feb 2024 21:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464795;
	bh=gLuNkKqu5DIeh9cDGGpSfJRD7bmFJZ3EtTjp5lCd2jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKHRNAklep0aoOeL/2JrMKyi4TivD41tgfGM9CT/+I1h9FWTzMUif1kQzFRX5DNey
	 PO96YC3IdiBKJfzUbh8OKaXrcnDNMmKtRo5xnboxpA1CVPYJ6mCuvuwnEdi7cUMnne
	 ks8TJa26Q9Z1cRo3FezpA4LNxHXUOR9W1QWgcjAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.7 140/309] lsm: fix the logic in security_inode_getsecctx()
Date: Tue, 20 Feb 2024 21:54:59 +0100
Message-ID: <20240220205637.530892501@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4030,7 +4030,19 @@ EXPORT_SYMBOL(security_inode_setsecctx);
  */
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
 


