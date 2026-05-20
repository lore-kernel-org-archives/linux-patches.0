Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E233F8896;
	Wed, 20 May 2026 17:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297190; cv=none; b=mhfWR+rGpa7vUeXD9hiLHAG8GOlkAfrhKNU7Ss2dSu1Pe3qj33DkyMi+8o0VktdUC5auLpftYH0L48no4TtZOGl1Yv7/Pe7GzPe4gCljQpbymG4nNwlv1QG8RRvzBcXiwOt8W3N1fIcOcXZo6F1YRMgnIZsZUeyXWeC7tXafFFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297190; c=relaxed/simple;
	bh=oiP37jOO/oIO6DpigHBU8Rm0uDTffh96mnsTVl68I9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Esh5jqWOtuuHnISBUzuTx1AMxN3vV7ThetY/VogWQMeJJwjebsEUbnUdq31FbwbWlUaIvpwI5rYgCLrIQ337y7sq/1i8PaiNSsCuBMu66AgBQ0nGDEzuOHUZdhNEWiAV0AL6W2Jas+QTK0AHVCXb06skey1t1+DT5sg70k+e89M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRCSkEPa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRCSkEPa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289291F00893;
	Wed, 20 May 2026 17:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297188;
	bh=AtmxiJV1zlaAy4kiN2YZumpk5FZSu+00mckXbfb4Hyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pRCSkEPa21au6Dhz78jdnw4KLeoEtwwIhciOnaB1VCiWBqFb1rI9v6vLXfKyItk42
	 tkn9q0l/bdAGGA1A3CuwPvqd6Q+fVwJt/GUuGJWjUMLHtjhBChslaoxlDx/4YTFgci
	 hz59eQDR9F4Ss7Jz94oiHX9v0s1Mww41RDqX5nwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Robaina <rrobaina@redhat.com>,
	Sergio Correia <scorreia@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.0 1047/1146] audit: fix incorrect inheritable capability in CAPSET records
Date: Wed, 20 May 2026 18:21:37 +0200
Message-ID: <20260520162211.924504830@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergio Correia <scorreia@redhat.com>

commit e4a640475e43f406fdfd56d370b1f34b0cbbc18d upstream.

__audit_log_capset() records the effective capability set into the
inheritable field due to a copy-paste error. Every CAPSET audit
record therefore reports cap_pi (process inheritable) with the value
of cap_effective instead of cap_inheritable.

This silently corrupts audit data used for compliance and forensic
analysis: an attacker who modifies inheritable capabilities to
prepare for a privilege-escalating exec would have the change masked
in the audit trail.

The bug has been present since the original introduction of CAPSET
audit records in 2008.

Cc: stable@vger.kernel.org
Fixes: e68b75a027bb ("When the capset syscall is used it is not possible for audit to record the actual capbilities being added/removed.  This patch adds a new record type which emits the target pid and the eff, inh, and perm cap sets.")
Reviewed-by: Ricardo Robaina <rrobaina@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Sergio Correia <scorreia@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/auditsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2786,7 +2786,7 @@ void __audit_log_capset(const struct cre
 
 	context->capset.pid = task_tgid_nr(current);
 	context->capset.cap.effective   = new->cap_effective;
-	context->capset.cap.inheritable = new->cap_effective;
+	context->capset.cap.inheritable = new->cap_inheritable;
 	context->capset.cap.permitted   = new->cap_permitted;
 	context->capset.cap.ambient     = new->cap_ambient;
 	context->type = AUDIT_CAPSET;


