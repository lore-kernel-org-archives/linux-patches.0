Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921D427604F;
	Tue,  8 Apr 2025 12:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116383; cv=none; b=OoxdKVBvLmNDH2/fMzf9yOKxkUR0TaIAuvZDLazJFTukCE/Na6aZZ2BnxA4CJhVuZtp0QLQbRVvdqC9QYrJur/06tPMcFJVWPVRb7Qe6OLDDTW2eFqCL0sQTWW69IBQDIVHpy4B5f/8+YPhYW/6RDbcmO6MlWfunxZPcsv6XarI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116383; c=relaxed/simple;
	bh=4T856D3NC+Gjq7fHE9x1HKzVFobQVp7il2BCsN+WM/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c4CNoG+UY3BnV4jDCnKgcnN9BXCGnWLyoUJhKFv0ZjLLZ7JUcR6dWrUzStaUUqjkBCSk6glSaLe6TvZ+CJyGuS0EYGlAHfo8GA0sFkMSMb0fNuU/uyGuF2VJsnCC3WukZjAuJdPczqiqc9kjgT1rjV89LqYd8dqMNLQLLgkDw74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BE02yuQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BE02yuQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAC2C4CEE5;
	Tue,  8 Apr 2025 12:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116383;
	bh=4T856D3NC+Gjq7fHE9x1HKzVFobQVp7il2BCsN+WM/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BE02yuQ50hnNUxOEF3T3+9QmEHZZi0AfyT1q7Cw5+ETi52laGMTRs5jWqoG1//IHJ
	 LIxwsVBuhoEZdJD+UiTPInZ0JN/Hk3YM8NWxBF9FS5u+j+xEcHZjT9M0mp8GVfSNuy
	 WUGdeHCITVnczoEEKHkMntndIEfZm5LeR3/FV2tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/423] clk: qcom: gcc-msm8953: fix stuck venus0_core0 clock
Date: Tue,  8 Apr 2025 12:47:25 +0200
Message-ID: <20250408104848.499049178@linuxfoundation.org>
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
index 855a61966f3ef..8f29ecc74c50b 100644
--- a/drivers/clk/qcom/gcc-msm8953.c
+++ b/drivers/clk/qcom/gcc-msm8953.c
@@ -3770,7 +3770,7 @@ static struct clk_branch gcc_venus0_axi_clk = {
 
 static struct clk_branch gcc_venus0_core0_vcodec0_clk = {
 	.halt_reg = 0x4c02c,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x4c02c,
 		.enable_mask = BIT(0),
-- 
2.39.5



