Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979C22116E9;
	Wed,  7 May 2025 18:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644094; cv=none; b=FSVST7wEvEKnk/LL2BIDYy3liMu4QxbsaABkTUkCnxptTPRBdBVbo7yQJyHtNoBNC5OHqZ4D82fn9giG5hyIYYu+SudHn24O4U1WmGeF+6wS4IzTE+m+yuXvdEKZnKqxDXOlrEARs/kISEFehUIB21jB8lFDoHNFlnu6Roivg9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644094; c=relaxed/simple;
	bh=PH6pBjr0TQPeYJrcgY65N0i7wxaVff+AMO/SDKvQwN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQptc5IHCASEhB3WiQCha44G1MKhBylZBgmiT7CkXWOG2MnV5WcK/G1e7plhSUzFnVEIv+5xBkIfY2eFni49/w/Xmm1xAhRAIaJNX/KwPtnDNx8EgCv6x+km/6D/HnmD0rNjnsMvXlCQQeLR++PrlkCRYTYlEzaoEI6V+he1ExM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVFa8PKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVFa8PKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2DCC4CEE2;
	Wed,  7 May 2025 18:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644094;
	bh=PH6pBjr0TQPeYJrcgY65N0i7wxaVff+AMO/SDKvQwN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVFa8PKZ0YHJ9DA8wxnGyt3PwJzwoALpqNFqGBuh/D5D4WCWDuAsLE/FD017REtm7
	 95ekMK8fdtvn03COeSIEmmZnMefCjDRg2NpEmt0OqadGbG55xSdkHST4Hbaw3pDanT
	 PMYWPn+Tt2F1E5+PVTHfGgS/eLP+ezF0/NHmfDAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 078/183] cpufreq: acpi: Set policy->boost_supported
Date: Wed,  7 May 2025 20:38:43 +0200
Message-ID: <20250507183827.846596845@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit be6b8681a0e4c1477a2c1cb155f7b9188aa88acb ]

With a later commit, the cpufreq core will call the ->set_boost()
callback only if the policy supports boost frequency. The
boost_supported flag is set by the cpufreq core if policy->freq_table is
set and one or more boost frequencies are present.

For other drivers, the flag must be set explicitly.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: 3d59224947b0 ("cpufreq: ACPI: Re-sync CPU boost state on system resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/acpi-cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 463b69a2dff52..ae0766b5a076b 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -909,6 +909,9 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	if (perf->states[0].core_frequency * 1000 != freq_table[0].frequency)
 		pr_warn(FW_WARN "P-state 0 is not max freq\n");
 
+	if (acpi_cpufreq_driver.set_boost)
+		policy->boost_supported = true;
+
 	return result;
 
 err_unreg:
-- 
2.39.5



