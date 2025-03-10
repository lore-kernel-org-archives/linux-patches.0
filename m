Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0582343D4;
	Mon, 10 Mar 2025 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630531; cv=none; b=WtewBnQuWvnhSqjfaRUXB7i05VfdTrg7Q6HhWz4Qm8jwBsyC4m2hKgX6HVkQlMc//Xv/PLtzCaaRAgNmU44Czerl0qVXqIe3tmnZ+v5MT4ZhF1t++MJyaIlULWdNVc1Wtgq78vc2F/gxSQs66uOvHZaaZUrX/3jb7I5A4x7xdbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630531; c=relaxed/simple;
	bh=7F7BFDEqM7+n4C2vn+Kf5kd8gDJpkG/iQjpQ7g1vCeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzLtVZLZaeowy5A52Cy8PdMeD6/iB/AQRpKIcTgXCC0QeSKrR1JArI8sam3v2fvnqe4mhg7kA6iyLOHAeadPGPQYKRW5kqEMtY+OnX64doNjKADBJ1ML0VRfRz6itvESu6UckuxF0GRNLlyheJgHPP8jrUX9ss7Yor/PUjrQxZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rOEViO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rOEViO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE21C4CEE5;
	Mon, 10 Mar 2025 18:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630531;
	bh=7F7BFDEqM7+n4C2vn+Kf5kd8gDJpkG/iQjpQ7g1vCeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rOEViO/mGFy0tzIANznwyIOJLE9Yyp8VIGUlNbC4yQXtzjdfEn8l7suPrzI4ItE4
	 nbvnXJ7pSEXYHojkIE2tsi7bVTymfHmdkaXzYtB6nRQvD4V3qIMekbnSReZOUD+cgh
	 Win7QqniMyfmatm/GcQqKcVk6KUMXQU66CewYfzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 446/620] kfence: allow use of a deferrable timer
Date: Mon, 10 Mar 2025 18:04:52 +0100
Message-ID: <20250310170603.200361226@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

[ Upstream commit 737b6a10ac19e41877aa1911bf6b361a72a88ad9 ]

Allow the use of a deferrable timer, which does not force CPU wake-ups
when the system is idle.  A consequence is that the sample interval
becomes very unpredictable, to the point that it is not guaranteed that
the KFENCE KUnit test still passes.

Nevertheless, on power-constrained systems this may be preferable, so
let's give the user the option should they accept the above trade-off.

Link: https://lkml.kernel.org/r/20220308141415.3168078-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: e64f81946adf ("kfence: skip __GFP_THISNODE allocations on NUMA systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/dev-tools/kfence.rst | 12 ++++++++++++
 lib/Kconfig.kfence                 | 12 ++++++++++++
 mm/kfence/core.c                   | 15 +++++++++++++--
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/Documentation/dev-tools/kfence.rst b/Documentation/dev-tools/kfence.rst
index 48244d32780f6..b6671d907836a 100644
--- a/Documentation/dev-tools/kfence.rst
+++ b/Documentation/dev-tools/kfence.rst
@@ -41,6 +41,18 @@ guarded by KFENCE. The default is configurable via the Kconfig option
 ``CONFIG_KFENCE_SAMPLE_INTERVAL``. Setting ``kfence.sample_interval=0``
 disables KFENCE.
 
+The sample interval controls a timer that sets up KFENCE allocations. By
+default, to keep the real sample interval predictable, the normal timer also
+causes CPU wake-ups when the system is completely idle. This may be undesirable
+on power-constrained systems. The boot parameter ``kfence.deferrable=1``
+instead switches to a "deferrable" timer which does not force CPU wake-ups on
+idle systems, at the risk of unpredictable sample intervals. The default is
+configurable via the Kconfig option ``CONFIG_KFENCE_DEFERRABLE``.
+
+.. warning::
+   The KUnit test suite is very likely to fail when using a deferrable timer
+   since it currently causes very unpredictable sample intervals.
+
 The KFENCE memory pool is of fixed size, and if the pool is exhausted, no
 further KFENCE allocations occur. With ``CONFIG_KFENCE_NUM_OBJECTS`` (default
 255), the number of available guarded objects can be controlled. Each object
diff --git a/lib/Kconfig.kfence b/lib/Kconfig.kfence
index 912f252a41fc6..459dda9ef619b 100644
--- a/lib/Kconfig.kfence
+++ b/lib/Kconfig.kfence
@@ -45,6 +45,18 @@ config KFENCE_NUM_OBJECTS
 	  pages are required; with one containing the object and two adjacent
 	  ones used as guard pages.
 
+config KFENCE_DEFERRABLE
+	bool "Use a deferrable timer to trigger allocations"
+	help
+	  Use a deferrable timer to trigger allocations. This avoids forcing
+	  CPU wake-ups if the system is idle, at the risk of a less predictable
+	  sample interval.
+
+	  Warning: The KUnit test suite fails with this option enabled - due to
+	  the unpredictability of the sample interval!
+
+	  Say N if you are unsure.
+
 config KFENCE_STATIC_KEYS
 	bool "Use static keys to set up allocations" if EXPERT
 	depends on JUMP_LABEL
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 3eab72fb3d8c9..1a2dc187a72f9 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -89,6 +89,10 @@ module_param_cb(sample_interval, &sample_interval_param_ops, &kfence_sample_inte
 static unsigned long kfence_skip_covered_thresh __read_mostly = 75;
 module_param_named(skip_covered_thresh, kfence_skip_covered_thresh, ulong, 0644);
 
+/* If true, use a deferrable timer. */
+static bool kfence_deferrable __read_mostly = IS_ENABLED(CONFIG_KFENCE_DEFERRABLE);
+module_param_named(deferrable, kfence_deferrable, bool, 0444);
+
 /* The pool of pages used for guard pages and objects. */
 char *__kfence_pool __ro_after_init;
 EXPORT_SYMBOL(__kfence_pool); /* Export for test modules. */
@@ -695,6 +699,8 @@ late_initcall(kfence_debugfs_init);
 
 /* === Allocation Gate Timer ================================================ */
 
+static struct delayed_work kfence_timer;
+
 #ifdef CONFIG_KFENCE_STATIC_KEYS
 /* Wait queue to wake up allocation-gate timer task. */
 static DECLARE_WAIT_QUEUE_HEAD(allocation_wait);
@@ -717,7 +723,6 @@ static DEFINE_IRQ_WORK(wake_up_kfence_timer_work, wake_up_kfence_timer);
  * avoids IPIs, at the cost of not immediately capturing allocations if the
  * instructions remain cached.
  */
-static struct delayed_work kfence_timer;
 static void toggle_allocation_gate(struct work_struct *work)
 {
 	if (!READ_ONCE(kfence_enabled))
@@ -745,7 +750,6 @@ static void toggle_allocation_gate(struct work_struct *work)
 	queue_delayed_work(system_unbound_wq, &kfence_timer,
 			   msecs_to_jiffies(kfence_sample_interval));
 }
-static DECLARE_DELAYED_WORK(kfence_timer, toggle_allocation_gate);
 
 /* === Public interface ===================================================== */
 
@@ -774,8 +778,15 @@ void __init kfence_init(void)
 
 	if (!IS_ENABLED(CONFIG_KFENCE_STATIC_KEYS))
 		static_branch_enable(&kfence_allocation_key);
+
+	if (kfence_deferrable)
+		INIT_DEFERRABLE_WORK(&kfence_timer, toggle_allocation_gate);
+	else
+		INIT_DELAYED_WORK(&kfence_timer, toggle_allocation_gate);
+
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
+
 	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
 		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
 		(void *)(__kfence_pool + KFENCE_POOL_SIZE));
-- 
2.39.5



