Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B851BFE06;
	Tue, 27 Aug 2024 14:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770255; cv=none; b=a4naCRcrp2DIv3/8JjU3kE70NtRBJiO9FBHGMOKlZVdvi0/QhPjS+L/NiroG704qijA+rvSG2aedsrTuPWMBHXctdX/f9DDfYaspCQaEuumgdPQDIE9TletZ9nLchGy+mz0gzqCOrtcud9Ao49ALYvO+3iw8oRUH0rgoEJ1ordY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770255; c=relaxed/simple;
	bh=liy07P7h9/HoONRzuNApgpPUNTc29OsjRQCo4tRqrqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u06+BRH/liXSgv5cfWRY5JkeCs1Gg71guIAQOT6Ngg5EfAn+etxDeSLl+H+EByb76TdQzFkV+LCqTW3dD0yhjQcxVkUmV2D3Xf6o8G48z2svGEz0THGsIBDfdZnOblq/ohPB+qah8h4mzf86JkNDZPLpobuJ7mXzm7Gu2+3gQTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujCG/pQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujCG/pQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB1BC4DDFF;
	Tue, 27 Aug 2024 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770254;
	bh=liy07P7h9/HoONRzuNApgpPUNTc29OsjRQCo4tRqrqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujCG/pQdkkFe+FFJ9IcyfMfaAOoy/2mtubje8yjs/de3nIkfAecaVcKdZeyC8+xKq
	 8uDwDiNu8ZgjcPzzPHBDt4JI+tKPNv7W20prRAgxyykUDehQL/eeKIhisryh8NG+11
	 70nmvsmfUgVLy+Ijv4827C592ajnRvK9zwi9lP2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/341] clocksource/drivers/arm_global_timer: Guard against division by zero
Date: Tue, 27 Aug 2024 16:36:44 +0200
Message-ID: <20240827143849.997585874@linuxfoundation.org>
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

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit e651f2fae33634175fae956d896277cf916f5d09 ]

The result of the division of new_rate by gt_target_rate can be zero (if
new_rate is smaller than gt_target_rate). Using that result as divisor
without checking can result in a division by zero error. Guard against
this by checking for a zero value earlier.
While here, also change the psv variable to an unsigned long to make
sure we don't overflow the datatype as all other types involved are also
unsiged long.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20240225151336.2728533-3-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/arm_global_timer.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
index e1c773bb55359..22a58d35a41fa 100644
--- a/drivers/clocksource/arm_global_timer.c
+++ b/drivers/clocksource/arm_global_timer.c
@@ -290,18 +290,17 @@ static int gt_clk_rate_change_cb(struct notifier_block *nb,
 	switch (event) {
 	case PRE_RATE_CHANGE:
 	{
-		int psv;
+		unsigned long psv;
 
-		psv = DIV_ROUND_CLOSEST(ndata->new_rate,
-					gt_target_rate);
-
-		if (abs(gt_target_rate - (ndata->new_rate / psv)) > MAX_F_ERR)
+		psv = DIV_ROUND_CLOSEST(ndata->new_rate, gt_target_rate);
+		if (!psv ||
+		    abs(gt_target_rate - (ndata->new_rate / psv)) > MAX_F_ERR)
 			return NOTIFY_BAD;
 
 		psv--;
 
 		/* prescaler within legal range? */
-		if (psv < 0 || psv > GT_CONTROL_PRESCALER_MAX)
+		if (psv > GT_CONTROL_PRESCALER_MAX)
 			return NOTIFY_BAD;
 
 		/*
-- 
2.43.0



