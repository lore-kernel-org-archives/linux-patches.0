Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA883C07A;
	Thu, 20 Aug 2026 15:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238627; cv=none; b=rFl/TohIfKVTBccP8gqCHMhv1OxU3AQM3NEMT49CeH1jQWqP7o9QakXwAGSkit8GEZhVZKlzS0gfqUTNtCq0qf92Y545yt/+dUvXm2zRbI38wRRplmqDN82ACYY5T1L4ws1k74JzbyMCU3ESQnYEiKWDREZcJ2auJj+gZ5eETdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238627; c=relaxed/simple;
	bh=sbY8r2MRzvZgtkfw3iRl3aDgfSrqyLyIPSvLIlzPC38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYP7r6WjHnZQM9Pwr6QMwTW00TK+/EkqWTy96lun4rujBjOHDOewhhaMLzNfgFBkj1GkMRTL9m195rcD+WjWayJ4H2HL2pyptWDLpnUmOfYC86KTIT6q9Vtv/0D/GcQZDxhU9NiGKzLn6k7t4RZgYfsITVSzKk2hQDU2UIEuELU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OaUb9bKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OaUb9bKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F201F000E9;
	Thu, 20 Aug 2026 15:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238626;
	bh=1QcRJs3pmajxGymqNrO5USMhS246bGP7t4b+jL9pxRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OaUb9bKJksH034THCMQ+1MCEycpnnL2v/DC9Oonaz+J3EojLaVMTLuciQsw9ujWX7
	 xPskHmp9G7Lr+EFmui8kcJrX2dntmDGGfUURByq0BlvAyHCZfdt0hwLDf3e/M66/DV
	 UPBuj3REQoSJCj73FfWsYHer09fR4CP0q/TUU7Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 186/228] tick: Include ktime.h and jiffies.h in linux/tick.h
Date: Thu, 20 Aug 2026 16:55:28 +0200
Message-ID: <20260820145250.353572288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 45f8dffc0714c3ef49c83e5bba4c56a4499bd5fc ]

The !CONFIG_NO_HZ_COMMON stubs use ktime_add(), ktime_get() and TICK_NSEC,
but tick.h includes neither <linux/ktime.h> nor <linux/jiffies.h>. Most
configurations build only because those declarations arrive transitively.

Commit 6440966067dc ("cpuset: Remove cpuset_cpu_is_isolated()") removed
<linux/cpuset.h> from <linux/sched/isolation.h>. The <linux/cpuset.h>
include chain had been satisfying these declarations before <linux/tick.h>
was parsed. Commit 8aa76aa41589 ("ring-buffer: Use a housekeeping CPU to
wake up waiters") then added <linux/sched/isolation.h> to ring_buffer.c
ahead of any header which provides them. Neither change is wrong on its
own: the failure requires both and appeared in v7.0.

ARM rpc_defconfig + CONFIG_FUNCTION_TRACER fails to build:

  $ make ARCH=arm rpc_defconfig
  $ ./scripts/config -e FTRACE -e FUNCTION_TRACER
  $ make ARCH=arm olddefconfig
  $ make ARCH=arm kernel/trace/ring_buffer.o
  In file included from include/linux/sched/isolation.h:6,
                   from kernel/trace/ring_buffer.c:8:
  include/linux/tick.h: In function 'tick_nohz_get_next_hrtimer':
  include/linux/tick.h:156:9: error: implicit declaration of function
      'ktime_add'; did you mean 'size_add'?
  include/linux/tick.h:156:19: error: implicit declaration of function
      'ktime_get'; did you mean 'time_init'?
  include/linux/tick.h:156:32: error: 'TICK_NSEC' undeclared

Include the headers the file actually uses.

Fixes: 8aa76aa41589 ("ring-buffer: Use a housekeeping CPU to wake up waiters")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: Codex:gpt-5.6-sol
Link: https://patch.msgid.link/20260722062141.19671-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tick.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 738007d6f577f..73dc3183e279b 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -7,6 +7,8 @@
 
 #include <linux/clockchips.h>
 #include <linux/irqflags.h>
+#include <linux/jiffies.h>
+#include <linux/ktime.h>
 #include <linux/percpu.h>
 #include <linux/context_tracking_state.h>
 #include <linux/cpumask.h>
-- 
2.53.0



