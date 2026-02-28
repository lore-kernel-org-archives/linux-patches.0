Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655B835AC06
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302734; cv=none; b=uovSBk6IWhv+TDM/14Ba5TzEEJEkEqfHOkAWB5uIjWbGIbmOrGp9PQnCAoojeBoGuMnSR+V7qP9tO59X7VOtCf+4zjOj/lfnrJV0yVe12rtj0R1bjTpRpRWS0xiGc4McfCq5DBl/Z3eBhDM9+D4qSsCSTznJBa4Vt3mSRlBoWTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302734; c=relaxed/simple;
	bh=yWCE/NI+m1d+ML6l9F2mZxDfFziUjzBlg9vZEMowvbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nD5BnIVFuL98azhtjb2DW4U2JbdZWlTu16SocGOvdrnF5UK94RQ7M7cuTikf5IbYjBzqMeF9ikUdgJK2UYb23pR6kLcms4tlpUUkEwRoLC8lMZH9ePpeRu/RCYvL5HySPlycaMV/0K4Xy7RMQET2rOUbOLWnYiCM8yZGmRBhcyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nVMUtFSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nVMUtFSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D7CC116D0;
	Sat, 28 Feb 2026 18:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302734;
	bh=yWCE/NI+m1d+ML6l9F2mZxDfFziUjzBlg9vZEMowvbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVMUtFSESasaGLCu7QZtTrhUiLsBdZB1RICgtWMJbtS+I4WYy4Jyrw6iCxCrgluc1
	 1NhiDXc/Wiqh+Zkel3qUjVpv46omil0wfwTI6cHGa6oxL69if6UOr6nx92UU3hGxGf
	 AwmSbk1iL26qpZSWXCwJxw3GUDG4rT3/cbQK8sPmINiqIwoOr7uvL/+U3muDv1jCZ3
	 eLx14chfBYeoM6wikCpbaQOg8/WzcUwmkq7rCsKDxIDOzYfVPJBHKTnhSXlKJUo54N
	 LHb0ZqeEqAGdhnjByYabUSMHgr51LRXkH2Iy+QjQCLKdHiSBbVoKY41bHAYM/4i5UB
	 JUnDl+8VRxPdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Paul Cercueil <paul@crapouillou.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/147] PM: core: Add new *_PM_OPS macros, deprecate old ones
Date: Sat, 28 Feb 2026 13:16:45 -0500
Message-ID: <20260228181736.1605592-97-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 1a3c7bb088266fa2db017be299f91f1c1894c857 ]

This commit introduces the following macros:

SYSTEM_SLEEP_PM_OPS()
LATE_SYSTEM_SLEEP_PM_OPS()
NOIRQ_SYSTEM_SLEEP_PM_OPS()
RUNTIME_PM_OPS()

These new macros are very similar to their SET_*_PM_OPS() equivalent.
They however differ in the fact that the callbacks they set will always
be seen as referenced by the compiler. This means that the callback
functions don't need to be wrapped with a #ifdef CONFIG_PM guard, or
tagged with __maybe_unused, to prevent the compiler from complaining
about unused static symbols. The compiler will then simply evaluate at
compile time whether or not these symbols are dead code.

The callbacks that are only useful with CONFIG_PM_SLEEP is enabled, are
now also wrapped with a new pm_sleep_ptr() macro, which is inspired from
pm_ptr(). This is needed for drivers that use different callbacks for
sleep and runtime PM, to handle the case where CONFIG_PM is set and
CONFIG_PM_SLEEP is not.

This commit also deprecates the following macros:

SIMPLE_DEV_PM_OPS()
UNIVERSAL_DEV_PM_OPS()

And introduces the following macros:

DEFINE_SIMPLE_DEV_PM_OPS()
DEFINE_UNIVERSAL_DEV_PM_OPS()

These macros are similar to the functions they were created to replace,
with the following differences:

 - They use the new macros introduced above, and as such always
   reference the provided callback functions.

 - They are not tagged with __maybe_unused. They are meant to be used
   with pm_ptr() or pm_sleep_ptr() for DEFINE_UNIVERSAL_DEV_PM_OPS()
   and DEFINE_SIMPLE_DEV_PM_OPS() respectively.

 - They declare the symbol static, since every driver seems to do that
   anyway; and if a non-static use-case is needed an indirection pointer
   could be used.

The point of this change, is to progressively switch from a code model
where PM callbacks are all protected behind CONFIG_PM guards, to a code
model where the PM callbacks are always seen by the compiler, but
discarded if not used.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 0ba2035026d0 ("crypto: ccp - Add an S4 restore flow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm.h | 74 +++++++++++++++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 24 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 5ac2c9ba5baf7..b4974dc837032 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -301,47 +301,59 @@ struct dev_pm_ops {
 	int (*runtime_idle)(struct device *dev);
 };
 
+#define SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	.suspend = pm_sleep_ptr(suspend_fn), \
+	.resume = pm_sleep_ptr(resume_fn), \
+	.freeze = pm_sleep_ptr(suspend_fn), \
+	.thaw = pm_sleep_ptr(resume_fn), \
+	.poweroff = pm_sleep_ptr(suspend_fn), \
+	.restore = pm_sleep_ptr(resume_fn),
+
+#define LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	.suspend_late = pm_sleep_ptr(suspend_fn), \
+	.resume_early = pm_sleep_ptr(resume_fn), \
+	.freeze_late = pm_sleep_ptr(suspend_fn), \
+	.thaw_early = pm_sleep_ptr(resume_fn), \
+	.poweroff_late = pm_sleep_ptr(suspend_fn), \
+	.restore_early = pm_sleep_ptr(resume_fn),
+
+#define NOIRQ_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	.suspend_noirq = pm_sleep_ptr(suspend_fn), \
+	.resume_noirq = pm_sleep_ptr(resume_fn), \
+	.freeze_noirq = pm_sleep_ptr(suspend_fn), \
+	.thaw_noirq = pm_sleep_ptr(resume_fn), \
+	.poweroff_noirq = pm_sleep_ptr(suspend_fn), \
+	.restore_noirq = pm_sleep_ptr(resume_fn),
+
+#define RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
+	.runtime_suspend = suspend_fn, \
+	.runtime_resume = resume_fn, \
+	.runtime_idle = idle_fn,
+
 #ifdef CONFIG_PM_SLEEP
 #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
-	.suspend = suspend_fn, \
-	.resume = resume_fn, \
-	.freeze = suspend_fn, \
-	.thaw = resume_fn, \
-	.poweroff = suspend_fn, \
-	.restore = resume_fn,
+	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #else
 #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #endif
 
 #ifdef CONFIG_PM_SLEEP
 #define SET_LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
-	.suspend_late = suspend_fn, \
-	.resume_early = resume_fn, \
-	.freeze_late = suspend_fn, \
-	.thaw_early = resume_fn, \
-	.poweroff_late = suspend_fn, \
-	.restore_early = resume_fn,
+	LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #else
 #define SET_LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #endif
 
 #ifdef CONFIG_PM_SLEEP
 #define SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
-	.suspend_noirq = suspend_fn, \
-	.resume_noirq = resume_fn, \
-	.freeze_noirq = suspend_fn, \
-	.thaw_noirq = resume_fn, \
-	.poweroff_noirq = suspend_fn, \
-	.restore_noirq = resume_fn,
+	NOIRQ_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #else
 #define SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
 #endif
 
 #ifdef CONFIG_PM
 #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
-	.runtime_suspend = suspend_fn, \
-	.runtime_resume = resume_fn, \
-	.runtime_idle = idle_fn,
+	RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
 #else
 #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
 #endif
@@ -350,9 +362,9 @@ struct dev_pm_ops {
  * Use this if you want to use the same suspend and resume callbacks for suspend
  * to RAM and hibernation.
  */
-#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
-const struct dev_pm_ops __maybe_unused name = { \
-	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+#define DEFINE_SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
+static const struct dev_pm_ops name = { \
+	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
 }
 
 /*
@@ -368,6 +380,19 @@ const struct dev_pm_ops __maybe_unused name = { \
  * .resume_early(), to the same routines as .runtime_suspend() and
  * .runtime_resume(), respectively (and analogously for hibernation).
  */
+#define DEFINE_UNIVERSAL_DEV_PM_OPS(name, suspend_fn, resume_fn, idle_fn) \
+static const struct dev_pm_ops name = { \
+	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
+}
+
+/* Deprecated. Use DEFINE_SIMPLE_DEV_PM_OPS() instead. */
+#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
+const struct dev_pm_ops __maybe_unused name = { \
+	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+}
+
+/* Deprecated. Use DEFINE_UNIVERSAL_DEV_PM_OPS() instead. */
 #define UNIVERSAL_DEV_PM_OPS(name, suspend_fn, resume_fn, idle_fn) \
 const struct dev_pm_ops __maybe_unused name = { \
 	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
@@ -375,6 +400,7 @@ const struct dev_pm_ops __maybe_unused name = { \
 }
 
 #define pm_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM), (_ptr))
+#define pm_sleep_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM_SLEEP), (_ptr))
 
 /*
  * PM_EVENT_ messages
-- 
2.51.0

