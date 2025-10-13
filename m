Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1BC271446;
	Mon, 13 Oct 2025 14:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367555; cv=none; b=gq6H6P6tSIBBUSWb23I7knJ8BG8ibWDgfKSmHKfGMedMj+jZvPzKCmK6UrL0uPrktaf147/9Cc48z6Gw9I4551o1ygSF5cvqq/d2gNbb3lhnCvp254vhBidDoqzRMPgeBtpgo9JUtl50C50Ad/0/H/xk1kl2DVTQ54cKEZRHHn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367555; c=relaxed/simple;
	bh=ZFW2VZ7JVqK3R25+cb+EbL/2vM7Vsil5ZAgWLnIipVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhcoaIL9ZWThXdrylTXhEngjscK7rDPiF3si5gKZj216U9JuUgIBEpgvoVgWqdouHNO4Sblz5cWvR8WsMSPQG6YxSHnPt7IgJXwp6/GMmdX01cI8+7lBQ0lie57Ii6A4i4M2LlrKBOP3ik1RJmXAG2CQjHR5/8Zi/NZu5gu/zxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OzevZmZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OzevZmZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1ACC4CEE7;
	Mon, 13 Oct 2025 14:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367555;
	bh=ZFW2VZ7JVqK3R25+cb+EbL/2vM7Vsil5ZAgWLnIipVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OzevZmZYlPMtqxTsMrgJRST39KQEaqwKQDTYdpVNyKFjnMB+ff2Bp447P/NRckO62
	 R8OZBPX2LQlJ5bBiNy2zzJMECngsrbdvIpPojlSE6I68vSu2GFneiyEae+eCuqcgJF
	 iBy8xIsjkjtpu1EUAzKA7RdgZZkA2T9aBhHw+z8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/196] smp: Fix up and expand the smp_call_function_many() kerneldoc
Date: Mon, 13 Oct 2025 16:44:03 +0200
Message-ID: <20251013144317.082786651@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3eeffeaf5450c..13b376c7296a5 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -862,16 +862,15 @@ static void smp_call_function_many_cond(const struct cpumask *mask,
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



