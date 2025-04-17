Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA72256C7C;
	Thu, 17 Apr 2025 18:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912992; cv=none; b=XqVCvYjUGFcKRUMRASlMQPY/SvRXXqqhoQPlrXUDp5ynxqgSHssEjr24HDkUBeCCU9KyjozXv+HB57rkWkGrgYOpfJynT2ZohR0rQm63nGhwKkMndj7Fvdfok7sc5vlQRSoIQGRh0k6pKCNmwExh06j8rW5mHh+5+qpIp+JuMyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912992; c=relaxed/simple;
	bh=XqFWkeWV89ggUUrkRY8eR39/tvLqCA3SlmMZy8PLOAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J2i7EVrjcLe1G8fjU5+YKjcyCxt3DRbBHky1ynDYJcpLTtMjcAlL93XrUYJSKVZ2hDSNoXjcZjm4eO1aeQpuq3doSbFMDk5Lk3mcQxgBPCegfjgciGT5SjPsBJg9CpsTDlscnTe8lvyKWule5YS6olSRdr2VdRZnLr6cpEQwD/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfBMy91s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfBMy91s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E61C4CEE4;
	Thu, 17 Apr 2025 18:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912992;
	bh=XqFWkeWV89ggUUrkRY8eR39/tvLqCA3SlmMZy8PLOAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfBMy91sao0B6v170VPi4uWzzGAQMP0ljE0Vj1DTH7RLWKsG4o2YsMfoBA7OIsoRV
	 cksQNVj2RjgQBWc0RBLX5FpUQaiFGS/av1kzZjIjdKYmSShdZGSAnJ5uC8d1EwjScf
	 SBfuetyEl1hsoh553UslugrUfqCgvIqaGrf+RO/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 191/449] pwm: stm32: Search an appropriate duty_cycle if period cannot be modified
Date: Thu, 17 Apr 2025 19:47:59 +0200
Message-ID: <20250417175125.662121646@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit fda6e0034e9da64e1cec31f4539b6c7abd9ed8be ]

If another channel is already enabled period must not be modified. If
the requested period is smaller than this unchangable period the driver
is still supposed to search a duty_cycle according to the usual rounding
rules.

So don't set the duty_cycle to 0 but continue to determine an
appropriate value for ccr.

Fixes: deaba9cff809 ("pwm: stm32: Implementation of the waveform callbacks")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/f0c50df31daa3d6069bfa8d7fb3e71fae241b026.1743844730.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/pwm/pwm-stm32.c b/drivers/pwm/pwm-stm32.c
index a59de4de18b6e..ec2c05c9ee7a6 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -103,22 +103,16 @@ static int stm32_pwm_round_waveform_tohw(struct pwm_chip *chip,
 		if (ret)
 			goto out;
 
-		/*
-		 * calculate the best value for ARR for the given PSC, refuse if
-		 * the resulting period gets bigger than the requested one.
-		 */
 		arr = mul_u64_u64_div_u64(wf->period_length_ns, rate,
 					  (u64)NSEC_PER_SEC * (wfhw->psc + 1));
 		if (arr <= wfhw->arr) {
 			/*
-			 * requested period is small than the currently
+			 * requested period is smaller than the currently
 			 * configured and unchangable period, report back the smallest
-			 * possible period, i.e. the current state; Initialize
-			 * ccr to anything valid.
+			 * possible period, i.e. the current state and return 1
+			 * to indicate the wrong rounding direction.
 			 */
-			wfhw->ccr = 0;
 			ret = 1;
-			goto out;
 		}
 
 	} else {
-- 
2.39.5



