Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E163161A6;
	Mon, 13 Oct 2025 15:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369261; cv=none; b=AWXqqUvZzKoW6DFNRM7COMDbz8zrG8BpceN1XB/+fZklkGSjWPJTX0naoiQvE4g/OhZWflJC5RpaN+TanMGE7rDbSIqhIj15vqgIuIxkkh3wX4FYR4Y9xpCaywWibkKwvLSkrpzQ2NAQiYvEf6MZzKLqiNNZJUOSUayjFV7OcKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369261; c=relaxed/simple;
	bh=cnmoIyxay2scur52ZzGd+pgWgjhrbNc3OniGg0D5WPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWBuzXEs5xwhoe4h6Gg9U0j3YKfreCfPw2qNlmCeIhe5JwWCdnRqtrBFbsVFlOeFhqxyt2CWWaxYAC3ukcud3LPy3mFvO7NXccEI98pO74u/qJiqDzQRjV3JquAR/C9efL+eLbK5qeoVTmlF7COMuFxT1sXq3Rk4t51IhfcAV8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suab8+nG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suab8+nG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9346CC16AAE;
	Mon, 13 Oct 2025 15:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369260;
	bh=cnmoIyxay2scur52ZzGd+pgWgjhrbNc3OniGg0D5WPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suab8+nGbQRe5p4yGCoes7uVVt5QfCmtl3XewFP4dbZaw/JRnp1rHjjNtnirROWwS
	 P4alNGBPbd4zggeSGfklSqsARnpxO1TUXd+wT07bQJWAspFKuh0WZ+1y4jZBuIgMEw
	 UyAiVm/QgxNAQx3/pyLUalXDTxI9yV09qKeo2Xks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 184/563] smp: Fix up and expand the smp_call_function_many() kerneldoc
Date: Mon, 13 Oct 2025 16:40:45 +0200
Message-ID: <20251013144417.948424917@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit ccf09357ffef2ab472369ab9cdf470c9bc9b821a ]

The smp_call_function_many() kerneldoc comment got out of sync with the
function definition (bool parameter "wait" is incorrectly described as a
bitmask in it), so fix it up by copying the "wait" description from the
smp_call_function() kerneldoc and add information regarding the handling
of the local CPU to it.

Fixes: 49b3bd213a9f ("smp: Fix all kernel-doc warnings")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/smp.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 56f83aa58ec82..02f52291fae42 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -884,16 +884,15 @@ static void smp_call_function_many_cond(const struct cpumask *mask,
  * @mask: The set of cpus to run on (only runs on online subset).
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
- * @wait: Bitmask that controls the operation. If %SCF_WAIT is set, wait
- *        (atomically) until function has completed on other CPUs. If
- *        %SCF_RUN_LOCAL is set, the function will also be run locally
- *        if the local CPU is set in the @cpumask.
- *
- * If @wait is true, then returns once @func has returned.
+ * @wait: If true, wait (atomically) until function has completed
+ *        on other CPUs.
  *
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler. Preemption
  * must be disabled when calling this function.
+ *
+ * @func is not called on the local CPU even if @mask contains it.  Consider
+ * using on_each_cpu_cond_mask() instead if this is not desirable.
  */
 void smp_call_function_many(const struct cpumask *mask,
 			    smp_call_func_t func, void *info, bool wait)
-- 
2.51.0



