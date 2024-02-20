Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F0C14F9DA;
	Tue, 20 Feb 2024 21:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462917; cv=none; b=KsKbwckbIykASeEHgurdqy5eIH2RPUa+diVDOKdyw4+D8LnesrL7g/j8SLyBVPYcMdt+QK1n58E9sEt2HQMPLStCucM0H4GyFX53e2nIFa3Aseue3EYdbm+MmQ6LeAHrwUqBT3u9M8ENe12ssL7dkH3VOkH1CywY4od3sZ+jQzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462917; c=relaxed/simple;
	bh=m0qa78mr00hkzX7Ga+PuAyWN6UOuowEdJf8lrEzTmZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7VMLfku4e3ItUlicUYwqAOAO8L0Qua62KBuG8uRwK4X/3uYVf454UU6dNerV2kooVCcZLCWpuIzmNCCazsFBgKT+6OhcAIAhNi6zpytBmMkTcvhra0Q/6IWpbB6xLmPKGooBPIcQ0KU3E7dB8JIsML9JVBMeqGVfMv048tFgys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFIWDZM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFIWDZM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96529C433F1;
	Tue, 20 Feb 2024 21:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462917;
	bh=m0qa78mr00hkzX7Ga+PuAyWN6UOuowEdJf8lrEzTmZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFIWDZM+A1pkTonEgd3hq7w3PjC61vmQHEfLWWVEndpw9Zt+CBVtARZ1vXRj67nW0
	 7CIxYbBcUvp+NvbpWZQUilP9uy1jRjOkGi4ILDSBc2Cs16MT/9t/jG+f6U2knYzJDU
	 UWaDzS3RXfg8tRd8eJ8aoYlwK+XbYAYTEsGl7+dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 078/197] lsm: fix the logic in security_inode_getsecctx()
Date: Tue, 20 Feb 2024 21:50:37 +0100
Message-ID: <20240220204843.414506813@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2186,7 +2186,19 @@ EXPORT_SYMBOL(security_inode_setsecctx);
 
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
 


