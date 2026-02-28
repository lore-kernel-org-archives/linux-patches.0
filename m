Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A6735AC20
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302733; cv=none; b=tDHPwt8RoARE6+dFUKTNdfv3RN+/YkPooYKJiqfFmzvZZpmWPCVwEHX/VDyXwX5k6N9AERmyPY3ajR5UIHxUo+yCWYtq3ErJR1bDFKBZHHHrX7MQIaLcRRfY+h3wWAiMOmXE2edv/St9G62G4mDgaSjGDGIRlBhe9JqK4wN8VAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302733; c=relaxed/simple;
	bh=RA0ykfmJKkDQI1XUBOGQHD7deHFIvJ33jbcbbOWLtco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkge9bO6aANMav1CRMj3r/e207Puk93w/LByURm+L6yqySwDTQvSYvuh9PUNe/R1Lq6uqW5tAoeR01e9yyCVvk+UANIB2Ofs0X7deGB1ZfEYQz9nFsq8NTkiEeaC44nUy9HMFrbGXSMAROMpQ2LVmDV8cGd71Cox8eta7Pg4qLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LqJMw4hi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqJMw4hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD88FC19424;
	Sat, 28 Feb 2026 18:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302733;
	bh=RA0ykfmJKkDQI1XUBOGQHD7deHFIvJ33jbcbbOWLtco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqJMw4hihS/yiclx/q7N+bs/F+LTDqMCcMTBbXSWenl6tesLsJjhAVsJEKZNkiLW3
	 ZAPCBwXoMW2eDyFs2kM6gY8W7X8FfoYo8iWa+VaLkxVA20yZkfjj+LZB+QtsZ9mKTJ
	 mnXA5TSSzf5zyWuNVmm4INq6yLxx3KhzgHciYHuOvBGzGR+12p1pZWiaN+fspUFBLv
	 3MCH/YTltDoBsVQQ7CqcOv8JUIDurO51s2FxZ8MBjG821LPs85FopduQjqYpfG6gyf
	 iWybfZIv1aMAhPe4Tn1uWia/pYp1YTQOmmzDxksM+pEfrbWmePCLpO+LnsVKO2ZBne
	 ghu6JQXxgPeJw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Paul Cercueil <paul@crapouillou.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/147] PM: core: Redefine pm_ptr() macro
Date: Sat, 28 Feb 2026 13:16:44 -0500
Message-ID: <20260228181736.1605592-96-sashal@kernel.org>
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

[ Upstream commit c06ef740d401d0f4ab188882bf6f8d9cf0f75eaf ]

The pm_ptr() macro was previously conditionally defined, according to
the value of the CONFIG_PM option. This meant that the pointed structure
was either referenced (if CONFIG_PM was set), or never referenced (if
CONFIG_PM was not set), causing it to be detected as unused by the
compiler.

This worked fine, but required the __maybe_unused compiler attribute to
be used to every symbol pointed to by a pointer wrapped with pm_ptr().

We can do better. With this change, the pm_ptr() is now defined the
same, independently of the value of CONFIG_PM. It now uses the (?:)
ternary operator to conditionally resolve to its argument. Since the
condition is known at compile time, the compiler will then choose to
discard the unused symbols, which won't need to be tagged with
__maybe_unused anymore.

This pm_ptr() macro is usually used with pointers to dev_pm_ops
structures created with SIMPLE_DEV_PM_OPS() or similar macros. These do
use a __maybe_unused flag, which is now useless with this change, so it
later can be removed. However in the meantime it causes no harm, and all
the drivers still compile fine with the new pm_ptr() macro.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 0ba2035026d0 ("crypto: ccp - Add an S4 restore flow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 52d9724db9dc6..5ac2c9ba5baf7 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -374,11 +374,7 @@ const struct dev_pm_ops __maybe_unused name = { \
 	SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
 }
 
-#ifdef CONFIG_PM
-#define pm_ptr(_ptr) (_ptr)
-#else
-#define pm_ptr(_ptr) NULL
-#endif
+#define pm_ptr(_ptr) PTR_IF(IS_ENABLED(CONFIG_PM), (_ptr))
 
 /*
  * PM_EVENT_ messages
-- 
2.51.0

