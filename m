Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8479255248;
	Wed, 21 Jan 2026 18:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019717; cv=none; b=VMTfKo6xfx05ybkKZdhvsBwA085DKuTrZnAr3jhYF7Hdko1OYD9drXEhyJB/rDJDniGFLfOgMH4IfOaxZBZaUdP2P+N485GOT3yVG2aTCnbqrVLcE+w2fdZA73w171jfuZFLKLwQd9RSLc6z6Tf+Ye6V6YRVME9NpMjTy7cJHXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019717; c=relaxed/simple;
	bh=+eUyhK5csae7gmybA4ghPhptsTxrB9MH772UDiToYbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ro/Nn6a/F8/k3uOYTRPauK+bH6upGMemUUBF1xm0USyKZ1fUoio9SBUDqZrIrQkYchNfhJQfwBOt+JHLejN6GDFdopeIjuXR4N+SYq1nBbfQmWx1n9ExfBk/bg1S64j4lamlhBc4+jIVnXVvCI0yU8otKAi/r483nTaWi+X7CgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBnC3edH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBnC3edH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AA7C16AAE;
	Wed, 21 Jan 2026 18:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019717;
	bh=+eUyhK5csae7gmybA4ghPhptsTxrB9MH772UDiToYbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBnC3edHmlR7JLn1az7OpRJBYsqkjd7GEFXjE0c2vLrYYtFPEHpx2iMDa/8cEB9Gi
	 d5HzmcwvbSgBTR9lBCeySUSc5pN9tGnelXuewuVTYgGNeTxWopHe+Fs1MD/T70qKun
	 x68Ud4ylBKPms7LVxLvZNOG9y3vK0onoK2hSpTBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.12 086/139] hrtimer: Fix softirq base check in update_needs_ipi()
Date: Wed, 21 Jan 2026 19:15:34 +0100
Message-ID: <20260121181414.553480990@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -931,7 +931,7 @@ static bool update_needs_ipi(struct hrti
 			return true;
 
 		/* Extra check for softirq clock bases */
-		if (base->clockid < HRTIMER_BASE_MONOTONIC_SOFT)
+		if (base->index < HRTIMER_BASE_MONOTONIC_SOFT)
 			continue;
 		if (cpu_base->softirq_activated)
 			continue;


