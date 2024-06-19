Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90174D9EA;
	Wed, 19 Jun 2024 13:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803403; cv=none; b=umUHacnhfUbF1OI/z+x6prJuw0sC53u36eGopdpgIa9aGQRbmmfQvk09WYOOAC2X1NkPKQxLHODmd1VbG+4XaLk52hYfVtqdPDn6XR+o2GPcOaIPFonP1+U4C8ZFKefLQ8aVy8ZPIFyU/O9nYaP1TrStBVa2PonT813hTFmvZG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803403; c=relaxed/simple;
	bh=i7gzrbF0LnY4OmFYR8JVXeUeyMpgU2IKM28UgO/O8XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hp3jq638q8zPeEy6IFe/Lz9EAKeT66WWM2lVXxsXQ5eskux2+VJfni2fGXAniZcemrcVBAt7zYvkBqUrwdGZlSyIr0Cno4Qqjdz0zCibdlnfFIpMyk4vbafypep/jvAjxTWJYcWsbIrkKG2+PTnFv/xihP2fv2CEZRyer5RX038=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAojn+E0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAojn+E0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1345AC2BBFC;
	Wed, 19 Jun 2024 13:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803403;
	bh=i7gzrbF0LnY4OmFYR8JVXeUeyMpgU2IKM28UgO/O8XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAojn+E0/XnPi3pCREUsVgq7DKu0Eg8ktzsRvEU7U3nNQz+vaNwo5yorel/puoUOc
	 ScBFz/Si31F0z4YNcZ8rbmTgh+NIhDXWSzXb/7vbVV43nUAh+0s/sy5EasZFpvjAc4
	 IYzM1sASsh16dW7kmlXNP8cTBfUDbh1HuatcWlQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.9 256/281] drm/i915/gt: Disarm breadcrumbs if engines are already idle
Date: Wed, 19 Jun 2024 14:56:55 +0200
Message-ID: <20240619125619.828555092@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 70cb9188ffc75e643debf292fcddff36c9dbd4ae upstream.

The breadcrumbs use a GT wakeref for guarding the interrupt, but are
disarmed during release of the engine wakeref. This leaves a hole where
we may attach a breadcrumb just as the engine is parking (after it has
parked its breadcrumbs), execute the irq worker with some signalers still
attached, but never be woken again.

That issue manifests itself in CI with IGT runner timeouts while tests
are waiting indefinitely for release of all GT wakerefs.

<6> [209.151778] i915: Running live_engine_pm_selftests/live_engine_busy_stats
<7> [209.231628] i915 0000:00:02.0: [drm:intel_power_well_disable [i915]] disabling PW_5
<7> [209.231816] i915 0000:00:02.0: [drm:intel_power_well_disable [i915]] disabling PW_4
<7> [209.231944] i915 0000:00:02.0: [drm:intel_power_well_disable [i915]] disabling PW_3
<7> [209.232056] i915 0000:00:02.0: [drm:intel_power_well_disable [i915]] disabling PW_2
<7> [209.232166] i915 0000:00:02.0: [drm:intel_power_well_disable [i915]] disabling DC_off
<7> [209.232270] i915 0000:00:02.0: [drm:skl_enable_dc6 [i915]] Enabling DC6
<7> [209.232368] i915 0000:00:02.0: [drm:gen9_set_dc_state.part.0 [i915]] Setting DC state from 00 to 02
<4> [299.356116] [IGT] Inactivity timeout exceeded. Killing the current test with SIGQUIT.
...
<6> [299.356526] sysrq: Show State
...
<6> [299.373964] task:i915_selftest   state:D stack:11784 pid:5578  tgid:5578  ppid:873    flags:0x00004002
<6> [299.373967] Call Trace:
<6> [299.373968]  <TASK>
<6> [299.373970]  __schedule+0x3bb/0xda0
<6> [299.373974]  schedule+0x41/0x110
<6> [299.373976]  intel_wakeref_wait_for_idle+0x82/0x100 [i915]
<6> [299.374083]  ? __pfx_var_wake_function+0x10/0x10
<6> [299.374087]  live_engine_busy_stats+0x9b/0x500 [i915]
<6> [299.374173]  __i915_subtests+0xbe/0x240 [i915]
<6> [299.374277]  ? __pfx___intel_gt_live_setup+0x10/0x10 [i915]
<6> [299.374369]  ? __pfx___intel_gt_live_teardown+0x10/0x10 [i915]
<6> [299.374456]  intel_engine_live_selftests+0x1c/0x30 [i915]
<6> [299.374547]  __run_selftests+0xbb/0x190 [i915]
<6> [299.374635]  i915_live_selftests+0x4b/0x90 [i915]
<6> [299.374717]  i915_pci_probe+0x10d/0x210 [i915]

At the end of the interrupt worker, if there are no more engines awake,
disarm the breadcrumb and go to sleep.

Fixes: 9d5612ca165a ("drm/i915/gt: Defer enabling the breadcrumb interrupt to after submission")
Closes: https://gitlab.freedesktop.org/drm/intel/issues/10026
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: <stable@vger.kernel.org> # v5.12+
Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Acked-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240423165505.465734-2-janusz.krzysztofik@linux.intel.com
(cherry picked from commit fbad43eccae5cb14594195c20113369aabaa22b5)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
+++ b/drivers/gpu/drm/i915/gt/intel_breadcrumbs.c
@@ -263,8 +263,13 @@ static void signal_irq_work(struct irq_w
 		i915_request_put(rq);
 	}
 
+	/* Lazy irq enabling after HW submission */
 	if (!READ_ONCE(b->irq_armed) && !list_empty(&b->signalers))
 		intel_breadcrumbs_arm_irq(b);
+
+	/* And confirm that we still want irqs enabled before we yield */
+	if (READ_ONCE(b->irq_armed) && !atomic_read(&b->active))
+		intel_breadcrumbs_disarm_irq(b);
 }
 
 struct intel_breadcrumbs *
@@ -315,13 +320,7 @@ void __intel_breadcrumbs_park(struct int
 		return;
 
 	/* Kick the work once more to drain the signalers, and disarm the irq */
-	irq_work_sync(&b->irq_work);
-	while (READ_ONCE(b->irq_armed) && !atomic_read(&b->active)) {
-		local_irq_disable();
-		signal_irq_work(&b->irq_work);
-		local_irq_enable();
-		cond_resched();
-	}
+	irq_work_queue(&b->irq_work);
 }
 
 void intel_breadcrumbs_free(struct kref *kref)
@@ -404,7 +403,7 @@ static void insert_breadcrumb(struct i91
 	 * the request as it may have completed and raised the interrupt as
 	 * we were attaching it into the lists.
 	 */
-	if (!b->irq_armed || __i915_request_is_complete(rq))
+	if (!READ_ONCE(b->irq_armed) || __i915_request_is_complete(rq))
 		irq_work_queue(&b->irq_work);
 }
 


