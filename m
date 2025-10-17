Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2EA369972;
	Fri, 17 Oct 2025 15:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713332; cv=none; b=eiS6m9CbKs5QG5bIamGvjcWrYAAcFlbleeojumI0+3Km/57aFRxvz7Vi/u51vmMgLB8J6APX4Q7c1SngeU5fcIMRzYDvHsxeSau8V4JHiOp9XAvFKPpmVT77BM0kT4B5AtqTwdrg2YJlUzuWS+OoNySQFA/4RYaYHRcwBEm6eBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713332; c=relaxed/simple;
	bh=wKUCKRWQsjHMwfCRfKCk10zPekclzcT9t2QV/INLCAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vo7m8PLYUDyRKCNs2X3UcB63pv3GFA6flrGTnL7PMG4AbWW4GrDTKjEf8jfJ3/oqib6Z57QCi4CNPJJzmrok/yq/sb5gGGT6p9QAnwlMX7FGkSgM8qO45KnCh5w9KHeFnJaxcsJgPBV/dLbFr8QYeKCEbHjg68e3t76BUaVzDj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Kf5VeCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Kf5VeCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D26AC4CEE7;
	Fri, 17 Oct 2025 15:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713331;
	bh=wKUCKRWQsjHMwfCRfKCk10zPekclzcT9t2QV/INLCAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Kf5VeCnR8tC1cGH8AmEQS7TiKNzMGQlZMAbm125b68VnjyCgsjj2uETBNUhfVtRv
	 vB/szz4hOahvcFzM2CKDHL5W12aOBOvnM/OxHnf/8LFE3kV+Rd8v1GGMSiRg7N6nDx
	 8YTx2a/XZB7jmDYPV8wOw8xTwL9+/WzwdH6QdPJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.1 095/168] pwm: berlin: Fix wrong register in suspend/resume
Date: Fri, 17 Oct 2025 16:52:54 +0200
Message-ID: <20251017145132.526764846@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

commit 3a4b9d027e4061766f618292df91760ea64a1fcc upstream.

The 'enable' register should be BERLIN_PWM_EN rather than
BERLIN_PWM_ENABLE, otherwise, the driver accesses wrong address, there
will be cpu exception then kernel panic during suspend/resume.

Fixes: bbf0722c1c66 ("pwm: berlin: Add suspend/resume support")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20250819114224.31825-1-jszhang@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-berlin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pwm/pwm-berlin.c
+++ b/drivers/pwm/pwm-berlin.c
@@ -274,7 +274,7 @@ static int berlin_pwm_suspend(struct dev
 		if (!channel)
 			continue;
 
-		channel->enable = berlin_pwm_readl(bpc, i, BERLIN_PWM_ENABLE);
+		channel->enable = berlin_pwm_readl(bpc, i, BERLIN_PWM_EN);
 		channel->ctrl = berlin_pwm_readl(bpc, i, BERLIN_PWM_CONTROL);
 		channel->duty = berlin_pwm_readl(bpc, i, BERLIN_PWM_DUTY);
 		channel->tcnt = berlin_pwm_readl(bpc, i, BERLIN_PWM_TCNT);
@@ -305,7 +305,7 @@ static int berlin_pwm_resume(struct devi
 		berlin_pwm_writel(bpc, i, channel->ctrl, BERLIN_PWM_CONTROL);
 		berlin_pwm_writel(bpc, i, channel->duty, BERLIN_PWM_DUTY);
 		berlin_pwm_writel(bpc, i, channel->tcnt, BERLIN_PWM_TCNT);
-		berlin_pwm_writel(bpc, i, channel->enable, BERLIN_PWM_ENABLE);
+		berlin_pwm_writel(bpc, i, channel->enable, BERLIN_PWM_EN);
 	}
 
 	return 0;


