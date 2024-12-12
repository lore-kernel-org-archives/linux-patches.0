Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D02121765E;
	Thu, 12 Dec 2024 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017472; cv=none; b=fRN/fod2lKpvsD4bRMj+HCzHJ4Yx8t3ykIAJoWspVxIfhFQG7ZjQU2XNZhKdUTr9yYxZt6kjwT3t6XTzKASTi7yMeEiYL7wW4LAL5yeeyh4Y0WV9FnfqgjjxoJpg1+iivrYc+mO+E2gq/r6DdzquKtnMiR6fIz4BBEyzh9NoG/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017472; c=relaxed/simple;
	bh=Mz0u0Jgp++5M9UGZCMQXySy0zx2rONY+8vNtb4nEsX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNsAv3llaanpNjubPUyTV/twovRqLglmwltkDqFMIa31mlJD78vsmt/6jh15wF2t+YEhfKyCpJNPfX2vIQLF0FE9K7dls3jHJOAXwRMu8LZvVOE3Ab3na6N4Z/ItoZJ/MQAN8Y30rJOfQYg7LN10m/m9D3VXiwH8ETDV84NqzAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CT3xYFqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CT3xYFqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D1AC4CECE;
	Thu, 12 Dec 2024 15:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017471;
	bh=Mz0u0Jgp++5M9UGZCMQXySy0zx2rONY+8vNtb4nEsX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CT3xYFqVbdaN+D3arhc/8c+/F/fDDDmVMiLsnmvUtYhbY9WcZKbZLbWrrOaLIt0Vs
	 vhlKgTKibtWr3LLXIxGs4/w4QhADJeyRrPw9u80RpULlSca47B9BOrEwrkdWC+oOEu
	 0vviO3OcyoJmSZiu9G4bCe7m/B6SOd7oIPR2HDOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/356] ptp: Add error handling for adjfine callback in ptp_clock_adjtime
Date: Thu, 12 Dec 2024 15:55:41 +0100
Message-ID: <20241212144245.496590417@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Ajay Kaher <ajay.kaher@broadcom.com>

[ Upstream commit 98337d7c87577ded71114f6976edb70a163e27bc ]

ptp_clock_adjtime sets ptp->dialed_frequency even when adjfine
callback returns an error. This causes subsequent reads to return
an incorrect value.

Fix this by adding error check before ptp->dialed_frequency is set.

Fixes: 39a8cbd9ca05 ("ptp: remember the adjusted frequency")
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://patch.msgid.link/20241125105954.1509971-1-ajay.kaher@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 9a50bfb56453c..b586da2e30023 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -133,7 +133,8 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 		if (ppb > ops->max_adj || ppb < -ops->max_adj)
 			return -ERANGE;
 		err = ops->adjfine(ops, tx->freq);
-		ptp->dialed_frequency = tx->freq;
+		if (!err)
+			ptp->dialed_frequency = tx->freq;
 	} else if (tx->modes & ADJ_OFFSET) {
 		if (ops->adjphase) {
 			s32 max_phase_adj = ops->getmaxphase(ops);
-- 
2.43.0



