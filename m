Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F191E22FC;
	Wed, 19 Feb 2025 08:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954642; cv=none; b=jXDoFGdrnK/MMlOUeLj5isJlrwKZsrAQDn/R6nH3rNUTQCSYNutD6aPQanEJ6ZQht0ckE063t34XyAnh8Qj1Sskp8P0tnIukJBwQFkeypQwow5GBuFEFmwnc9XDJoDB4rYQp74rC9VFhYOB2UrdXNCjxCW+u0thUeKsYzsvVXwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954642; c=relaxed/simple;
	bh=Wu19uNVEDj2FzbRBm82NE2mWhsAlK0pv24UjMsbkEM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ce6P80WljL8YLnnh+u9FKCE0zjwpkjFgSphh89FY2dvOD6rmVdYPpeEBWAEReYDiU3eT8ZXL3KJq66D7MV25SzxSHw1hX8AauEHdPHOSM8w6UpwJz6N19OxgJvVai/19xAgbuplsPQHTqGbDQhuRyMzKFLy7MENgEscSSI9QYcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgpM753D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgpM753D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A97C4CED1;
	Wed, 19 Feb 2025 08:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954641;
	bh=Wu19uNVEDj2FzbRBm82NE2mWhsAlK0pv24UjMsbkEM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgpM753D6hCErYQayIzOhGDj3s+OcqwwYmiof8g1E176IRUC1Gut1o0ZOTxw1YjZc
	 K0AgwcJosCGwv4nHoRgtxoCbRN6ux8LUMF4YvxJ/yCI9RFEqGxPV91xFRhDFG+JyMj
	 ETNfwyQa0jLq1cVdXQy0yjMrqhFtJHCD0ccxhRJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.13 267/274] cpufreq/amd-pstate: Remove the goto label in amd_pstate_update_limits
Date: Wed, 19 Feb 2025 09:28:41 +0100
Message-ID: <20250219082620.035864195@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>

commit d364eee14c682b141f4667efc3c65191339d88bd upstream.

Scope based guard/cleanup macros should not be used together with goto
labels. Hence, remove the goto label.

Fixes: 6c093d5a5b73 ("cpufreq/amd-pstate: convert mutex use to guard()")
Signed-off-by: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250205112523.201101-2-dhananjay.ugwekar@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -827,8 +827,10 @@ static void amd_pstate_update_limits(uns
 	guard(mutex)(&amd_pstate_driver_lock);
 
 	ret = amd_get_highest_perf(cpu, &cur_high);
-	if (ret)
-		goto free_cpufreq_put;
+	if (ret) {
+		cpufreq_cpu_put(policy);
+		return;
+	}
 
 	prev_high = READ_ONCE(cpudata->prefcore_ranking);
 	highest_perf_changed = (prev_high != cur_high);
@@ -838,8 +840,6 @@ static void amd_pstate_update_limits(uns
 		if (cur_high < CPPC_MAX_PERF)
 			sched_set_itmt_core_prio((int)cur_high, cpu);
 	}
-
-free_cpufreq_put:
 	cpufreq_cpu_put(policy);
 
 	if (!highest_perf_changed)


