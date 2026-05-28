Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A08B1DE4E0;
	Thu, 28 May 2026 20:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000671; cv=none; b=bhCBnHkz+v6whRIc+W07uGHTYO7/y3o4rE73lxKYZ5b0x+JgLumDlBEo1Jj7WdXYOiAf1XRqKXZZVUYDBu4fXCkz7kAvKF/0M/1vnzR5tPCrA9KknNjklzAHCwrJ42UD6U4y3XmZWkAkXLCjthxPRVqih6OcPDuDEhur1g5wJBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000671; c=relaxed/simple;
	bh=8y7J5z5OxEQMrGpsbuFmkPyHIf+QwuThtjJpoJV36ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aY6fkH5TNAj+kWmnrEFg3Kdr9DgEPSuUicd8cwqWbYvfyKLhWxy8NlJ25MqL0uPFPs1FfuDx/EXOOm+N3JM6z25hsUUpt4Cr3MnWjr52gxwNRC1YqXxcB5eDUORowCxRcbMxPaDp0a42iMn0NvKgvHQPmN+mZUuvcnnUE384I2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzDAjrHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzDAjrHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789FB1F000E9;
	Thu, 28 May 2026 20:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000670;
	bh=V/zHQE0AfILfVllMaKfr8XZH62l6ixjvqNR+RPrgaXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tzDAjrHBCtMjEFwn6Es7vn9y5i2iMjYLcUC0oMtJmOyba/uPYs4Qc8T+Vx6Vc+2gx
	 zLQoNrNOvmWhH3wlCqjmndVsPwI1wMSgPx9NloPu/xCksiNFp1wcGNBHDmCuo6iM+Z
	 KD5jzNLlvBXfsf8QlI31pRnJwSoZQBKNk9Df14QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.12 091/272] lsm: hold cred_guard_mutex for lsm_set_self_attr()
Date: Thu, 28 May 2026 21:47:45 +0200
Message-ID: <20260528194631.928724547@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit 4a9b16541ad3faf8bccb398532bf3f8b6bbf1188 upstream.

Just as proc_pid_attr_write() already does before calling the LSM
hook. This only matters for SELinux and AppArmor which check
whether the process is being ptraced and if so, whether to
allow the transition.

Cc: stable@vger.kernel.org
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/lsm_syscalls.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/security/lsm_syscalls.c
+++ b/security/lsm_syscalls.c
@@ -55,7 +55,14 @@ u64 lsm_name_to_attr(const char *name)
 SYSCALL_DEFINE4(lsm_set_self_attr, unsigned int, attr, struct lsm_ctx __user *,
 		ctx, u32, size, u32, flags)
 {
-	return security_setselfattr(attr, ctx, size, flags);
+	int rc;
+
+	rc = mutex_lock_interruptible(&current->signal->cred_guard_mutex);
+	if (rc < 0)
+		return rc;
+	rc = security_setselfattr(attr, ctx, size, flags);
+	mutex_unlock(&current->signal->cred_guard_mutex);
+	return rc;
 }
 
 /**


