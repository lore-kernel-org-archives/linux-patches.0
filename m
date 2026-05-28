Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D5E2C11F9;
	Thu, 28 May 2026 20:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999515; cv=none; b=PlL/JlsdS/kmMij8rTMdRqKCGX6UjxisaNMdMZ6YrHKed+u1ObpfMcvWoK7mPBJ6EWpXfgdDvip37rzInG/ZzYOxWed5iJTgHJXGlZ9+Whc0IEzX6iAkX3hOEr86GJYSZm1BYTlvqSr+8dn1hX/8h11W19h5R/iT+nvNiYl3WCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999515; c=relaxed/simple;
	bh=BTkrmFz3Z7FY94MyKfwBKmzMmAwC7e7/Fsv7HQi/B6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zzi0zRdlCSy93R028gMOjLsLz5EaPWDgXBx6qL3hJwY37nQqMzeFWiWAWJju2A2AxbZbpWH6wkc8004v8xjognPYtW++lpOuR80bLpE164Cr3F3Sw81RL/CR1cg+yLzQfnghF7BvOygW7lWUr2xz4tngcl9O2mZu4WLAkhitNw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yWm2mpN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yWm2mpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D4C1F000E9;
	Thu, 28 May 2026 20:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999514;
	bh=P8z+E6n0wqHJnyR0W/V+G3cRUO58wGnOxOSDrpTrsL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1yWm2mpNE577w6C4wpf1Cel3mlGest1knTLqoQFxEZGRhGQGdrZgt2fF/LKPOOQJM
	 kGhA4EVcGpG3ruGYHqd62EGPf1cejCzpveZih0ZPlpb9ZUfWlCZwg+42WrcGpmaVbR
	 w/6GMGe/3V31bbSUHx+PqoIBn6euSMgUG46suQrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 094/377] lsm: hold cred_guard_mutex for lsm_set_self_attr()
Date: Thu, 28 May 2026 21:45:32 +0200
Message-ID: <20260528194641.079658890@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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


