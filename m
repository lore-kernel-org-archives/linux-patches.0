Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C2C16D9B8;
	Mon, 12 Aug 2024 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480352; cv=none; b=OhypPOjb8lssWr1nEAA5TgXD3iNspj9ybqDWOsuZVvIrCaUam2Y/b//zCluzRim5tJDUBhzbteMWnTLOxzTN7ub2/MoPn3eVP2l4aJlw++nvyYBD8eupLS+e5KEaWRLVHYJUOGQHAxtBILPv/95k0O3jwxo+81dJxBG6hrZrUHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480352; c=relaxed/simple;
	bh=VIoWVf2TyQhojItDqtNhC3A1QrQWRI+wOcMArQytaUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqQ8xR/nfd3viGadQpP/BJKPRrJ0triDCAxTElTPk9m32zHNLLKZfpvj2zyrJQd/7+PLTXJLkpyuVvSPB3VuMr8sKXffvINlD3OgNx/20idGxjtzk46bnRcCJEgIieia+XefPSWkCiUmLyh0g1/GIiPWFgrs2at2t3GznWjMbtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrwJZzjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrwJZzjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9504AC32782;
	Mon, 12 Aug 2024 16:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480352;
	bh=VIoWVf2TyQhojItDqtNhC3A1QrQWRI+wOcMArQytaUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrwJZzjGDlCNapx7kRuQFye+qOHZKOVtSJYED43WLCH0WCzRSLzLOqQL1n4YL9xWE
	 1Xvt2UkgXSvpj0ZqEvNbS4ZVYVKrAg6jUO4hqr4qitGpsV16DjcmoaA9GMeYBalX0q
	 GwtfYcCSkdWYbvlXmZU04wrLp/mjbdXqV3nJ989k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <linux@armlinux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 171/263] module: make waiting for a concurrent module loader interruptible
Date: Mon, 12 Aug 2024 18:02:52 +0200
Message-ID: <20240812160153.094583252@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 2124d84db293ba164059077944e6b429ba530495 ]

The recursive aes-arm-bs module load situation reported by Russell King
is getting fixed in the crypto layer, but this in the meantime fixes the
"recursive load hangs forever" by just making the waiting for the first
module load be interruptible.

This should now match the old behavior before commit 9b9879fc0327
("modules: catch concurrent module loads, treat them as idempotent"),
which used the different "wait for module to be ready" code in
module_patient_check_exists().

End result: a recursive module load will still block, but now a signal
will interrupt it and fail the second module load, at which point the
first module will successfully complete loading.

Fixes: 9b9879fc0327 ("modules: catch concurrent module loads, treat them as idempotent")
Cc: Russell King <linux@armlinux.org.uk>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 7445d27ce3cdc..3f9da537024a1 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -3101,7 +3101,7 @@ static bool idempotent(struct idempotent *u, const void *cookie)
 	struct idempotent *existing;
 	bool first;
 
-	u->ret = 0;
+	u->ret = -EINTR;
 	u->cookie = cookie;
 	init_completion(&u->complete);
 
@@ -3137,7 +3137,7 @@ static int idempotent_complete(struct idempotent *u, int ret)
 	hlist_for_each_entry_safe(pos, next, head, entry) {
 		if (pos->cookie != cookie)
 			continue;
-		hlist_del(&pos->entry);
+		hlist_del_init(&pos->entry);
 		pos->ret = ret;
 		complete(&pos->complete);
 	}
@@ -3145,6 +3145,28 @@ static int idempotent_complete(struct idempotent *u, int ret)
 	return ret;
 }
 
+/*
+ * Wait for the idempotent worker.
+ *
+ * If we get interrupted, we need to remove ourselves from the
+ * the idempotent list, and the completion may still come in.
+ *
+ * The 'idem_lock' protects against the race, and 'idem.ret' was
+ * initialized to -EINTR and is thus always the right return
+ * value even if the idempotent work then completes between
+ * the wait_for_completion and the cleanup.
+ */
+static int idempotent_wait_for_completion(struct idempotent *u)
+{
+	if (wait_for_completion_interruptible(&u->complete)) {
+		spin_lock(&idem_lock);
+		if (!hlist_unhashed(&u->entry))
+			hlist_del(&u->entry);
+		spin_unlock(&idem_lock);
+	}
+	return u->ret;
+}
+
 static int init_module_from_file(struct file *f, const char __user * uargs, int flags)
 {
 	struct load_info info = { };
@@ -3188,20 +3210,8 @@ static int idempotent_init_module(struct file *f, const char __user * uargs, int
 
 	/*
 	 * Somebody else won the race and is loading the module.
-	 *
-	 * We have to wait for it forever, since our 'idem' is
-	 * on the stack and the list entry stays there until
-	 * completed (but we could fix it under the idem_lock)
-	 *
-	 * It's also unclear what a real timeout might be,
-	 * but we could maybe at least make this killable
-	 * and remove the idem entry in that case?
 	 */
-	for (;;) {
-		if (wait_for_completion_timeout(&idem.complete, 10*HZ))
-			return idem.ret;
-		pr_warn_once("module '%pD' taking a long time to load", f);
-	}
+	return idempotent_wait_for_completion(&idem);
 }
 
 SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
-- 
2.43.0



