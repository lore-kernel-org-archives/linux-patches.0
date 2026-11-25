Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622184;
	b=nFYDZ/+x286zmyTTjvptxsDQQnR/jfu7+lQ5GgcWyhpwNbPbDIAsG2r9R3dCfYoZg9tK
	 PgghWtij50DX+54v7yqeXooGSDYQzVi3np5rrXUq+b8dWw9hUZ4jrWr4ujx6OcUSOyf0i
	 q9QCBqWiJDlN8vo1C4Crd8e9faqIJlEmZaEmdv3rRqA3V+RVPj3tFyHbMYC/m7sly4/7y
	 ++bynq8EmB2CAycJJP7OCCs2ghXoCRWNlw8gNeInc12e3a25ZvBtVOwAgVjs8WsxKMVGD
	 7g7stnEiwTyqswCpMkvnD54T68U2+1yHOWUsHJsV+ICRsFiefQs1lSVTYMegh9DYfHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3+fRK0Kf/QJKn732Hd4BYy4khmA2hCZkFgWfUVuHQrQ=;
	b=VqMmmQLRt2oRE3WNwamYLegSokIXz0fid6LwaBBSgZvwBcP7IiWc9KmxTaUHj416umgU
	 /0RjeNig5mQmB8d7Wbq+8zo2ORsgY6S/dD2yIVJYjxZS40luUDI1ul2xAG85Zppze2oOg
	 MHvAw6ZKsm6kJpEayzUS7SoMrqmYGVD25Wq05ITtcCaslwLd7w2gykT1z6jPWPOQ8Se0U
	 2IJH3s13O9YCgXmSMWJS3laMmWV6/5yhoe4sulsU64uksfX5OfzJj8ga4510mWcbDfiqG
	 V8OM+0zLvcKOn69gLfKHYmKqYxjU6Z9D6+Raa3SyuOt3KoNYkW0nbekgnOUmhZbcMIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xoe3SRkT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F4C606A333;
	Wed, 25 Nov 2026 15:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xoe3SRkT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343391F000C6;
	Wed, 25 Nov 2026 15:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622183;
	bh=3+fRK0Kf/QJKn732Hd4BYy4khmA2hCZkFgWfUVuHQrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xoe3SRkTE+vJQvEGL+eskLvsrif1mJeFUoz5vVTKjpW5YnMC9sEBR9TyhEtkOPC3E
	 K7bljuNgkgXlTXjIyD9mdWfXHINkcWFwKNjZewkBeBCBv3dq/cDLny1A7BJZ/Nbfdl
	 f+i30kQNkIj0UWvLmniB+SF1EOfa6OElytXuM9Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 457/990] drm/xe/forcewake: Add scope-based cleanup for forcewake
Date: Wed, 25 Nov 2026 15:30:24 +0100
Message-ID: <20261125143832.798807175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 074edfbdfba25493324807f749fbc86bf0af3a2d ]

Since forcewake uses a reference counting get/put model, there are many
places where we need to be careful to drop the forcewake reference when
bailing out of a function early on an error path.  Add scope-based
cleanup options that can be used in place of explicit get/put to help
prevent mistakes in this area.

Examples:

   CLASS(xe_force_wake, fw_ref)(gt_to_fw(gt), XE_FW_GT);

       Obtain forcewake on the XE_FW_GT domain and hold it until the
       end of the current block.  The wakeref will be dropped
       automatically when the current scope is exited by any means
       (return, break, reaching the end of the block, etc.).

   xe_with_force_wake(fw_ref, gt_to_fw(ss->gt), XE_FORCEWAKE_ALL) {
        ...
   }

       Hold all forcewake domains for the following block.  As with the
       CLASS usage, forcewake will be dropped automatically when the
       block is exited by any means.

Use of these cleanup helpers should allow us to remove some ugly
goto-based error handling and help avoid mistakes in functions with lots
of early error exits.

An 'xe_force_wake_release_only' class is also added for cases where a
forcewake reference is passed in from another function and the current
function is responsible for releasing it in every flow and error path.

v2:
 - Create a separate constructor that just wraps xe_force_wake_get for
   use in the class.  This eliminates the need to update the signature
   of xe_force_wake_get().  (Michal)

v3:
 - Wrap xe_with_force_wake's 'done' marker in __UNIQUE_ID.  (Gustavo)
 - Add a note to xe_force_wake_get()'s kerneldoc explaining that
   scope-based cleanup is preferred when possible.  (Gustavo)
 - Add an xe_force_wake_release_only class.  (Gustavo)

v4:
 - Add NULL check on fw in release_only variant.  (Gustavo)

Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patch.msgid.link/20251118164338.3572146-30-matthew.d.roper@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Stable-dep-of: 557c7b434378 ("drm/xe: Sync Wa_16023105232 in xe_was to match OOB rule")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_force_wake.c |  7 ++++++
 drivers/gpu/drm/xe/xe_force_wake.h | 40 ++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_force_wake.c b/drivers/gpu/drm/xe/xe_force_wake.c
index c59a9b330697d..76e054f314ee1 100644
--- a/drivers/gpu/drm/xe/xe_force_wake.c
+++ b/drivers/gpu/drm/xe/xe_force_wake.c
@@ -166,6 +166,13 @@ static int domain_sleep_wait(struct xe_gt *gt,
  * xe_force_wake_ref_has_domain() function. Caller must call
  * xe_force_wake_put() function to decrease incremented refcounts.
  *
+ * When possible, scope-based forcewake (through CLASS(xe_force_wake, ...) or
+ * xe_with_force_wake()) should be used instead of direct calls to this
+ * function.  Direct usage of get/put should only be used when the function
+ * has goto-based flows that can interfere with scope-based cleanup, or when
+ * the lifetime of the forcewake reference does not match a specific scope
+ * (e.g., forcewake obtained in one function and released in a different one).
+ *
  * Return: opaque reference to woken domains or zero if none of requested
  * domains were awake.
  */
diff --git a/drivers/gpu/drm/xe/xe_force_wake.h b/drivers/gpu/drm/xe/xe_force_wake.h
index 0e3e84bfa51c3..1e2198f6a0078 100644
--- a/drivers/gpu/drm/xe/xe_force_wake.h
+++ b/drivers/gpu/drm/xe/xe_force_wake.h
@@ -61,4 +61,44 @@ xe_force_wake_ref_has_domain(unsigned int fw_ref, enum xe_force_wake_domains dom
 	return fw_ref & domain;
 }
 
+struct xe_force_wake_ref {
+	struct xe_force_wake *fw;
+	unsigned int domains;
+};
+
+static struct xe_force_wake_ref
+xe_force_wake_constructor(struct xe_force_wake *fw, unsigned int domains)
+{
+	struct xe_force_wake_ref fw_ref = { .fw = fw };
+
+	fw_ref.domains = xe_force_wake_get(fw, domains);
+
+	return fw_ref;
+}
+
+DEFINE_CLASS(xe_force_wake, struct xe_force_wake_ref,
+	     xe_force_wake_put(_T.fw, _T.domains),
+	     xe_force_wake_constructor(fw, domains),
+	     struct xe_force_wake *fw, unsigned int domains);
+
+/*
+ * Scoped helper for the forcewake class, using the same trick as scoped_guard()
+ * to bind the lifetime to the next statement/block.
+ */
+#define __xe_with_force_wake(ref, fw, domains, done) \
+	for (CLASS(xe_force_wake, ref)(fw, domains), *(done) = NULL; \
+	     !(done); (done) = (void *)1)
+
+#define xe_with_force_wake(ref, fw, domains) \
+	__xe_with_force_wake(ref, fw, domains, __UNIQUE_ID(done))
+
+/*
+ * Used when xe_force_wake_constructor() has already been called by another
+ * function and the current function is responsible for releasing the forcewake
+ * reference in all possible cases and error paths.
+ */
+DEFINE_CLASS(xe_force_wake_release_only, struct xe_force_wake_ref,
+	     if (_T.fw) xe_force_wake_put(_T.fw, _T.domains), fw_ref,
+	     struct xe_force_wake_ref fw_ref);
+
 #endif
-- 
2.53.0



