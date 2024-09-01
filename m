Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2BA18132F;
	Sun,  1 Sep 2024 16:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207587; cv=none; b=Wf0sOUCkjXKmggyrM7ajBnJj9RlsIWUBzy5VaRHXtMJ3WZ04Odb+5L5dgx6WbtYfuxDImd4ofeGOseoBxR2iwRrXqUm8VaqNcV8SeOXIJ7zEPU2HkhYVoNnUTEmF4ZBkW45q1PLOhebDtSqMO2hVjCNN+ghuV7+hAE7hKCHnfsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207587; c=relaxed/simple;
	bh=CQmXlF0UGH2x0rDS0Y3nhrSI6BjuoCzXIbbft55MUPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qTonoz7anb2tHeCjEfvfwosyAiYaj4F4EHP/LJ3GToM5LnKLTAo6f/LVxrdnBWlcvpC3p4CT26jh/3b27hRBaqN0H0p/101qtQQu8+30vXiE3O2owfTWVzsdqCmSv+LgxjlsG73ZW69QT0esuTKuqKp3e4Y4cVl/+n5/l7has1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfWLUYpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfWLUYpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29814C4CEC3;
	Sun,  1 Sep 2024 16:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207586;
	bh=CQmXlF0UGH2x0rDS0Y3nhrSI6BjuoCzXIbbft55MUPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfWLUYpRRBOEzw6a+5EQxya6g7LhuqykcyVLspW18x4h32WuH5MwAGvIS79qk+chm
	 BgvoQelWhp8HqtNQhNXDdsfZygmySHUhW0LtAlY5RC0NvkK2TAYC/2dWMgA9Hrg0VK
	 S0+YKT1+1pyUkmF/mY49+At2PdMqBOwXb57nPEaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/98] ssb: Fix division by zero issue in ssb_calc_clock_rate
Date: Sun,  1 Sep 2024 18:15:47 +0200
Message-ID: <20240901160804.340980081@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rand Deeb <rand.sec96@gmail.com>

[ Upstream commit e0b5127fa134fe0284d58877b6b3133939c8b3ce ]

In ssb_calc_clock_rate(), there is a potential issue where the value of
m1 could be zero due to initialization using clkfactor_f6_resolv(). This
situation raised concerns about the possibility of a division by zero
error.

We fixed it by following the suggestions provided by Larry Finger
<Larry.Finger@lwfinger.net> and Michael Büsch <m@bues.ch>. The fix
involves returning a value of 1 instead of 0 in clkfactor_f6_resolv().
This modification ensures the proper functioning of the code and
eliminates the risk of division by zero errors.

Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Michael Büsch <m@bues.ch>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230904232346.34991-1-rand.sec96@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ssb/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 0a26984acb2ca..9e54bc7eec663 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -835,7 +835,7 @@ static u32 clkfactor_f6_resolve(u32 v)
 	case SSB_CHIPCO_CLK_F6_7:
 		return 7;
 	}
-	return 0;
+	return 1;
 }
 
 /* Calculate the speed the backplane would run at a given set of clockcontrol values */
-- 
2.43.0



