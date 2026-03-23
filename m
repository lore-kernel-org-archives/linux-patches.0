Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEEC823DD;
	Mon, 23 Mar 2026 14:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275531; cv=none; b=pATqodyP0fndFOsHvjKVhT/EdIORUY9+vUivLebxrAyH1VQzCoWwoATqBNG9RPpBRZjLIzueuMFcYsT3yiskcvfmUf56mcU1DQNtS8uoTXn3c75cYVow29uIvosEXY10GK+ap6/TnE7Bk0+QZ7YsnFRnXc4Ld630iKc+SZdiKkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275531; c=relaxed/simple;
	bh=vLtMphh8ydOwYsd64b2KeFZ3eKfO3Ld4P/1pY0BvowM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxCX6vPJFg2QOPInoiwZL8DMjwtbYu9C/tUZCJd3DUzSM+A0RhhaoVQvfSMkw87gMrFLIhMNhLNflrzhvJ6V3TjdB1XsNaMmGi8rqSxEqNza9qGrsBWRB1+9B5IBFrzCyTgnW4gMYEcjJirPschlHMuz2sLUHPVs8d2UKzoovEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Odi1vjzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Odi1vjzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D4DC4CEF7;
	Mon, 23 Mar 2026 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275531;
	bh=vLtMphh8ydOwYsd64b2KeFZ3eKfO3Ld4P/1pY0BvowM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Odi1vjzzwu0aXoG1W5ZsHKHTtzTY03SvwmWAD8z+NiONCsfnWLCbhflN9w17uFK/7
	 beWtNTqjTjXfIrBWUxClelCAPAz6ju6YgmYXZ/9tafYULMaofPyKfbFjMa9APQ2gv+
	 AD2KyUwpiT4oZGItYSYtbEokVSRxxnPi0lryGYOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/460] time/jiffies: Mark jiffies_64_to_clock_t() notrace
Date: Mon, 23 Mar 2026 14:42:09 +0100
Message-ID: <20260323134529.873174669@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1ad88e97b4ebc..da7e8a02a0964 100644
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



