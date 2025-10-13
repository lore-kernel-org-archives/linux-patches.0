Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513AE30C61C;
	Mon, 13 Oct 2025 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368194; cv=none; b=ZrrQDw6aIQSrzgLcQRHoL+RZa/FqyNpB5gcvafw0w3szS0z/UPWHxMFzsW6Px8NUQsmg9oc4TNR0DHqcG0hJCph16zk0DwjMazOi/p1Nw+IWvK0X6e/HFoQXnAAiIr5pFUKQMNfooFTHhxPtgHnk63QIrfl9npU9T6Y5K1R62pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368194; c=relaxed/simple;
	bh=3U8/CXw9z4gNo82gXYBUiQAnevdp5vlc0ZC4U1SJCXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bl7gOdXnBJWA7fx9C09W7C/a8DZ4YunVXejnf2VVKXf4dkb9u8FIcQpSL6IJtLqxZCOVZbuDObLTX1hxd2uySUMu5YC1S+gHcr6yIKNAtJ/hLiEh/grz2pz+z3L49ngWL6nhYiyelVZX3CEONraSlBsuTtdEyoGj0S1A5hBbb8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDiHGlc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDiHGlc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EFBC4CEFE;
	Mon, 13 Oct 2025 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368194;
	bh=3U8/CXw9z4gNo82gXYBUiQAnevdp5vlc0ZC4U1SJCXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDiHGlc9+V80I09GkMhSlk6B9HXJ7JarF61UWHK4rdGGeJPwYrbjH4S79Jg6X4fR9
	 W3juuyiIgyiwhojsetHj7dfP3hqqE8BC1PZZg5XJcxUHaZ01C47wksjPh0aJ5y6OLj
	 +6ca2ITkBsR2EB+8M6R5CYfto4KV/LwCidgdbqus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/262] smp: Fix up and expand the smp_call_function_many() kerneldoc
Date: Mon, 13 Oct 2025 16:43:39 +0200
Message-ID: <20251013144328.900469901@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f25e20617b7eb..fa6faf50fb43b 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -891,16 +891,15 @@ static void smp_call_function_many_cond(const struct cpumask *mask,
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



