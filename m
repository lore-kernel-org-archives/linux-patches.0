Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1271A43D502;
	Tue, 21 Jul 2026 22:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671972; cv=none; b=q4JtJj2C2aVdyt98XusAM0LmcL0JS6VU/hK4GjX+iizCyT5THHEIt+fL2S5uiYCS8eI4i6/8ITCA/S/YKJARrwLel9Pl4rWpWjYWvoQF4dB8RIBCjeSeo+inPv1+OpqAJ3D7eRyIqbMm5b7+9H3vF1feGDsNF4aostkqVtpR9s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671972; c=relaxed/simple;
	bh=WVjLtwNmJ9Bk3IEQimVbfstfQ68GgxUKi1l44HxwZ+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfD4ZpJHKvLeaqEFW9s+f5dsZkPa89qFSvRcRIx5W7NU/HFbsCVTs5X/wrgqcJWB9yffmyCSgKmqEt2+kdgKe+8Q36bIKMKvHhDQN/3tSF7vOlky3ATp52hJVLfNkG52TxglDLmSzJe9dIDislH1Iro5Kb2FrDxqR4Is+B8hY1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnO/qJwp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnO/qJwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DC61F000E9;
	Tue, 21 Jul 2026 22:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671970;
	bh=n39GMNMCOxpQn4G6QcBjJSDyR/V/XWMu+d2h/dsGMe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnO/qJwpzpbJRebLnGNU6COmdTgzyHYf9cXAh8TMiAlaf2huFRdqhBkF0CUCrxkz7
	 Jc9h1UXOSZ+7BixuEelYgRkzA2HXeErceong7F6Y4yqNajIyqrl3IqDHiGniWgAdXd
	 Wxxhz+cNchlM6r+J5+1EMKzaZ1w/M2kXdVw8Jpqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 446/843] thermal: intel: Fix dangling resources on thermal_throttle_online() failure
Date: Tue, 21 Jul 2026 17:21:21 +0200
Message-ID: <20260721152416.062078819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dab7e8fb105985..3f90b12e1caa98 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -467,8 +467,13 @@ static int thermal_throttle_online(unsigned int cpu)
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
 
@@ -479,7 +484,7 @@ static int thermal_throttle_online(unsigned int cpu)
 	l = apic_read(APIC_LVTTHMR);
 	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
 
-	return thermal_throttle_add_dev(dev, cpu);
+	return err;
 }
 
 static int thermal_throttle_offline(unsigned int cpu)
-- 
2.53.0



