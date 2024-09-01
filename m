Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E5E44C97;
	Sun,  1 Sep 2024 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207704; cv=none; b=DJp3Sw1hs4Bm3rirUCDft4yV9RtBxScF/GlW7bnOXfQnHJwve322XSQsWckgGxx2Nxy/9qrJ7LyYK/mOjLjwSI+8vM2h818hf/GSQzJta+NPKVLiT8HsEjz4Rf/KKvLLPMBufa1US8p1WRA5xxBhUkXi+mNjNZlQDpN4zETvI3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207704; c=relaxed/simple;
	bh=jrL/fZ+RD4vOMmnxX1VGyeuonQRqpmd1JvkV10lP1K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9cxYFbUlJgdM73cp04BXPDN3DeRKJ/B0fx4KdRy91FTUiZ9MHScZZkOuimm3V/77Tm+UwvwnQjutMpm56ya8FET9z+bRp2raqQKGUIDFy8ImycxZo57RHS7sAwBp0xgHHZKPlOERiWRxe/b6IH1xn74Ucj9bI6dfLMWDVY7s0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSrsHQbu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSrsHQbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A515C4CEC3;
	Sun,  1 Sep 2024 16:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207704;
	bh=jrL/fZ+RD4vOMmnxX1VGyeuonQRqpmd1JvkV10lP1K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSrsHQbuCsIpcaIQqbXZQJd5IHIUOeeWjxUTyNeXIzVcbtPwlfZVQU3cHnFvT/+1z
	 Ci7LwqgHejoivgIzbRpOJ4kLl39YoTzbBc0dCnHjynNEKwGEuJaXCqaoZHg09Xxgii
	 7WlesHNzsL5En74hbaQtJjcouSbzXwHdiC8sKhBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Chang <phil.chang@mediatek.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 51/98] hrtimer: Prevent queuing of hrtimer without a function callback
Date: Sun,  1 Sep 2024 18:16:21 +0200
Message-ID: <20240901160805.624963222@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Chang <phil.chang@mediatek.com>

[ Upstream commit 5a830bbce3af16833fe0092dec47b6dd30279825 ]

The hrtimer function callback must not be NULL. It has to be specified by
the call side but it is not validated by the hrtimer code. When a hrtimer
is queued without a function callback, the kernel crashes with a null
pointer dereference when trying to execute the callback in __run_hrtimer().

Introduce a validation before queuing the hrtimer in
hrtimer_start_range_ns().

[anna-maria: Rephrase commit message]

Signed-off-by: Phil Chang <phil.chang@mediatek.com>
Signed-off-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 0eb5b6cc6d939..b600dc1290d7e 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1172,6 +1172,8 @@ void hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	struct hrtimer_clock_base *base;
 	unsigned long flags;
 
+	if (WARN_ON_ONCE(!timer->function))
+		return;
 	/*
 	 * Check whether the HRTIMER_MODE_SOFT bit and hrtimer.is_soft
 	 * match.
-- 
2.43.0



