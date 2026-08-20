Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47FF8635D;
	Thu, 20 Aug 2026 15:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238047; cv=none; b=dIv7JfB4peW+iYEgx1J1JYA5bS5AeIKP2cj9IxKBQgUT0cJAjnr27TLVIqHgWDkAuFEGuqAGYUcWhcyGveVNnHeIh7iQwiUBMLGHRQvna4+y3XzfIUUOMkFPoV5afg8jXQlbzf0IEXakaxrLIbTILaeZGuaJoDGdnLuEkul3to0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238047; c=relaxed/simple;
	bh=e+9c/tSXPbMMTL29NEFgYrmVc2fzgd0DJozKie1pFt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opCVhpgZNDVdK5kFRMWY40as/vumL3h5LbK5SiHhTTqW+y4uXzqaNhiTQ0XWyxejfdlFPBn6+i5VnUN+5yPKnlwvB7rT6pRfxhQzbqp5Nt3rSCMXs7huBzy50q0tAcPC5MVnn7jsqU2PgEb1L7goc/9UWLGCbh45W8Ioc26btl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBPh/ePU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBPh/ePU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABF51F000E9;
	Thu, 20 Aug 2026 15:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238046;
	bh=Hw5hAv+eN78Ewjy343ZbRn5PSn94EoI52d+b2dFRjIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBPh/ePUmivG0s427OD+tnBvhMqfO37BI9jruA5q0s1FZwwBY4P6+JKDWQkZD/pPV
	 PzCmGmgjX6L+ymkMWdga21YbL5q6d1MFyYLopwinlidf1mUtNtF8K7VXJWfosHRvhU
	 zv6GjlcpsIenPdFgOec9LoN49CYpOkTm14H8b/CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.1 002/228] selinux: require every boolean value to be defined
Date: Thu, 20 Aug 2026 16:52:24 +0200
Message-ID: <20260820145244.539700862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit a93d37a09b863810653f93d371fb197457d59deb upstream.

p_bools.nprim comes from the policy image independently of how many
booleans follow it, and cond_index_bool() fills bool_val_to_struct[] at
value - 1, so a count larger than the values present leaves NULL entries.
Every user of that array then walks it by index and dereferences each
entry: cond_evaluate_expr() on the access-vector path,
security_get_bools() and security_get_bool_value() behind selinuxfs, and
security_set_bools(). A sparse class value is absorbed by
policydb_class_isvalid() and its siblings; booleans have no such
predicate, and no consumer that could use one.

Reject a boolean value that no boolean defines, once, where the array is
built. Conforming policies define every boolean they declare and are
unaffected.

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/policydb.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -721,6 +721,7 @@ static inline void symtab_hash_eval(stru
 static int policydb_index(struct policydb *p)
 {
 	int i, rc;
+	u32 v;
 
 	if (p->mls_enabled)
 		pr_debug(
@@ -772,6 +773,24 @@ static int policydb_index(struct policyd
 		if (rc)
 			goto out;
 	}
+
+	/*
+	 * A sparse class value is absorbed by policydb_class_isvalid() and
+	 * its siblings, but no such predicate exists for booleans: every
+	 * user of bool_val_to_struct[] walks it by index and dereferences
+	 * each entry -- cond_evaluate_expr(), the two getters and
+	 * security_set_bools() -- so an unclaimed one has no consumer that
+	 * can tolerate it.
+	 */
+	for (v = 0; v < p->p_bools.nprim; v++) {
+		if (!p->bool_val_to_struct[v]) {
+			pr_err("SELinux:  boolean %u is declared but not defined\n",
+			       v + 1);
+			rc = -EINVAL;
+			goto out;
+		}
+	}
+
 	rc = 0;
 out:
 	return rc;


