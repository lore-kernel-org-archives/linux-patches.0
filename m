Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C7815F41B;
	Tue, 27 Aug 2024 14:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770147; cv=none; b=H9556xCmIppVfHBa2D8nNMxp6Ci8iuxPG39iWg2hL++xpROQ8rixk1947tLwT3wcggTDOyMlt1pbr+XMuoxzNFJNe2+YdzgyKXDfCkLlhKtVEQ5/MuZ2s54UI+39YUgnplE1Uav5r2eWBGQm09XuGLdluc1wcLW/JH++NK6VzTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770147; c=relaxed/simple;
	bh=lU7YCi8sa+I4NQOSH7v7ssjPGu0TtAxCDRbU9BbvREc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHBdRdqCy+1v4ooyofSYNopSx1d/DvZGAvUFNKwIxMtoGPH0vyLh8b5Jpiw4jIUw4XXKXY5IaSaR6j1x687HaWNyF6wLBceD3goGLQ+J0ySjHWTuWSRgV+HcQ6jX166avF8tHAoXYJJydI3F2Ah4Yr3+1Zn7ySqYUaM7YQDvAk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDJXDE+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDJXDE+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A0CC4AF10;
	Tue, 27 Aug 2024 14:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770147;
	bh=lU7YCi8sa+I4NQOSH7v7ssjPGu0TtAxCDRbU9BbvREc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDJXDE+orRMJ7TRFgv3jS6HjOldlWzlPNQS54o+xT/Iy6B40ISLuvaq0nc/EuIzNV
	 E+yz/+VHfGtjKu5UQkCSAt9AGtUfKaU8Cq8lQquCtM+A+wLBSVE/rJx4J7OsF+50O8
	 OH8J1glM3rmdZR62DyD5tVYSqRj4eRXPDdWBO7pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Mhetre <amhetre@nvidia.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/341] memory: tegra: Skip SID programming if SID registers arent set
Date: Tue, 27 Aug 2024 16:36:12 +0200
Message-ID: <20240827143848.785279232@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Mhetre <amhetre@nvidia.com>

[ Upstream commit 0d6c918011ce4764ed277de4726a468b7ffe5fed ]

There are few MC clients where SID security and override register
offsets are not specified like "sw_cluster0" in tegra234. Don't program
SID override for such clients because it leads to access to invalid
addresses.

Signed-off-by: Ashish Mhetre <amhetre@nvidia.com>
Link: https://lore.kernel.org/r/20231107112713.21399-2-amhetre@nvidia.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra186.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/memory/tegra/tegra186.c b/drivers/memory/tegra/tegra186.c
index 533f85a4b2bdb..7633481e547d2 100644
--- a/drivers/memory/tegra/tegra186.c
+++ b/drivers/memory/tegra/tegra186.c
@@ -75,6 +75,9 @@ static void tegra186_mc_client_sid_override(struct tegra_mc *mc,
 {
 	u32 value, old;
 
+	if (client->regs.sid.security == 0 && client->regs.sid.override == 0)
+		return;
+
 	value = readl(mc->regs + client->regs.sid.security);
 	if ((value & MC_SID_STREAMID_SECURITY_OVERRIDE) == 0) {
 		/*
-- 
2.43.0



