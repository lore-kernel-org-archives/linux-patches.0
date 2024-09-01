Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD952C190;
	Sun,  1 Sep 2024 17:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210267; cv=none; b=b2o6fb7U8ln+61rdmDKcJ+4KYa8QKb6IerJ8yy3IrhzZq6TawG6zT/aa3YQt3ChRNmGqMfenJPccXhx2T30DbZemV1dbjJDcK2LhOFb/rqpDTktJTu7MuHQL12yS4HafMimiJJnW0B0CoYVjudvOI8jF2nZDJnkVQf70aHqPiIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210267; c=relaxed/simple;
	bh=iKhzfLRFWydvPdONPyDM0NnREcYykTFS6XuNLio7op8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBAqBti07bcYTFJxVGBwJvauak3PpP8eJOwAswh1eniWrPluJMatmSL7+8Nn1QXxZ+gopc1J2JlPFc73EGltMuUPOSFZmZrvtuk1X907/JMQrWnDCUFV3/8oX2pno+ZhQUemtZZNmuoORFVsmHu41SasyOGGSCuX7Vi4/f6Aw2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIDOT+gr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIDOT+gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE1AC4CEC3;
	Sun,  1 Sep 2024 17:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210267;
	bh=iKhzfLRFWydvPdONPyDM0NnREcYykTFS6XuNLio7op8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIDOT+grmVoKCu4eGDFvUyBIUT9byJJjnn8UevkkRaZ7f/OzKC6pDofr/7VD6y06h
	 Fogui30ZrQP3Nned/0WKiztSUhWbBUQWbIZqPSE81KogqRJ90ov+XL2yWhvOdJMcrD
	 cH5CLQLDpOgYsqf6/hbjNdYfGyEV3DgZvp8/yGMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Chang <phil.chang@mediatek.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/215] hrtimer: Prevent queuing of hrtimer without a function callback
Date: Sun,  1 Sep 2024 18:16:59 +0200
Message-ID: <20240901160827.390170355@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5502c687bd401..bdd9041d595e9 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1284,6 +1284,8 @@ void hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	struct hrtimer_clock_base *base;
 	unsigned long flags;
 
+	if (WARN_ON_ONCE(!timer->function))
+		return;
 	/*
 	 * Check whether the HRTIMER_MODE_SOFT bit and hrtimer.is_soft
 	 * match on CONFIG_PREEMPT_RT = n. With PREEMPT_RT check the hard
-- 
2.43.0



