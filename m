Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C297242C514;
	Sat, 12 Sep 2026 12:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216869; cv=none; b=ip0XzfzWdbj3zVtV2mUoVnu2C9XBBLimyyYAEhdDU6S3oEHIEVGupHbUDhd/iv3J6UoYe3S7mJiYslImSfDK+CSSgjX4ng7DqYwE48LTB+ZGHJWKgxdeY17AV7+qEdtpxUonbkbTsAxEBtRuaItOv0fVt3IkywIrZaf15rbXkYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216869; c=relaxed/simple;
	bh=esx/bQdjMj0s5NYw1IVdJgsGikWfOAN5+5lEUdBUC14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igWS6zMCP8PhmfD2pIceqL8plf17Qvfd5qjVLajQeIpd4Y5ryiiNk2qO5vLldPpKSlg1R7Vu9eayXI/NZZm1zVGwt+PkPSAdC9/JRJnbROa5ObAVMNlA7a2hKLJ13YAkR8HeDQ8giTewx2tt0hKgp8YiNoauan24ozg/VyHSIQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1z70jbTD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1z70jbTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30231F000FF;
	Sat, 12 Sep 2026 12:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216867;
	bh=3qw9Xj/T+csntyh/JvAXgn067GD0mCUyDZZj1iTucPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1z70jbTDFmQNm4Xh7NTLrUj/MYIo1dgazW1mBpGG73cZcgycsqzjCGk+BvcgUT9DE
	 rHhA+m5qqxWAJuzTIYhDbK0kSk5s1Zu3IkhNRbjeGXqXzNcSuWFeBu1LPSpvfJN3MY
	 ETnOb4cvsfC6xUZhRXVC3qQquKSQtHD13IA8MZMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0823/1376] ACPI: processor: Unregister cpufreq notifier on init failure
Date: Sat, 12 Sep 2026 08:54:09 +0200
Message-ID: <20260912065625.890049641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 93970583157df..d6d9c57dd555f 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -289,6 +289,12 @@ static int __init acpi_processor_driver_init(void)
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



