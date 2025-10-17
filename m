Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97D3330B00;
	Fri, 17 Oct 2025 15:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715302; cv=none; b=GspYp4g2vEqt4KZ72p8xSjeyF48oWhnEJvh8Iifabogdk9xb5NIxuqvSk86bNA2KzGKWUDr/GqjkPOf+ZoM3/FLFAXsRNTqBko7mPPt36MXLA/FUwFluRv9JGPKE8VDKOKYq+ljVTyzuhce2eFffYU19V2ES1sEwNETG8c8vOtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715302; c=relaxed/simple;
	bh=KGi12mQzl5Nbxic9SstdI0k+nC2rqA3l9JUn0BMtF80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hgl26K4PhM4uttxd/ggKTOHe4D9mtm5fft5E7VJFYHBb2LQ+BIv135MKvPW+xsRQ4jAnBR8AsUXYe+EXdtuX+PKBSg6rwcR6R5sqVe+yHylKUMCwcsI19OnxK6LKmvDusjBnszygCw/tKrMqBFXPfSwGXdL414EFOIlioVo5VQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YntX9UUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YntX9UUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD70C4CEFE;
	Fri, 17 Oct 2025 15:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715301;
	bh=KGi12mQzl5Nbxic9SstdI0k+nC2rqA3l9JUn0BMtF80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YntX9UUZTINL6S1nbNhepi1jzoeeilfoCA9XqzZJAunjt7X/PpSgHCYAAEYJ39ZOb
	 Hg9+SDpEkwL6zYIexKHNPsevByFhATnpDQPoP5H3YP63H4ZmpomhTkaCSL/YcJozw8
	 JCLs08JvQDaOifgGafr4irwM8bc3OaJiM5VAkvqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=BCrgen=20Gro=C3=9F?= <jgross@suse.com>,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
Subject: [PATCH 6.17 161/371] xen: take system_transition_mutex on suspend
Date: Fri, 17 Oct 2025 16:52:16 +0200
Message-ID: <20251017145207.758066930@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

commit 9d52b0b41be5b932a0a929c10038f1bb04af4ca5 upstream.

Xen's do_suspend() calls dpm_suspend_start() without taking required
system_transition_mutex. Since 12ffc3b1513eb moved the
pm_restrict_gfp_mask() call, not taking that mutex results in a WARN.

Take the mutex in do_suspend(), and use mutex_trylock() to follow
how enter_state() does this.

Suggested-by: Jürgen Groß <jgross@suse.com>
Fixes: 12ffc3b1513eb "PM: Restrict swap use to later in the suspend sequence"
Link: https://lore.kernel.org/xen-devel/aKiBJeqsYx_4Top5@mail-itl/
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Cc: stable@vger.kernel.org # v6.16+
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250921162853.223116-1-marmarek@invisiblethingslab.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/manage.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -11,6 +11,7 @@
 #include <linux/reboot.h>
 #include <linux/sysrq.h>
 #include <linux/stop_machine.h>
+#include <linux/suspend.h>
 #include <linux/freezer.h>
 #include <linux/syscore_ops.h>
 #include <linux/export.h>
@@ -95,10 +96,16 @@ static void do_suspend(void)
 
 	shutting_down = SHUTDOWN_SUSPEND;
 
+	if (!mutex_trylock(&system_transition_mutex))
+	{
+		pr_err("%s: failed to take system_transition_mutex\n", __func__);
+		goto out;
+	}
+
 	err = freeze_processes();
 	if (err) {
 		pr_err("%s: freeze processes failed %d\n", __func__, err);
-		goto out;
+		goto out_unlock;
 	}
 
 	err = freeze_kernel_threads();
@@ -154,6 +161,8 @@ out_resume:
 
 out_thaw:
 	thaw_processes();
+out_unlock:
+	mutex_unlock(&system_transition_mutex);
 out:
 	shutting_down = SHUTDOWN_INVALID;
 }


