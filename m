Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CD62676FA;
	Tue,  8 Apr 2025 12:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116500; cv=none; b=LzvlrgcVCZ4sARrJIrLbtddujID3ZIxUYVQKoxuWQEGDW3Y43/3tDJ1EekqDraoq+u71gR02cQ7j31kan8zwKXnN6MtpkDncCGgvjUsnP/WHyl5k2aWizCrDMxeg71wAbN0oZEZ/0LFu+AZlhjtfvyuwtrxc2SuFGjZXfTComNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116500; c=relaxed/simple;
	bh=uHvyaUHQ937SmdHq9Pfmh+gt0JEyiiX9BM9Rr0Xa8v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yn9pdLP7EIMbwXYPWTHCb5pC7u5P/ZXnPH1RKyYPjf9M5NStelO20tXFS0FoZz808d8/zqYaFFgS1l9Dacy3R7lxphixi85x6gwWsMLL8pj3mQ6atwDiQeThhrOrXh2F+zgSqCleIP4v8gxdTAfzquXw5s1vgmKEoNyg/OTG4B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNlGJE2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNlGJE2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4B9C4CEE5;
	Tue,  8 Apr 2025 12:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116499;
	bh=uHvyaUHQ937SmdHq9Pfmh+gt0JEyiiX9BM9Rr0Xa8v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNlGJE2jYCl/eImdkzjORstS6mfEoKVIgnGIPEpdk+OXPZrgkFF7HmvKgTcebxcAP
	 ldLjLMBXWb9qH4FWd31Qsqx3URaktCGOeyQcu97xj1a4JuekhSZriyhLmi04HCPuqz
	 pZ/+JDGernA7uinLbK7ZUfLeKJVqyuWW+pUiBTdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/423] clk: qcom: mmcc-sdm660: fix stuck video_subcore0 clock
Date: Tue,  8 Apr 2025 12:48:07 +0200
Message-ID: <20250408104849.488251042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 000cbe3896c56bf5c625e286ff096533a6b27657 ]

This clock can't be enable with VENUS_CORE0 GDSC turned off. But that
GDSC is under HW control so it can be turned off at any moment.
Instead of checking the dependent clock we can just vote for it to
enable later when GDSC gets turned on.

Fixes: 5db3ae8b33de6 ("clk: qcom: Add SDM660 Multimedia Clock Controller (MMCC) driver")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/r/20250315-clock-fix-v1-1-2efdc4920dda@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-sdm660.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/mmcc-sdm660.c b/drivers/clk/qcom/mmcc-sdm660.c
index 98ba5b4518fb3..b9f02d91004e8 100644
--- a/drivers/clk/qcom/mmcc-sdm660.c
+++ b/drivers/clk/qcom/mmcc-sdm660.c
@@ -2544,7 +2544,7 @@ static struct clk_branch video_core_clk = {
 
 static struct clk_branch video_subcore0_clk = {
 	.halt_reg = 0x1048,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x1048,
 		.enable_mask = BIT(0),
-- 
2.39.5



