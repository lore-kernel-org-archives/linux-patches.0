Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF698375AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301638; cv=none; b=go3A7GXtN3Hu6nfAUSBwtQtq0eoBEPr9JKehLfIqoFz9Hnw84CePimpBj2W5uMksESImyr2BvkOs0FsTBDzD8hA6jljx6CBjjbLVgmdIaUGnpxEWqVb1k7sm+CLKOz/eN1eQNQwtEPn/8yMjK7rG14AwGIvALiss0k6QHEiykyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301638; c=relaxed/simple;
	bh=2gWalRDBM9X5NnGcJ/p2Q+pNLIMpJfNpSmic/L6ncxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n38SSB1XpNdWiZeqiPyAQShwPrmaDkLPNx7mHyBFqBW5Z/1C/N1tQ/tn3B8CzNDguoyRuLoaxTBgT4vsabHwB0k+uBBH76qR6C+0RuYF+xcFYTk+VIVbq0zXTlbuM9Tn7WG8Vd7x4DDzWvtWcXmEZ9GO1RDWm4E06Ww/pmLlyRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YCgbE7Cb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YCgbE7Cb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E15DC19424;
	Sat, 28 Feb 2026 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301638;
	bh=2gWalRDBM9X5NnGcJ/p2Q+pNLIMpJfNpSmic/L6ncxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCgbE7CbbqbpLq7td9rDeYRtA7JgJhNvHmPbjLwO88w1o7pQj3rBRiT3A9oUCwrcT
	 be9mBSVinhBrZe4aIP5+xa97HElKTQH9q1jLOklIW3uc5enuZyuUlSpO/0CcK0GouX
	 qAYRxBHgZD3Eb8N+/FhnbhUBFmh74IGs6Ua4lRPi2KSpI4/MfV/eWiuEJiPQhBiuKX
	 0LeNgw7k1M3QuF52m01RAsfyLUyVgc37FzMmEmulX3M1Vc5x5Xhs4gSegtVSMNVNHP
	 6sNrdl8YfQv47UpB6YVC3Xwd3WraYgmqbTaplKFsMyrNNx8SxA0xHuZldgAz13UvU0
	 mvHXQ1X1vvcug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/385] thermal: intel: x86_pkg_temp_thermal: Handle invalid temperature
Date: Sat, 28 Feb 2026 12:54:14 -0500
Message-ID: <20260228180011.1568201-32-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 9635c586a559ba0e45b2bfbff79c937ddbaf1a62 ]

After commit be0a3600aa1e ("thermal: sysfs: Rework the handling of trip
point updates"), THERMAL_TEMP_INVALID can be passed to sys_set_trip_temp()
and it is treated as a regular temperature value there, so the sysfs
write fails even though it is expected to succeed and disable the given
trip point.

Address this by making sys_set_trip_temp() clear its temp variable when
it is equal to THERMAL_TEMP_INVALID.

Fixes: be0a3600aa1e ("thermal: sysfs: Rework the handling of trip point updates")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2815400.mvXUDI8C0e@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/x86_pkg_temp_thermal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c b/drivers/thermal/intel/x86_pkg_temp_thermal.c
index 8c44f378b61ef..29af9510a6161 100644
--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -127,6 +127,9 @@ sys_set_trip_temp(struct thermal_zone_device *tzd,
 	u32 l, h, mask, shift, intr;
 	int tj_max, val, ret;
 
+	if (temp == THERMAL_TEMP_INVALID)
+		temp = 0;
+
 	tj_max = intel_tcc_get_tjmax(zonedev->cpu);
 	if (tj_max < 0)
 		return tj_max;
-- 
2.51.0

