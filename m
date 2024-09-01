Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69720183CBD;
	Sun,  1 Sep 2024 16:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208758; cv=none; b=S4VnsQp5KA/hBfuBqAwnQMkixA/Scjx5fTA0KUDFXVAvyHPF/okisnTraQr1tXQ8ZVVMi4PUVQlDH4Jx6Mygn2nct+SRu/yF8QOs8SxFJh/Mf6FZKSDckCDwjFhn+XyJkC+ZXYdXA7zDZW1bwZNm/j7T+rGLYc31pCJ+fePzQI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208758; c=relaxed/simple;
	bh=UEhjeehEBW7hYRvAxHRlG/oJmxkdWmUiZWEEC5vZekA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rS3vDVXFK+iuq9d+W5GcICIJtH9k2HWNKgsk2znB43xsVlMWHGUtlX2GzpSf79HK/mo3PR6ZFgM0al8aa8esXbEQViAXH+BJoJYpPt4Nsk02SZoXMUwk/1fLGLaUZuB5IzMbkZVOksAlDhd0EZqffUn6E88ukTWJTW7cq4VFLuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETGdo3Q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETGdo3Q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFEAC4CEC3;
	Sun,  1 Sep 2024 16:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208758;
	bh=UEhjeehEBW7hYRvAxHRlG/oJmxkdWmUiZWEEC5vZekA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETGdo3Q8+3Tx5NbgAfRCHuzzybxWhj96TUS8AzuTxvM1hrNugWNC1ZGJVIsxoCjFk
	 Bm0uREgdB6PEg7UfBmtejGpp4iepkfRzrU1Q8f9kUqgyolCb5hLwyiUfNG+E1JefSf
	 nqcvIGoCLbl1g7MQZShbIDto1c7rypUvk+YlT86I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/134] ssb: Fix division by zero issue in ssb_calc_clock_rate
Date: Sun,  1 Sep 2024 18:16:17 +0200
Message-ID: <20240901160811.276676250@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



