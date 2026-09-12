Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2986D35201F;
	Sat, 12 Sep 2026 11:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212829; cv=none; b=OHLOziAv4YFy/iXJ6dVT7QPR23hSSMTycVVbt3qAuk4MhEsPW7Mfidj16DnYPKMKBIQh6yX5POIO6ITq0oXHCBoe4vgKUViEpQvsjomeKUEcmQy1pooYoHY8ri0BIf2OqoKmnDqU2uEQaCj3r9PQpOqgmU0p2a30phidXUpIuWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212829; c=relaxed/simple;
	bh=s9ShMI9MNgywpW8zOWvUDIaMPYL1KP4TntWUvs07zFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKkxMKF+5m0WreO9wcVpKpgpabopKP61XFJ8hyihh1PN8U4Fc8JobXjH/VgHCGbepyrelTgkJRe52aBo3fFSexc0aLybzGSgYsxhJclSckYYhvc2dIr0jNrBGIDTVqRjwetNss538QDeqU7VH3HBv3mG9JhlvYhu3Mg8kLdo5JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNb+eNm7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNb+eNm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13CC1F000FF;
	Sat, 12 Sep 2026 11:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212828;
	bh=aTtEgCsYm0gaC6LAu1fBMCrqYrnsTA0hrUxV3UJbHaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNb+eNm7UYxIzES2OJBUm4LL63L32WV78pQ2SSQBHg92yK8+ccL6fselolrWcCFcX
	 ZynY1p8CVR5aRT+Px3GVf2NElXSIrn9fKqt/FYOiYDtqgQ3w/huidf3E0Ez+BlA+xj
	 gOnKT/AtMZ/gzMpe5kROuSrL0Q3UEYeGDB0kggdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1472/1518] cpufreq/amd-pstate: Grab "amd_pstate_driver_lock" when toggling dynamic_epp
Date: Sat, 12 Sep 2026 09:00:41 +0200
Message-ID: <20260912065656.854778489@linuxfoundation.org>
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

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit 9228169d2ae055ed09a163887fc59a710a5eb73b ]

Concurrently changing driver mode and dynamic_epp with:

    echo passive > /sys/devices/system/cpu/amd_pstate/status&
    echo disable > /sys/devices/system/cpu/amd_pstate/dynamic_epp&

hits the WARN_ON_ONCE() in static_key_disable_cpuslocked() and hangs the
system since both sysfs writes are trying to do
amd_pstate_change_driver_mode() without any synchronization.

Grab the "amd_pstate_driver_lock" mutex when modifying "dynamic_epp" to
prevent the two paths from racing with each other. Add a lockdep
assertion for "amd_pstate_driver_lock" in
amd_pstate_change_driver_mode() to formalize the dependency.

Since "cppc_mode" is stable under "amd_pstate_driver_lock", only reload
the driver when in "AMD_PSTATE_ACTIVE" mode and reject all writes when
in passive or guided mode, or if the driver is not loaded, since only
active mode operates on EPP.

Fixes: e30ca6dd5345 ("cpufreq/amd-pstate: Add dynamic energy performance preference")
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/r/20260508051748.10484-2-kprateek.nayak@amd.com
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 067f6aabf3222..eed7ed42c391c 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1576,6 +1576,8 @@ static int amd_pstate_change_driver_mode(int mode)
 {
 	int ret;
 
+	lockdep_assert_held(&amd_pstate_driver_lock);
+
 	ret = amd_pstate_unregister_driver(0);
 	if (ret)
 		return ret;
@@ -1691,6 +1693,13 @@ static ssize_t dynamic_epp_store(struct device *a, struct device_attribute *b,
 	if (ret)
 		return ret;
 
+	guard(mutex)(&amd_pstate_driver_lock);
+
+	if (cppc_state != AMD_PSTATE_ACTIVE) {
+		pr_debug("dynamic_epp can only be toggled in active mode\n");
+		return -EINVAL;
+	}
+
 	if (dynamic_epp == enabled)
 		return -EINVAL;
 
-- 
2.53.0



