Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB903FADF1;
	Mon, 17 Aug 2026 15:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978811; cv=none; b=dBklMTeYA5x0MuCdlVKUPbFXDuaj3XNH0beyvBbm4pkppMD5ELxSi/W08HXk3TNf244RyRNa36qpged4Es9AVQylQTmgkRyOPdFVQsVmO/UCsLFlgbgClNqhdIVAmUOqi1xaHwJ4j2Pi2zcGHJM6+8P4UbQ5CDQM76QndFGCh0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978811; c=relaxed/simple;
	bh=rWn4jitGP/pkrVftMqi2h0gMiq/1dEvCag9fFDEhBV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SSTcjrs+CyJQ2S99WLhajbyadwwtSHBzals6LE8XUUZJu2yKUu4B7uGhTB9N5S3Jv/kkf4ETuUiyq5fXq8F3aGCwwStVayouwdMavQcMBJihAcTG/skkj/G4T6vKbR3aBMNLHwOM3OkLhHhrFveJ7CQJa8MAPZTO8kx8vP1UW9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiOkiqgN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiOkiqgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7EA1F000E9;
	Mon, 17 Aug 2026 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978809;
	bh=rlXH/UcRpJ2H+bthloE+Wm3+ov/Rc5yATbm4IagN+C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UiOkiqgN9RhVJHToAWtcTtZA48FM7TnoqgHVH6Wg/ehDpk2rDNdsvKeF+XnxjK1W+
	 cu52myraAGSBEhY41KWSRgJzebogs7Ng0LludB9+Od93gRAoxT3xtJMt1VkN8euyFl
	 tsA2WOz1UtQYYevZL0iRIBHEvmknoL8Y4QECF4lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/609] platform/x86/intel-uncore-freq: Fix current_freq_khz after CPU hotplug
Date: Mon, 17 Aug 2026 15:24:57 +0200
Message-ID: <20260817132543.116404464@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixiong Wei <weiguixiong@bytedance.com>

commit 6b63520ed14b17bbe9c2103debbd2152dde1fba3 upstream.

When the last CPU of a legacy uncore die goes offline,
uncore_freq_remove_die_entry() clears control_cpu. During CPU hotplug
re-add, uncore_freq_add_entry() still populates sysfs attributes before
assigning the new control CPU. As a result, the current frequency read
returns -ENXIO and current_freq_khz is omitted from the recreated sysfs
group.

Assign control_cpu before the initial read paths and before
create_attr_group() so sysfs recreation uses the new online CPU. If
sysfs creation fails, restore control_cpu to -1 to keep the error path
state consistent.

Fixes: 4d73c6772ab7 ("platform/x86: intel-uncore-freq: Conditionally create attribute for read frequency")
Cc: stable@vger.kernel.org
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260602020752.3126-1-weiguixiong@bytedance.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[weiguixiong: Adapt to legacy uncore_read() and create_attr_group() flow.]
Signed-off-by: Guixiong Wei <weiguixiong@bytedance.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/uncore-frequency/uncore-frequency-common.c  | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
index dd2e654daf4b17..88316ceb4c6c4d 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
@@ -197,13 +197,18 @@ int uncore_freq_add_entry(struct uncore_data *data, int cpu)
 
 	sprintf(data->name, "package_%02d_die_%02d", data->package_id, data->die_id);
 
+	/*
+	 * Set the control CPU before any read path so entry recreation after CPU
+	 * hotplug can populate read-only attributes from the new online CPU.
+	 */
+	data->control_cpu = cpu;
 	uncore_read(data, &data->initial_min_freq_khz, &data->initial_max_freq_khz);
 
 	ret = create_attr_group(data, data->name);
-	if (!ret) {
-		data->control_cpu = cpu;
+	if (ret)
+		data->control_cpu = -1;
+	else
 		data->valid = true;
-	}
 
 uncore_unlock:
 	mutex_unlock(&uncore_lock);
-- 
2.53.0



