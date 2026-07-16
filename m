Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F9031E85C;
	Thu, 16 Jul 2026 13:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210223; cv=none; b=aCeSHOR2v5eZUFXQh+rN+UziBAhBUU6F6pT0sVSG7yn94YgOnRmBFIsOijhWdksOaxpJFlfyB/cnEKFpJRyC5gPcFB1pYBfapLSarj72+duXNmtiGMGtfLrCDLRphb85TwArmfIhCMrLLskHhs0minJkNjUnqR1puBiVy82GcA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210223; c=relaxed/simple;
	bh=c+WpTgYLIgUzJnSyhhxzMGDfStTMKLtaPMQtJQbGrxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VQ0UzG1GQXzddikLjP0AOsgEI+lAfSAuT8RGTkRrzWZFGJakEksCGidV+yAuzp871mT26PXVV79QsYoCT2x9jcowPs1bC+CasN81PDa5MEuYwrk/RHf7PAg/+GiT2hcRUBqxJwbIdsC61ZQk/PQ6JZYV7l/cY7wbhj+2lnFvBlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbe8R4I6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbe8R4I6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784911F000E9;
	Thu, 16 Jul 2026 13:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210222;
	bh=XfK8CCdyPx+oi9GwH0hlfc+bYeFF8tV5g3ElQySFXIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbe8R4I6GDtv+nJaOu+br+4qsDePNEsTvJnINsFSdm4fXBIZtysyGAcfuvP55xCih
	 Vn4TDHE3AW9Xdjc0myYQbHM5OfJ57tK4KCkqIBq1OUd3H6WOd3xW7JMMVF8FHkzsyt
	 TvxgrH6Hys8n+Vu+fW+TXGrxCOEJdodVxW7If4bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 7.1 447/518] landlock: Account all audit data allocations to user space
Date: Thu, 16 Jul 2026 15:31:55 +0200
Message-ID: <20260716133057.621484252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit b232bd12789fa57405b5092f28788be97aae9999 upstream.

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


