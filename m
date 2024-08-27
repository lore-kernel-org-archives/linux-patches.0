Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7561C5783;
	Tue, 27 Aug 2024 14:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770399; cv=none; b=kF3Axc7ND41xd5BEL+FDtzDTGYTxbe8EhIwGHs5BvhpukBLnItbGNIbPUh87MW3AGsJ04BX0JaSYkeILme/2Wy7mK+zw0wE+fsvCuj5Ebrb+4hRq3IFT1cLvtoz6LKASarfDvW/hdQL1FzGqoAS2kRnYEfoEVXbDcvIX37NFSvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770399; c=relaxed/simple;
	bh=eIFyzoRTECRsNPE+ln2r6FM4f1nA/rwhduzA8Tu0cEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmA2pEH751wFVHFrkZf0Yp1ySW8qsFP9xncem1eKb/DpDU6cNoxl23wbJ6Bm57yL//YPFqNnNZ4+IiKN1RCPE05ZqWf5LEe6Ktt3c7FebK9EuMZSA9fG9Ic7neV9uYzqhpzV6d5CsDr5akLTi7L3+bHTX4RBUxNHOq9E/zL/Ffk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xj6vAKRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xj6vAKRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F507C61050;
	Tue, 27 Aug 2024 14:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770399;
	bh=eIFyzoRTECRsNPE+ln2r6FM4f1nA/rwhduzA8Tu0cEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xj6vAKRFzYKCx02C8fHlUbef+jMHNIBlpRQcE9Olp3mZNt0UBP0hnXJoIZ4niwNMj
	 WMTOYd+riVWhNXisvf6qSHhoh206pQnfGfTIkhTub9tMIj8IUkkHu2lOWh9wuPvzAd
	 uxODp0Y5wUfO0mmE6/BsxeabpBhS+TDfgk05jMJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Chang <phil.chang@mediatek.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 216/341] hrtimer: Prevent queuing of hrtimer without a function callback
Date: Tue, 27 Aug 2024 16:37:27 +0200
Message-ID: <20240827143851.629573102@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index 6057fe2e179b0..57e5cb36f1bc9 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1288,6 +1288,8 @@ void hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	struct hrtimer_clock_base *base;
 	unsigned long flags;
 
+	if (WARN_ON_ONCE(!timer->function))
+		return;
 	/*
 	 * Check whether the HRTIMER_MODE_SOFT bit and hrtimer.is_soft
 	 * match on CONFIG_PREEMPT_RT = n. With PREEMPT_RT check the hard
-- 
2.43.0



