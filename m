Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866151C4EF6;
	Tue, 27 Aug 2024 14:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770070; cv=none; b=G1EAzsHE1ogMa3sNs/LhJ/ro/0owlSfijdz48E8QjsmzEqOJyrtb3hQAZ+6b0Qw12qn6uXo9wgpovkGN+U7Xk+wI/gdlT9W3/9cE7AcePul9PO+fQEs8KJUTzTR7J2+D9CiQg5PAnRFPxJ/G2dd/dDI2BoaDhmRbHETV+Gla+Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770070; c=relaxed/simple;
	bh=N6lWjtihlU4gBUj5LZSMXRkFgnNaS6+3Z3AOXyxMSdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aovSPkLyslbWBBysZ3I6eIkOQ+VVrkAa6KbKG3GAgKtu05M1UgY2Giy/mydImOH97ilUSoy5EaA3VTyK7e5UWm8MFNa5bT7hmjCQN+5dvZd6hQ/SknLaA5x90HOBcaoxU8UBE1PrbI55X/6oEh5V3avXNykHfZWXJXTBC9CFOCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y78OAoGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y78OAoGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BAFC61045;
	Tue, 27 Aug 2024 14:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770070;
	bh=N6lWjtihlU4gBUj5LZSMXRkFgnNaS6+3Z3AOXyxMSdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y78OAoGmXAWDHInulpODkzSyvmuG2njqWlycXvvpj2TKpNkRLB2fah6sYc9YYTHYW
	 Z2tnwD3qK8BO8Ts39ZcP3pl3kMwhj5yKSbAa53GARP+xHI1qVDXnp4DflFIUlPR+cy
	 6VEPwRuN2h8nyeZ0lTJ8HgdqGe6cSaiBOD4GsU+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/341] ssb: Fix division by zero issue in ssb_calc_clock_rate
Date: Tue, 27 Aug 2024 16:35:17 +0200
Message-ID: <20240827143846.681478493@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0c736d51566dc..070a99a4180cc 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -839,7 +839,7 @@ static u32 clkfactor_f6_resolve(u32 v)
 	case SSB_CHIPCO_CLK_F6_7:
 		return 7;
 	}
-	return 0;
+	return 1;
 }
 
 /* Calculate the speed the backplane would run at a given set of clockcontrol values */
-- 
2.43.0



