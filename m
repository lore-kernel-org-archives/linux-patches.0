Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317E23B4EAC;
	Tue, 21 Jul 2026 18:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657596; cv=none; b=AI4JKehHEBFEq9etFryAazb53ybdSLinyYJ0NB+eakYXgjKxgOoxmN3XshDhqonNg53KK/CaZmVqIjy+t6jlEzWObLkSOVVoUuWhRol7U5XYEdqYWM3nYkRPYY5w79IoFQ8KpuL7H77CWU94oKnHIv0Rya++f/x7W8u/fxVDOVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657596; c=relaxed/simple;
	bh=lMqnPykhK0l3yTm6QZxwRHIYFwaCPgO5DxlJoxZbH3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRXhTH/3yI8gStOLWakhrdH3h9yfGoTsO1YoWvfqViKeSGRQIxfg/g/TORBdsnUOPtWDcSdhrYBSlz+RC3fnXlXMdc4TLgwI0/W1vPd7Zjj6ZpAolobQjZtImnBuQ6saH//Jb+OaWNIx8MYxnmLEERNPwRLr2AvbZXlI8on0cT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7Pwa0vL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7Pwa0vL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932EA1F00A3A;
	Tue, 21 Jul 2026 18:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657595;
	bh=CugEgsHPQGKbcCaZTwXA1ePESvkkGO7Cm7KBPZ8vzy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x7Pwa0vLliAqsBcVgGbmEp34GoJA00wcJaeR5/198VraGZnV1hi0x/aXy+17Ve3qh
	 Ogh2SZIiSNZXHecBxGOEBERebLvhIV6czoQvbMmWgOsX0fE2aNJuvB212rJLi12RtC
	 yE+VZsq9lr4YFAEHYldaUPbRcAMO7cElpiP6Et30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0823/1611] thermal: intel: Fix dangling resources on thermal_throttle_online() failure
Date: Tue, 21 Jul 2026 17:15:39 +0200
Message-ID: <20260721152533.901740725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index debc94e2dc1697..7c21483c46b91a 100644
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



