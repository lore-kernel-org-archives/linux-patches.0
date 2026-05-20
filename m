Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAEE3F39EE;
	Wed, 20 May 2026 17:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299801; cv=none; b=mDwi/ovwowLtI5K6rrHOGNjBeIkozk97slfNzXFVHPGGy2A853fAMu+3Ohh2WknjEiujYOZGGPq+krK0oxyQQ2ruzGp4XyeJAbOtS/SJ+LpZXx03bushhgg6iZGcU6BldB+WOcieHc3343c5OkEBwIlNOu8rXSOsyquU/W6aqhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299801; c=relaxed/simple;
	bh=QDZ8K/CI3zm/4jwGmq9nvpDMnvV6uoQ7yzAFIeid2fY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMCJrTkYwEbJiGx6Z8ReeiqXvELXPf30io6tCpHbL7jOSnDd/fChtY0ldtE54jIfpSpzy+FSieJVlC4QPjOoN4wjXACvC/wiJhm2uIR5RJhX6Rta0HnQJ78oAj1OiNTUiOw3ryjkjZUH8h2I2YQcWvuarNFp5SG7+RouOKApFWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuYSNTnA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuYSNTnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB141F00893;
	Wed, 20 May 2026 17:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299799;
	bh=h/CGFMlNDT8f9Mx2iafijMlFo7r1Q6Lv+tLxaLH+RX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuYSNTnAHXpDEhvHk72mOi5hnDFIzQBdJoeF5lIvHpQ9lShUsA1SC7bP9idIsjG2Z
	 3SCmiC8MMSxw0R/NKkVyubMf0OVqZwVkAsJAZDh/HaAwV6cfnU+4IPv/6S//DdD601
	 akVj5724Qze2Q7I+LxPl97ipikkO7AfT+86msY8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Robaina <rrobaina@redhat.com>,
	Sergio Correia <scorreia@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 884/957] audit: fix incorrect inheritable capability in CAPSET records
Date: Wed, 20 May 2026 18:22:47 +0200
Message-ID: <20260520162153.739194936@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
@@ -2814,7 +2814,7 @@ void __audit_log_capset(const struct cre
 
 	context->capset.pid = task_tgid_nr(current);
 	context->capset.cap.effective   = new->cap_effective;
-	context->capset.cap.inheritable = new->cap_effective;
+	context->capset.cap.inheritable = new->cap_inheritable;
 	context->capset.cap.permitted   = new->cap_permitted;
 	context->capset.cap.ambient     = new->cap_ambient;
 	context->type = AUDIT_CAPSET;


