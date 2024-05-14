Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9D21D54D;
	Tue, 14 May 2024 11:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685145; cv=none; b=LAF/nPYoBPCnvU0STNdDnjcGK4tQjazwj8mbXmJ0okdRy8yRsx931PMUWgId3V7j0h8v1lQxEEceVQKSTQg+ynwJB7UReKWsGOdgHGNI+C8vJ6dr6O01jlCR1qtl+/W4riiFDsKANio3cjPGizDpPfV0DWj6WL/Jd7QuMtKZZEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685145; c=relaxed/simple;
	bh=y8umImRYyETy0H8PXuq/f8r8IS7NGApUF4DTfJ5+N0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpJ2zfOP/gIhfOJM98iJf8OjWlyTXSISZQSCZ0nkpbxTUmLXMRc7/bdveEB/A560Y6cvREpD3ueIbPPIa5GHuisqigti8ZE3QNqkMXUDnJ4UvIdDqT4pgy+g2RWWCIlT2d2kRiieqj4pA650KaMIbK4Rs/E53nJ9jzOjpHspAw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUxnbE3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUxnbE3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3581CC2BD10;
	Tue, 14 May 2024 11:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685145;
	bh=y8umImRYyETy0H8PXuq/f8r8IS7NGApUF4DTfJ5+N0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUxnbE3hwgGIpUM+Wc1U/HZg8QKaKUErJm47aMlQPgHRyASlcjvn3RXY74shXSCms
	 xxydYDWrALhwE7NmrHYg0hMN6fttwGb8UbeLp0hXIYS2B5grbqeKvU430jxqOXIKJa
	 vxT4PQ0hht6z4O2Dw5Idi1PxHCI/JHFMzaJdF/dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Ernst <justin.ernst@hpe.com>,
	Thomas Renninger <trenn@suse.de>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/301] tools/power/turbostat: Fix uncore frequency file string
Date: Tue, 14 May 2024 12:16:55 +0200
Message-ID: <20240514101037.690121429@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0561362301c53..ffa964ddbacef 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1969,7 +1969,7 @@ unsigned long long get_uncore_mhz(int package, int die)
 {
 	char path[128];
 
-	sprintf(path, "/sys/devices/system/cpu/intel_uncore_frequency/package_0%d_die_0%d/current_freq_khz", package,
+	sprintf(path, "/sys/devices/system/cpu/intel_uncore_frequency/package_%02d_die_%02d/current_freq_khz", package,
 		die);
 
 	return (snapshot_sysfs_counter(path) / 1000);
-- 
2.43.0



