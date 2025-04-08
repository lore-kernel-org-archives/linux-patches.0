Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B38826FDBF;
	Tue,  8 Apr 2025 12:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115672; cv=none; b=aUtD8Wy+uEfmGKq7SH97euVr5DfE2MUg7GeCyrBfs6+nlElgpZAU21zOxOo+0le/MNND6vXnW68S9OaawhKclFtJAtd3/kVW93+hNYpIQU3Jqk+0gNIwEThF8+wDNFWvlFwW/v7qCsARBuezLCs+SfbXAMcBJp8JfdypG/h8hpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115672; c=relaxed/simple;
	bh=BGSr4fQ++AZaSsOHkS38+OkxNJbgXQmuvMb+pwoVDbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HolxtnXzdUtXt03nD3sedUqS4zNS3qpE4ye9e2DNz5H9OJjS8CrRX5m3C8WxuFsCzhAdp5jZM8OPNwt58OzxjI//FJ0LqP37zJX8zZzALxYmcfheUucdsKMiyzP/TMqG73kcVAE4tYSBXrDu2y56E5b5VtoEe7AqEjVFjRpCtYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgSL11pg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgSL11pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24897C4CEEA;
	Tue,  8 Apr 2025 12:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115672;
	bh=BGSr4fQ++AZaSsOHkS38+OkxNJbgXQmuvMb+pwoVDbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgSL11pgwTrNNjtk9E5khcImWD1m6ekuZVSo/HaOCXWUlI7Jo5Tyh5HgZ98Wz8gSM
	 /vtbbER+JNYlVINieei2dXd6Vb+sotOjpkDdmeL7mqjfTY2CzB1xrAsCeGEBNAM43b
	 fKMD6smHMcUsA8SunorCT8Nor6L/L2x5h6Td8uco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/204] clk: qcom: gcc-msm8953: fix stuck venus0_core0 clock
Date: Tue,  8 Apr 2025 12:49:50 +0200
Message-ID: <20250408104822.114432631@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8aafa6591e845..3b32830f7466a 100644
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



