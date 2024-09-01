Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91129183092;
	Sun,  1 Sep 2024 16:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209950; cv=none; b=mUvyz0yF3wCUe3mdvYfMFict3MrXRAxHWx/Hu+vmZsFLgiZ8W3fuAhduVRDaf2lm5BR4Hx6SGD7PTU7s0QF3ZOIIPS4aB04V7dtKA3Qz3uE0pE38fk712RWkpiHX3LmbEZzkK+XiooG5z2Qa/oIlkaUN/zQ7LbpyUqvhj5hZtwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209950; c=relaxed/simple;
	bh=Py8/KlINwenuukJfRslLgBdYVZypYjSEkQYVizsH/uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kf2vhDNYYmViK1Z8mdE0cPbbv3HFW8WV70cBhpXLULHrSKY76R8BjjF7kecwb2NqblmdA4R88FkMEB3sQ1cOqdoo8TOZ5Z8+045/f8+6KM9Q5NZo/DPaNnHAqU2BnfZLMhcko0IU/liYVvttdx94im/YgGVT1k8E+GMQX8XAA6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cz6qHF90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cz6qHF90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000B0C4CEC3;
	Sun,  1 Sep 2024 16:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209950;
	bh=Py8/KlINwenuukJfRslLgBdYVZypYjSEkQYVizsH/uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cz6qHF90DKpQkme0BBsPe5jfQ+MvG+PyfxyvH+72Wp/Du2dh4tUXqcSEXETZ+dbOD
	 wXTpUCqtSnVRAr2o+tb6hj3GGHL3KRueWJCQ6ySeFq1w6KfbWKghbv0b4rLMeGh3N7
	 Fn+RDiDLB/YKdnF5utaFcooP/I0jnrgo8zC7IRqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/215] ssb: Fix division by zero issue in ssb_calc_clock_rate
Date: Sun,  1 Sep 2024 18:15:55 +0200
Message-ID: <20240901160824.975932195@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8a93c83cb6f80..d52e91258e989 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -837,7 +837,7 @@ static u32 clkfactor_f6_resolve(u32 v)
 	case SSB_CHIPCO_CLK_F6_7:
 		return 7;
 	}
-	return 0;
+	return 1;
 }
 
 /* Calculate the speed the backplane would run at a given set of clockcontrol values */
-- 
2.43.0



