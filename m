Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62E735505D;
	Tue,  6 Jan 2026 17:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720302; cv=none; b=ut3TkBtI0ILojGcBbWZFTzmg5okXNkt+y4VJ3ykCZDZkHkA2ub8d7GSI/0fBzTtHRtpopPfnyNN0ShK99l2Ne6msyqIP5XuhCSmqUqDsqSt7RZsfxCF23Fw+T9R6pm6pCqsZPBU94LXuofI2R92xSgWDR6+0Kt5Y0CJ/va7HKjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720302; c=relaxed/simple;
	bh=/CabtWzGuIrssOoJxPUxR9sia9POz63jBqC/UEOh288=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0ikNghufMyA7LqZP+0nPpPmlfpe+xGqK+Bj1lMu/SO8z2sUsfh4jDen8Kgs+1ITIBELAPwCMCzWtn6mnPdfMR1yigO2ZQgpf+lRtbR93+rJQhGgpXL5mUlG3xxH9pTyIL3+tkJzsFpZmLf1oOZ3x7hGhK2wDzJWhHNEwQBulfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKc4DVoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKc4DVoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6D0C116C6;
	Tue,  6 Jan 2026 17:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720302;
	bh=/CabtWzGuIrssOoJxPUxR9sia9POz63jBqC/UEOh288=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JKc4DVoVVhjP1KexzAsdpPnKyhms0TWO5VMwTsOUJYAtb/dl/xpsQ0kWwqre6Gzpr
	 pwDIpWgvpMFx8m1vhKMaVG+ZCRSIUgc5vpLymcm5zThNU4LLx7wJZKdG5b1wD1ameY
	 xdJBD6IT7jt5cyg4a1D+mzoATaJknPotAKlTrnUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>
Subject: [PATCH 6.12 195/567] cpuidle: governors: teo: Drop misguided target residency check
Date: Tue,  6 Jan 2026 17:59:37 +0100
Message-ID: <20260106170458.538741711@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit a03b2011808ab02ccb7ab6b573b013b77fbb5921 upstream.

When the target residency of the current candidate idle state is
greater than the expected time till the closest timer (the sleep
length), it does not matter whether or not the tick has already been
stopped or if it is going to be stopped.  The closest timer will
trigger anyway at its due time, so if an idle state with target
residency above the sleep length is selected, energy will be wasted
and there may be excess latency.

Of course, if the closest timer were canceled before it could trigger,
a deeper idle state would be more suitable, but this is not expected
to happen (generally speaking, hrtimers are not expected to be
canceled as a rule).

Accordingly, the teo_state_ok() check done in that case causes energy to
be wasted more often than it allows any energy to be saved (if it allows
any energy to be saved at all), so drop it and let the governor use the
teo_find_shallower_state() return value as the new candidate idle state
index.

Fixes: 21d28cd2fa5f ("cpuidle: teo: Do not call tick_nohz_get_sleep_length() upfront")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/5955081.DvuYhMxLoT@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/governors/teo.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -462,11 +462,8 @@ static int teo_select(struct cpuidle_dri
 	 * If the closest expected timer is before the target residency of the
 	 * candidate state, a shallower one needs to be found.
 	 */
-	if (drv->states[idx].target_residency_ns > duration_ns) {
-		i = teo_find_shallower_state(drv, dev, idx, duration_ns, false);
-		if (teo_state_ok(i, drv))
-			idx = i;
-	}
+	if (drv->states[idx].target_residency_ns > duration_ns)
+		idx = teo_find_shallower_state(drv, dev, idx, duration_ns, false);
 
 	/*
 	 * If the selected state's target residency is below the tick length


