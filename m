Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F288624E4A1;
	Tue, 11 Nov 2025 01:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822880; cv=none; b=M+XL32dxykpLKYjrEMsoCCox1C20BW8bG2QRkitPulRQoIud2MH9expdqJlsoc+TwMNgWBQBq8mfaCC3EyWx8MWIv4fZcIFkTn1kq8k/JtuhCUhHg3uqTVT8S2hTRRpJM3JQWN3DawKumMb+P+GA/WS1sOFJbZ1ne5JHwsViftE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822880; c=relaxed/simple;
	bh=1NExgAhkHNtToTwcM3y1G+BC16TCFthYhGJDMhrmvlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4VyoQ2be8809YcXAkcwDkiXYmD9727tidw4zG7dg5hvwMzUUxrMcng/ztgJqQM/VEA37+TV3Z4mkmxeBFKj9xisYCEl7zQ3fgiNBeIXrgEvv5T0tCxIZ6sOCdjR9p1af4i19+pKUpxTPio2DrL+Jx8mxCXwvELF/Xk30zw6SnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gwxe7RBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gwxe7RBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF12C19424;
	Tue, 11 Nov 2025 01:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822879;
	bh=1NExgAhkHNtToTwcM3y1G+BC16TCFthYhGJDMhrmvlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gwxe7RBT2Rht0l/e683aHwynHeItEzUrhYfVD7ViTxAN67fe6kfgB+GCIIhXfCTkr
	 zRPdvSHkEbkf+1nSyLL4UHqnC766NBrGSPBT+JVQLoUb8MpY//C5I+iyJcRz1onVfM
	 MiLQIwtoErnvV9yqa4QnHwST8dRz9nvUf/aszLKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sohil Mehta <sohil.mehta@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 166/849] cpufreq: ondemand: Update the efficient idle check for Intel extended Families
Date: Tue, 11 Nov 2025 09:35:36 +0900
Message-ID: <20251111004540.448436896@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sohil Mehta <sohil.mehta@intel.com>

[ Upstream commit 7f3cfb7943d27a7b61bdac8db739cf0bdc28e87d ]

IO time is considered busy by default for modern Intel processors. The
current check covers recent Family 6 models but excludes the brand new
Families 18 and 19.

According to Arjan van de Ven, the model check was mainly due to a lack
of testing on systems before INTEL_CORE2_MEROM. He suggests considering
all Intel processors as having an efficient idle.

Extend the IO busy classification to all Intel processors starting with
Family 6, including Family 15 (Pentium 4s) and upcoming Families 18/19.

Use an x86 VFM check and move the function to the header file to avoid
using arch-specific #ifdefs in the C file.

Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
Link: https://patch.msgid.link/20250908230655.2562440-1-sohil.mehta@intel.com
[ rjw: Added empty line after #include ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq_ondemand.c | 25 +------------------------
 drivers/cpufreq/cpufreq_ondemand.h | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 0e65d37c92311..a6ecc203f7b7f 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -29,29 +29,6 @@ static struct od_ops od_ops;
 
 static unsigned int default_powersave_bias;
 
-/*
- * Not all CPUs want IO time to be accounted as busy; this depends on how
- * efficient idling at a higher frequency/voltage is.
- * Pavel Machek says this is not so for various generations of AMD and old
- * Intel systems.
- * Mike Chan (android.com) claims this is also not true for ARM.
- * Because of this, whitelist specific known (series) of CPUs by default, and
- * leave all others up to the user.
- */
-static int should_io_be_busy(void)
-{
-#if defined(CONFIG_X86)
-	/*
-	 * For Intel, Core 2 (model 15) and later have an efficient idle.
-	 */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
-			boot_cpu_data.x86 == 6 &&
-			boot_cpu_data.x86_model >= 15)
-		return 1;
-#endif
-	return 0;
-}
-
 /*
  * Find right freq to be set now with powersave_bias on.
  * Returns the freq_hi to be used right now and will set freq_hi_delay_us,
@@ -377,7 +354,7 @@ static int od_init(struct dbs_data *dbs_data)
 	dbs_data->sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR;
 	dbs_data->ignore_nice_load = 0;
 	tuners->powersave_bias = default_powersave_bias;
-	dbs_data->io_is_busy = should_io_be_busy();
+	dbs_data->io_is_busy = od_should_io_be_busy();
 
 	dbs_data->tuners = tuners;
 	return 0;
diff --git a/drivers/cpufreq/cpufreq_ondemand.h b/drivers/cpufreq/cpufreq_ondemand.h
index 1af8e5c4b86fd..2ca8f1aaf2e34 100644
--- a/drivers/cpufreq/cpufreq_ondemand.h
+++ b/drivers/cpufreq/cpufreq_ondemand.h
@@ -24,3 +24,26 @@ static inline struct od_policy_dbs_info *to_dbs_info(struct policy_dbs_info *pol
 struct od_dbs_tuners {
 	unsigned int powersave_bias;
 };
+
+#ifdef CONFIG_X86
+#include <asm/cpu_device_id.h>
+
+/*
+ * Not all CPUs want IO time to be accounted as busy; this depends on
+ * how efficient idling at a higher frequency/voltage is.
+ *
+ * Pavel Machek says this is not so for various generations of AMD and
+ * old Intel systems. Mike Chan (android.com) claims this is also not
+ * true for ARM.
+ *
+ * Because of this, select a known series of Intel CPUs (Family 6 and
+ * later) by default, and leave all others up to the user.
+ */
+static inline bool od_should_io_be_busy(void)
+{
+	return (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+		boot_cpu_data.x86_vfm >= INTEL_PENTIUM_PRO);
+}
+#else
+static inline bool od_should_io_be_busy(void) { return false; }
+#endif
-- 
2.51.0



