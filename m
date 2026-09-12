Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7D4381E98;
	Sat, 12 Sep 2026 09:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205517; cv=none; b=GDcjeDCIww1rf6pdh6i5MW7kolLYeXW240nsilPAufY0Lbn3kyO2btozBc+m+m/ytG8UWT5pp3Okx+aeAZXqJlsZC6L99PTBcrhsNUYMzpSFw1xfPmkaOU9Bh+V2NGMoxmc5yP6qK9ALnw+1PpXk2k2lmRcevVAuzII3D95aZ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205517; c=relaxed/simple;
	bh=FN073281GV8TwZ28RVhQZPZSlUvu5eOC3AaGueaGrhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKJjilSvBykrUuIPkEKQBMdBi3juXrsdwLUMaG4oZ5nD2l3Zzx4qP/eEWFFHsD3jP/ji4R76v84CnlopILRo4/QM8fxzUjvetn0tFoXrqYvj3nlqSkqtQLLgP6x46GNFf3z0bxjN10SVy2wZ8nkLJurMdiZxvsBnPuJS/nZUxxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3C5kIm6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3C5kIm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A471F000FF;
	Sat, 12 Sep 2026 09:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205516;
	bh=vnoeX2EnrGjXKMraPnc10fhld935WAc26w1K5CwqlPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b3C5kIm6GyC1tp6qyMVZxAwjo1E8e549GEh/TzB9h9GkDXCo+V9sibQxHxyhbESSo
	 Zey2+ElfQ7d9zM1WTbb0qLviGemdOuclaW6KRt5Y4Les+H6iGIeCdO0xoJmVoC9cwd
	 nYJmmUiXMOcaeKqStxLhzGemFTfMsDlUT1VDm7S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dhruva Gole <d-gole@ti.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0019/1518] PM: runtime: Wrapper macros for ACQUIRE()/ACQUIRE_ERR()
Date: Sat, 12 Sep 2026 08:36:28 +0200
Message-ID: <20260912065623.853576592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit ef8057b07c72a817537856b98d6e7493b9404eaf ]

Add wrapper macros for ACQUIRE()/ACQUIRE_ERR() and runtime PM
usage counter guards introduced recently: pm_runtime_active_try,
pm_runtime_active_auto_try, pm_runtime_active_try_enabled, and
pm_runtime_active_auto_try_enabled.

The new macros should be more straightforward to use.

For example, they can be used for rewriting a piece of code like below:

        ACQUIRE(pm_runtime_active_try, pm)(dev);
        if ((ret = ACQUIRE_ERR(pm_runtime_active_try, &pm)))
                return ret;

in the following way:

        PM_RUNTIME_ACQUIRE(dev, pm);
        if ((ret = PM_RUNTIME_ACQUIRE_ERR(&pm)))
                return ret;

If the original code does not care about the specific error code
returned when attepmting to resume the device:

        ACQUIRE(pm_runtime_active_try, pm)(dev);
        if (ACQUIRE_ERR(pm_runtime_active_try, &pm))
                return -ENXIO;

it may be changed like this:

        PM_RUNTIME_ACQUIRE(dev, pm);
        if (PM_RUNTIME_ACQUIRE_ERR(&pm))
                return -ENXIO;

Link: https://lore.kernel.org/linux-pm/5068916.31r3eYUQgx@rafael.j.wysocki/
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/3400866.aeNJFYEL58@rafael.j.wysocki
Stable-dep-of: d378fceaafd7 ("iio: light: apds9306: fix PM reference leak in apds9306_read_data()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pm_runtime.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -637,6 +637,30 @@ DEFINE_GUARD_COND(pm_runtime_active_auto
 DEFINE_GUARD_COND(pm_runtime_active_auto, _try_enabled,
 		  pm_runtime_resume_and_get(_T), _RET == 0)
 
+/* ACQUIRE() wrapper macros for the guards defined above. */
+
+#define PM_RUNTIME_ACQUIRE(_dev, _var)			\
+	ACQUIRE(pm_runtime_active_try, _var)(_dev)
+
+#define PM_RUNTIME_ACQUIRE_AUTOSUSPEND(_dev, _var)	\
+	ACQUIRE(pm_runtime_active_auto_try, _var)(_dev)
+
+#define PM_RUNTIME_ACQUIRE_IF_ENABLED(_dev, _var)	\
+	ACQUIRE(pm_runtime_active_try_enabled, _var)(_dev)
+
+#define PM_RUNTIME_ACQUIRE_IF_ENABLED_AUTOSUSPEND(_dev, _var)	\
+	ACQUIRE(pm_runtime_active_auto_try_enabled, _var)(_dev)
+
+/*
+ * ACQUIRE_ERR() wrapper macro for guard pm_runtime_active.
+ *
+ * Always check PM_RUNTIME_ACQUIRE_ERR() after using one of the
+ * PM_RUNTIME_ACQUIRE*() macros defined above (yes, it can be used with
+ * any of them) and if it is nonzero, avoid accessing the given device.
+ */
+#define PM_RUNTIME_ACQUIRE_ERR(_var_ptr)	\
+	ACQUIRE_ERR(pm_runtime_active, _var_ptr)
+
 /**
  * pm_runtime_put_sync - Drop device usage counter and run "idle check" if 0.
  * @dev: Target device.


