Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF89024BD00;
	Mon, 23 Jun 2025 13:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684854; cv=none; b=g5l47CNxhFIHDFFozyH8nA6UJGhJiS7U2nkZ5RGIT3a6nQo/yo2pXO+fRhotBPQlJPL4d8v1dPYFKOptlUrcKjLxGDnYoj5EFSKCe3oS1dZexk56C+Yf1n/OyK/7+t9I38f3Dr63BXxiitt8ZHl6moal+GhK/EaaseMa+aD0MnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684854; c=relaxed/simple;
	bh=wvTnu+Lz2a/rNAgYCazSz5QsSDpQeJ0WJTAdQ0InwO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCOzx+HMw+I3W/twRF7OG9ouDcPIYU2wkktA23cQ+Xc3MG/PIEsTi0IvUXxprfHDFV/dgdroK3FxByPUIId/Fa8J/JELWDAEA9/LpKh5g4RHhmX5280V9BZLVU3Apt4+noWIZK8AuFFoTToZyItMuinDZMZxfD+jCWNw0zsy4Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxJ15Wma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxJ15Wma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3ED8C4CEEA;
	Mon, 23 Jun 2025 13:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684854;
	bh=wvTnu+Lz2a/rNAgYCazSz5QsSDpQeJ0WJTAdQ0InwO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxJ15WmaDGHynfXh8Wd4ITxxZB9XKlPfFHPKrzBklkQN8Y9pdVHPkIrEywBXBYVTs
	 qxuekuerLGMy+owdue+05VSJPtuilc0FKHoXt+Mv8NjsYo0hdF3M8LUPBxz79ROqft
	 X/D+m14+61PPb0HiPvWNLvgwiObBiBXCIoa5o39I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manu Bretelle <chantr4@gmail.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 004/355] acpi-cpufreq: Fix nominal_freq units to KHz in get_max_boost_ratio()
Date: Mon, 23 Jun 2025 15:03:25 +0200
Message-ID: <20250623130626.857452749@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

commit cb6a85f38f456b086c366e346ebb67ffa70c7243 upstream.

commit 083466754596 ("cpufreq: ACPI: Fix max-frequency computation")
modified get_max_boost_ratio() to return the nominal_freq advertised
in the _CPC object. This was for the purposes of computing the maximum
frequency. The frequencies advertised in _CPC objects are in
MHz. However, cpufreq expects the frequency to be in KHz. Since the
nominal_freq returned by get_max_boost_ratio() was not in KHz but
instead in MHz,the cpuinfo_max_frequency that was computed using this
nominal_freq was incorrect and an invalid value which resulted in
cpufreq reporting the P0 frequency as the cpuinfo_max_freq.

Fix this by converting the nominal_freq to KHz before returning the
same from get_max_boost_ratio().

Reported-by: Manu Bretelle <chantr4@gmail.com>
Closes: https://lore.kernel.org/lkml/aDaB63tDvbdcV0cg@HQ-GR2X1W2P57/
Fixes: 083466754596 ("cpufreq: ACPI: Fix max-frequency computation")
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Cc: 6.14+ <stable@vger.kernel.org> # 6.14+
Link: https://patch.msgid.link/20250529085143.709-1-gautham.shenoy@amd.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/acpi-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -657,7 +657,7 @@ static u64 get_max_boost_ratio(unsigned
 	nominal_perf = perf_caps.nominal_perf;
 
 	if (nominal_freq)
-		*nominal_freq = perf_caps.nominal_freq;
+		*nominal_freq = perf_caps.nominal_freq * 1000;
 
 	if (!highest_perf || !nominal_perf) {
 		pr_debug("CPU%d: highest or nominal performance missing\n", cpu);


