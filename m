Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4DA4C7F;
	Mon, 23 Jun 2025 13:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685128; cv=none; b=MXlgSpku5ZVnqxcXWF6ta9CoH31qI+5aPWH119nVIGbcdIfutTN+CFHwev+hv9XG5Rb3dnzO3a58qFNtlro+2/6vS9C6rPhdUwOQ3SmQHJadaTU0h5HWu64OXukujwL+DN1FSgFaSpm4GK9Gw8Wigi4uIWUbbuJmmpbZbAN6Ifw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685128; c=relaxed/simple;
	bh=FRRJtSvkQHaUP5QuF081791/MVFwsRweFKgm0gliD58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGGad+HGkpcRqKYmmubaVS+gwfhARVkQMwDxANbVMRH0WuWdqJnoaTOb4HU4rpOGG9gTqvfWnRiWK9dvyPYzY4wuUYLsgOU/wXJGec1sPzvqQUn5uO8RG4wmcX8eLkgoNovPpKVD8rnEQdfLbIJpBej0F/C5IXb69VY77Og1+4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLO4AFEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLO4AFEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6BAC4CEEA;
	Mon, 23 Jun 2025 13:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685128;
	bh=FRRJtSvkQHaUP5QuF081791/MVFwsRweFKgm0gliD58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLO4AFEu1cqGDjKQ8T9n7m0UAwXFPU+6iEZQxkg9ZMzDsSOqd5fP6vH6KRfGZEOpH
	 LibnJgdwK/IjQ2W0OwhwSB/J3dsucBllI+0ER/osYMEPWi+ck1At8rzuTkFdxow15S
	 4cJVJM+hXEznq79VsIOIaTyYR0lMDe5c/jqV1ZoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manu Bretelle <chantr4@gmail.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 004/411] acpi-cpufreq: Fix nominal_freq units to KHz in get_max_boost_ratio()
Date: Mon, 23 Jun 2025 15:02:28 +0200
Message-ID: <20250623130633.123430081@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -661,7 +661,7 @@ static u64 get_max_boost_ratio(unsigned
 	nominal_perf = perf_caps.nominal_perf;
 
 	if (nominal_freq)
-		*nominal_freq = perf_caps.nominal_freq;
+		*nominal_freq = perf_caps.nominal_freq * 1000;
 
 	if (!highest_perf || !nominal_perf) {
 		pr_debug("CPU%d: highest or nominal performance missing\n", cpu);


