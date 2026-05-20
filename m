Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546D6370D54;
	Wed, 20 May 2026 18:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300051; cv=none; b=uPd1ehpTa5rkBD1luHUO1doaNlAJf2mnR0dXpSP7X2oPAAKEG0C69c68w2rF40aA/wcjFlzSpIO9WY8pte+YYoP45tlQzeoxAsINGpq5PyRj1arGYs/98mNsQrf/eTgCPY/7Y+I0fTyoe97qRdv1+n3lOkHXeaig6t4Mi8n1teU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300051; c=relaxed/simple;
	bh=gYfWmRvTbesSpwXUY6OkVJy8kDiFXsDPbPrLDH+ziws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3S6Y0r5O9uUL65rBIHt+RAXLT6e+mAFgnNnGiBNk+103QDRDEdMYQnvk98N7XDJ7O+5jBUQD0Esy8TweGJVJNzvVFr9xSLN5YuiykN/xZy4lbwtEtAOxEjBhiDvhbHXHgTLLDg4/BQlUVenpNIYMybzGy49gLgrUec3WKhxXw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dq5oS85; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dq5oS85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA801F000E9;
	Wed, 20 May 2026 18:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300050;
	bh=BL/rw0hstJAjRAimXLCrl4K6riIbG4JoAESkvi75ZTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0dq5oS85jvuLgAKd6YG75W6vI72JejivX/pBG0d+EWGK2h9nc9cTPO5zxVIhr8Kxc
	 UnIF3925voIbmRF2Bie+5Me7hiXGh4VQG4nkJ9U469M2VS+p3eimcp8Q9LDrNVb20f
	 oQ/nBMshzWrpS68Irj3RGxQiaOO9TmSQhgXceLl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/666] hrtimer: Avoid pointless reprogramming in __hrtimer_start_range_ns()
Date: Wed, 20 May 2026 18:13:59 +0200
Message-ID: <20260520162111.845623129@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit d19ff16c11db38f3ee179d72751fb9b340174330 ]

Much like hrtimer_reprogram(), skip programming if the cpu_base is running
the hrtimer interrupt.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260224163429.069535561@kernel.org
Stable-dep-of: f2e388a019e4 ("hrtimer: Reduce trace noise in hrtimer_start()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 6abd0d2807f5d..343c7e4008aba 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1279,6 +1279,14 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	}
 
 	first = enqueue_hrtimer(timer, new_base, mode);
+
+	/*
+	 * If the hrtimer interrupt is running, then it will reevaluate the
+	 * clock bases and reprogram the clock event device.
+	 */
+	if (new_base->cpu_base->in_hrtirq)
+		return false;
+
 	if (!force_local) {
 		/*
 		 * If the current CPU base is online, then the timer is
-- 
2.53.0



