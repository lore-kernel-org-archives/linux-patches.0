Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429D0314A74;
	Tue, 16 Dec 2025 12:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888101; cv=none; b=fG8UkXJO+bdRX785uwfWw8QRmhN6kuYWXewksq86yJCJNtVkfyJqBANgOUy0iR/KL1qLB64u//T649SKTCJh3DEqFodamjYZzO6jy3yTopPuDb18p/kl2SivmoeVMyPbN7c3F4n5WOuLGVERZ3MON+76D0TpB2yFMtpsxYsXvnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888101; c=relaxed/simple;
	bh=yztUb649o0Mqd+a12EeRKeCaszznhmi+Wv+FvxB5HNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPU5XiTGyWvEJeH17hWimhsfE6Recv27TSTxyu6SNnUD50fueSfsnxZoLFHC0aojOQSU/weTvV/NkxN2CWW4+7VkxwBO1yxRnbclBttozoTmf2cDg1C81eALn7HNTbbGsv63c4aeWy6H4Ky41UHmOYKW+BkbIRXItRTW5Swhi84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACoho7Yn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACoho7Yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DAAC4CEF1;
	Tue, 16 Dec 2025 12:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888101;
	bh=yztUb649o0Mqd+a12EeRKeCaszznhmi+Wv+FvxB5HNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACoho7YnpGResg70NKQ9YUSWQm4a9ddzN7plpQEAzykfIJePKZVDBggEjbYe5HuRA
	 jv0Jv9E8UlU9UJj/LRo3TdIf5J6g+vNfgnNeDag3sbD7p3t0kaXZOq/gSPdRmKTZHE
	 YIsqilkKkIv8GoP6VFHYlZnWW1dSHVMJjNTYVAw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 433/614] clocksource/drivers/stm: Fix double deregistration on probe failure
Date: Tue, 16 Dec 2025 12:13:20 +0100
Message-ID: <20251216111417.062352691@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 6b38a8b31e2c5c2c3fd5f9848850788c190f216d ]

The purpose of the devm_add_action_or_reset() helper is to call the
action function in case adding an action ever fails so drop the clock
source deregistration from the error path to avoid deregistering twice.

Fixes: cec32ac75827 ("clocksource/drivers/nxp-timer: Add the System Timer Module for the s32gx platforms")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20251017055039.7307-1-johan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-nxp-stm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clocksource/timer-nxp-stm.c b/drivers/clocksource/timer-nxp-stm.c
index bbc40623728fa..16d52167e949b 100644
--- a/drivers/clocksource/timer-nxp-stm.c
+++ b/drivers/clocksource/timer-nxp-stm.c
@@ -208,10 +208,8 @@ static int __init nxp_stm_clocksource_init(struct device *dev, struct stm_timer
 		return ret;
 
 	ret = devm_add_action_or_reset(dev, devm_clocksource_unregister, stm_timer);
-	if (ret) {
-		clocksource_unregister(&stm_timer->cs);
+	if (ret)
 		return ret;
-	}
 
 	stm_sched_clock = stm_timer;
 
-- 
2.51.0



