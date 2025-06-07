Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7135715D1;
	Sat,  7 Jun 2025 10:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291071; cv=none; b=tmv65guYKFAvO3yaEJouSfgE1LhOxp/NkIdllOfJVdWeohTMcsGcjB9j3I6CrQ6Axyc5IWDYDVadCRbvsE+7hYpOIt7+K9k7SbTT6lgv/XINXS2YqZLfwDz4IWLsNwnhTaJrsHUbKE9ZWoxw2Eh44HgoFP++nL40lGH9cwgApVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291071; c=relaxed/simple;
	bh=ccGnUiECjgvmvy0cUJn+rVtPo+n33cpCmdnKoCrw5gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKct1OXPYrtRn0VOK8/AHLiryymvXBIaCfcofXdTBXr3GrMqwMWSIw+5DIDkOZeJKctpeMBT2q4uBbCA+FJkQyXaTyeOA+5lp/1f+EMBnpwOfnqL7h4+4n7KuDwuHBJxjoOINe12vp1Goraz6caN4Q7GPQQqhpEJtQUdwv+VZOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZEzLas0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZEzLas0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC809C4CEE4;
	Sat,  7 Jun 2025 10:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291071;
	bh=ccGnUiECjgvmvy0cUJn+rVtPo+n33cpCmdnKoCrw5gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZEzLas0ugH6RNWNmFAg8+LEFh2j+okPKMqOd8DL34nYgZ4f++aL1wex1wdRIgPlE
	 GcbH1dO5Tw+7zOrcskguQNz+Jqgj+1XHe7s4vhk8aIqpGAlGyQJTxlSohPOzBLF48Z
	 Vo8S0PZW5+PbhEtq86uNQAQAiR+ELg1Zg8W7+Pl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manu Bretelle <chantr4@gmail.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.15 09/34] acpi-cpufreq: Fix nominal_freq units to KHz in get_max_boost_ratio()
Date: Sat,  7 Jun 2025 12:07:50 +0200
Message-ID: <20250607100720.089471114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
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
@@ -660,7 +660,7 @@ static u64 get_max_boost_ratio(unsigned
 	nominal_perf = perf_caps.nominal_perf;
 
 	if (nominal_freq)
-		*nominal_freq = perf_caps.nominal_freq;
+		*nominal_freq = perf_caps.nominal_freq * 1000;
 
 	if (!highest_perf || !nominal_perf) {
 		pr_debug("CPU%d: highest or nominal performance missing\n", cpu);


