Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C887F54F87;
	Thu, 30 Nov 2023 16:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1zJbTLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CB7C433C9;
	Thu, 30 Nov 2023 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361647;
	bh=lDFNM8NpnSjL4G+SJtbf5IzPSsShLXaNPfX7tfdQ34k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1zJbTLrJ9jEdvIqETaPPb1s3fZxCITNqhN8ITiEFrVKXBfQNIZglnLnyq3lIePqi
	 XFRfv6Fp56FDJmb+SPE8kBpJ5aXA5kIsACavKE14lItT09Dn+8maN/j+tf4JsAp747
	 D4gYIZONtjpYEIGd1F2Kgb65MfcdcMrwb4NCxVu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Hasemeyer <markhas@chromium.org>,
	Sanket Goswami <Sanket.Goswami@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 081/112] platform/x86/amd/pmc: adjust getting DRAM size behavior
Date: Thu, 30 Nov 2023 16:22:08 +0000
Message-ID: <20231130162142.891002508@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

commit c6ea14d557343cd3af6c6be2f5a78c98bdb281bb upstream.

amd_pmc_get_dram_size() is used to get the DRAM size information. But
in the current code, mailbox command to get the DRAM size info is sent
based on the values of dev->major and dev->minor.

But dev->major and dev->minor will have either junk or zero assigned to
them until at least once a call to amd_pmc_get_smu_version() is made
which ideally populates dev->major and dev->minor.

However, adding a amd_pmc_get_smu_version() call to
amd_pmc_get_dram_size() has a downside of elevating the boot times.

After talking to the PMFW team, it's understood that the "get dram
size" mbox command would only be supported on specific platforms (like
Mendocino) and not all. So, adjust getting DRAM size behavior such
that,

- if running on Rembrandt or Mendocino and the underlying PMFW knows
how to execute the "get dram size" command it shall give the custom
dram size.

- if the underlying FW does not report the dram size, we just proceed
further and assign the default dram size.

The simplest way to address this is to remove amd_pmc_get_dram_size()
function and directly call the "get dram size" command in the
amd_pmc_s2d_init().

Reported-by: Mark Hasemeyer <markhas@chromium.org>
Fixes: be8325fb3d8c ("platform/x86/amd: pmc: Get STB DRAM size from PMFW")
Cc: stable@vger.kernel.org
Suggested-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20231116170121.3372222-1-Shyam-sundar.S-k@amd.com
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc.c |   31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -912,33 +912,6 @@ static const struct pci_device_id pmc_pc
 	{ }
 };
 
-static int amd_pmc_get_dram_size(struct amd_pmc_dev *dev)
-{
-	int ret;
-
-	switch (dev->cpu_id) {
-	case AMD_CPU_ID_YC:
-		if (!(dev->major > 90 || (dev->major == 90 && dev->minor > 39))) {
-			ret = -EINVAL;
-			goto err_dram_size;
-		}
-		break;
-	default:
-		ret = -EINVAL;
-		goto err_dram_size;
-	}
-
-	ret = amd_pmc_send_cmd(dev, S2D_DRAM_SIZE, &dev->dram_size, dev->s2d_msg_id, true);
-	if (ret || !dev->dram_size)
-		goto err_dram_size;
-
-	return 0;
-
-err_dram_size:
-	dev_err(dev->dev, "DRAM size command not supported for this platform\n");
-	return ret;
-}
-
 static int amd_pmc_s2d_init(struct amd_pmc_dev *dev)
 {
 	u32 phys_addr_low, phys_addr_hi;
@@ -957,8 +930,8 @@ static int amd_pmc_s2d_init(struct amd_p
 		return -EIO;
 
 	/* Get DRAM size */
-	ret = amd_pmc_get_dram_size(dev);
-	if (ret)
+	ret = amd_pmc_send_cmd(dev, S2D_DRAM_SIZE, &dev->dram_size, dev->s2d_msg_id, true);
+	if (ret || !dev->dram_size)
 		dev->dram_size = S2D_TELEMETRY_DRAMBYTES_MAX;
 
 	/* Get STB DRAM address */


