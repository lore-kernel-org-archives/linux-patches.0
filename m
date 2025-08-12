Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D8B217F35;
	Tue, 12 Aug 2025 19:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026764; cv=none; b=BXuBAk/F5itkl1FSVY1FGKfGBxTiB7uFkGyjDtaoxu1I9mbcHCMjIFkLpA/2sr5CEeCjmNd2yReOJXjWNPU/AyG00XS0oTYionF3Ys8Q+KN2MgroANN4P+xf8WoUjPVm8gGuOywyxEDNDqvaUUU0iMCOHFo+mK0au7yHhL9aigs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026764; c=relaxed/simple;
	bh=c3lVdYii2fjaXnc5XsB0KBiAlJ3g8fmA2sprTAdPWA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hER6HVtD61V1+bAgrnZsW8MQb9rimi9vVftf3eWccso36vySnauOgsba+B0+XsX+T1dbfzplqSNlDdpYqqithCzLtVTgs/vHXStmKYw2ww00XRk/L787KL0PTclLqh20OZznoxjZxc9A57f/RM4NX0CyA0pcD1mnDHkZ4JBl7K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbd4+NEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbd4+NEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DB8C4CEF0;
	Tue, 12 Aug 2025 19:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026764;
	bh=c3lVdYii2fjaXnc5XsB0KBiAlJ3g8fmA2sprTAdPWA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbd4+NEg9eexYomupA3aUQloEWu97r97tiSqfQ90ovwFR/O8BFFzXlMDwmVBmuOYS
	 FQFVf6p65sHngbFu51+hQETcY4mspaAxH/LgXnVXm2ceykkMSJ4RNlNaXXm4Jw8y4B
	 FbjV1gy2829aATj4rRkwpCHzLMiKvC+ENlgYTc98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 432/480] tools/power turbostat: Fix bogus SysWatt for forked program
Date: Tue, 12 Aug 2025 19:50:40 +0200
Message-ID: <20250812174415.217628196@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 44207567fa64e995d4f2ec2d45af4c947cb1a465 ]

Similar to delta_cpu(), delta_platform() is called in turbostat main
loop. This ensures accurate SysWatt readings in periodic monitoring mode
$ sudo turbostat -S -q --show power -i 1
CoreTmp	PkgTmp	PkgWatt	CorWatt	GFXWatt	RAMWatt	PKG_%	RAM_%	SysWatt
60	61	6.21	1.13	0.16	0.00	0.00	0.00	13.07
58	61	6.00	1.07	0.18	0.00	0.00	0.00	12.75
58	61	5.74	1.05	0.17	0.00	0.00	0.00	12.22
58	60	6.27	1.11	0.24	0.00	0.00	0.00	13.55

However, delta_platform() is missing for forked program and causes bogus
SysWatt reporting,
$ sudo turbostat -S -q --show power sleep 1
1.004736 sec
CoreTmp	PkgTmp	PkgWatt	CorWatt	GFXWatt	RAMWatt	PKG_%	RAM_%	SysWatt
57	58	6.05	1.02	0.16	0.00	0.00	0.00	0.03

Add missing delta_platform() for forked program.

Fixes: e5f687b89bc2 ("tools/power turbostat: Add RAPL psys as a built-in counter")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 7a407694d221..444b6bfb4683 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -9593,6 +9593,7 @@ int fork_it(char **argv)
 	timersub(&tv_odd, &tv_even, &tv_delta);
 	if (for_all_cpus_2(delta_cpu, ODD_COUNTERS, EVEN_COUNTERS))
 		fprintf(outf, "%s: Counter reset detected\n", progname);
+	delta_platform(&platform_counters_odd, &platform_counters_even);
 
 	compute_average(EVEN_COUNTERS);
 	format_all_counters(EVEN_COUNTERS);
-- 
2.39.5



