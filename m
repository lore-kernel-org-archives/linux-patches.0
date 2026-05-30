Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8804739A4A4;
	Sat, 30 May 2026 17:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162056; cv=none; b=XCuYXZ+NT7A8LGKiWEz6mBJRJsptmAiOoLBWTTpcqHFjGZGolaXyR8rDENeOLdAIYIFNfUr2kw6BRYdRy2p/oGa83nDGCf7N7zTC9BMZijuRVDSh0IknVJlJvVe9iyAIAIN0ajpcFEOlisnVRrZzfIBajycPXrX9Csayz9TQ9Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162056; c=relaxed/simple;
	bh=53Eo+iJrAQk6UV7GMMiFeZ3i7bB7QZJpCNy0lnJyiVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRRzrMLINB7CQN5Wr/YiVEgwQZkbIklA2S708gdoHKGKsH02FW7fEM27oonjPUs9XXjY97Gb0iNTRaAqIp8BgCzB/4ZfSMGfGvE6xujlpldo157orirmWrw9RYCdIpoKzcguGFVpJV6nerq9f2F9caklyoxhzw3ss08bzSrghAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHe1F7aG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHe1F7aG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99D61F00893;
	Sat, 30 May 2026 17:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162055;
	bh=Kbr8oWYB4igwpUXS0vo1/ghGX0EMpw7D+o3q12Xv7YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHe1F7aGOfweozAzTABFzG/1QFeSCjdOZWZsuKjuEJYYKOy6suvvpV50w74qVMbHL
	 pZBXh6Zcf7kLaw7TUH29GsO/2Of4ZcbgKlYttDU5OCZlFeajcDmYU3ufrifZkNIrH+
	 7YizyTEhtK2eAq5jBILDyTOtXYm6M35sneZTqRnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Robaina <rrobaina@redhat.com>,
	Sergio Correia <scorreia@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 808/969] audit: fix incorrect inheritable capability in CAPSET records
Date: Sat, 30 May 2026 18:05:32 +0200
Message-ID: <20260530160322.944433698@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2841,7 +2841,7 @@ void __audit_log_capset(const struct cre
 
 	context->capset.pid = task_tgid_nr(current);
 	context->capset.cap.effective   = new->cap_effective;
-	context->capset.cap.inheritable = new->cap_effective;
+	context->capset.cap.inheritable = new->cap_inheritable;
 	context->capset.cap.permitted   = new->cap_permitted;
 	context->capset.cap.ambient     = new->cap_ambient;
 	context->type = AUDIT_CAPSET;


