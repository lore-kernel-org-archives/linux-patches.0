Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE68256C84;
	Tue, 21 Jul 2026 15:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649346; cv=none; b=JGn/8rccj0vQb4rhUOh/J2w1q/D7pWbqDG97E76M7JXNDrAp9gTgnfKaAvdUGWWuYWT7Y85Y3ctY7VihGz1AbxNRMRRkmrqg2ZvK/0BmiB7oZYM30hOtdCYpDfWrix8Q/N0KrNkdLQ34xK/3qkzAG0i7bGQmauHGZq0mOALsF+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649346; c=relaxed/simple;
	bh=4EewT398jBIUDLNDtz5Jm3EpGTDgaMisyDpCpITQLk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCGlHdtWQU6Zab02HhN2/sDWtNkVIhpNyJD2LcbAdNE1TTTvlHGpC+hX5ZkZ9YhnaBLYeTT39NjIy9/degoQZNDmHbhh7ZQ02fkHKa6H+H8goPDiTOcFGnJhMoeHApPYXvHNvVf6OeYPLQvAVk6U25WomC322pogjlgRoZY/ZVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1lNsJnR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1lNsJnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627A61F00A3A;
	Tue, 21 Jul 2026 15:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649344;
	bh=9+3LUv44tkntEFb1h7MfLrRZq7xzFK2OInnAGVnKqGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1lNsJnRfYXzXx7rN+JFFlic/5Dn0uZYeU6+H8/EGjFYnYx/hyYTgi9/awDFoi4fc
	 2ochDx3JUyGsQPGcU30IgMMu4bYJyShUNCXkgEinRmh/8flncUkFfELPeW23F4JST3
	 hv7HyObKjPlaPcB6IZCAs8D5VtEOZX45328T9q7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0541/2077] ACPI: processor: Add cpuidle driver check in acpi_processor_register_idle_driver()
Date: Tue, 21 Jul 2026 17:03:34 +0200
Message-ID: <20260721152605.570455129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index ee5facccbe10c5..390ab5f1d31378 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1355,6 +1355,15 @@ void acpi_processor_register_idle_driver(void)
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



