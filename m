Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F853E00A3;
	Wed, 30 Sep 2026 19:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796353; cv=none; b=Ag1nT2i9X5L48c2MY08vT7AQFOxYr99uvMD/d522yUuUYXysmbP3WI6eV5EQRX3VSryEdHyq+4+OKYFd4ISB15yN/KtgO3DKsA1kX8XJVjjYfVrl2qT+SILGp3t/sJ60ANOSDSspN66zRuAj5DNlzZhpOGcz++TqAKEde7I9mJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796353; c=relaxed/simple;
	bh=Jp0HK9v4qz/nDxcDF1RdjH3aHWZxoOweDHS9lLRN5zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M1C5CVeOjESTcl0K/QmTaLSu2cqcWFTsEqYZYATWXw/BiEiduUs54CADruzVLY30H607y0LzsW8+9uqNaU3nu7dYmL9ACYy4FJnmmtLOXqQ9JqwyTo2Xe5hq2Opr/lrCTLLnGJGJJ9TeyTgtJEwzgrDusjfOPwJNmmf3OBITmZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJ38W4GF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJ38W4GF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807F01F00898;
	Wed, 30 Sep 2026 19:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796352;
	bh=pnsB9I+XSkcoa1bIKhexjwg3SEPOcKqNCcEW2LfZxD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJ38W4GFk/yxC0lSFoR79NaQd19Gavn6rLaEdR4nvlz6F1ksZHh95h1tBOziXs08U
	 845011V8eUE2qKYHNtVK/oJMfvvttcimw6Oxnk+sjw3NFkJWE0CsSwtn1mkIeKtQYY
	 xZtc4wuMShwZZJSwPQ87h9W/yIBg5PNMMN7nznxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 0882/1193] selinux: always fill AVC decision in avc_has_perm_noaudit()
Date: Wed, 30 Sep 2026 17:26:06 +0200
Message-ID: <20260930152453.843035997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1151,8 +1151,11 @@ inline int avc_has_perm_noaudit(u32 ssid
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


