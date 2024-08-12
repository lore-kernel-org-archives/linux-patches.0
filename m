Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4CE183CD9;
	Mon, 12 Aug 2024 16:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479009; cv=none; b=k7yJrsM7XoGHfHwYe7mf3FfFcaXKCDOvxpI8Pj58OaAPGisq8XMiQfX7jK2g8gGS4GZSZTBfv+Fs1o+UgQlW3lp1wKc9IaBOTG85WmaxsxTOYv2vBAPpPBJVupt8fvXTzP3Qs3x0kdxYbhxtVKrV6J5syyc87/HcC6oCMlZYH8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479009; c=relaxed/simple;
	bh=dB2fTciNH7C99yeMCkwymMBnv0h1RnzHu+mZrclazpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ewk/G/0PToW8eCWcrFWV51Rqa9HWCjV18VbAEZXCesb/4WJ6MOMb+3FN7eNCPfe6D5F+kcutNaXz1NPpIAn/SM4MXiJTH9JO0KpKg9pB2Yh8M+KwCXrhlMe0TRGMMrHIPHADI2m0o1SQ8zpsMOeeFlFNGn9SjKMmJPZhGF23z+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wzv93lRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wzv93lRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C326EC32782;
	Mon, 12 Aug 2024 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479009;
	bh=dB2fTciNH7C99yeMCkwymMBnv0h1RnzHu+mZrclazpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wzv93lRHTaUCItg6Os87E7pK+V+yov7ezMj8bJGJJdWcg6TYFBb0LpfMweb0NiZze
	 u5qe7HUuK96EqJMq5/xGq2JECB54BaoX4CsU8JGF7Xp+B/X1yjPmKbFkMvbOKgqn+A
	 TOA5yl+Sxpbf+7MEKgT2TpOfy4fDEOC3CRvmIA/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/150] clocksource: Fix brown-bag boolean thinko in cs_watchdog_read()
Date: Mon, 12 Aug 2024 18:03:06 +0200
Message-ID: <20240812160129.214262378@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit f2655ac2c06a15558e51ed6529de280e1553c86e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 6d5a0fc98e398..cd9a59011dee9 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -235,7 +235,7 @@ static enum wd_read_status cs_watchdog_read(struct clocksource *cs, u64 *csnow,
 		wd_delay = clocksource_cyc2ns(wd_delta, watchdog->mult,
 					      watchdog->shift);
 		if (wd_delay <= WATCHDOG_MAX_SKEW) {
-			if (nretries > 1 || nretries >= max_retries) {
+			if (nretries > 1 && nretries >= max_retries) {
 				pr_warn("timekeeping watchdog on CPU%d: %s retried %d times before success\n",
 					smp_processor_id(), watchdog->name, nretries);
 			}
-- 
2.43.0



