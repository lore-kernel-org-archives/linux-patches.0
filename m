Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C58191F98;
	Wed, 28 Jan 2026 15:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614194; cv=none; b=eiug8+mW+97M7nG4vxdgyaUNWegYiOiZ9KhHW9kEhaayvSLmYPiHrKgCwgsk+qZIx0ZP1Hfy8A3OGJVGDj1nB7i90FV2khQz7L6KcMw9RcV/aVC6RtG/vN5WLPdHdfwtkaPs3Hm9tWCjHi89h/uX/FOtkD8u/miC6bgXrURDuUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614194; c=relaxed/simple;
	bh=Cs6QG+pkwqGerGW2aaDi5KK4LwJGk8QJ/9py+n+ryjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c3eaFzvaNnvqpYXCcfth70q3y+Sh1PcEU4ziHPVfUZsbvA6136gEzmJOHi8ecmOHQUqpItmnF0s6GVCYoa2zvYPE+XhuY3RefVz0JmOL52UMt1vrSNtazotjr/sj/4jlPSwgDQcPg8DLOk/MCUSHfvIW2We5Xhy8I0zr+I4h6Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pC20KIqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pC20KIqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF72C4CEF1;
	Wed, 28 Jan 2026 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614194;
	bh=Cs6QG+pkwqGerGW2aaDi5KK4LwJGk8QJ/9py+n+ryjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pC20KIqYCDq0FEB02JqqwckPxG8MyGOsdVK0TT+nPqmli0+VNuOeDct2yCYRaND5G
	 8qnCVPPRRxBzIamw5vI2lHVzohJnPwj7TqFujIMWtwPfwkHZ/TQc9XWjeAOYf34uPF
	 8P9QSj1SMeiVimx/bprXaNzccbSLQ2HsSuHy7/nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.6 063/254] hrtimer: Fix softirq base check in update_needs_ipi()
Date: Wed, 28 Jan 2026 16:20:39 +0100
Message-ID: <20260128145346.967785131@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -941,7 +941,7 @@ static bool update_needs_ipi(struct hrti
 			return true;
 
 		/* Extra check for softirq clock bases */
-		if (base->clockid < HRTIMER_BASE_MONOTONIC_SOFT)
+		if (base->index < HRTIMER_BASE_MONOTONIC_SOFT)
 			continue;
 		if (cpu_base->softirq_activated)
 			continue;


