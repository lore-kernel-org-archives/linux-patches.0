Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583D23BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsHuTfAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0759CC433CA;
	Wed, 15 Nov 2023 19:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076105;
	bh=2JyNz8gFhaWixTbbMCLxdLAYf12LQzSUgyJ2noW2b5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsHuTfAeapbdOw8uU0ypn4Fwl1PPctbG5fWMxY7ksigvMSMAs5yotaUaDhCenyVLu
	 XyI0c7C4U9xUQxVJt1lwFVoK8nN/o1MTNIdsKmA9cUZ+cdLb+wvKyXwF41XU3DTXNx
	 yGyTd1eN01f7QTiDTLvVAbKn9GOHbdHaxjuaqNMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Paul Cercueil <paul@crapouillou.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 079/550] PM: sleep: Fix symbol export for _SIMPLE_ variants of _PM_OPS()
Date: Wed, 15 Nov 2023 14:11:03 -0500
Message-ID: <20231115191606.178508787@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit 8d74f1da776da9b0306630b13a3025214fa44618 ]

Currently EXPORT_*_SIMPLE_DEV_PM_OPS() use EXPORT_*_DEV_PM_OPS() set
of macros to export dev_pm_ops symbol, which export the symbol in case
CONFIG_PM=y but don't take CONFIG_PM_SLEEP into consideration.

Since _SIMPLE_ variants of _PM_OPS() do not include runtime PM handles
and are only used in case CONFIG_PM_SLEEP=y, we should not be exporting
dev_pm_ops symbol for them in case CONFIG_PM_SLEEP=n.

This can be fixed by having two distinct set of export macros for both
_RUNTIME_ and _SIMPLE_ variants of _PM_OPS(), such that the export of
dev_pm_ops symbol used in each variant depends on CONFIG_PM and
CONFIG_PM_SLEEP respectively.

Introduce _DEV_SLEEP_PM_OPS() set of export macros for _SIMPLE_ variants
of _PM_OPS(), which export dev_pm_ops symbol only in case CONFIG_PM_SLEEP=y
and discard it otherwise.

Fixes: 34e1ed189fab ("PM: Improve EXPORT_*_DEV_PM_OPS macros")
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm.h | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index badad7d11f4fd..d305412556f35 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -374,24 +374,39 @@ const struct dev_pm_ops name = { \
 	RUNTIME_PM_OPS(runtime_suspend_fn, runtime_resume_fn, idle_fn) \
 }
 
-#ifdef CONFIG_PM
-#define _EXPORT_DEV_PM_OPS(name, license, ns)				\
+#define _EXPORT_PM_OPS(name, license, ns)				\
 	const struct dev_pm_ops name;					\
 	__EXPORT_SYMBOL(name, license, ns);				\
 	const struct dev_pm_ops name
-#define EXPORT_PM_FN_GPL(name)		EXPORT_SYMBOL_GPL(name)
-#define EXPORT_PM_FN_NS_GPL(name, ns)	EXPORT_SYMBOL_NS_GPL(name, ns)
-#else
-#define _EXPORT_DEV_PM_OPS(name, license, ns)				\
+
+#define _DISCARD_PM_OPS(name, license, ns)				\
 	static __maybe_unused const struct dev_pm_ops __static_##name
+
+#ifdef CONFIG_PM
+#define _EXPORT_DEV_PM_OPS(name, license, ns)		_EXPORT_PM_OPS(name, license, ns)
+#define EXPORT_PM_FN_GPL(name)				EXPORT_SYMBOL_GPL(name)
+#define EXPORT_PM_FN_NS_GPL(name, ns)			EXPORT_SYMBOL_NS_GPL(name, ns)
+#else
+#define _EXPORT_DEV_PM_OPS(name, license, ns)		_DISCARD_PM_OPS(name, license, ns)
 #define EXPORT_PM_FN_GPL(name)
 #define EXPORT_PM_FN_NS_GPL(name, ns)
 #endif
 
-#define EXPORT_DEV_PM_OPS(name) _EXPORT_DEV_PM_OPS(name, "", "")
-#define EXPORT_GPL_DEV_PM_OPS(name) _EXPORT_DEV_PM_OPS(name, "GPL", "")
-#define EXPORT_NS_DEV_PM_OPS(name, ns) _EXPORT_DEV_PM_OPS(name, "", #ns)
-#define EXPORT_NS_GPL_DEV_PM_OPS(name, ns) _EXPORT_DEV_PM_OPS(name, "GPL", #ns)
+#ifdef CONFIG_PM_SLEEP
+#define _EXPORT_DEV_SLEEP_PM_OPS(name, license, ns)	_EXPORT_PM_OPS(name, license, ns)
+#else
+#define _EXPORT_DEV_SLEEP_PM_OPS(name, license, ns)	_DISCARD_PM_OPS(name, license, ns)
+#endif
+
+#define EXPORT_DEV_PM_OPS(name)				_EXPORT_DEV_PM_OPS(name, "", "")
+#define EXPORT_GPL_DEV_PM_OPS(name)			_EXPORT_DEV_PM_OPS(name, "GPL", "")
+#define EXPORT_NS_DEV_PM_OPS(name, ns)			_EXPORT_DEV_PM_OPS(name, "", #ns)
+#define EXPORT_NS_GPL_DEV_PM_OPS(name, ns)		_EXPORT_DEV_PM_OPS(name, "GPL", #ns)
+
+#define EXPORT_DEV_SLEEP_PM_OPS(name)			_EXPORT_DEV_SLEEP_PM_OPS(name, "", "")
+#define EXPORT_GPL_DEV_SLEEP_PM_OPS(name)		_EXPORT_DEV_SLEEP_PM_OPS(name, "GPL", "")
+#define EXPORT_NS_DEV_SLEEP_PM_OPS(name, ns)		_EXPORT_DEV_SLEEP_PM_OPS(name, "", #ns)
+#define EXPORT_NS_GPL_DEV_SLEEP_PM_OPS(name, ns)	_EXPORT_DEV_SLEEP_PM_OPS(name, "GPL", #ns)
 
 /*
  * Use this if you want to use the same suspend and resume callbacks for suspend
@@ -404,19 +419,19 @@ const struct dev_pm_ops name = { \
 	_DEFINE_DEV_PM_OPS(name, suspend_fn, resume_fn, NULL, NULL, NULL)
 
 #define EXPORT_SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
-	EXPORT_DEV_PM_OPS(name) = { \
+	EXPORT_DEV_SLEEP_PM_OPS(name) = { \
 		SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
 	}
 #define EXPORT_GPL_SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
-	EXPORT_GPL_DEV_PM_OPS(name) = { \
+	EXPORT_GPL_DEV_SLEEP_PM_OPS(name) = { \
 		SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
 	}
 #define EXPORT_NS_SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn, ns)	\
-	EXPORT_NS_DEV_PM_OPS(name, ns) = { \
+	EXPORT_NS_DEV_SLEEP_PM_OPS(name, ns) = { \
 		SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
 	}
 #define EXPORT_NS_GPL_SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn, ns)	\
-	EXPORT_NS_GPL_DEV_PM_OPS(name, ns) = { \
+	EXPORT_NS_GPL_DEV_SLEEP_PM_OPS(name, ns) = { \
 		SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
 	}
 
-- 
2.42.0



