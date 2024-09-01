Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649B62C190;
	Sun,  1 Sep 2024 17:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210437; cv=none; b=XxWLglcNTqhdCn3TX2AAPYtNDA9ji87mCDOeiySZ0Rf35yKMmrQe08JZrhBwZsLmPBcG1BOG883RA3qbZXs46GkNMlRiFPu8rbig6Ihlaa/2BsPdulh9nLLX4UJWWJk2XDS20xiRC4NWltcF2MJwQE5diGqm3XyNnhSrz6TIK2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210437; c=relaxed/simple;
	bh=GJYNYBiDI/eiZmOh/GlpOF/JdljFvkiQDgQgjGjPtU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzWLl4HYd5h8xOACzPEEmD7iRvk7V83otbJPE792scP4QLOyDlXp2WNbLb3XPiNeux/KlCQo0/GxaM7TCeMMR8GL0HaahX1+Rw+P10lvTGWW6RvV5cda5Dht+mko13wFg4rKi7VOrzgPPppWMW4si3OO+QCrKpXC1pG++/ABsWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IOhS+ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IOhS+ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C397EC4CEC3;
	Sun,  1 Sep 2024 17:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210437;
	bh=GJYNYBiDI/eiZmOh/GlpOF/JdljFvkiQDgQgjGjPtU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IOhS+ub6ieVA/1A/W6q2EmxZH0LdEytBgJtQKrbxWaqFSHcuQg/FlyOtxuj6+9xV
	 oT0DCZYER0o1Cg7k+6QDb8KGpCZ+cRCqFjLH0ur7eyw1cE9lvGlwu0cAG4LsrCuHdX
	 FLXaQjeMhPpXNe9xHxj6aGb2HZwY+sZq+wClJigM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/215] PM: core: Remove DEFINE_UNIVERSAL_DEV_PM_OPS() macro
Date: Sun,  1 Sep 2024 18:18:21 +0200
Message-ID: <20240901160830.501957530@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 3f4b32511a77bc5a05cfbf26fec94c4e1b1cf46a ]

The deprecated UNIVERSAL_DEV_PM_OPS() macro uses the provided callbacks
for both runtime PM and system sleep, which is very likely to be a
mistake, as a system sleep can be triggered while a given device is
already PM-suspended, which would cause the suspend callback to be
called twice.

The amount of users of UNIVERSAL_DEV_PM_OPS() is also tiny (16
occurences) compared to the number of places where
SET_SYSTEM_SLEEP_PM_OPS() is used with pm_runtime_force_suspend() and
pm_runtime_force_resume(), which makes me think that none of these cases
are actually valid.

As the new macro DEFINE_UNIVERSAL_DEV_PM_OPS() which was introduced to
replace UNIVERSAL_DEV_PM_OPS() is currently unused, remove it before
someone starts to use it in yet another invalid case.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 5af9b304bc60 ("phy: xilinx: phy-zynqmp: Fix SGMII linkup failure on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm.h | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index d1c19f5b1380f..452c1ed902b75 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -366,6 +366,12 @@ const struct dev_pm_ops name = { \
 	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
 }
 
+/* Deprecated. Use DEFINE_SIMPLE_DEV_PM_OPS() instead. */
+#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
+const struct dev_pm_ops __maybe_unused name = { \
+	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+}
+
 /*
  * Use this for defining a set of PM operations to be used in all situations
  * (system suspend, hibernation or runtime PM).
@@ -378,20 +384,9 @@ const struct dev_pm_ops name = { \
  * suspend and "early" resume callback pointers, .suspend_late() and
  * .resume_early(), to the same routines as .runtime_suspend() and
  * .runtime_resume(), respectively (and analogously for hibernation).
+ *
+ * Deprecated. You most likely don't want this macro.
  */
-#define DEFINE_UNIVERSAL_DEV_PM_OPS(name, suspend_fn, resume_fn, idle_fn) \
-static const struct dev_pm_ops name = { \
-	SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
-	RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
-}
-
-/* Deprecated. Use DEFINE_SIMPLE_DEV_PM_OPS() instead. */
-#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
-const struct dev_pm_ops __maybe_unused name = { \
-	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
-}
-
-/* Deprecated. Use DEFINE_UNIVERSAL_DEV_PM_OPS() instead. */
 #define UNIVERSAL_DEV_PM_OPS(name, suspend_fn, resume_fn, idle_fn) \
 const struct dev_pm_ops __maybe_unused name = { \
 	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
-- 
2.43.0



