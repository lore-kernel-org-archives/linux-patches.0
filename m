Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9A6137750;
	Sat, 30 May 2026 18:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166966; cv=none; b=YndZZcfC67HatwRoWa2eJ4pVf/BcSRtjpD7zBswCeDCcaF+H0V8LKzKEA/SNqr63618GocgtF6tjodVdVxjxvYWVxgghTyJbzvwHhdQ3NeBWvEZqhHhXoWgyn3yuzczZOY8wmAhM9KqlTh2+nXFnaqHuaxoynIU9lVS0vrxvzJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166966; c=relaxed/simple;
	bh=H0er6DmNgb6tVtT3wX1xMUiHKBFfKjpA/J/x1jv70Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HE5iRpQe9cBnSCRzrHoBHwHGqtrRSF9JfqZGCcEEt44jjpjzFYgnnsMZCuVtjJY5i0VGZDnO/DokPfaAoSld/gQwgArXYUOcSHkN7rE6wNhHTmty7uAeC1wJ9DQtZMwHrLIBq03TXj87Tg7+Ue3v6YahUXToMKqaL/uuxEL9D0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSIyeUbD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSIyeUbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21171F00893;
	Sat, 30 May 2026 18:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166965;
	bh=AKpgyDmbBasipP6n/SButF2WU8NCeoSvO2ggEIklT/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSIyeUbDfrLd8X2/cy6aObXo0qTPM1Ksax4cK+2IprdetWxIOX9MmUhOXli9jBlnY
	 j0ePTBlpbkyIcIiyulQJODcIMeDKG+QaApdkpvkesN3TEX3BkWSmQ0IOsWCCMWxBvD
	 15iQ5VvyiLst638gdUdFjNmM1R5jSDVp+EB8y1Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Robaina <rrobaina@redhat.com>,
	Sergio Correia <scorreia@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 507/589] audit: enforce AUDIT_LOCKED for AUDIT_TRIM and AUDIT_MAKE_EQUIV
Date: Sat, 30 May 2026 18:06:28 +0200
Message-ID: <20260530160237.925195752@linuxfoundation.org>
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

commit f9e1c1324b4d98d591a6f7568fdebf5cf456dfc2 upstream.

AUDIT_ADD_RULE and AUDIT_DEL_RULE correctly check for AUDIT_LOCKED
and return -EPERM, but AUDIT_TRIM and AUDIT_MAKE_EQUIV do not. This
allows a process with CAP_AUDIT_CONTROL to modify directory tree
watches and equivalence mappings even when the audit configuration
has been locked, undermining the purpose of the lock.

Add AUDIT_LOCKED checks to both commands.

Cc: stable@vger.kernel.org
Reviewed-by: Ricardo Robaina <rrobaina@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Sergio Correia <scorreia@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1430,6 +1430,8 @@ static int audit_receive_msg(struct sk_b
 		err = audit_list_rules_send(skb, seq);
 		break;
 	case AUDIT_TRIM:
+		if (audit_enabled == AUDIT_LOCKED)
+			return -EPERM;
 		audit_trim_trees();
 		audit_log_common_recv_msg(audit_context(), &ab,
 					  AUDIT_CONFIG_CHANGE);
@@ -1442,6 +1444,8 @@ static int audit_receive_msg(struct sk_b
 		size_t msglen = data_len;
 		char *old, *new;
 
+		if (audit_enabled == AUDIT_LOCKED)
+			return -EPERM;
 		err = -EINVAL;
 		if (msglen < 2 * sizeof(u32))
 			break;


