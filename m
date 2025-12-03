Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A3830EF9E;
	Wed,  3 Dec 2025 15:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776022; cv=none; b=W3ACZwv0bUCliJAYQhJorr1vmK/ecRC/5sqcAMNT+IB061zfG8aQZMr+5hYvnaJuCKADI0XUKYesGyB4AkgWM7SI2ayPY0ODvN3Mr+fmPHjrEMQipoCpiFt47dbRGuLJb1rzziDWl4o7Xk88teQ12syUIzeVBtEBAN0lm4/C7wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776022; c=relaxed/simple;
	bh=D5TZ6Wy5OCwoERLL3Pa+GCKsgWabZNGNH5USnqVLGqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaglxeIx6a8hpbdkyG/314RlxNQRk/CfDXFmxQ4VtwBkluVcTEcMf0da7ALN1dNlde+zls+I2mfWDxif6sAnZQrWlrvBaw7ZIeIOqdvciv/pEZBi/LB2k3TG3Wa0lHnfa4mG5lex0z6vtbDbHxSCeZ1d/NDim4DyRo4dl8U05R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdgGe0Zg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdgGe0Zg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA41DC4CEF5;
	Wed,  3 Dec 2025 15:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776022;
	bh=D5TZ6Wy5OCwoERLL3Pa+GCKsgWabZNGNH5USnqVLGqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdgGe0ZgyCn5kWnhIoVoMhAjyy+kLYFFezZMAkdsnkFf8mUowllCeesCEyAlDszyg
	 gRxF1jSTdSQFI72zM+42L6k+JYTB8YBtL/NuiaEu1DHXCmksdz5plytOnuWrkAQut7
	 KuzMiEZ4sGT/c5J2y/mlFfyBnpYEYUmQT8SVh6mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/300] cpuidle: Fail cpuidle device registration if there is one already
Date: Wed,  3 Dec 2025 16:24:20 +0100
Message-ID: <20251203152402.697809966@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 7b1b7961170e4fcad488755e5ffaaaf9bd527e8f ]

Refuse to register a cpuidle device if the given CPU has a cpuidle
device already and print a message regarding it.

Without this, an attempt to register a new cpuidle device without
unregistering the existing one leads to the removal of the existing
cpuidle device without removing its sysfs interface.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 83af15f77f66f..1c1fa6ac9244a 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -576,8 +576,14 @@ static void __cpuidle_device_init(struct cpuidle_device *dev)
 static int __cpuidle_register_device(struct cpuidle_device *dev)
 {
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
+	unsigned int cpu = dev->cpu;
 	int i, ret;
 
+	if (per_cpu(cpuidle_devices, cpu)) {
+		pr_info("CPU%d: cpuidle device already registered\n", cpu);
+		return -EEXIST;
+	}
+
 	if (!try_module_get(drv->owner))
 		return -EINVAL;
 
@@ -589,7 +595,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
 			dev->states_usage[i].disable |= CPUIDLE_STATE_DISABLED_BY_USER;
 	}
 
-	per_cpu(cpuidle_devices, dev->cpu) = dev;
+	per_cpu(cpuidle_devices, cpu) = dev;
 	list_add(&dev->device_list, &cpuidle_detected_devices);
 
 	ret = cpuidle_coupled_register_device(dev);
-- 
2.51.0



