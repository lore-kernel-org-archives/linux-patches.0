Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5C6399352;
	Sat, 12 Sep 2026 10:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209169; cv=none; b=GmgIE8D87nCU6nSt62MksyuWxQIEGL68Nu329VdolCPF7N6wQ3xmSO/PVnoeOB6yIe0UQqcdRFfslA1aHlTTbbkxMHLI1tw0AXtUKqnPzHj4o3Jpo28vEztgTqgNrjrn5+q7/BL0WE2YIH7TMCDwZCbX8Ft9cJQPhvv/2MbiBqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209169; c=relaxed/simple;
	bh=EnsWr1IPURR9vLYbSOtL74/TpJe+dvlHFT8NuK9nZDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbFtdPFH03YZZp1mx7hON0MaJexE8fAmoM8ii8ULXgiTtGMZjkmJj1HUeRDBoscFcEudoBBelmi8PB8o3O90B6GB6h3J768TvmBgvIfiCocK8eBQOJQnM9j/EI6Vt7PwrZ+6vtPZvqZJEcqj4rxzrlzidZRfkdP9cnm4MywpaL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoKF1F25; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoKF1F25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750C41F000FF;
	Sat, 12 Sep 2026 10:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209167;
	bh=DOg7bbwbUhM6r3CgGlLT/qKD3QSW8Hf8qhB9v/Eqlsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AoKF1F25xsZdkh84uOKiGFPOTtqNgyygJHRBQUhtd+fX1i55ONnc9H6Wl9mcGRWe+
	 DGOyLwY+x6E0kVopHz5hQj/QO+j9beuVzLINZcOUFdCIS8G8JpEYBYVfi8OZ3yaHsw
	 H0LvyokXfxR20qrUt1tePOQiT5zQ/KZwidNIwfkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0765/1518] ACPI: processor: Unregister cpufreq notifier on init failure
Date: Sat, 12 Sep 2026 08:48:54 +0200
Message-ID: <20260912065640.738782963@linuxfoundation.org>
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
index 311863e00ffd5..06589bf488f74 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -292,6 +292,12 @@ static int __init acpi_processor_driver_init(void)
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



