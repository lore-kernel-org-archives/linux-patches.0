Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AE133ADB0;
	Tue, 21 Jul 2026 19:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660847; cv=none; b=YKVsiKcjS2c6cDWfW1Rlw5YnANcG0Mq1G0rhZTjBB/u7gAsSc6ztfkbz8qD7IYKdYnpaHBX9jPF4jZLp6S8Be5htSY+IMucnpxgKe0r0qrw0Eqg1N+pPALF3hRvlFUDRVqbUppIKWa26bFlfy6n9rKofnKh3ik4YLFdgIKAW7Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660847; c=relaxed/simple;
	bh=ym+esV8zYfVXpRxksbfYGFr8oWpeStGLN7nMzswEQj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0f52OUdcGQsYPr7DPfil7+PDwPwMT09nKTPxw3znA4iB+zMeNPKQ5Z8X4kblsGVvfrDOLD421R8sc36GBB43XFbFpyFkGaEnhkd6LiypTqCmYGDFcHwSFqqwNbfJc1927Yu3FjgGtUuffGMyszLenqtXYn7G32NUa4evUVO1E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLwJYcJx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLwJYcJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CA81F000E9;
	Tue, 21 Jul 2026 19:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660845;
	bh=91G4fqhP2gv/VeYumZCZtSCuHWdB8U6iMcDgyjePRwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wLwJYcJxmmXp9wDnzwVhdwqYNKI1YMPcBHTmB5iIJLHbqvMgKCl2FrjMbBzkMlClE
	 F93meTdSuNvpvPDf5Vm7VZgL72YQ2h5wiyZ+EfxcWhA74geo2L5dRAz+JFPYvmBIQ9
	 vyhe1up1AM1GrklnlV1NHcKN5SdaLOPDvRqPAouQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1133/2077] thermal: intel: Fix dangling resources on thermal_throttle_online() failure
Date: Tue, 21 Jul 2026 17:13:26 +0200
Message-ID: <20260721152619.543753630@linuxfoundation.org>
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

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit b91d287fa7a1ba0727eed5823c6ee4924ee5fa31 ]

The function thermal_throttle_add_dev() may fail and abort a CPU hotplug
online operation. Since the failure occurs within the online callback,
thermal_throttle_online(), the CPU hotplug framework does not invoke the
corresponding offline callback. As a result, the hardware and software
resources set up during the failed operation are not torn down.

Since only thermal_throttle_add_dev() can fail, call it before setting up
the rest of the resources.

Fixes: f6656208f04e ("x86/mce/therm_throt: Optimize notifications of thermal throttle")
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Link: https://patch.msgid.link/20260613-rneri-directed-therm-intr-v3-1-3a26d1e47fc8@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/therm_throt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index 44fa4dd15dd1c5..45a8ef4a608b14 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -529,8 +529,13 @@ static int thermal_throttle_online(unsigned int cpu)
 {
 	struct thermal_state *state = &per_cpu(thermal_state, cpu);
 	struct device *dev = get_cpu_device(cpu);
+	int err;
 	u32 l;
 
+	err = thermal_throttle_add_dev(dev, cpu);
+	if (err)
+		return err;
+
 	state->package_throttle.level = PACKAGE_LEVEL;
 	state->core_throttle.level = CORE_LEVEL;
 
@@ -548,7 +553,7 @@ static int thermal_throttle_online(unsigned int cpu)
 	l = apic_read(APIC_LVTTHMR);
 	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
 
-	return thermal_throttle_add_dev(dev, cpu);
+	return err;
 }
 
 static int thermal_throttle_offline(unsigned int cpu)
-- 
2.53.0



