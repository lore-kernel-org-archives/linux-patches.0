Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC03151CD6;
	Tue, 20 Feb 2024 21:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463701; cv=none; b=SsJRSqAjRlYG6+MOgNv2VhCJAHlLq2nEhx9AF0Evrw8126E5FlgJAkMq6xLzKlnaSkyqAtHePcYG5EZXwkjowNR2vmh2Jc40MXEmYMJcKmgB+fkj6GeuKmimnlOMwfmYE5JeXrlzOXcw0mjo67cqGNT0Y4xoPFgjlMPGC1yGKRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463701; c=relaxed/simple;
	bh=vakR73KCyxNMeRwxS+i5FUpHjP6E6ErVq1YPY3FSmt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay/OWNgFL18OS583L83sLcoulcadyJchBApj6VsIfT8bfsK1SCCxNtkmu7v0B9+S/hM5NecbKxdWxRuv6iGmmqwt5ue4r6Jetv0rXvk37icij58aFZbGrwCuaAGPb6b5kqMvyJjQyMvXyYgMlTJYqkwGWbRFy5RENTzBbADo6MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgC7Tyu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgC7Tyu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C91C433F1;
	Tue, 20 Feb 2024 21:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463701;
	bh=vakR73KCyxNMeRwxS+i5FUpHjP6E6ErVq1YPY3FSmt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgC7Tyu8S2UOB/G/PPkpRqVi1IR0z2MLuE26HWo90cS1sTYvM8ru5lnsY/zxcmNNN
	 320WUMbz3gWCplx7h5EB6VkSV6jpxSXAq4TX3a8kh+BZJ6CANMLTobJgrI/KVF9Ks2
	 UA8fnfiLLcolSRTYvCgA8zFVXLejOlEKd09E8Jrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 126/331] lsm: fix the logic in security_inode_getsecctx()
Date: Tue, 20 Feb 2024 21:54:02 +0100
Message-ID: <20240220205641.550418493@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


