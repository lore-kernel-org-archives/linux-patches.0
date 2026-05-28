Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6E5338936;
	Thu, 28 May 2026 19:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998187; cv=none; b=fk3T850h83qolW3aYmsoRAOCmGPp+3wVDc52rM0irGAgguqsEor6QaqpIqq7TWrpxJj/UhR9G1IfeUDsNK4QtBp4AwWWl6x7G5nYMI0CdMjjW8CEjdMILD/2W9311wKcFwsw1GOQCKn1cY2SHReBsB2U6E1TyPOrkKzG1+hxZr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998187; c=relaxed/simple;
	bh=Rx7auoKn0TrDLs7WRgMNGzdM2wS8QxnVJkpPrN3AWxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdVqo3Ej0l8Zbz2NB7klNS5tp5Blpn0mDkqo9CikJaSnYNXwueLdzb6XiZuJjbOaxHLgsTSBD/YbU9CINWgp1YYgyY10jVb/ixg9JAnHaqVf7vcYlj0N9fxBdPy+q4kgNB6Amgbv3DrFJ/ZshqSjiFe/VNlwjocFRrmnpasfyEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yARVaoGz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yARVaoGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C091F000E9;
	Thu, 28 May 2026 19:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998186;
	bh=c277MKnbbq9BfgOXBrS7kDRqwa6gsI4NfOyjPcDIElk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yARVaoGzwbzL6mvy2C1zoF4mRq+Ml2pVyZoaGRolcktxuBVbdyR5QGQOraKpIaz5f
	 iuqfRJQPjoOfcBKYaAF5lLCjnj3r5E5HN2nKvLO8zx7FDeRX+/F8/sdy9TGiG6gRiT
	 u1tR+WklY4PVymwc+MRfHin1BiKp+iRoEVFG2j3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.0 085/461] lsm: hold cred_guard_mutex for lsm_set_self_attr()
Date: Thu, 28 May 2026 21:43:34 +0200
Message-ID: <20260528194649.382794406@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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
@@ -57,7 +57,14 @@ u64 lsm_name_to_attr(const char *name)
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


