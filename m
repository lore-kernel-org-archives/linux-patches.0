Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7C8221FD4;
	Sat, 12 Sep 2026 15:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226459; cv=none; b=GgHFV9/VFPh1yo+h2c9njiFS6sf7wkddsgj17lv/U8CYadLkuTZ7E/GYY3coEBQktHmU/H9/i21+399h0QKERWX2VDlWXMEPjgUTqMm+z24E9qT6sqKGiDiYlImAOLzSOh5Av56G57PphZmVlrBR00C2LSKeYnJ56+xpqfWuLm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226459; c=relaxed/simple;
	bh=Wd///tImVOOCsIipqZESFzzLWNbvfSDlS7cJDztpi9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lM+GM1OcxUIdquoBLQuq8Xq+fo4cjs7RKesan+h7AXM6hY/CPnlPpizUQEEbeE10atS4WID8CNVE652bBm9tfQ/1KjlBI5a45hV6NQTNCzpegp778rBzrqKQoTziGz5WxATnkGTrI0BK9gm3OhtzCqzsixczMvEKKPUvhLxu6Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zStzlXgs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zStzlXgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4E51F000FF;
	Sat, 12 Sep 2026 15:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226457;
	bh=MSIgwuEjKnvNZ3mW1jS6tsSWspS39RT/qbtPYOMt9SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zStzlXgspK4MExpZSwU/yJTTord4E0fAPg/fTN5AqyNATaFd7M7S44e3Wf5ga1Ocp
	 ir3kQJ8FsGb6AMJnuQoeQscPM6qVgHTNKo08ywBFdzPNEmNUfT2zVS+zU6eKwJbGe/
	 ct7De805yuH9ikszHzgGQJcSZs4fpKaj3befQkxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1404/1424] ACPI: processor: Add cpuidle driver check in acpi_processor_register_idle_driver()
Date: Sat, 12 Sep 2026 09:03:56 +0200
Message-ID: <20260912065638.701542983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index af7e1f0262fa6..d755c266e3586 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1379,6 +1379,15 @@ void acpi_processor_register_idle_driver(void)
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



