Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C343F4DC5;
	Tue, 13 Oct 2026 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791900570; cv=none; b=YRetLdI8M9+Cy9Rtw4XUrIGL0Mhti7ru0IHS39bG6wkg/pc9f3z20QIkmECWJ5TDSNsso8UT9Fu0+wHmCLwDpuhtQ0ct39YK4q117iw9o73BHm3927+BX42S/x3nc0BqNY5d2TdWRp9v6JcmTucOtUu7vIAA22F0NT8BTsQvtbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791900570; c=relaxed/simple;
	bh=lEC0ImydFuSeefjzcTaGVGN4ZB7kKX+wsph3q4lBdLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OchKv7gdSslBDFyCKNyTrsfq6VwrOxcm9cSLriwYcAfmY744Ykferzgxu8oeIVu3b3QYTil9rAj8YBnSG5NtJ7h8Mg408UloYPkdavOs+k26CWA224f9+2eWUUnYPUoVwG1dKueUBOfO9q7OoYp8GHKYksONjfQXxrmZF7PRL2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JcHZ+0H+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JcHZ+0H+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638C91F000FF;
	Tue, 13 Oct 2026 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791900568;
	bh=MFi7HA+n4yyZpEE6/mTBJhffFB9f0mw35Sw3/OfeOhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JcHZ+0H+PO2ZSkVshMyc8Zi76XkV/sWMa4sjZd9CHiTINaoQ1MWTTDoCEFXtXuH40
	 CgTSgRDAmNO5gLRph1j/XSLKRXp83wkhavmSImtYTiewt5iWlGf8kN3vVWiy2vB122
	 QlEkqv0gFU6nhcsG9+15u384uYxQuSJAS6oCWF/yYOr89nBRH8BNvtU5DheenidH+a
	 P/qQri/m5TsEg+rtdeBvHPgXrI82LRMlfIjgoRwlX7WdGfMPg8Kz4jjSicnL7j22g1
	 ZRyT4LP9E6RIIqfaBsjOeIN/UvMr+0ogVyHMs7adh0+PYpPTyB2vpQJNw9vAPreY0a
	 6BnFVU4mIeixA==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Joel Fernandes <joelagnelf@nvidia.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 177/621] srcu: Use irq_work to start GP in tiny SRCU
Date: Tue, 13 Oct 2026 07:09:16 -0700
Message-ID: <20261013140916.139338-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261013112925.062661881@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Tue, 13 Oct 2026 13:32:52 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> 6.18-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Joel Fernandes <joelagnelf@nvidia.com>
> 
> [ Upstream commit a6fc88b22bc8d12ad52e8412c667ec0f5bf055af ]
> 
> Tiny SRCU's srcu_gp_start_if_needed() directly calls schedule_work(),
> which acquires the workqueue pool->lock.
> 
> This causes a lockdep splat when call_srcu() is called with a scheduler
> lock held, due to:
> 
>   call_srcu() [holding pi_lock]
>     srcu_gp_start_if_needed()
>       schedule_work() -> pool->lock
> 
>   workqueue_init() / create_worker() [holding pool->lock]
>     wake_up_process() -> try_to_wake_up() -> pi_lock
> 
> Also add irq_work_sync() to cleanup_srcu_struct() to prevent a
> use-after-free if a queued irq_work fires after cleanup begins.
> 
> Tested with rcutorture SRCU-T and no lockdep warnings.
> 
> [ Thanks to Boqun for similar fix in patch "rcu: Use an intermediate irq_work
> to start process_srcu()" ]
> 
> Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
> Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> Signed-off-by: Boqun Feng <boqun@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/srcutiny.h |  4 ++++
>  kernel/rcu/srcutiny.c    | 19 ++++++++++++++++++-
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
> index 51ce25f07930e..1f9a226e6fd81 100644
> --- a/include/linux/srcutiny.h
> +++ b/include/linux/srcutiny.h
> @@ -11,6 +11,7 @@
>  #ifndef _LINUX_SRCU_TINY_H
>  #define _LINUX_SRCU_TINY_H
>  
> +#include <linux/irq_work_types.h>

I just found this makes UM build for kunit fails like below:

'''
$ ./tools/testing/kunit/kunit.py run --kunitconfig mm/damon/tests/
[07:00:33] Configuring KUnit Kernel ...
[07:00:33] Building KUnit Kernel ...
Populating config with:
$ make ARCH=um O=.kunit olddefconfig
Building with:
$ make all compile_commands.json scripts_gdb ARCH=um O=.kunit --jobs=14
ERROR:root:In file included from ../include/linux/srcu.h:59,
                 from ../include/linux/notifier.h:16,
                 from ../include/linux/memory_hotplug.h:7,
                 from ../include/linux/mmzone.h:1538,
                 from ../include/linux/gfp.h:7,
                 from ../include/linux/slab.h:17,
                 from ../include/linux/crypto.h:18,
                 from ../arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                 from ../arch/um/kernel/asm-offsets.c:3:
../include/linux/srcutiny.h:14:10: fatal error: linux/irq_work_types.h: No such file or directory
   14 | #include <linux/irq_work_types.h>
      |          ^~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
'''

Seems commit c809f081fe40 ("irqwork: Move data struct to a types header") which
made irq_work_types.h is not in the queue.  Below simple change fixed the issue
on my setup.

'''
diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
index 1f9a226e6fd81..786693905accc 100644
--- a/include/linux/srcutiny.h
+++ b/include/linux/srcutiny.h
@@ -11,7 +11,7 @@
 #ifndef _LINUX_SRCU_TINY_H
 #define _LINUX_SRCU_TINY_H

-#include <linux/irq_work_types.h>
+#include <linux/irq_work.h>
 #include <linux/swait.h>

 struct srcu_struct {
'''

Cherry-picking the commit c809f081fe40 ("irqwork: Move data struct to a types
header") also fixed the issue on my setup.


Thanks,
SJ

[...]
