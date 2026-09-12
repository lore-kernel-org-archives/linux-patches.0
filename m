Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE962E7622;
	Sat, 12 Sep 2026 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224384; cv=none; b=qLBhA4cE6hBBPCMGZZ2tad935qyn0YDRwzIMCqL37Xsx5+5tsKUcMxWrlXFKQDU20qv9ZqmgGxvdaJwetgSfiFhCZhSddWj0kaBielDa+W8IXJqC5RRWSaMLaB0mcsqjh6mxyFH3UHSWC79Cy/Vpu54yGPZaVwmJt+eyuFgNBRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224384; c=relaxed/simple;
	bh=Eiv6xg+lerLt6CZzvPbxfx0d+lCiplHsqmlWy9CRQNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUsFNhNJ/glfr2MWKbHiXzgsqVcdugbFjMOtcqn9WF5TY3gxsAK260//PKl3YNoQbtnl47E2n1WZXljqzGkrK4KPndWkQUkkM+DutXwntTnttBlZk/aej2MlPwo3fR+MY1eh3FMXIqGoLoSCcQpik7IyYxV7tHHnuaQXyOyyuew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgbJN4wo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgbJN4wo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A901F000FF;
	Sat, 12 Sep 2026 14:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224382;
	bh=eLYcLvh4n5/HDRCX3OQRDqrUgUk7sPm8X3WSNolfinY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JgbJN4worRf1IgyUSmwVmNfaBUq/Vsx9hQNfE2wWZSenAhK7HEb2sdhjTU4JQcPB5
	 QPn+AjFbIZ68z8zwogOL4pXIbXp20elw6Hp/JFWqfHFR31bbLOyIfDQQen67SqR190
	 MJPQgTRalSQO6ix6fapYdCYFZ4cj9qWJJ/lL3p6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0981/1424] ACPI: processor: Unregister cpufreq notifier on init failure
Date: Sat, 12 Sep 2026 08:56:53 +0200
Message-ID: <20260912065629.283691063@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit 06f32dd67e6b23a05bef0d8183c5335af91c0c3b ]

acpi_processor_driver_init() registers the cpufreq policy notifier before
registering the ACPI processor driver and setting up CPU hotplug state.

If driver_register() or cpuhp_setup_state() fails, the error path only
unregisters the ACPI processor driver and the idle driver. The cpufreq
notifier remains registered even though initialization failed.

Mirror the module exit path on the init failure path and unregister the
cpufreq notifier when it has been registered.

Fixes: c0e0421a60bf ("ACPI: processor: Reorder acpi_processor_driver_init()")
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Link: https://patch.msgid.link/20260729023605.197367-1-pengcan@kylinos.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_driver.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index ccf8d93c314b7..c076e1d5a228e 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -293,6 +293,12 @@ static int __init acpi_processor_driver_init(void)
 unregister_idle_drv:
 	acpi_processor_unregister_idle_driver();
 
+	if (acpi_processor_cpufreq_init) {
+		cpufreq_unregister_notifier(&acpi_processor_notifier_block,
+					    CPUFREQ_POLICY_NOTIFIER);
+		acpi_processor_cpufreq_init = false;
+	}
+
 	return result;
 }
 
-- 
2.53.0



