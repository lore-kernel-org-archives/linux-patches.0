Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A392C262BE;
	Mon, 27 May 2024 19:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838086; cv=none; b=QiRJ6Z4MZ5i4/Jhx8ErnqZhw3INlmjbbwNFj3oKffLoTXQ+/ADsDkd4zcs/FwQiTXqFMjCZfeai8igZp9HJG52dp4LraZTnkR2VYktpdza2z4+LUZPLPov5Qm2JQd4RUxE0dnmaNNTodn9ZsdnyLP8NP2A1kcD+sL/hM14VD1cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838086; c=relaxed/simple;
	bh=4dZaORMtH93wf3a6nBNax1zvN9KTGrVfhPfmXl0/6ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LvCnkd+0k8YlpTGb+fvBgFELMBf7FPhaOQ8tGL6G4WGpONrauKRcFhIl6k78ncDvB4btxqMX8aOc6vgQywewFhpGdtTN+kip+ccgtLUCdkmmwdEe6r/GruEAax/rOjSB5AiZ58RTAdS56jFuckZQ9qmizzPq4/XKF4+p4QY5CFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lh+WFmh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lh+WFmh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A46BC2BBFC;
	Mon, 27 May 2024 19:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838086;
	bh=4dZaORMtH93wf3a6nBNax1zvN9KTGrVfhPfmXl0/6ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lh+WFmh0iP0fAe26Giu1FzvBLr5cywNs+XnvyeVeutZnr3NGameVAFwGlHLQV3fG/
	 Ze6XoyK4kD+yi06GjsELQ/dSSqsB78DmB5j/cQWYKDb4VyChB+42zaUc7CgzdiD44n
	 lPRMepWhQI59QEqNsMWCYX46bfFf20Ua02MCimyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 259/493] pwm: Drop duplicate check against chip->npwm in of_pwm_xlate_with_flags()
Date: Mon, 27 May 2024 20:54:21 +0200
Message-ID: <20240527185638.765219332@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 91bb23493f8fd115e362d075ebaa3e6f12d1439d ]

args->args[0] is passed as parameter "index" to pwm_request_from_chip().
The latter function also checks for index >= npwm, so
of_pwm_xlate_with_flags() doesn't need to do that.

Link: https://lore.kernel.org/r/b06e445a6ed62a339add727eccb969a33d678386.1704835845.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Stable-dep-of: 3e551115aee0 ("pwm: meson: Add check for error from clk_round_rate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 606d9ef0c7097..b025d90e201c9 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -111,9 +111,6 @@ of_pwm_xlate_with_flags(struct pwm_chip *chip, const struct of_phandle_args *arg
 	if (args->args_count < 1)
 		return ERR_PTR(-EINVAL);
 
-	if (args->args[0] >= chip->npwm)
-		return ERR_PTR(-EINVAL);
-
 	pwm = pwm_request_from_chip(chip, args->args[0], NULL);
 	if (IS_ERR(pwm))
 		return pwm;
-- 
2.43.0



