Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C0D51121D;
	Wed, 30 Sep 2026 16:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786068; cv=none; b=ShqDWXoourreI3OKoHKTH80IZI6uBGyugmgL1jpSzxz1hNXZus3Jnl4WKU6jpm3WXcHBZrTY+fkhS/5lZ588fhM1atXzf7ObLkh5Zkk9VRv2YcbwNu7ayNjqvT8j+/qW2MpWSeWRHQm4KYwLPIMMK9kjZ7yPCZzJ4FJ80ifvMLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786068; c=relaxed/simple;
	bh=SOIVWSAOM2Bp8lyydTLG/f/yqFGLj/LGeXaT1S5bIeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=diFy8wQ9puFl0fQ+JyQsGuW/PfAZ8dWFK0f7gqLxfqPPvoSb/dfUtW/7T0PBeUJacwKt/33IAxj9+3MqYORlSCv6w+IX6ZCX4pzCQNfB15zpRo+KI5UIzPN6Y4CWYpFbAzc3whhu8tb8macP/oC48Nb/PBj9Z/GKzRad/VJTi6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yREwXain; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yREwXain"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E036B1F000FF;
	Wed, 30 Sep 2026 16:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786067;
	bh=7alf0Qz4qY+YfzqE1JBFoJjVTvMEOkNzLUBCnHmHZtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yREwXainBY5WQ77xhbe/7VM20B/Om1sKaM4nVKSJtShaee2wddQgAtOWdhYmvwXBo
	 t9MvaAmL8GqIO4ildLYjJO4RUoDeYb7k5bNHd8BlTm8HZOzY2Y+E5CAUFkHQIEtmcr
	 pV3RqmxLK5+4zorq2OvthGa05m9L05fuijUyHBsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 729/982] selinux: always fill AVC decision in avc_has_perm_noaudit()
Date: Wed, 30 Sep 2026 17:24:25 +0200
Message-ID: <20260930152432.412953724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

commit 8861db305103107199b1426f25fde1fb6d465583 upstream.

avc_has_perm_noaudit() is documented to return a copy of the access
decision in @avd, but its early return for an empty requested permission
set leaves the buffer untouched.  All callers pass an uninitialized
stack variable and afterwards feed it to avc_audit(), and the inode hook
even stores it in the per-task decision cache.

Fill in a deny-all, audit-all decision, similar to avd_init(), so every
caller receives a defined value at no cost on the hot path.

Cc: stable@vger.kernel.org
Fixes: e6f2f381e4015386 ("selinux: replace BUG_ONs with WARN_ONs in avc.c")
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/avc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -1144,8 +1144,11 @@ inline int avc_has_perm_noaudit(struct s
 	int rc = 0;
 	u32 denied;
 
-	if (WARN_ON(!requested))
+	if (WARN_ON(!requested)) {
+		/* Provide a deny-all, audit-all decision to the caller. */
+		*avd = (struct av_decision){ .auditdeny = 0xffffffff };
 		return -EACCES;
+	}
 
 	rcu_read_lock();
 


