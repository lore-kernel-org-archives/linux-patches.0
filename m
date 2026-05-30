Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADDD137750;
	Sat, 30 May 2026 18:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166902; cv=none; b=sad+4WUaxECY9ba4WY5gUFs9qTuIAM3y1KlggJiQkkPLXCV8GkDOx3GIqRUACecfTqUkd2VXDUBoVr2htXOyEJftUY1vR7E1xBlbFnpURxT24j3jawEDpmVBKbxMNVa2ySsT/7glNhmY56liMwsCYF98H+F8S/k2VVRwyqDhEyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166902; c=relaxed/simple;
	bh=AMtYRJyfyVlabEz7gRvHKg8iWYwqYWU6WvAO/0y+2wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btaiEu0zxl4KOirSuabiKUkOmwkI0eaebyfJ+40X4L/a1whwOnRj/daryLNT5heecdemeN+NKTcKw26yEuopepTNOT9s5vBHhvEvouLsSrZMXErOqP62hn/2pxpXgcEODHlSMJ9FZRGGBJAYlGrtg8fAht3eR36e38RTZsEFDNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giBUFtCL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giBUFtCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDDF1F00893;
	Sat, 30 May 2026 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166900;
	bh=t/D77fe2mkFD4GBqTd4FMOi3pbvSyuuadXBGuJF4q1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giBUFtCLGVnANrq5Y+k5i1i/cCp3H8c8K9LWx13UopRxsmOROwHx+sibjmUjBskse
	 OAskDBnR32VttcoXFE5K8j8THIywcKe4u2ewDU1Ex8f1cvBF+gxZ3VLOe68nO7qhy7
	 OOs67PwSW4XjtVvVTaYdunYU2rS35ytx763i1GcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Robaina <rrobaina@redhat.com>,
	Sergio Correia <scorreia@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 504/589] audit: fix incorrect inheritable capability in CAPSET records
Date: Sat, 30 May 2026 18:06:25 +0200
Message-ID: <20260530160237.853486281@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2582,7 +2582,7 @@ void __audit_log_capset(const struct cre
 	struct audit_context *context = audit_context();
 	context->capset.pid = task_tgid_nr(current);
 	context->capset.cap.effective   = new->cap_effective;
-	context->capset.cap.inheritable = new->cap_effective;
+	context->capset.cap.inheritable = new->cap_inheritable;
 	context->capset.cap.permitted   = new->cap_permitted;
 	context->capset.cap.ambient     = new->cap_ambient;
 	context->type = AUDIT_CAPSET;


