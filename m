Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C406472F6C;
	Sat, 12 Sep 2026 11:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212878; cv=none; b=YAbIxVHPjpzVER8DCT1eoFOYetwA4pczQZwJUDSsNWr9Olzb/nZMXe+Uk34V1iNFH7FcTFkIaKyehpFjqBRWAdcDgrYYY5nc0sBE2eI+B4MAGaYJ1J3On2JDuQFM3uOo+vBStcG+z1r/qMtE2ylcQrZJ8DKidEvAJ/7cxNlSbBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212878; c=relaxed/simple;
	bh=xbaRQFFf8CG+9qYWI5A6iSBl/Krh/wZb9CP56XD4jFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSv0ZA3MD6w5jbdX6rscfuPh9VodJ10Ywv2sTehI6zIiBOkmoevEDPGomPJWhaHouh0ttpVkYtNqKNEiFibgFA2elA/BgeQ+YQb81rvGonhKt7EiB1XZzN8xZdPnHsl43i5WrTbbj0fr1j8CVAvwASSDFCJ7Xqc3o06TEMVBIvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmRnUu6p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmRnUu6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358D91F00898;
	Sat, 12 Sep 2026 11:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212876;
	bh=nLOcsrrepT1h5P/Zh4b3rzJ+VAC/GZXMPWBGAruKSnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmRnUu6pD3fGBkI0JPuqllYZ3lrCDdDC2GBeMS7zgnSvEiH9jpudrYXN5969XNVYz
	 xLyIrkY9ioSDBtHY0cCqHguvhmuzvqxg9slV4gKFslWRYCXjOVQe+m2tGG2/1XDtCw
	 orLKUupNX2M52MMqhU3iSxyR/8IDrCdC4fK+NNu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1514/1518] ACPI: processor: Add cpuidle driver check in acpi_processor_register_idle_driver()
Date: Sat, 12 Sep 2026 09:01:23 +0200
Message-ID: <20260912065657.815330561@linuxfoundation.org>
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

From: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>

[ Upstream commit 66c62e6773c54ce5233eb21c6d48999c3747bd13 ]

Commit 7a8c994cbb2d ("ACPI: processor: idle: Optimize ACPI idle
driver registration") moved the ACPI idle driver registration to
acpi_processor_driver_init(), but it didn't check whether a cpuidle
driver was already registered.

For example, on Intel platforms, if the intel_idle driver is already
loaded, the code would still evaluate the _CST object in the ACPI
table and attempt to register the acpi_idle driver. This registration
would fail with -EBUSY due to the existing check in cpuidle_register_driver.

Add a check at the beginning of acpi_processor_register_idle_driver()
to avoid unnecessary _CST evaluate and potential registration failures.

Fixes: 7a8c994cbb2d ("ACPI: processor: idle: Optimize ACPI idle driver registration")
Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Link: https://patch.msgid.link/20260608190359.3254-1-TonyWWang-oc@zhaoxin.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index ce07505a8de69..5c6f736ba3b52 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1371,6 +1371,15 @@ void acpi_processor_register_idle_driver(void)
 	int ret = -ENODEV;
 	int cpu;
 
+	/*
+	 * If a cpuidle driver is already registered, there is no need to
+	 * evaluate _CST or attempt to register the ACPI idle driver.
+	 */
+	if (cpuidle_get_driver()) {
+		pr_debug("cpuidle driver %pS already registered.\n", cpuidle_get_driver());
+		return;
+	}
+
 	acpi_processor_update_max_cstate();
 
 	/*
-- 
2.53.0



