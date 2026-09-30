Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1B64EA39A;
	Wed, 30 Sep 2026 15:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783567; cv=none; b=pgEWrNeBg5YM6pa9kNXU5qJCRBQoW9u0brmJCmOxWdfNGBR8rbceO0VuT5ENmPrFEftYMHu4aX5zGSH6pRKTixxeq2F5RsV57gEcvVHrvd2ZGhGTuSa0qntok9LSCPkAJW/ngBFB4zsTWyZQBmFjaJ9zSa0LMwkOwOVmkNvNeyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783567; c=relaxed/simple;
	bh=bXh1FdQmfljKeYvMqjSC9D3DGlL8kIQWipUP0TTplA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SRXuSoLl9XrcXa4NpqkLltpG1IRzTe+HiufnPoWewmmqv3un7VRIhlU122HkY/RV38cPdJfPs94mQOd5Ii5a9Zu2b8WurJ4i54XG9sGMDmgo6pfELrEmbe9RcW/eqLRXkdxv54cDL6lrcrq/E0yzaPCqzJdhgXa0CpKQ5LPHg7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GrIRiL+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrIRiL+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7891F00898;
	Wed, 30 Sep 2026 15:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783560;
	bh=mopD9kwHJ40NxDmzMkSRIr9bkZq+s3pn1AwxWnf41TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GrIRiL+zK7YO0w5EFoCCvMFeda1xZpgBQSY3/Sc6yZHweehj+csXOS/zQPOB5wYYA
	 gC3HNexqD1UTEuEIDfFsrXHe9XazcbFZa3cwcmsCbATT8vKpZRpXmlhgpD0cMcFx+T
	 lIdZBYRXisZwMtFZUvd9NFqpx7KkhXZlj/Dp8Dho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 440/595] selinux: always fill AVC decision in avc_has_perm_noaudit()
Date: Wed, 30 Sep 2026 17:25:33 +0200
Message-ID: <20260930152357.145008667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1145,8 +1145,11 @@ inline int avc_has_perm_noaudit(struct s
 	int rc = 0;
 	u32 denied;
 
-	if (WARN_ON(!requested))
+	if (WARN_ON(!requested)) {
+		/* Provide a deny-all, audit-all decision to the caller. */
+		*avd = (struct av_decision){ .auditdeny = 0xffffffff };
 		return -EACCES;
+	}
 
 	rcu_read_lock();
 


