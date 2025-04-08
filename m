Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BA2267F4F;
	Tue,  8 Apr 2025 11:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112718; cv=none; b=dOlzk6dC7ZiyIUGAnprOEK89F1tzMYzDG841n2xjUQwg25LWm5ARAFM99VVk4mCd9j5HeDWVo960wm2jMG7li3A62T05N//D9dqgoJVrI4iTWj72qWU3YB1h8ki3UGJXlSZRnbB8tvFnoNrRdRG6+4poXuDMORvyJ0CMvwKlgQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112718; c=relaxed/simple;
	bh=YNZG5YmoEHQd6XSwRuaQK+uGbrk80HnU7IOojfKevek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NqNm21KAUbazO4+hCqdISWifB0+UPYx5xaKu+sg/X+uDCrTQ5ymOK1iYiX7JS3NKCD4CQDshJJW32iIF8fjA2IzAGbUcOGPGhQ/FD4SqFPuk+Zz91T4AtG6IzZw0wrTkD9qS6j6T/gNjjtXlM5fqWO/pTEYjgkMlU1lwqjMntxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqZ4Ju9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqZ4Ju9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DB5C4CEE5;
	Tue,  8 Apr 2025 11:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112718;
	bh=YNZG5YmoEHQd6XSwRuaQK+uGbrk80HnU7IOojfKevek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqZ4Ju9JyBGmrE122vMHqkLMBwrGJFN9I+cZzZ4iMOQZ820I41z4G15rE3u5XG/8f
	 A3VTABExiMtoqVouLOVn8WTeqq9koUA2yw2s6sj2l4EZQFBQKHw/R4wuE03BI4RepD
	 xaV6dWvjeVcVTv6bwiYM6I8a/qVBexmx/YidlFh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/279] clk: qcom: gcc-msm8953: fix stuck venus0_core0 clock
Date: Tue,  8 Apr 2025 12:49:16 +0200
Message-ID: <20250408104831.003384064@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vladimir Lypak <vladimir.lypak@gmail.com>

[ Upstream commit cdc59600bccf2cb4c483645438a97d4ec55f326b ]

This clock can't be enable with VENUS_CORE0 GDSC turned off. But that
GDSC is under HW control so it can be turned off at any moment.
Instead of checking the dependent clock we can just vote for it to
enable later when GDSC gets turned on.

Fixes: 9bb6cfc3c77e6 ("clk: qcom: Add Global Clock Controller driver for MSM8953")
Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/r/20250315-clock-fix-v1-2-2efdc4920dda@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8953.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-msm8953.c b/drivers/clk/qcom/gcc-msm8953.c
index 49513f1366ffd..9d11f993843db 100644
--- a/drivers/clk/qcom/gcc-msm8953.c
+++ b/drivers/clk/qcom/gcc-msm8953.c
@@ -3771,7 +3771,7 @@ static struct clk_branch gcc_venus0_axi_clk = {
 
 static struct clk_branch gcc_venus0_core0_vcodec0_clk = {
 	.halt_reg = 0x4c02c,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x4c02c,
 		.enable_mask = BIT(0),
-- 
2.39.5



