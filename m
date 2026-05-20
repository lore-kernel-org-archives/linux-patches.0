Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C9F3F23B7;
	Wed, 20 May 2026 16:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294454; cv=none; b=qzgfxOZkNYL2A/a5lFOG7u2scVIVx/seCi2LuSCwTDB3+S77q2AIH3t/6rRVFPM+fMgPVCcA3suNH8rug1G64Cr6HnY8VsgPBcuBSr+fjSqk3rE9AKaoTVcUiBU+ksz2MRm4jLzaLiKcEPy/AVp/mT61iv93izsBRZX/tRyhA+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294454; c=relaxed/simple;
	bh=2v/xkidaA693bBz9YA2o09f+iXwiHrTr6oyZVSpdjIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFIQYYQMKM5yHySZtIJg30A5CdTQeDX+JONuh58J18cFyU9zIrcEL3ixmmSE0cJXS2V2WMnHYQUPw86Nr3eVr5nJ6C1eQa5ofrxxvoyHy2D2mGWkSO7un4aiBM5a7rSPgEU5AVlzKSDTFbMCgiRxno9PmMVvgXSFR8WC/2UBRSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7wlurm0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7wlurm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41E51F00893;
	Wed, 20 May 2026 16:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294453;
	bh=ccxC7TlZND9IdBit+A/w5SetkyF82XWB/To40/jo16k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7wlurm0b61k/+laBKPmEW9LHg4SLE4GXKKjT/pCnCBmzMmW7riOkoYDs6SdGthxB
	 1narEtSSCsgrJ8ifdmwIZCqViYx3genBnt+uyTWTgrFJGqrsv7yT8yJ/uCnOhJrKuZ
	 +DqzBFRT72i3N5jRcDDirNN9n3Kro8oilbykL8zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0046/1146] hrtimer: Avoid pointless reprogramming in __hrtimer_start_range_ns()
Date: Wed, 20 May 2026 18:04:56 +0200
Message-ID: <20260520162149.421270951@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 1e37142fe52f4..1bbb0a9ff3a23 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1269,6 +1269,14 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
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



