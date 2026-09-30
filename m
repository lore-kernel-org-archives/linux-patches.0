Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71533624BF;
	Wed, 30 Sep 2026 17:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788697; cv=none; b=Lriv/Ff6gCH0CA9HvE9QEuOJ/2n7OHsmrf8NRwEuBRTIL43Hz3agrzmx8pD/NCMmre0i3Dsqeq3IgpZ5VSGJJbQ4tKjJCiIIt1OeBi2wPqyh685uxOkwR7//bVpDowroeKJIX1TqwStaE063xhEKZWbVh7RY15N6YhM/8kUUhzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788697; c=relaxed/simple;
	bh=v5M015SWZl/mCXS6evuV/0D28SdwKMkU0d8Kl6lRCv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MOn3d4GYhO5yOjBNpIeWg1qFu4QDu+k02t+PxouTJj9soK+9fqbfwO5+TQoa20S96tC8FJzXKEnFrOhK/hrse6v2XpkLk0JX2x/CEJM0/y4WlX2bRpMCLVmktPRkwxZbWwdteCPYJWXDVeqJ7ydUAquJdccMlDou4iMHp0+vGZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qxc2B+rZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qxc2B+rZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2221F000FF;
	Wed, 30 Sep 2026 17:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788696;
	bh=bdKfCTccH5KeK1a6ydtnotRxgxrEqIOSGhm1QYLoOL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qxc2B+rZQ2GB/Z15s9q+cYRn1pTIC9yr7t8wKtMiMD8Uo3bphl8KigaN6IpAkDVI0
	 +a5X3q04jKu/KuvVyOrjrfeLA9LP1ByNsKC5RP0YtE6zjE9cm0WPkLxiBfzgFgDGD6
	 XY6xhxhvbsuaJJnir+eRBC6t6lhjHwjBtTeqxR+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.12 217/877] selinux: always fill AVC decision in avc_has_perm_noaudit()
Date: Wed, 30 Sep 2026 17:18:48 +0200
Message-ID: <20260930152419.411441310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1143,8 +1143,11 @@ inline int avc_has_perm_noaudit(u32 ssid
 	u32 denied;
 	struct avc_node *node;
 
-	if (WARN_ON(!requested))
+	if (WARN_ON(!requested)) {
+		/* Provide a deny-all, audit-all decision to the caller. */
+		*avd = (struct av_decision){ .auditdeny = 0xffffffff };
 		return -EACCES;
+	}
 
 	rcu_read_lock();
 	node = avc_lookup(ssid, tsid, tclass);


