Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17504139D13;
	Tue, 14 May 2024 10:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683040; cv=none; b=A8UGxDao28mtW6TDtLP9i6VPqZQKHdKnsCCKsYqs/n4l1SKElLE0uczcoEWEszzmi7XRd1niGqCeskzebrA7bVrtFbzAcfX74at6R0mT0FJlYNJLle45hgNkLn26+5Y04ri+Ta6AIm9M0vixFKvz78yGIkI1tjpMzq0UJ+bbnYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683040; c=relaxed/simple;
	bh=do4Oco3AKsU4zlY2HOEe2CtyXN/zteIc5j1brgQZv10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUp6e+0tbfdvs7lXGKC4CPfhx38w+nQcfwawLQD6KGvpCQFdpWQKKlj1G2X1kDwAmDkQKv2hFrqOV0jh5FrR61iNEYtubxp9vwOCGiG+hidhR6d/skouIiYYEVfnKJgqg+9lqnB9kOR/J9O7dvYhXXzb7inF2yXACij4g3B+v0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dqEWtaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dqEWtaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764CEC2BD10;
	Tue, 14 May 2024 10:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683040;
	bh=do4Oco3AKsU4zlY2HOEe2CtyXN/zteIc5j1brgQZv10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dqEWtaBkX/Z3zT/VYkd6DfyRC8W4GJ5mYhkTJIe0d49liwGAty340EiMouMU2boR
	 gK9iKS5ut8zOoRrqc1D9Jc5UFn2W9HU+GYTTL2lg4SUejO5gDj/z+TWLJFnuV+QdUk
	 4t0Dcvb5wGpp3krKYZkBi5TiV6ipNxAl2wTksUM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Ernst <justin.ernst@hpe.com>,
	Thomas Renninger <trenn@suse.de>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 156/336] tools/power/turbostat: Fix uncore frequency file string
Date: Tue, 14 May 2024 12:16:00 +0200
Message-ID: <20240514101044.493620379@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Ernst <justin.ernst@hpe.com>

[ Upstream commit 60add818ab2543b7e4f2bfeaacf2504743c1eb50 ]

Running turbostat on a 16 socket HPE Scale-up Compute 3200 (SapphireRapids) fails with:
turbostat: /sys/devices/system/cpu/intel_uncore_frequency/package_010_die_00/current_freq_khz: open failed: No such file or directory

We observe the sysfs uncore frequency directories named:
...
package_09_die_00/
package_10_die_00/
package_11_die_00/
...
package_15_die_00/

The culprit is an incorrect sprintf format string "package_0%d_die_0%d" used
with each instance of reading uncore frequency files. uncore-frequency-common.c
creates the sysfs directory with the format "package_%02d_die_%02d". Once the
package value reaches double digits, the formats diverge.

Change each instance of "package_0%d_die_0%d" to "package_%02d_die_%02d".

[lenb: deleted the probe part of this patch, as it was already fixed]

Signed-off-by: Justin Ernst <justin.ernst@hpe.com>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 3438ad938d7e4..53b764422e804 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2612,7 +2612,7 @@ unsigned long long get_uncore_mhz(int package, int die)
 {
 	char path[128];
 
-	sprintf(path, "/sys/devices/system/cpu/intel_uncore_frequency/package_0%d_die_0%d/current_freq_khz", package,
+	sprintf(path, "/sys/devices/system/cpu/intel_uncore_frequency/package_%02d_die_%02d/current_freq_khz", package,
 		die);
 
 	return (snapshot_sysfs_counter(path) / 1000);
-- 
2.43.0



