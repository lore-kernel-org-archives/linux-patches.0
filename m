Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2380C17C9E9;
	Tue, 16 Jul 2024 15:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145162; cv=none; b=nMUqEzpU0TGCoVaJGVNbDCNBNXGkUw64acxF22VDOwV/RYuXrVP6PJTnBEUhIiMgUlpMh8N6/Nqc4xGzuhwb5A2X2uEqjiI7tQMbecvVYmaWpTGxUF84E/0Ff5i9rmLvfAfEH7+R6129uEW7AXEDsBpDOzYkK+I2O6VVyZCcBKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145162; c=relaxed/simple;
	bh=/IY7ZHL+os4wN3edEl8EFA36dKaz3RB9HV3FgczjU7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmaQ0N3hALaeGIz1Hn9TGlsFvYA5pS5qliCao8Bp1FzbY+lA0XSt0ce2eUd4g5hu5rhCnh6Cpf4MfGWwllH3wfAb6aGtsMhkpbKJPZH9WcXbv/TrXcJ/rVjIEMYJd/6S6s2glAV1brb/TgaiE58nAD4HgdObz3z8yAymYx7kr0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQz2Bh03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQz2Bh03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBC3C116B1;
	Tue, 16 Jul 2024 15:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145162;
	bh=/IY7ZHL+os4wN3edEl8EFA36dKaz3RB9HV3FgczjU7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQz2Bh03W+9Wg+WS70zi0eUEJqWjgHGGv8hdzoFeI1IrGvcCGQ4Xv8sQlugiAjzAe
	 aqDzlVbTpD13U71y4GHtmkC6HC2qdnPjvz/r/zDBSXmqDUTTgqI4MoNe/7mZRrCXKm
	 vI2Yp8NxPWiaSUERbwoUBvPQc6akZhkkiFrGiawc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Dhruva Gole <d-gole@ti.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.9 119/143] cpufreq: Allow drivers to advertise boost enabled
Date: Tue, 16 Jul 2024 17:31:55 +0200
Message-ID: <20240716152800.558972878@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 102fa9c4b439ca3bd93d13fb53f5b7592d96a109 upstream.

The behavior introduced in commit f37a4d6b4a2c ("cpufreq: Fix per-policy
boost behavior on SoCs using cpufreq_boost_set_sw()") sets up the boost
policy incorrectly when boost has been enabled by the platform firmware
initially even if a driver sets the policy up.

This is because policy_has_boost_freq() assumes that there is a frequency
table set up by the driver and that the boost frequencies are advertised
in that table. This assumption doesn't work for acpi-cpufreq or
amd-pstate. Only use this check to enable boost if it's not already
enabled instead of also disabling it if alreayd enabled.

Fixes: f37a4d6b4a2c ("cpufreq: Fix per-policy boost behavior on SoCs using cpufreq_boost_set_sw()")
Link: https://patch.msgid.link/20240626204723.6237-1-mario.limonciello@amd.com
Reviewed-by: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
Suggested-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1431,7 +1431,8 @@ static int cpufreq_online(unsigned int c
 		}
 
 		/* Let the per-policy boost flag mirror the cpufreq_driver boost during init */
-		policy->boost_enabled = cpufreq_boost_enabled() && policy_has_boost_freq(policy);
+		if (cpufreq_boost_enabled() && policy_has_boost_freq(policy))
+			policy->boost_enabled = true;
 
 		/*
 		 * The initialization has succeeded and the policy is online.


