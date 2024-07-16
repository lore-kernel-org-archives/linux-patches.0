Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCC019AD59;
	Tue, 16 Jul 2024 16:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145921; cv=none; b=iZBEODnUClZmgJapnUBza1xSY9A2ieGFSZm2MqYVAay/m3i56RejaqIMeiX49rfWh129Iljng1Wzqhrk0AWTyOJNUnVPVjrIvxbUPA/wm/SMs4de3pTLaxMOpXhigA+I44yY14fc626dsB76JwZ+37mUkXQVReHNtG0HK17IYV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145921; c=relaxed/simple;
	bh=w6uW7yhbpftbx4u8ufCYqxm1VJhbs0U6P6Jr2/4jCXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZncsPE3iwFk9GzYc62Rx7kALQCULglz+GUamL+JuBhtYnoTsXoXoiDbxiqBnylNNF9YmZKYBOWwznJIOPcZEmg7sk+pawalAgoHoyseUChAsTLPqCV9I3vDRZcrKJ6hSn+ZU32GDA4bEcWqm2fvYaCAPWAJg9rhYczyWABe1q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqeVB++b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqeVB++b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0CAC116B1;
	Tue, 16 Jul 2024 16:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145921;
	bh=w6uW7yhbpftbx4u8ufCYqxm1VJhbs0U6P6Jr2/4jCXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqeVB++bbpKFzRsq3e0d9mO+xf99XZmzOyMbaUkf8gqeaWAcUIQKrB40N5wijPKPp
	 IORZJoQgzpiNn/oqEpB4ixwCQ4OLtmPgqZz6H8QSu407gUk9WVqfBBQ7T/cOYdt2hZ
	 Ge59uTFF7XfPYoikGjW+L6Eqqv8HIesvrgg5v5O8=
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
Subject: [PATCH 6.6 092/121] cpufreq: Allow drivers to advertise boost enabled
Date: Tue, 16 Jul 2024 17:32:34 +0200
Message-ID: <20240716152754.868895232@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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
@@ -1422,7 +1422,8 @@ static int cpufreq_online(unsigned int c
 		}
 
 		/* Let the per-policy boost flag mirror the cpufreq_driver boost during init */
-		policy->boost_enabled = cpufreq_boost_enabled() && policy_has_boost_freq(policy);
+		if (cpufreq_boost_enabled() && policy_has_boost_freq(policy))
+			policy->boost_enabled = true;
 
 		/*
 		 * The initialization has succeeded and the policy is online.


