Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F2812CD9B;
	Tue, 30 Apr 2024 11:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476094; cv=none; b=hCYMc5qfPwA9ApEAWCpWY81H2AU1z1TaKcaLkvytGPDI7oeiFvDY173ZbN8jppHD1qNjfrS9k8mgGfU0AShnFnPWvsYkbMI3RQNgpSkIMd+pqAKLC4nF2q35OVqTENoLKOXakh96fDEfcI5woqZ9706DLNQjgIEB0ZEeC53aKIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476094; c=relaxed/simple;
	bh=urSgdWURu3YxGP/gPKEEYNOTJWRKylw92VEI5AhwAiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcxtHtvdSSdeTdEhnNvSgfEIid+M0bIWUfc7a0iLjdigPV+2o0XNTLe/eYzKeupWsjrUE8jev3s/oMi8LRSNPkL2x9SPWBNoEEsAaB+mPnoL2Nf0tOaAqpsQqhe1af+bUcJuYVNlmxApc+AmakH1UoNXyDE05rXkmoihejl1+BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbgNpKru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbgNpKru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEC8C2BBFC;
	Tue, 30 Apr 2024 11:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476094;
	bh=urSgdWURu3YxGP/gPKEEYNOTJWRKylw92VEI5AhwAiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbgNpKrusGp+FM9V1UBNPsQzEfQ7MocUPlE3pjZ8CZN6QOHQkt0SEu8UHl+OSwj/p
	 NbWb8ydxT+OulBlttG6zcReJmNglWOM7mYhpEE7VOs7MSqoUjz/PGAKNkpl3RPLfy/
	 bZARlAlVpIozOVpz5bJ1aGavhSkczrr5mhg0Xqng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/107] clk: Print an info line before disabling unused clocks
Date: Tue, 30 Apr 2024 12:39:51 +0200
Message-ID: <20240430103045.579898800@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 12ca59b91d04df32e41be5a52f0cabba912c11de ]

Currently, the regulator framework informs us before calling into
their unused cleanup paths, which eases at least some debugging. The
same could be beneficial for clocks, so that random shutdowns shortly
after most initcalls are done can be less of a guess.

Add a pr_info before disabling unused clocks to do so.

Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230307132928.3887737-1-konrad.dybcio@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: e581cf5d2162 ("clk: Get runtime PM before walking tree during disable_unused")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 276b8a1f3c3f3..7c92dd209a99d 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1315,6 +1315,8 @@ static int clk_disable_unused(void)
 		return 0;
 	}
 
+	pr_info("clk: Disabling unused clocks\n");
+
 	clk_prepare_lock();
 
 	hlist_for_each_entry(core, &clk_root_list, child_node)
-- 
2.43.0



