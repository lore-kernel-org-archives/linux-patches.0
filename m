Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3813161BF;
	Mon, 13 Apr 2026 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098929; cv=none; b=J8GUrH5bAxiRKyJOpZcwpcj2W7pjs3d82f6QAAWrb+zK9uaSQuAHQYgZPAH3zPA42xuo6jqNX9tc7pYNMqEXv+L9WQXBqd9Arx2OPE3p0fWmDGABKzmeO0sdwRAznI+V6h4nizqsvwrsoOqvqQx7wCQ6GylkLNEfsXV4udO9kwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098929; c=relaxed/simple;
	bh=vWmP2FzzmrVe42dh/QBwbO49t5Ow4h1dWc0U/o6o224=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdNgnSTb89/iE9t1xXtep77Ot+zrNn8errTIe6o3Pp1je5T2K3SOyOuujZuRV2oVcNlZqkNUGT+/i/Oylzgzkvg9zWx79E4pc+UkBXgvCPLz39LM27+zr4JrC1TcQn9DWaU+rYpQuC5L8LXdVq1vt93LvG4oGmHPQ9EL4Oo8j7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1yfw0uS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1yfw0uS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF95C2BCAF;
	Mon, 13 Apr 2026 16:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098928;
	bh=vWmP2FzzmrVe42dh/QBwbO49t5Ow4h1dWc0U/o6o224=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1yfw0uSn389BmIksahDWkmP/HWSHBTS4x70wOslLLnbg3xp4L3FeMeE71q8fvuAf
	 z6M7kcCMB25Z+lHUX70L8/a1bZskXFJt+7gHvP4nQ0STioPQHFHWNIRX7DIJGWPcgc
	 dRHksGYIwKls2CP01LrenE4yxePXkM/9uGsbF7Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/491] time/jiffies: Mark jiffies_64_to_clock_t() notrace
Date: Mon, 13 Apr 2026 17:55:56 +0200
Message-ID: <20260413155823.197349116@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 755a648e78f12574482d4698d877375793867fa1 ]

The trace_clock_jiffies() function that handles the "uptime" clock for
tracing calls jiffies_64_to_clock_t(). This causes the function tracer to
constantly recurse when the tracing clock is set to "uptime". Mark it
notrace to prevent unnecessary recursion when using the "uptime" clock.

Fixes: 58d4e21e50ff3 ("tracing: Fix wraparound problems in "uptime" trace clock")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260306212403.72270bb2@robin
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/time.c b/kernel/time/time.c
index 6f81aead1856d..37c381607f372 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -702,7 +702,7 @@ EXPORT_SYMBOL(clock_t_to_jiffies);
  *
  * Return: jiffies_64 value converted to 64-bit "clock_t" (CLOCKS_PER_SEC)
  */
-u64 jiffies_64_to_clock_t(u64 x)
+notrace u64 jiffies_64_to_clock_t(u64 x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
 # if HZ < USER_HZ
-- 
2.51.0



