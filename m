Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6184E2E7F05;
	Tue, 15 Jul 2025 13:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587310; cv=none; b=auOzHGqv1zVyNl+Xq6o0qMsd+mR8ZJr2LWxqrPL1Ubmz8kHhTv9hZUMGZRM/8TU7BDlP1s9vxpIIkyr3tNSp/lSJcTl2UI8+veZGTqMLG5YFHAsl9wvUqKijZMn1htnfGdQ3RbT3gtqmbDXzSiWpv3nAPz/LG+fGKsK8OzPIoio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587310; c=relaxed/simple;
	bh=PSyYPcAsnAAwt+lNB3tFn0GEyW9NUVOI86VTIHLA8iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QH9GVw6c2kJLbAGAZDLCRstKBHLsON0nmkMZPgGujMNePOuOLUjWPMq/OR+y4EfQLY2JLdqv1mAvluBqhK/K3iXM69tRz3nxDTsxsSQ8ZJLy5HF4b6p/YkW4mPVB7nNlCKgMuKKam07ZmiFMntVEvwgn1LqLXnFo4qgnBA/irXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVy0rn+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVy0rn+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E319BC4CEF1;
	Tue, 15 Jul 2025 13:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587310;
	bh=PSyYPcAsnAAwt+lNB3tFn0GEyW9NUVOI86VTIHLA8iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVy0rn+N/6WcTyXEHxFZEUqPxRGupFusgx0Lzafbn2QvAfQP68cc3qji/l/g2eb7J
	 k+AdlHRldP/g0VvsutgJa3wCJDjWlFAodXAkhfYOdeIIal7BG6N9mSYV4QKrFV6xrG
	 7A75ZVvZJEOpebiJWXCpgkVXbI4J4v1gJj5sMHlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Kurt Borja <kuurtb@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 53/88] platform/x86: think-lmi: Fix sysfs group cleanup
Date: Tue, 15 Jul 2025 15:14:29 +0200
Message-ID: <20250715130756.686654974@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 4f30f946f27b7f044cf8f3f1f353dee1dcd3517a ]

Many error paths in tlmi_sysfs_init() lead to sysfs groups being removed
when they were not even created.

Fix this by letting the kobject core manage these groups through their
kobj_type's defult_groups.

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Cc: stable@vger.kernel.org
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250630-lmi-fix-v3-3-ce4f81c9c481@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_common.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 26d00b1853b42..02787682b395e 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -21,6 +21,7 @@
 #include <linux/intel_rapl.h>
 #include <linux/processor.h>
 #include <linux/platform_device.h>
+#include <linux/string_helpers.h>
 
 #include <asm/iosf_mbi.h>
 #include <asm/cpu_device_id.h>
@@ -227,17 +228,34 @@ static int find_nr_power_limit(struct rapl_domain *rd)
 static int set_domain_enable(struct powercap_zone *power_zone, bool mode)
 {
 	struct rapl_domain *rd = power_zone_to_rapl_domain(power_zone);
+	u64 val;
+	int ret;
 
 	if (rd->state & DOMAIN_STATE_BIOS_LOCKED)
 		return -EACCES;
 
 	cpus_read_lock();
-	rapl_write_data_raw(rd, PL1_ENABLE, mode);
+	ret = rapl_write_data_raw(rd, PL1_ENABLE, mode);
+	if (ret)
+		goto end;
+
+	ret = rapl_read_data_raw(rd, PL1_ENABLE, true, &val);
+	if (ret)
+		goto end;
+
+	if (mode != val) {
+		pr_debug("%s cannot be %s\n", power_zone->name,
+			 str_enabled_disabled(mode));
+		goto end;
+	}
+
 	if (rapl_defaults->set_floor_freq)
 		rapl_defaults->set_floor_freq(rd, mode);
+
+end:
 	cpus_read_unlock();
 
-	return 0;
+	return ret;
 }
 
 static int get_domain_enable(struct powercap_zone *power_zone, bool *mode)
-- 
2.39.5



