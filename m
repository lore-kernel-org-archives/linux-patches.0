Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150963BADA9;
	Sat, 12 Sep 2026 20:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243569; cv=none; b=CFMrR03EFH4go0j5H260oqMruCmB9WSEok0FgRtlTcLLabT56eDWlP+2VJHSQIu35Q8CSSzhDvG0wGz2J7HA1QVM3GyDE1Q48VID6mU2QUs2Pu7XPfkOCAvfrZgyAwkLC/OTRwH7Xh1luuEKdyBotv82g648kTYgzfMzieDq2BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243569; c=relaxed/simple;
	bh=o0J3DKlLI0mMxQzr9uBjpVkLsad9O7/EIsWU6MMViGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ednldJd/K+u47D63uTOd7lvQNzOzCN8KC69HcdPsu9ZtCkWSuPiR1JlPzQQMeAKoHaKozVUYB/gYNoLD63afKiCAmSImHBLvKn9fIZgHJrkybsW2h772JXFPsz6rmleXSjvsxl+9axBl3e9QvkXPdRD8n5zmIlzlWUpnnEEuvWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCq1mUIy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCq1mUIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26A91F00893;
	Sat, 12 Sep 2026 20:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243566;
	bh=AEJmXv56lCIKn21UQAaGFBuuGV2GDRz8A/n2UdH8xJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCq1mUIyZnUTD1vwKD0yURGDfj06nL/0Buxsw2mQygsWFpulVWwGmTLMSDOgQM7cG
	 a9BIYjgVaPJ8kCmS3UrIRT3e8WOuXDrUK9oYhf1Ku+sEXbeoN1860BZxlAdan5dagr
	 qwNtwZyUEzfAEjsHq1uk9O/qiAnmKBmEWObRcysI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 790/798] clk: qcom: gdsc: Bump parent usage count when GDSC is found enabled
Date: Sat, 12 Sep 2026 09:06:58 +0200
Message-ID: <20260912065535.169110401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 41fff779d7948147f2440c4bb134cdf8b45b22d7 ]

When a GDSC is found to be enabled at boot the pm_runtime state will
be unbalanced as the GDSC is later turned off. Fix this by increasing
the usage counter on the power-domain, in line with how we handled the
regulator state.

Fixes: 1b771839de05 ("clk: qcom: gdsc: enable optional power domain support")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20220713212818.130277-1-bjorn.andersson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index 4b6dcb0aade11..a98e15d4a1eef 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -427,6 +427,14 @@ static int gdsc_init(struct gdsc *sc)
 				return ret;
 		}
 
+		/* ...and the power-domain */
+		ret = gdsc_pm_runtime_get(sc);
+		if (ret) {
+			if (sc->rsupply)
+				regulator_disable(sc->rsupply);
+			return ret;
+		}
+
 		/*
 		 * Votable GDSCs can be ON due to Vote from other masters.
 		 * If a Votable GDSC is ON, make sure we have a Vote.
-- 
2.53.0



