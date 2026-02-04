Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8AB427A1D;
	Wed,  4 Feb 2026 15:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217682; cv=none; b=ewaFq3a1Zq3xthMiQztOc3BrWDzrHEqEBCHpuhC48wHHsPLT4NDcZ2UG7i8ciLuOJKuQH6oxiXFFndaD/vBEe1yp14mwBUdmIoS7yWBuVFy+d424XJQatsDGRNFUU+ezE73akYirTOJRDdJGUfz9GDxjwO8tWn2PQs7aZBpPhxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217682; c=relaxed/simple;
	bh=dDRnssuYxhmEYgPtycoRVaaCVGBlIe4nQWgS+G6XLLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OO3YQNw8dpuRYw3/dVWeazX0zazs/86G3l0c0Q0vy/gmYMUSgK2FGEdiF2iRZJaVhoc2v4NDWaVk+m7LPMtscCzoT5NMo8m2vQUKVglpKoZPZ3kKI5S/9FMb7M86qJXMlt0EUBepmzWvEFYtOTsqu21crnX2OK4VDKLix8yxg30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvbN95uj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvbN95uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F36C4CEF7;
	Wed,  4 Feb 2026 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217682;
	bh=dDRnssuYxhmEYgPtycoRVaaCVGBlIe4nQWgS+G6XLLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvbN95ujkcg5YwkEiMbFRBvTRbjKbeFqaWSQONJIZvFDo3CHLSemGlx5xhpQ3piGq
	 +ZSPUQHSL+it8btTB2yr6qrL7BJw+/UI+X3jaYygKdqXNsovMpLtoAfhCwDxU1IoaS
	 RMg1K54xE7WQvvZOw1tzH9/u+1iVy5n/BLUePhb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.1 054/280] hrtimer: Fix softirq base check in update_needs_ipi()
Date: Wed,  4 Feb 2026 15:37:08 +0100
Message-ID: <20260204143911.594555051@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 05dc4a9fc8b36d4c99d76bbc02aa9ec0132de4c2 upstream.

The 'clockid' field is not the correct way to check for a softirq base.

Fix the check to correctly compare the base type instead of the clockid.

Fixes: 1e7f7fbcd40c ("hrtimer: Avoid more SMP function calls in clock_was_set()")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260107-hrtimer-clock-base-check-v1-1-afb5dbce94a1@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/hrtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -939,7 +939,7 @@ static bool update_needs_ipi(struct hrti
 			return true;
 
 		/* Extra check for softirq clock bases */
-		if (base->clockid < HRTIMER_BASE_MONOTONIC_SOFT)
+		if (base->index < HRTIMER_BASE_MONOTONIC_SOFT)
 			continue;
 		if (cpu_base->softirq_activated)
 			continue;


