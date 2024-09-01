Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE6717C;
	Sun,  1 Sep 2024 17:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210030; cv=none; b=clE+HK+uskBxtGaPJtXRe+SwwuTK2ySfVH9t3aNMJBUBpjgWCYzTmsDZB7lon7lnPQyacKS1GEqrbvQxT73Ep72ea3GpKdw7KXn/M7Heyh7xsjf1ky20oo3z/VlqyLcLRHbQLRYSCussAmR+e76JsC0DuiXNaCz0v/M1OU/oZbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210030; c=relaxed/simple;
	bh=EAHUtizIOU+wwZOpUToe7KF548IUTpkmj0fjJ6I7GmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRLusFRKCkktG97KtqNqxOwDVPV5WNqBTSkogO8YulxOJj2YST0+7GrHa1J0WY8aFND9mD/emlOapHIr5h07LuOFJQErq44rx83kC/vKd9URE0TgEhlRJ98/7ItrT/x50+m6P3BdSaNubxD9oj/DbTrKALdasTqeR/bK9vFCvoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZR+RZG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZR+RZG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B83C4CEC3;
	Sun,  1 Sep 2024 17:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210030;
	bh=EAHUtizIOU+wwZOpUToe7KF548IUTpkmj0fjJ6I7GmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZR+RZG2T3Lh6CWsB/sI0b97c0rku/GOlUbc8n/3VXreNiI9kVsp0FrbKmIqRcCN3
	 +3fK72q7I4RbjuiC7BDwFQY0C7QrSoGEPktaCPhi+AVVVjxTZW0IEr1BC7x3VQxpdY
	 hlBYDfkThqfQeyXV2lTGLJDrok6rGuDhjc+vWqq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Mhetre <amhetre@nvidia.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/215] memory: tegra: Skip SID programming if SID registers arent set
Date: Sun,  1 Sep 2024 18:16:17 +0200
Message-ID: <20240901160825.811630576@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4bed0e54fd456..2ff586c6b1021 100644
--- a/drivers/memory/tegra/tegra186.c
+++ b/drivers/memory/tegra/tegra186.c
@@ -43,6 +43,9 @@ static void tegra186_mc_client_sid_override(struct tegra_mc *mc,
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



