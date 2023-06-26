Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83E7D526
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3093CC433C9;
	Mon, 26 Jun 2023 18:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804707;
	bh=kR5t8bTEO73iH89VJlnnEQ9itMI1V0WT//U1zwobbgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WB02v9ofGeP/c2ZY6I+mv91i37S1Q8mLddGVVg6FvuEB/WmU4HEnNkp6nZga/fTU5
	 oF+ThJUGRq8pfsHBreGMnQ3ZBxarIVq0GN9pKgVktZkrmbQdvT0+cDLUbvEHPLZ3hn
	 MKfWCyQByAWimyjVBeqjM3XJIxDaSg2KcUc/Btf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 15/96] ACPI: sleep: Avoid breaking S3 wakeup due to might_sleep()
Date: Mon, 26 Jun 2023 20:11:30 +0200
Message-ID: <20230626180747.554067525@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 22db06337f590d01d79f60f181d8dfe5a9ef9085 upstream.

The addition of might_sleep() to down_timeout() caused the latter to
enable interrupts unconditionally in some cases, which in turn broke
the ACPI S3 wakeup path in acpi_suspend_enter(), where down_timeout()
is called by acpi_disable_all_gpes() via acpi_ut_acquire_mutex().

Namely, if CONFIG_DEBUG_ATOMIC_SLEEP is set, might_sleep() causes
might_resched() to be used and if CONFIG_PREEMPT_VOLUNTARY is set,
this triggers __cond_resched() which may call preempt_schedule_common(),
so __schedule() gets invoked and it ends up with enabled interrupts (in
the prev == next case).

Now, enabling interrupts early in the S3 wakeup path causes the kernel
to crash.

Address this by modifying acpi_suspend_enter() to disable GPEs without
attempting to acquire the sleeping lock which is not needed in that code
path anyway.

Fixes: 99409b935c9a ("locking/semaphore: Add might_sleep() to down_*() family")
Reported-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: 5.15+ <stable@vger.kernel.org> # 5.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpica/achware.h |    2 --
 drivers/acpi/sleep.c          |   16 ++++++++++++----
 include/acpi/acpixf.h         |    1 +
 3 files changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/acpi/acpica/achware.h
+++ b/drivers/acpi/acpica/achware.h
@@ -101,8 +101,6 @@ acpi_status
 acpi_hw_get_gpe_status(struct acpi_gpe_event_info *gpe_event_info,
 		       acpi_event_status *event_status);
 
-acpi_status acpi_hw_disable_all_gpes(void);
-
 acpi_status acpi_hw_enable_all_runtime_gpes(void);
 
 acpi_status acpi_hw_enable_all_wakeup_gpes(void);
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -635,11 +635,19 @@ static int acpi_suspend_enter(suspend_st
 	}
 
 	/*
-	 * Disable and clear GPE status before interrupt is enabled. Some GPEs
-	 * (like wakeup GPE) haven't handler, this can avoid such GPE misfire.
-	 * acpi_leave_sleep_state will reenable specific GPEs later
+	 * Disable all GPE and clear their status bits before interrupts are
+	 * enabled. Some GPEs (like wakeup GPEs) have no handlers and this can
+	 * prevent them from producing spurious interrups.
+	 *
+	 * acpi_leave_sleep_state() will reenable specific GPEs later.
+	 *
+	 * Because this code runs on one CPU with disabled interrupts (all of
+	 * the other CPUs are offline at this time), it need not acquire any
+	 * sleeping locks which may trigger an implicit preemption point even
+	 * if there is no contention, so avoid doing that by using a low-level
+	 * library routine here.
 	 */
-	acpi_disable_all_gpes();
+	acpi_hw_disable_all_gpes();
 	/* Allow EC transactions to happen. */
 	acpi_ec_unblock_transactions();
 
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -749,6 +749,7 @@ ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_sta
 						     acpi_event_status
 						     *event_status))
 ACPI_HW_DEPENDENT_RETURN_UINT32(u32 acpi_dispatch_gpe(acpi_handle gpe_device, u32 gpe_number))
+ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_hw_disable_all_gpes(void))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_disable_all_gpes(void))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_enable_all_runtime_gpes(void))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_enable_all_wakeup_gpes(void))


