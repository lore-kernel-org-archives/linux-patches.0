Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D927253944;
	Tue, 11 Nov 2025 01:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822875; cv=none; b=GsLvQCQC4P8LiACqTJMC46n4lvVMkfeexQ2hCSJvwpov6bzqZnXFxxhQ45Fd6lyCSYQ11feL9LILsHvgPvc5gWUQvD8RSvIxyUi5dFKvLhm3m2XH0QARmwCP0mfhEXSa2JZVJ31SYt04DHIrzMsOp9Qo5jGdI4+iyWAyG/je3aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822875; c=relaxed/simple;
	bh=jxyglao/2SBai+lpHkCtTi21ZbgOBnyVTvaDtuVISI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBHGqXj88ZoBf/MNvWdRbq2dQRRvHgObmGtq8nBRwkCdPxOguIEoApyFnaZU9hck5fjoQt0BP38TKquhr8v0/z1XWRUqxmWbXzhZVgipcMx0xpLQBhYuCbB1A2M0Po8GGQB+geQpWDE1L1YSEgvcsoJx1jpAf5dC5YHV2ojekWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7+Y/S5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7+Y/S5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B85C19421;
	Tue, 11 Nov 2025 01:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822875;
	bh=jxyglao/2SBai+lpHkCtTi21ZbgOBnyVTvaDtuVISI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7+Y/S5F0qt2XVUOCvnTe9Gkz5cr18KzJzAaZSHzJeqyMWkBf1qj9L2PK4C/e1/pJ
	 1Zrd2kxhh8XCmWa0Z4lIzZGazjMDZ4E7xH69ofdQZ4RuhMN5cwY51b1L1ev/jfBlDH
	 zOTmFmNf1bfujw0cKcyae0ipPA/Tjuh74U7TSGgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sohil Mehta <sohil.mehta@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/565] cpufreq: ondemand: Update the efficient idle check for Intel extended Families
Date: Tue, 11 Nov 2025 09:39:41 +0900
Message-ID: <20251111004529.765523954@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



