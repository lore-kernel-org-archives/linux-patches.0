Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D1C11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3A2C433C8;
	Mon, 11 Sep 2023 14:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444070;
	bh=FnO5d+MVIaJGqWs5NglNJwHhFVsyo+EH9T3XHre3oG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAhflCEOdKQw31byE4IiDGsq1o8NZaDU4CSiyHNkBFbO2TLX9pnf8Vq6Zn+cYzuNF
	 hYi21N6WqpVtcN8m5ERm3J4+4zI0AzPagjGPp4HXeFgSbVjHDt5V8rsbqcUMYUol58
	 m+IWdDrvZ2zsYkKl5NXqXbHS8zqDjyY9e26FZVmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 599/737] platform/x86/amd/pmf: Fix a missing cleanup path
Date: Mon, 11 Sep 2023 15:47:38 +0200
Message-ID: <20230911134707.269056436@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 4dbd6e61adc7e52dd1c9165f0ccaa90806611e40 ]

On systems that support slider notifications but don't otherwise support
granular slider the SPS cleanup path doesn't run.

This means that loading/unloading/loading leads to failures because
the sysfs files don't get setup properly when reloaded.

Add the missing cleanup path.

Fixes: 33c9ab5b493a ("platform/x86/amd/pmf: Notify OS power slider update")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230823185421.23959-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index a022325161273..6fa33a05c5a75 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -322,7 +322,8 @@ static void amd_pmf_init_features(struct amd_pmf_dev *dev)
 
 static void amd_pmf_deinit_features(struct amd_pmf_dev *dev)
 {
-	if (is_apmf_func_supported(dev, APMF_FUNC_STATIC_SLIDER_GRANULAR)) {
+	if (is_apmf_func_supported(dev, APMF_FUNC_STATIC_SLIDER_GRANULAR) ||
+	    is_apmf_func_supported(dev, APMF_FUNC_OS_POWER_SLIDER_UPDATE)) {
 		power_supply_unreg_notifier(&dev->pwr_src_notifier);
 		amd_pmf_deinit_sps(dev);
 	}
-- 
2.40.1



