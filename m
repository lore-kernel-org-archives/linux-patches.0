Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684D537170
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tg+DwVye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145DAC433CA;
	Wed, 15 Nov 2023 19:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076452;
	bh=oOdzx/pNmOR3iUJjwCLQRbId1Y2l+w/WI2xXxqZ0e2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tg+DwVyeCRJEQsWQQPzd/3SFX1lbN+8F5rS+BbwfGld073ND2ivlF/agWV1KZd6AR
	 hBgI0Ld8tPiGC14fXjk8lIJYr+SwH+6Ay8a1IdMeRgP/SaVC0owwtO31fw1/cUTGYk
	 Ciba3iCEOICF3yXEozSrjteca1jnIaLyg7nUHexU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 297/550] memory: tegra: Set BPMP msg flags to reset IPC channels
Date: Wed, 15 Nov 2023 14:14:41 -0500
Message-ID: <20231115191621.402073865@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit f344675a34383ae26a8230f4b1cd99cbd0defebd ]

Set the 'TEGRA_BPMP_MESSAGE_RESET' bit in newly added 'flags' field
of 'struct tegra_bpmp_message' to request for the reset of BPMP IPC
channels. This is used along with the 'suspended' check in BPMP driver
for handling early bandwidth requests due to the hotplug of CPU's
during system resume before the driver gets resumed.

Fixes: f41e1442ac5b ("cpufreq: tegra194: add OPP support and set bandwidth")
Co-developed-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Sumit Gupta <sumitg@nvidia.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra234.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/memory/tegra/tegra234.c b/drivers/memory/tegra/tegra234.c
index 8fb83b39f5f5b..0952f1210b772 100644
--- a/drivers/memory/tegra/tegra234.c
+++ b/drivers/memory/tegra/tegra234.c
@@ -852,6 +852,10 @@ static int tegra234_mc_icc_set(struct icc_node *src, struct icc_node *dst)
 	msg.rx.data = &bwmgr_resp;
 	msg.rx.size = sizeof(bwmgr_resp);
 
+	if (pclient->bpmp_id >= TEGRA_ICC_BPMP_CPU_CLUSTER0 &&
+	    pclient->bpmp_id <= TEGRA_ICC_BPMP_CPU_CLUSTER2)
+		msg.flags = TEGRA_BPMP_MESSAGE_RESET;
+
 	ret = tegra_bpmp_transfer(mc->bpmp, &msg);
 	if (ret < 0) {
 		dev_err(mc->dev, "BPMP transfer failed: %d\n", ret);
-- 
2.42.0



