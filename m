Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F264B33438C;
	Mon, 27 Oct 2025 18:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591593; cv=none; b=M9HOobqSsK/2+L0L5aHcKlGHjLZDTR1Wa3YxcskZI7w15qLEqzqXDolK5q7fE75zd9M4Pk8vMDUIfXa8q8JeFxzes34WpGMCN4GAmjiPfLlHgCX+yLroxN/NCrkHUAZl4+BL7p+Dn+omtLBq7tvMqNKMYbA4sRUK1nd9w7We8og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591593; c=relaxed/simple;
	bh=wwFNRXCrC0kwFG0+y717ozY7bgvL31Iwt6BgfklfQsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c822JZVqL9kItsFLfgv1q1ZE9EkTIJXJmnvv3ISRC2gSnZODMwzC1RnDRz/Bu4OvG0SaligM+luJJwDhCl1qbpq7d0YTF99eilYSt1ljP+cZijzXpU9rObz/uq/SsSuJmvDF4eRn0TnAFvcTA0I5i449DqvSpnlKL6NjFyzVu3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsJf5Bd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsJf5Bd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA34C4CEF1;
	Mon, 27 Oct 2025 18:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591592;
	bh=wwFNRXCrC0kwFG0+y717ozY7bgvL31Iwt6BgfklfQsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsJf5Bd7p+VpI3qUBCuS9nUWTC1fmlla/WtnWlvciR4SYHjqQJYCIlvdYZNsR/CWB
	 THh7eMYOJps/3gV6S7V74VGIb7TkvBSxrOj0Sqvcp6/ghtpoPPXcIzSYYczZNAAKWJ
	 X5cTBLpVJdD6M93q+qjB0rv2EaFO6Ke7LHULKXLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 5.10 229/332] pwm: berlin: Fix wrong register in suspend/resume
Date: Mon, 27 Oct 2025 19:34:42 +0100
Message-ID: <20251027183530.846763057@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ukleinek: backport to 5.10]
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-berlin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pwm/pwm-berlin.c
+++ b/drivers/pwm/pwm-berlin.c
@@ -249,7 +249,7 @@ static int berlin_pwm_suspend(struct dev
 		if (!channel)
 			continue;
 
-		channel->enable = berlin_pwm_readl(pwm, i, BERLIN_PWM_ENABLE);
+		channel->enable = berlin_pwm_readl(pwm, i, BERLIN_PWM_EN);
 		channel->ctrl = berlin_pwm_readl(pwm, i, BERLIN_PWM_CONTROL);
 		channel->duty = berlin_pwm_readl(pwm, i, BERLIN_PWM_DUTY);
 		channel->tcnt = berlin_pwm_readl(pwm, i, BERLIN_PWM_TCNT);
@@ -280,7 +280,7 @@ static int berlin_pwm_resume(struct devi
 		berlin_pwm_writel(pwm, i, channel->ctrl, BERLIN_PWM_CONTROL);
 		berlin_pwm_writel(pwm, i, channel->duty, BERLIN_PWM_DUTY);
 		berlin_pwm_writel(pwm, i, channel->tcnt, BERLIN_PWM_TCNT);
-		berlin_pwm_writel(pwm, i, channel->enable, BERLIN_PWM_ENABLE);
+		berlin_pwm_writel(pwm, i, channel->enable, BERLIN_PWM_EN);
 	}
 
 	return 0;


