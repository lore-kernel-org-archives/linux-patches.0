Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F8C29CA;
	Mon, 12 Aug 2024 16:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479672; cv=none; b=as/4mAaQigSEczObega9STTStPtd2Fjk8RywLJek40nM0z7p9uFUVYMYYe7YCjw7DsWVGIuiJJrX1AOL92zTQKz6r6oDSTnSb5DjcwhxiWfFL+NTnTzCqoaQcOIsueAqiFMwJtRsEQrtlWlLRtu4PwtqzfkPkdD6g4JfR0bOFck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479672; c=relaxed/simple;
	bh=UQz1UnJXPsKu2HMt2KidjApKrGtsaAFJleZl8g/FN90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNiBOaxRnEDH7/GYy63XNfC/XheUvx0g34A7bCRR4Ci3fLUZF3pAj74Mwqp7ApTk1o2NYJJ3pUTFe6ngGBNer6qAXxAO/ea+LbhmjnsHFV3si1XzJ3he8Rm/evTQwz86ATG96XHoLi0Yz4Aq2Wuuk1g1CyqrtkjeLpbxiwlAlfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4QDqVCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4QDqVCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ACEC32782;
	Mon, 12 Aug 2024 16:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479672;
	bh=UQz1UnJXPsKu2HMt2KidjApKrGtsaAFJleZl8g/FN90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4QDqVCKDSGGLFoE/Q498v13PhnuTj88qznhBvm5pqoEdmLh6tbtQ/ktifhZ5s9pW
	 zpQvURP5CxpmOpD4ktKXPqnd3k4XqaKGlT1okWnYLp1NM6lrv86lMAvIdZyT1uUyjm
	 PbwC2fJ9GTjahlVsniPurvh55IBLMeZJOqjahUpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/189] clocksource: Fix brown-bag boolean thinko in cs_watchdog_read()
Date: Mon, 12 Aug 2024 18:03:06 +0200
Message-ID: <20240812160137.148721790@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c95080f005dd4..3260bbe98894b 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -238,7 +238,7 @@ static enum wd_read_status cs_watchdog_read(struct clocksource *cs, u64 *csnow,
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



