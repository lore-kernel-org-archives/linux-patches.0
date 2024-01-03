Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D521C29C;
	Wed,  3 Jan 2024 17:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vsCxH1Wu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D486C433C8;
	Wed,  3 Jan 2024 17:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302051;
	bh=HZA4PhY1KPmZmPMzQ7da314sbUMCmCWrJXqx9L8mdY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsCxH1WuUtwuklXR3bYJZ9VqdlL+sqwPvdTscbcwWHjtgqILrGbAZ2jvO59B2i2J3
	 4UembLczskjkvWioyXzlPZ1fzWqOWFzZVCCaEyqiDev2+c95bFFwZJzoCy9AmXihCm
	 /sKYmtjgRXjDKkW3S+Qzpu0tGFGtFpeRBDReZves=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 32/49] platform/x86/intel/pmc: Add suspend callback
Date: Wed,  3 Jan 2024 17:55:52 +0100
Message-ID: <20240103164840.026750158@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit 7c13f365aee68b01e7e68ee293a71fdc7571c111 ]

Add a suspend callback to struct pmc for performing platform specific tasks
before device suspend. This is needed in order to perform GBE LTR ignore on
certain platforms at suspend-time instead of at probe-time and replace the
GBE LTR ignore removal that was done in order to fix a bug introduced by
commit 804951203aa5 ("platform/x86:intel/pmc: Combine core_init() and
core_configure()").

Fixes: 804951203aa5 ("platform/x86:intel/pmc: Combine core_init() and core_configure()")
Signed-off-by: "David E. Box" <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20231223032548.1680738-4-david.e.box@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.c | 3 +++
 drivers/platform/x86/intel/pmc/core.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index e95d3011b9997..5ab470d87ad7e 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -1279,6 +1279,9 @@ static __maybe_unused int pmc_core_suspend(struct device *dev)
 	struct pmc_dev *pmcdev = dev_get_drvdata(dev);
 	struct pmc *pmc = pmcdev->pmcs[PMC_IDX_MAIN];
 
+	if (pmcdev->suspend)
+		pmcdev->suspend(pmcdev);
+
 	/* Check if the syspend will actually use S0ix */
 	if (pm_suspend_via_firmware())
 		return 0;
diff --git a/drivers/platform/x86/intel/pmc/core.h b/drivers/platform/x86/intel/pmc/core.h
index 0729f593c6a75..38d888e3afa63 100644
--- a/drivers/platform/x86/intel/pmc/core.h
+++ b/drivers/platform/x86/intel/pmc/core.h
@@ -363,6 +363,7 @@ struct pmc {
  * @s0ix_counter:	S0ix residency (step adjusted)
  * @num_lpm_modes:	Count of enabled modes
  * @lpm_en_modes:	Array of enabled modes from lowest to highest priority
+ * @suspend:		Function to perform platform specific suspend
  * @resume:		Function to perform platform specific resume
  *
  * pmc_dev contains info about power management controller device.
@@ -379,6 +380,7 @@ struct pmc_dev {
 	u64 s0ix_counter;
 	int num_lpm_modes;
 	int lpm_en_modes[LPM_MAX_NUM_MODES];
+	void (*suspend)(struct pmc_dev *pmcdev);
 	int (*resume)(struct pmc_dev *pmcdev);
 
 	bool has_die_c6;
-- 
2.43.0



