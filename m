Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C2331F98D;
	Sat, 30 May 2026 18:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164758; cv=none; b=Ldh0/B4SFqc42CKpi2kdq1wfSwxaxql94/DbmwfFjxp+XZO9IhB2MGwUx1BlcJnI/6p/hWDc9VZ7aabTufBDBaPLA96jfrx/2a4Vomhp2U5JKaDqgtnmurgkRsbqMjCcckbDeG6FsrS3Wh2BwCYAW6O4wIbiW6r/nfEi+hp/mVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164758; c=relaxed/simple;
	bh=4qyLuubKRBUmlJ+g0I7Wh2hctzabZE5bFP/G6I/lIO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpjrNnDEPoDGo2YI/uMy2risNnJ77B/oap9L/MqvFCfCnGLa5H0Vhc+X4BdYqPptkT6QcbdgEvs1+u7sRvTYFynR5d7dRwtfmhhA3RiyKb8jWf/oqqHKeMo60wc1ELvJZDNkNpidn9ygkT68yP2rPOWyeo1esYlQ3VQX7v01/9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9vk0DTv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9vk0DTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25881F00893;
	Sat, 30 May 2026 18:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164757;
	bh=XryLQ2EeeXYfzr9jU0nxRxYUy0vgdz/jTo/X+U7tues=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9vk0DTvOGq8spsDx+Peb1ZCk7Leac+lSfLPM8IWvdBTpncCipEP5iEHNcViVfo+/
	 NmU+IsWzXEUr+huy9gFcd0TQyxAH3ZP454B60ZYoJcSxahqHLnc340daoMsJ9df8IU
	 KAhiN4VytAz2XtQqQ9nNPk0zowNzy6pCdrm+rDxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Robaina <rrobaina@redhat.com>,
	Sergio Correia <scorreia@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 649/776] audit: fix incorrect inheritable capability in CAPSET records
Date: Sat, 30 May 2026 18:06:03 +0200
Message-ID: <20260530160256.699762551@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2585,7 +2585,7 @@ void __audit_log_capset(const struct cre
 
 	context->capset.pid = task_tgid_nr(current);
 	context->capset.cap.effective   = new->cap_effective;
-	context->capset.cap.inheritable = new->cap_effective;
+	context->capset.cap.inheritable = new->cap_inheritable;
 	context->capset.cap.permitted   = new->cap_permitted;
 	context->capset.cap.ambient     = new->cap_ambient;
 	context->type = AUDIT_CAPSET;


