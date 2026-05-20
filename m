Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F863F1AB8;
	Wed, 20 May 2026 17:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297110; cv=none; b=gishhg5LLZpOgQk0hAxVrUOARE1+EyR4G7wIEE54C4FJc81hxumUjZFcF/K5tiDapHPRLE1aqpsxajM9PvoRuKRtiRxZ/UZnnFcehzs1E1Kh7OtG4yxIpbzJ0VxdS3YILcqWcYMFa99fKJO7F04m69R9R1jOjQOYKhgDpt6FnL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297110; c=relaxed/simple;
	bh=Fmwvy0NG1ybcSj+cd7jLg7ybgkfki3ETxcXtqV5cRds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGZGcIIubFmt/nqAmQSGaCVpdqUO8XnR9S4gZjs6C+3D6nROuqBOTlhR1U+/0eNjw+iPfxRAG9l6juiwD6tZr2YcMtjCtnFUB9pUMOK2kZmn72zuC21ZU8Y4YpF+loO/97htBpfyPa9O7DRzivqy1do98XxGOZ7kV/z1v+JR1UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cS+RXJ4t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cS+RXJ4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D5F1F000E9;
	Wed, 20 May 2026 17:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297109;
	bh=K37OC/lAEZgPeMmV6qS7CuerJ43f9fPXUeWkoNf+rOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cS+RXJ4t5/mq7YfISMqQNgZd9cJkb/55jtoJDRQgskWtXbp4MfiKg1CdQ5f0L+6cQ
	 AMWa4eJDNmSZHEXNz6y2HkJUqWXp3LZouTP9ph9tLM1jxplX1xeNQoKqnP6c8QbcDw
	 h8BxN4xglz5vYsBl3le8wlccPtFJZ6JD75APUMJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Robaina <rrobaina@redhat.com>,
	Sergio Correia <scorreia@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.0 1055/1146] audit: enforce AUDIT_LOCKED for AUDIT_TRIM and AUDIT_MAKE_EQUIV
Date: Wed, 20 May 2026 18:21:45 +0200
Message-ID: <20260520162212.110873935@linuxfoundation.org>
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
@@ -1466,6 +1466,8 @@ static int audit_receive_msg(struct sk_b
 		err = audit_list_rules_send(skb, seq);
 		break;
 	case AUDIT_TRIM:
+		if (audit_enabled == AUDIT_LOCKED)
+			return -EPERM;
 		audit_trim_trees();
 		audit_log_common_recv_msg(audit_context(), &ab,
 					  AUDIT_CONFIG_CHANGE);
@@ -1478,6 +1480,8 @@ static int audit_receive_msg(struct sk_b
 		size_t msglen = data_len;
 		char *old, *new;
 
+		if (audit_enabled == AUDIT_LOCKED)
+			return -EPERM;
 		err = -EINVAL;
 		if (msglen < 2 * sizeof(u32))
 			break;


