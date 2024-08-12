Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3DB183CD4;
	Mon, 12 Aug 2024 16:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480287; cv=none; b=hCHQB/nM0yUkENtGgb8kVuqPGhLvbZOWk+2RYLcLn/BPwfjbLOtq1kZwG8vT8ykqEe6ElHM0V2qkMUQWzl/mX2ffAET1zV5I/TsfiU+IfxTrZr1mp8zjXYSzTtWquoDjhPAsr8IzuGXyXPwKgT30t8noD2g54VnX1n6kGuFIOzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480287; c=relaxed/simple;
	bh=YZDgHrq9o+3dCcHJF117eTtkfkVmQbmyTItz+wx3IWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBcuUzMzR+Mip0W02/7eIo+tAkzuDnRYzq1kZuBGu9ZBRT0/zTZRmsRYL/LdrU8lUPvNnSI4cKHjN+vp3eiPYisbL/uRqY87MNP0HnZdoMJ9jfu12uIh7rLYGPleeSywxBUW9D0WwvDKJC/sp5RZ4levIGUef7s1IWiwIxcKMK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvXIXNpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvXIXNpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48ED6C32782;
	Mon, 12 Aug 2024 16:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480287;
	bh=YZDgHrq9o+3dCcHJF117eTtkfkVmQbmyTItz+wx3IWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvXIXNpdd2GU2aAT1d/SpOxzP28HsLoA85r7V6eTiLj1nwy8vK8gHni4AWIDASdwk
	 q39prq9cXrPVpLNr2dQkF6LCSBcqfHlVyqAw6fIWlDVcZKkMCCAva8exBWx6iqmUyC
	 s3+5obbAJL49MvT5e8IBWhHoVtZJ+C7zKN1kdPNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.10 120/263] clocksource: Fix brown-bag boolean thinko in cs_watchdog_read()
Date: Mon, 12 Aug 2024 18:02:01 +0200
Message-ID: <20240812160151.142400612@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

commit f2655ac2c06a15558e51ed6529de280e1553c86e upstream.

The current "nretries > 1 || nretries >= max_retries" check in
cs_watchdog_read() will always evaluate to true, and thus pr_warn(), if
nretries is greater than 1.  The intent is instead to never warn on the
first try, but otherwise warn if the successful retry was the last retry.

Therefore, change that "||" to "&&".

Fixes: db3a34e17433 ("clocksource: Retry clock read if long delays detected")
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240802154618.4149953-2-paulmck@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/clocksource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -246,7 +246,7 @@ static enum wd_read_status cs_watchdog_r
 
 		wd_delay = cycles_to_nsec_safe(watchdog, *wdnow, wd_end);
 		if (wd_delay <= WATCHDOG_MAX_SKEW) {
-			if (nretries > 1 || nretries >= max_retries) {
+			if (nretries > 1 && nretries >= max_retries) {
 				pr_warn("timekeeping watchdog on CPU%d: %s retried %d times before success\n",
 					smp_processor_id(), watchdog->name, nretries);
 			}


