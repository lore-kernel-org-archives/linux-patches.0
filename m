Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF2438E8AB;
	Tue, 21 Jul 2026 19:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662812; cv=none; b=QNCapZtvCJj5oWc79I5539HPhtuH1MrVZA0joP17fmzFbUelfH+t0wwnX/fPSCa3kxTkBqFOyWkqZa2gfTbYyLEZPtq4xgBlGS3k+F/ZVMaVx9we5MoiHyJb2l+wc5A2RjF404RiGaPaC+r7PhYeka9pM2MbgcITCrTllP3A+UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662812; c=relaxed/simple;
	bh=mTpmShDwdKC+VNUDAhFRZ/rYMqtuxYvk1TCVLao0UQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkNdP63EQy0+9fZz9x/6g5D+i7Ry6VIUqwM02Iqhbh2EOC9hKKY7GfEoNSTSSlBrsO5nKxXFhmkDsHREPzANdoBa2FOM895rw1pn1Pwm7MoDnUZhvmkauY7eRBCFvPkwfaqBD5Jr42FLfGRHZKzxo6/If31CejL0Jzdbm/mTbYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4bopbhU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4bopbhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023711F000E9;
	Tue, 21 Jul 2026 19:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662811;
	bh=lXFwHpNuE/orpfk8o4oKpJ4LvkjuTHBv9rtUMkEKSVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4bopbhUmACLylts6rC5HGHUzgKvzVU5yZqOCMfnkiaM4g+ALA0aGjJgXT8V+OI+z
	 c9IL4zNZbfiED57Svp1MdnlyzVzw6mT0Wic4v3UZ1FOnepqmzDmW+b//MjRQiqcs2Z
	 I4EXbXT0Dkv4tomc+MkJRe+/x7WRY1s4p5xtj8Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0585/1276] thermal: intel: Fix dangling resources on thermal_throttle_online() failure
Date: Tue, 21 Jul 2026 17:17:08 +0200
Message-ID: <20260721152459.207861863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index e69868e868eb9e..dfdc8c1b0eb5d3 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -528,8 +528,13 @@ static int thermal_throttle_online(unsigned int cpu)
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
 
@@ -547,7 +552,7 @@ static int thermal_throttle_online(unsigned int cpu)
 	l = apic_read(APIC_LVTTHMR);
 	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
 
-	return thermal_throttle_add_dev(dev, cpu);
+	return err;
 }
 
 static int thermal_throttle_offline(unsigned int cpu)
-- 
2.53.0



