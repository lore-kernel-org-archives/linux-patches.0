Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D89A35337D;
	Tue, 26 Aug 2025 14:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217648; cv=none; b=IAs7pIq+rOG0CaaOQ4+Qyvrj3jcjhRqVVA6MJ+zAYj/Tq/s1PQW4tLqPL3jlRhMDz2Gv23D5Sp8rbcMufwQKVnu3Jirqvwxcak37lN96leFpMrxy3cRnSimj8GmQ6Sr6dLc/MzU602sH6uids31XKKd9af1j4tby076fLGvhAJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217648; c=relaxed/simple;
	bh=sT4puVGDDGHnoXb6j7l9sc86RWkid7cWRTcjY6ep2FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJvtcDS8WRRR1BeUgsfon69JKaNXLwjzKh4+mU696Tx+b1d8Nu50Aden3P4cm3rYlHilO/amQyjpN4Gw/Ck66kUC9tNPytiiawoJm9DFseL2Pyl2blZPMt4QrIdalPHbT205VzmC2ND1bSbbzTirBxPEb2WNwDZUgh8x1BPyfGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkXxTyrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkXxTyrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001B9C4CEF1;
	Tue, 26 Aug 2025 14:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217648;
	bh=sT4puVGDDGHnoXb6j7l9sc86RWkid7cWRTcjY6ep2FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkXxTyrUAjsIwA+FF7KAYDavyPK43wo+fMSM+D78Llzwr5J6PO24ZTD0K58lW7uNH
	 QrxWHMBKTVi0bLTEFfgXH5jWBHogxXxX2flwcG7pNOodxXCOAA/x8ooFGgxyvNDc8I
	 0ut01R/WPnSEyTipLnMXDj2ZgdDrjkKOWXR1pGqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Prashant Malani <pmalani@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/523] cpufreq: CPPC: Mark driver with NEED_UPDATE_LIMITS flag
Date: Tue, 26 Aug 2025 13:07:12 +0200
Message-ID: <20250826110929.935376299@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

From: Prashant Malani <pmalani@google.com>

[ Upstream commit 0a1416a49e63c320f6e6c1c8d07e1b58c0d4a3f3 ]

AMU counters on certain CPPC-based platforms tend to yield inaccurate
delivered performance measurements on systems that are idle/mostly idle.
This results in an inaccurate frequency being stored by cpufreq in its
policy structure when the CPU is brought online. [1]

Consequently, if the userspace governor tries to set the frequency to a
new value, there is a possibility that it would be the erroneous value
stored earlier. In such a scenario, cpufreq would assume that the
requested frequency has already been set and return early, resulting in
the correct/new frequency request never making it to the hardware.

Since the operating frequency is liable to this sort of inconsistency,
mark the CPPC driver with CPUFREQ_NEED_UPDATE_LIMITS so that it is always
invoked when a target frequency update is requested.

Link: https://lore.kernel.org/linux-pm/20250619000925.415528-3-pmalani@google.com/ [1]
Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Prashant Malani <pmalani@google.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/20250722055611.130574-2-pmalani@google.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cppc_cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index f29e8d0553a8..17e712651090 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -396,7 +396,7 @@ static int cppc_cpufreq_set_boost(struct cpufreq_policy *policy, int state)
 }
 
 static struct cpufreq_driver cppc_cpufreq_driver = {
-	.flags = CPUFREQ_CONST_LOOPS,
+	.flags = CPUFREQ_CONST_LOOPS | CPUFREQ_NEED_UPDATE_LIMITS,
 	.verify = cppc_verify_policy,
 	.target = cppc_cpufreq_set_target,
 	.get = cppc_cpufreq_get_rate,
-- 
2.39.5



