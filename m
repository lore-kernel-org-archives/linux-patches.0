Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A020C1DFD1;
	Sun,  1 Sep 2024 16:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209521; cv=none; b=jSYsG/ijJKoT5KxzT5tMK3j/NDUHdKQ+JABG8IDPkjAB++L8bgbsBzalxHIb6J6N3eDBSmnloeLLPJhx/o5t3Kr7iGhx6uj2jPA29hg2WuenWkCocOsLLGcqs3eogi2axN78gmppmBMplpGLOtfbdPEsDzWfQKfQHDopb5iqy98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209521; c=relaxed/simple;
	bh=S5GgmOHYWfDaWK7w5yrT7S3ktDAiCWUp0KYCl0skvgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TFTIDYZz/WGpnlIGyzkQJeF5v6XgNwalrwi5+58UpCbUjsqDCY/n9xJQqxi5EzXLhy6di/cW1wEnluSjCC7jCPpqoDIG0SQss6DGs/xmyidjhPDm2XD8D4/gi7obkw+IUDeO6Ss2SediJi4IEVTDksPhPJEnZlE7MXk2V9V4vsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erF1Pd38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erF1Pd38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2890BC4CEC3;
	Sun,  1 Sep 2024 16:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209521;
	bh=S5GgmOHYWfDaWK7w5yrT7S3ktDAiCWUp0KYCl0skvgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erF1Pd38JlgSYsnUTw1zn+gOhfUP03lfPkLZV1nECarTMGGL4TSOXe0YcvXL/sSr8
	 R2n4niwiEkkNTKS81jThjGA6JOT5tWkoXEcFwDxvUC8T6dIRdkCBpHRpMve/46OMP/
	 4jbEqGv0ucRbxo2YN8dUpD2x+rvqQAj4pg8W17aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/151] ssb: Fix division by zero issue in ssb_calc_clock_rate
Date: Sun,  1 Sep 2024 18:16:31 +0200
Message-ID: <20240901160815.270512468@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



