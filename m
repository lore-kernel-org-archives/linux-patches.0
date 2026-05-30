Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784F133B6C4;
	Sat, 30 May 2026 17:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162066; cv=none; b=Ct3+4GEkfgajLPsmmoq68+4nXKkZ79Ugob45uxOFyHe5tSI7CEC0mcHaaZNRaqZnGxV3lV2AvgiYNmWoOka7+FjXjZSToFSQfgdPBFE55fsPrxkN9vp0BXsWR+66PCumN+1A99HBP5BcrE/DX825HESR8AY+O+nV2bywtuaEDdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162066; c=relaxed/simple;
	bh=BU1Jz0W23Ny7XQFBgGXIkVGxJ/apV+iRZARTDEXwors=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1xp3Sp0i10A6ZRHmZw+NVR9ikAR8I78rTFdJzZER5Pe1Czjs/8rbinwP99WKJHkkIDs47Ccmi8CrVQFUvnanqBGGs0jM6LM5fDrT9gfI7DVrjpCH+jXHEnCI90/I1YY2Vslazi4kTKwzrp3wKj2NBqOOGYEv9CjIGz1SyVGePY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7dgm/N4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7dgm/N4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AC41F00893;
	Sat, 30 May 2026 17:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162065;
	bh=RAt5bLryQvZkhShUJVR58AUPKUQOnqveaoYqu/lnXYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7dgm/N458RjrmSFDetiBUwAdb+aket4fdmgFshA/Bsj51uOiVgdf9LiEz0IT5/Kz
	 uGvjafTGMZ7zREoSO0GX0BGOV5by893YYQ4lw4VsTx4lbQl5czjIQI+gCZrF12tAq2
	 ff8xR1YxEVHcnHQIi4z7LS6FlVc4XGgfe34WG1ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Robaina <rrobaina@redhat.com>,
	Sergio Correia <scorreia@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 811/969] audit: enforce AUDIT_LOCKED for AUDIT_TRIM and AUDIT_MAKE_EQUIV
Date: Sat, 30 May 2026 18:05:35 +0200
Message-ID: <20260530160323.029653477@linuxfoundation.org>
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
@@ -1428,6 +1428,8 @@ static int audit_receive_msg(struct sk_b
 		err = audit_list_rules_send(skb, seq);
 		break;
 	case AUDIT_TRIM:
+		if (audit_enabled == AUDIT_LOCKED)
+			return -EPERM;
 		audit_trim_trees();
 		audit_log_common_recv_msg(audit_context(), &ab,
 					  AUDIT_CONFIG_CHANGE);
@@ -1440,6 +1442,8 @@ static int audit_receive_msg(struct sk_b
 		size_t msglen = data_len;
 		char *old, *new;
 
+		if (audit_enabled == AUDIT_LOCKED)
+			return -EPERM;
 		err = -EINVAL;
 		if (msglen < 2 * sizeof(u32))
 			break;


