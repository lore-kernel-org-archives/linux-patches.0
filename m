Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7754E334C3F;
	Thu, 27 Nov 2025 15:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255828; cv=none; b=V8QcVt9zKUFL7EdZNXMKeTSnwg4FSPiC7bDRuIB3P4iymVH9eLCyR9aPMmb4oEYxfSuTp3VOGkbLLqVPAf+8tfRuH9KIR0E2dQqv3QWTYLmOVVS+bCVRuUOnIdlxRMSrr/mxleygFMetvT4dKOgLxno2AF57LIt2WC1etRZ/FRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255828; c=relaxed/simple;
	bh=PEiEzzzfL/CzM0X/dwgU0sqf8hlbN8kKVggTMAMzla8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2wV+rSXGRtWK25XzAVr2KbSIW/y4ZUUpMgp05ZP5swTbLIDMd5lJiZRpLqq0jJlEU2COZQW/aAfxbf/tFtU6lvVGrodkmJA3xciLURyQmj9zWjJa67Ue1wprh9UQ5xy+wVENom+GzX14F+Gy9B8zk42uXrcf8aHucbPeMkTbbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNTWHiJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNTWHiJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34C0C4CEF8;
	Thu, 27 Nov 2025 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255828;
	bh=PEiEzzzfL/CzM0X/dwgU0sqf8hlbN8kKVggTMAMzla8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNTWHiJ7MhoCouy1ZTil3lcflC128GZ6nffya59mCMGSGllDnc7B91qCWX2oX5G40
	 E+UOpxhAc02oMMF0smgqnUGhErHJFXoP0TN+Y3mahO8oKQT0DttMmV1QoDB+j7CWmP
	 0dVlRTyyG4VngdEN5qvQ/QNk7/hJPKao/poca5Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Yang <wen.yang@linux.dev>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 127/175] tick/sched: Fix bogus condition in report_idle_softirq()
Date: Thu, 27 Nov 2025 15:46:20 +0100
Message-ID: <20251127144047.596210809@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Yang <wen.yang@linux.dev>

[ Upstream commit 807e0d187da4c0b22036b5e34000f7a8c52f6e50 ]

In commit 0345691b24c0 ("tick/rcu: Stop allowing RCU_SOFTIRQ in idle") the
new function report_idle_softirq() was created by breaking code out of the
existing can_stop_idle_tick() for kernels v5.18 and newer.

In doing so, the code essentially went from this form:

	if (A) {
		static int ratelimit;
		if (ratelimit < 10 && !C && A&D) {
                       pr_warn("NOHZ tick-stop error: ...");
		       ratelimit++;
		}
		return false;
	}

to a new function:

static bool report_idle_softirq(void)
{
       static int ratelimit;

       if (likely(!A))
               return false;

       if (ratelimit < 10)
               return false;
...
       pr_warn("NOHZ tick-stop error: local softirq work is pending, handler #%02x!!!\n",
               pending);
       ratelimit++;

       return true;
}

commit a7e282c77785 ("tick/rcu: Fix bogus ratelimit condition") realized
ratelimit was essentially set to zero instead of ten, and hence *no*
softirq pending messages would ever be issued, but "fixed" it as:

-       if (ratelimit < 10)
+       if (ratelimit >= 10)
                return false;

However, this fix introduced another issue:

When ratelimit is greater than or equal 10, even if A is true, it will
directly return false. While ratelimit in the original code was only used
to control printing and will not affect the return value.

Restore the original logic and restrict ratelimit to control the printk and
not the return value.

Fixes: 0345691b24c0 ("tick/rcu: Stop allowing RCU_SOFTIRQ in idle")
Fixes: a7e282c77785 ("tick/rcu: Fix bogus ratelimit condition")
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20251119174525.29470-1-wen.yang@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-sched.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index c527b421c8652..466e083c82721 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1152,16 +1152,15 @@ static bool report_idle_softirq(void)
 			return false;
 	}
 
-	if (ratelimit >= 10)
-		return false;
-
 	/* On RT, softirq handling may be waiting on some lock */
 	if (local_bh_blocked())
 		return false;
 
-	pr_warn("NOHZ tick-stop error: local softirq work is pending, handler #%02x!!!\n",
-		pending);
-	ratelimit++;
+	if (ratelimit < 10) {
+		pr_warn("NOHZ tick-stop error: local softirq work is pending, handler #%02x!!!\n",
+			pending);
+		ratelimit++;
+	}
 
 	return true;
 }
-- 
2.51.0



