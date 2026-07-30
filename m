Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E288440A06;
	Thu, 30 Jul 2026 15:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425040; cv=none; b=mf3BgyvFSY4cNyVFU6jWgY+0m8t9mXpy/9vaVZhWTCXFJcvluqumtG77tcDKUgtKzU56t2dx4SGpVU0igd1br1dxy5bJusB5rZlaSJBVszc7UAvlTVc706OWeQCk/0Nq8FEE3nuYxezYC4LEn51HqjVeUNLRffdYSEgmHEH+LBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425040; c=relaxed/simple;
	bh=aW+WC46HyqHmk0FstIPGMEJB2gX3V8WtikSP3nFkv70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Weh1o3R07E9wZAQQ97xaR/rnW/ApSO1Cfji2GtcRNp7USTrwP+iOqPMlXKfxUZxNnY3xLQXET5PFtZi0KiXKPflzNL60vzd0QEXZURXSI7/3GSADrwZu7T8HLW1SmiJ2wvP3YjUI2bY8EcZCiZtocDzYdo9Ue2gDj4X2nlsOQw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwqD5y2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwqD5y2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9871F00A3D;
	Thu, 30 Jul 2026 15:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425039;
	bh=plRuVDwUQrJYTDsJzpkkA6WRo2xalICPRAZThQqTefg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pwqD5y2b0nPB+G4lU3TanS/N/Xka2MQ9MPMYI1ZIBXtML9dI5l5Ym1kEI+olt6wai
	 HXJw8iNlG3CYULx+EkWZNnMCjfGgvqpxMp6cBQf/KydL41BMXj/ybrliMH9X26Zrrj
	 TQnl+7DTySfW/9phbDk+CNnL6uF3Qdj6nFgLHvr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 606/675] landlock: Account all audit data allocations to user space
Date: Thu, 30 Jul 2026 16:15:36 +0200
Message-ID: <20260730141457.994651926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit b232bd12789fa57405b5092f28788be97aae9999 ]

Mark the kzalloc_flex() of struct landlock_details with
GFP_KERNEL_ACCOUNT so the allocation is charged to the calling task,
like the other Landlock per-domain allocations which have used
GFP_KERNEL_ACCOUNT forever.

Every property of landlock_details is caller-attributable: allocated by
landlock_restrict_self(2), owned by the caller's landlock_hierarchy,
contents are the caller's pid, uid, comm, and exe_path, lifetime bounded
by the caller's domain.  While the caller may not know nor control the
size of this allocation (i.e. exe_path), this data should still be
accounted for it.

The deciding factor is whether userspace can trigger the allocation, not
whether the size of the data is known nor controlled by the caller.
This aligns with the kmemcg accounting policy established by commit
5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg").

No new failure modes: the hierarchy and ruleset are allocated before
details and are already accounted, so landlock_restrict_self(2) already
returns -ENOMEM under memcg pressure.  This change widens that existing
failure window slightly; it does not introduce a new error code.

Cc: Günther Noack <gnoack@google.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: stable@vger.kernel.org
Fixes: 1d636984e088 ("landlock: Add AUDIT_LANDLOCK_DOMAIN and log domain status")
Link: https://patch.msgid.link/20260513180309.165840-1-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/domain.c |    9 +++++----
 security/landlock/domain.h |    5 +----
 2 files changed, 6 insertions(+), 8 deletions(-)

--- a/security/landlock/domain.c
+++ b/security/landlock/domain.c
@@ -90,11 +90,12 @@ static struct landlock_details *get_curr
 		return ERR_CAST(buffer);
 
 	/*
-	 * Create the new details according to the path's length.  Do not
-	 * allocate with GFP_KERNEL_ACCOUNT because it is independent from the
-	 * caller.
+	 * Create the new details according to the path's length.  Account to
+	 * the calling task's memcg, like the other Landlock per-domain
+	 * allocations, even if it may not control the related size.
 	 */
-	details = kzalloc_flex(*details, exe_path, path_size);
+	details =
+		kzalloc_flex(*details, exe_path, path_size, GFP_KERNEL_ACCOUNT);
 	if (!details)
 		return ERR_PTR(-ENOMEM);
 
--- a/security/landlock/domain.h
+++ b/security/landlock/domain.h
@@ -33,10 +33,7 @@ enum landlock_log_status {
  * Rarely accessed, mainly when logging the first domain's denial.
  *
  * The contained pointers are initialized at the domain creation time and never
- * changed again.  Contrary to most other Landlock object types, this one is
- * not allocated with GFP_KERNEL_ACCOUNT because its size may not be under the
- * caller's control (e.g. unknown exe_path) and the data is not explicitly
- * requested nor used by tasks.
+ * changed again.
  */
 struct landlock_details {
 	/**


