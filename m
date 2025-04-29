Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C561126BF7;
	Tue, 29 Apr 2025 16:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945306; cv=none; b=SNZ+Zk+7vcsE9T2A3Y0Vk1NefLtOMZ1eKpMWLGS5oN8kVf13pzk+J0397GKFKoZ1U1vwBHml9nmQiPi1N7InramSeNCwvB3uDCf6H3w0XPEHK9m7injCouT60YF6OAIyPLMDvhE+Mnkew24P/hFkQArky4iFUJi3G+Z7KIJejsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945306; c=relaxed/simple;
	bh=BKGv3zFcqn0xuNmF++dJXXpEbk6sQypcGplfSK6CLfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOvUy2gqcMU2wnPUQmRg/x83x06xLWBqKsaa2JUiqJSlaH99JTU71MILKIP6GPfjBon9kuJaWoQqjGE//k8Jvs0NKDhm815jUS//m2y20490m08Sl4PJ5DtOecrEAP/1EPsj8nt0G802bmS/jNPC3CV9nEEnp0iNaRxOoKJXAmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3S7YbNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3S7YbNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E931AC4CEE3;
	Tue, 29 Apr 2025 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945306;
	bh=BKGv3zFcqn0xuNmF++dJXXpEbk6sQypcGplfSK6CLfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3S7YbNutel1Gc7tt3ucx3ISX+1JtAEtRhbrr58IZ+qPRH5DXpbz5mG6sZ4VRdP39
	 J+apEz/55vfBZruiK76EBz2SbZSPTNC0SVjTvqUgokH5A6zjJyqPz+mIv4jM04OqPr
	 NLiaWyHyebVD5BraYPHUY8Irh9F3vagPjOk9amew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Woerner <twoerner@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.4 069/179] thermal/drivers/rockchip: Add missing rk3328 mapping entry
Date: Tue, 29 Apr 2025 18:40:10 +0200
Message-ID: <20250429161052.211301873@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Trevor Woerner <twoerner@gmail.com>

commit ee022e5cae052e0c67ca7c5fec0f2e7bc897c70e upstream.

The mapping table for the rk3328 is missing the entry for -25C which is
found in the TRM section 9.5.2 "Temperature-to-code mapping".

NOTE: the kernel uses the tsadc_q_sel=1'b1 mode which is defined as:
      4096-<code in table>. Whereas the table in the TRM gives the code
      "3774" for -25C, the kernel uses 4096-3774=322.

[Dragan Simic] : "After going through the RK3308 and RK3328 TRMs, as
  well as through the downstream kernel code, it seems we may have
  some troubles at our hands.  Let me explain, please.

  To sum it up, part 1 of the RK3308 TRM v1.1 says on page 538 that
  the equation for the output when tsadc_q_sel equals 1 is (4096 -
  tsadc_q), while part 1 of the RK3328 TRM v1.2 says that the output
  equation is (1024 - tsadc_q) in that case.

  The downstream kernel code, however, treats the RK3308 and RK3328
  tables and their values as being the same.  It even mentions 1024 as
  the "offset" value in a comment block for the rk_tsadcv3_control()
  function, just like the upstream code does, which is obviously wrong
  "offset" value when correlated with the table on page 544 of part 1
  of the RK3308 TRM v1.1.

  With all this in mind, it's obvious that more work is needed to make
  it clear where's the actual mistake (it could be that the TRM is
  wrong), which I'll volunteer for as part of the SoC binning project.
  In the meantime, this patch looks fine as-is to me, by offering
  what's a clear improvement to the current state of the upstream
  code"

Link: https://opensource.rock-chips.com/images/9/97/Rockchip_RK3328TRM_V1.1-Part1-20170321.pdf
Cc: stable@vger.kernel.org
Fixes: eda519d5f73e ("thermal: rockchip: Support the RK3328 SOC in thermal driver")
Signed-off-by: Trevor Woerner <twoerner@gmail.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/20250207175048.35959-1-twoerner@gmail.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/rockchip_thermal.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/thermal/rockchip_thermal.c
+++ b/drivers/thermal/rockchip_thermal.c
@@ -360,6 +360,7 @@ static const struct tsadc_table rk3328_c
 	{296, -40000},
 	{304, -35000},
 	{313, -30000},
+	{322, -25000},
 	{331, -20000},
 	{340, -15000},
 	{349, -10000},


