Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97761DE4C2;
	Tue, 26 Aug 2025 12:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212746; cv=none; b=XFyyOQuCYcG6J/zaCIPDAGBkDMYkqhwqeSf9i5+4n5hrMVfvLeCj+Ake659hmOOcmD4r3K3IYfkhkzJllQNRCtdFAiAmW4OPiWujb9DZ5rqR5NqnA3L59/Rad1/ZpJsWzkgxJ0kPmF2zYRtQb5j7jCnW2AIIoWjxxjbAPN3aUD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212746; c=relaxed/simple;
	bh=T7MBxw8OE9mMHG68cUOPcgKFJ2oxyr2ezMj61ecJ/XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciYYkqc93oSIq6aKHxphCTCesoA6umtFzWZenbhV6nOX9J22iGIWvjNlM1EUh4rOWjl1Lb1iXR3uOVnvvGyeYluWHZoiBaMdHJNyttnVcphrjko+FZN9ztzMK44WnnSTA7LeYf7klVlz+fSukhbZ0EfmtUf6bR9GzTqMs9UUgyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBndnMHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBndnMHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3C7C4CEF1;
	Tue, 26 Aug 2025 12:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212746;
	bh=T7MBxw8OE9mMHG68cUOPcgKFJ2oxyr2ezMj61ecJ/XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBndnMHYgaptSlmc7N/0oMAy1rgYzcgp9AdhtFZ3zFfTNkOMkIMJJrXYbY32TrVD1
	 09ke3ZHhNSuwPOOx6RR2Ebg8rkCUY4zkaNDHdIR8FzgxGqxecUZ9fHa1hXR8hFepZC
	 oflRkhqWQgFyEPJshvkby5vrXrnvMiMV3VLJ3za4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Prashant Malani <pmalani@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/587] cpufreq: CPPC: Mark driver with NEED_UPDATE_LIMITS flag
Date: Tue, 26 Aug 2025 13:03:54 +0200
Message-ID: <20250826110955.096535890@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aa34af940cb5..ea32bdf7cc24 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -847,7 +847,7 @@ static struct freq_attr *cppc_cpufreq_attr[] = {
 };
 
 static struct cpufreq_driver cppc_cpufreq_driver = {
-	.flags = CPUFREQ_CONST_LOOPS,
+	.flags = CPUFREQ_CONST_LOOPS | CPUFREQ_NEED_UPDATE_LIMITS,
 	.verify = cppc_verify_policy,
 	.target = cppc_cpufreq_set_target,
 	.get = cppc_cpufreq_get_rate,
-- 
2.39.5



