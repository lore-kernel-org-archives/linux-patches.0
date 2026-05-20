Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBFC3FBEDA;
	Wed, 20 May 2026 18:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301603; cv=none; b=VWtn+jkigwvZwfahmIUJ7LJnZhJ2rFETVQPcfp28ylCu0HB3cdyX2X72cjnI6WbHY9ZJJOSO+rVDBrLJyQzN08jmudUSYKqvDq2TC7R8WCahuD6COrFb/44FUr0KHzgzeyX6oJEQJ1NBHYfFU44yxTFHTK3MdVWvxS4h4iE3TTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301603; c=relaxed/simple;
	bh=H0Buf2w4hxBMU3SkZRVGbUi9osFbOu8TEInptoGaU2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6GYWu+te7CbOqiw91WBstJpldt/k08KWzBLmvyvC14qhMzy657rhEYETNgiRni9GOwihEkgqT1DWIL4vzFJibZ7lPjeCxQBkkFk4I4Ul3tdISRM3ORxkRlevYFeSoHzHZjbMpvvsrUUsbIsflIBmqRvS8omCki5mvlmIlQbZAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrzZwUwB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrzZwUwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862BC1F000E9;
	Wed, 20 May 2026 18:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301602;
	bh=DRTZrstLobicDjoSwub0kmeWAovGJgJvPNWIitamKLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OrzZwUwBFovYby30ConXKZNXiiD2qp0Tkk2Yvrnfmm1ziBR8V989o1auMXxxxr12u
	 6jCbpvAo+uTdzbfU5LNez8sjwRlXq19YkUGOhiaOloPxmW8edUpVtc+QNNGqcH546C
	 EOkt1sj7yl3z82PaYcF8u/ZbVPi/1ozxR59yowTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Robaina <rrobaina@redhat.com>,
	Sergio Correia <scorreia@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.12 618/666] audit: enforce AUDIT_LOCKED for AUDIT_TRIM and AUDIT_MAKE_EQUIV
Date: Wed, 20 May 2026 18:23:49 +0200
Message-ID: <20260520162124.666741045@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1427,6 +1427,8 @@ static int audit_receive_msg(struct sk_b
 		err = audit_list_rules_send(skb, seq);
 		break;
 	case AUDIT_TRIM:
+		if (audit_enabled == AUDIT_LOCKED)
+			return -EPERM;
 		audit_trim_trees();
 		audit_log_common_recv_msg(audit_context(), &ab,
 					  AUDIT_CONFIG_CHANGE);
@@ -1439,6 +1441,8 @@ static int audit_receive_msg(struct sk_b
 		size_t msglen = data_len;
 		char *old, *new;
 
+		if (audit_enabled == AUDIT_LOCKED)
+			return -EPERM;
 		err = -EINVAL;
 		if (msglen < 2 * sizeof(u32))
 			break;


