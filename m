Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6467269808;
	Tue,  8 Apr 2025 12:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113804; cv=none; b=JOxY8M0MXNAcY81wavnZN7YM0HRSjH7hPh/GTKiw7l3hWG4cpuBG/lRWirWukJkajRaM2ITHwT8UhawC+cKILSRYtjJ7v99kCQzvMuyUIIr40aEC7Xd/UJgqpf23N2OSLgLNa8C/AQkP3B3Zd/4myDEuf1iuqOoO1O/u2uQWHPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113804; c=relaxed/simple;
	bh=FVjYBBRJz0SnmivlIbS+g8UuLKs4lLco4cHbdwJf20s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MheoiG6L6wvQy4mp2H5dBPMPVdTUtwhiGPGY6A8svOn718ejpUIe9qCkUgdQ0q4vuDm5IDdphc5rd1+xFGtuE1DmF5I06cDaJ4+FewbTbUDF1bc1teoUNExukq95arQa/Be8R5RudjMuagOoIvXWKYkoE8V8+oTw9Tg/DSQ/Ygg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=st8P7DPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="st8P7DPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4DAC4CEE5;
	Tue,  8 Apr 2025 12:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113804;
	bh=FVjYBBRJz0SnmivlIbS+g8UuLKs4lLco4cHbdwJf20s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=st8P7DPybzCZSzSJU5X9jPhltkDvxXtpgw768kSD/mNLhwXiLdXxiorg+MBTwkO61
	 ZV6OFrEFT80UMPN7wVpZ9uJoCB4CwXoE4ZnWWHRuquLfM+HCmPqQfpEbogTOt7fdEw
	 6snjxzttyVQCOeFnVylIoklm59sM/SdA2C5UGjlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris von Recklinghausen <crecklin@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Phil Auld <pauld@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Krishanth Jagaduri <Krishanth.Jagaduri@sony.com>
Subject: [PATCH 5.4 003/154] sched/isolation: Prevent boot crash when the boot CPU is nohz_full
Date: Tue,  8 Apr 2025 12:49:04 +0200
Message-ID: <20250408104815.404967297@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

Documentation/timers/no_hz.rst states that the "nohz_full=" mask must not
include the boot CPU, which is no longer true after:

  08ae95f4fd3b ("nohz_full: Allow the boot CPU to be nohz_full").

However after:

  aae17ebb53cd ("workqueue: Avoid using isolated cpus' timers on queue_delayed_work")

the kernel will crash at boot time in this case; housekeeping_any_cpu()
returns an invalid CPU number until smp_init() brings the first
housekeeping CPU up.

Change housekeeping_any_cpu() to check the result of cpumask_any_and() and
return smp_processor_id() in this case.

This is just the simple and backportable workaround which fixes the
symptom, but smp_processor_id() at boot time should be safe at least for
type == HK_TYPE_TIMER, this more or less matches the tick_do_timer_boot_cpu
logic.

There is no worry about cpu_down(); tick_nohz_cpu_down() will not allow to
offline tick_do_timer_cpu (the 1st online housekeeping CPU).

[ Apply only documentation changes as commit which causes boot
  crash when boot CPU is nohz_full is not backported to stable
  kernels - Krishanth ]

Reported-by: Chris von Recklinghausen <crecklin@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/r/20240411143905.GA19288@redhat.com
Closes: https://lore.kernel.org/all/20240402105847.GA24832@redhat.com/
Signed-off-by: Krishanth Jagaduri <Krishanth.Jagaduri@sony.com>
[ strip out upstream commit and Fixes: so tools don't get confused that
  this commit actually does anything real - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/timers/no_hz.rst |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/Documentation/timers/no_hz.rst
+++ b/Documentation/timers/no_hz.rst
@@ -129,11 +129,8 @@ adaptive-tick CPUs:  At least one non-ad
 online to handle timekeeping tasks in order to ensure that system
 calls like gettimeofday() returns accurate values on adaptive-tick CPUs.
 (This is not an issue for CONFIG_NO_HZ_IDLE=y because there are no running
-user processes to observe slight drifts in clock rate.)  Therefore, the
-boot CPU is prohibited from entering adaptive-ticks mode.  Specifying a
-"nohz_full=" mask that includes the boot CPU will result in a boot-time
-error message, and the boot CPU will be removed from the mask.  Note that
-this means that your system must have at least two CPUs in order for
+user processes to observe slight drifts in clock rate.) Note that this
+means that your system must have at least two CPUs in order for
 CONFIG_NO_HZ_FULL=y to do anything for you.
 
 Finally, adaptive-ticks CPUs must have their RCU callbacks offloaded.


