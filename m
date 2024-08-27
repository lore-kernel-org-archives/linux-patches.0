Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1211D1731;
	Tue, 27 Aug 2024 15:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772517; cv=none; b=VlHdXv0zr6ZwdZCZcbbCmY5AhF+BVq6lGb7uRB8dhFrHkTuKF06iJiW/h9Vxyzp5/oc6Z3zpGBjJo8pEJhQLD/P2Ts1knKx0gDv/KEgyoC8SfKL9wS/jPXQe3VRnwhPdqu9na4qr0QCQcqOhfjrNIXy0LkiZUa/J2kmU/AO5vhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772517; c=relaxed/simple;
	bh=yuQMb2Q388Ax6PCo/TRlAw3EtxuNRffsVK343qsn3O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puOMQYnx2gh28etK+Mzb6Ys4sSJLB00sYltDg61cW3VKcHc2ozuDUQzkr5cvh1v8boEWMKLVh+HAm6NweibaVzkqDMjDCRyJULJUiT+eTw8POECCUHt3N3NndIzEGF9BEbwNimiy8k60BoGLSVDQNDP9ejblfvUirybyMt+mfC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJWBI2Dj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJWBI2Dj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA96EC61067;
	Tue, 27 Aug 2024 15:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772516;
	bh=yuQMb2Q388Ax6PCo/TRlAw3EtxuNRffsVK343qsn3O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJWBI2DjHEVYKOlxbUafiNPJqep40q7/5tU2ofWT6C8Z+9yrqwEVO5FNfOdoGnquO
	 3D39y13z6WkvxKOnJiX86ifUD8v+f3CWI0AAG4tYdlGGLu7TTad/YPEnTcSOztAHTz
	 s472DiP+c0ciK9Eblt6FmeA+0D9hdbMcsH+XRBuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Chang <phil.chang@mediatek.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/321] hrtimer: Prevent queuing of hrtimer without a function callback
Date: Tue, 27 Aug 2024 16:38:35 +0200
Message-ID: <20240827143846.112996107@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index 314fb7598a879..f62cc13b5f143 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1285,6 +1285,8 @@ void hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	struct hrtimer_clock_base *base;
 	unsigned long flags;
 
+	if (WARN_ON_ONCE(!timer->function))
+		return;
 	/*
 	 * Check whether the HRTIMER_MODE_SOFT bit and hrtimer.is_soft
 	 * match on CONFIG_PREEMPT_RT = n. With PREEMPT_RT check the hard
-- 
2.43.0



