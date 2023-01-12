Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC10749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEE5C433EF;
	Thu, 12 Jan 2023 14:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532494;
	bh=/ktH43AALJeYfa4XMHiFVmunaH4Ur4pLwRBUZ/3JUiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkVSOTXYlGyxIdwgYu0mV+erUclIhvrHJ9sc7G5fO5kkmOJbJShpCweG4AV7oioWR
	 afNI1ygf4o6Atof62SZZs2xaiPfCGsyJ99uG3D2hAXNESsXHbn3Ne6kOuOW2yNO0Cx
	 UGpkdSDfUS7+G+fXvqkb3fnxFyYNd+Nslz7wXjoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/783] drm/tegra: Add missing clk_disable_unprepare() in tegra_dc_probe()
Date: Thu, 12 Jan 2023 14:48:17 +0100
Message-Id: <20230112135532.709277075@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Zekun <zhangzekun11@huawei.com>

[ Upstream commit 7ad4384d53c67672a8720cdc2ef638d7d1710ab8 ]

Add the missing clk_disable_unprepare() before return from
tegra_dc_probe() in the error handling path.

Fixes: f68ba6912bd2 ("drm/tegra: dc: Link DC1 to DC0 on Tegra20")
Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index ceb86338c003..958d12da902d 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -2564,8 +2564,10 @@ static int tegra_dc_probe(struct platform_device *pdev)
 	usleep_range(2000, 4000);
 
 	err = reset_control_assert(dc->rst);
-	if (err < 0)
+	if (err < 0) {
+		clk_disable_unprepare(dc->clk);
 		return err;
+	}
 
 	usleep_range(2000, 4000);
 
-- 
2.35.1



