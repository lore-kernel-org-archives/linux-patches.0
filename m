Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE97126982C;
	Sat, 12 Sep 2026 08:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201010; cv=none; b=GsIkiGnRcFlHauD2vZKtozl42pnL12kHEBnJBrYt1tLDFerubDLnfpjr+sBdRwqc55gENbCMwNTIIJsKlsvhGJobJD7DiZsoLUXRTkPewZTmfHoNuTLwFOmmmnJiM9nKu83+Qpxj7K9B5ZooHZxay2W/2WmaEttL/GXolyzHOpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201010; c=relaxed/simple;
	bh=0djJz+9uhmCxAj6VHeR9TiuX6Z86Bc7dFjB6lDKIM58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNPj4xngd+JpD+y99kV7pmwhDI9yMFHF0yuBmBPZD+vAqZbqyn8y/JjuAUgsATxM5OTwQbbRZfv60nfHwakkGvGF4/88gIWrQX59RCLkq/LJGMXwGhxtxFf9uN86syeEd70JWmZL2vcSJZ+qLPmYn8rQxqtJ/MTRbiJkWa/Ipxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJVSsOD/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJVSsOD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4D21F000FF;
	Sat, 12 Sep 2026 08:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201009;
	bh=4IvXwnabWJr9y2Ac+aSDT1HHNNg2LAxPJ3J3OXSLlco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJVSsOD/hvNKz4smgfwAeyEWDu53a6tlVY8r5/C0vVtrlEdPh0TL/ZM46gfkzMm7L
	 xvKDn6Lvfy3oF7L+yQWAbYmIRD7e1VUl2oGm6HIW+S79QNPFrqDy0eOrBDOpuniwNG
	 BwVhr2nHuDoNRlWDpSpKJKLiynSUGtkuPUWDE088=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0906/1815] ACPI: processor: Unregister cpufreq notifier on init failure
Date: Sat, 12 Sep 2026 08:44:16 +0200
Message-ID: <20260912065710.192487462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index cda8fd7200004..cdc2ae1632b21 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -285,6 +285,12 @@ static int __init acpi_processor_driver_init(void)
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



