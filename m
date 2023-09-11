Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797F91170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE812C433C8;
	Mon, 11 Sep 2023 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442011;
	bh=/goFSqXm6e1PjC3MAJyUqztOn6q/L67VDEYqhzslp6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=it/TQmjFA4bjiIhQ8i9I8UPCi2kCDdH9MQtinGHEoJtQL4qcbvASA6sa9VLRc2dIW
	 EEWsFVKbGPs6ecHpqs6wRtbhMOGwZbjTsdbz9sTSwqwTunBMR9LpGygItM+rQD9iDO
	 QBtmjndKqOZniru7jIBwTfuIEYWkX0/DpnjlzgVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 588/739] platform/x86/amd/pmf: Fix a missing cleanup path
Date: Mon, 11 Sep 2023 15:46:27 +0200
Message-ID: <20230911134707.527838605@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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
index 57bf1a9f0e766..78ed3ee22555d 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -324,7 +324,8 @@ static void amd_pmf_init_features(struct amd_pmf_dev *dev)
 
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



