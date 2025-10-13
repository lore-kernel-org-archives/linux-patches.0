Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D348E2566;
	Mon, 13 Oct 2025 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367075; cv=none; b=mgB+NeoWn0OLg2NDnuKjBI84JqSXtGC1LdLXK+68XQYkhCxMp8+D/tXR7D/DyY4pMqCQ68JEaEiIjOgVWdl7FYMsm3Ll1z0joD18N9EZH16VFUUXrJPMWMpYouGCw9RDw9ZzQWsEeD4pIgD1tMc6swzVOL+HHqYHBhkoymt8ZZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367075; c=relaxed/simple;
	bh=ezzRnwncbG9E4KDolkMVG9qM12TJ4IrrYF2CPCcYMRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJJOCPmf1GFGM0xxBuv9EL5KWbKLbP4Z4x0fFXdYht9mbbZyw7FRrpEH0PEo0zh5w9kmGUeEcTeSEsyVdSCZkEC7vvn6VR04Nhov2a+e8EtXwPGNewnEH5VBeX/9hTf+EYnq6z2p1drMJFHpKRASX+HIEhXnzSHoA+cMJll4GLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUtzqGPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUtzqGPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D69FC4CEE7;
	Mon, 13 Oct 2025 14:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367075;
	bh=ezzRnwncbG9E4KDolkMVG9qM12TJ4IrrYF2CPCcYMRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUtzqGPDMh8M3WKkDQo/RJ4+7clIHmpUuEm/MUeL9uvVw6AflmqI4sOqlQQE9hb46
	 XZcHDkJHgFJDAbTBWXFyfezZc4/yrmCCeo1kqe+JO5TlG31dwYIUSJN4nG0v5TJvwo
	 poYWoJucA6Cv/54265wpkyQxXNjGGXsIEMd+Ywb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/196] smp: Fix up and expand the smp_call_function_many() kerneldoc
Date: Mon, 13 Oct 2025 16:44:15 +0200
Message-ID: <20251013144317.541153438@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0acd433afa7bc..42e1067fae7ad 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -1005,16 +1005,15 @@ static void smp_call_function_many_cond(const struct cpumask *mask,
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



