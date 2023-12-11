Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64261FBE1;
	Mon, 11 Dec 2023 18:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSMUIbm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE86C433C8;
	Mon, 11 Dec 2023 18:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319481;
	bh=ijMoGisBSVVVyO8722+VrPt364XWHQ/ZJCznLbp1Pv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSMUIbm8EC12ShbL38jJ/5BZi3xzlCExKHT2Yt1ujCVSrt8cXhl5eiivTYRIXASAh
	 QVy6Gt4iPKXfRFUOWDS0gikT56Qg3l6dJlz4nI7gW/3+F5K9BNXu/oNApGuWTBUgRW
	 Jp7VrHGCqS889UQK9n+Q6Ad0xKjErNF5DquXwbKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Kunwu Chan <chentao@kylinos.cn>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/244] ARM: imx: Check return value of devm_kasprintf in imx_mmdc_perf_init
Date: Mon, 11 Dec 2023 19:20:15 +0100
Message-ID: <20231211182051.284648089@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 1c2b1049af3f86545fcc5fae0fc725fb64b3a09e ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful
by checking the pointer validity.

Release the id allocated in 'mmdc_pmu_init' when 'devm_kasprintf'
return NULL

Suggested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Fixes: e76bdfd7403a ("ARM: imx: Added perf functionality to mmdc driver")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/mmdc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/mmdc.c b/arch/arm/mach-imx/mmdc.c
index 2157493b78a9b..df69af9323754 100644
--- a/arch/arm/mach-imx/mmdc.c
+++ b/arch/arm/mach-imx/mmdc.c
@@ -501,6 +501,10 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
 
 	name = devm_kasprintf(&pdev->dev,
 				GFP_KERNEL, "mmdc%d", ret);
+	if (!name) {
+		ret = -ENOMEM;
+		goto pmu_release_id;
+	}
 
 	pmu_mmdc->mmdc_ipg_clk = mmdc_ipg_clk;
 	pmu_mmdc->devtype_data = (struct fsl_mmdc_devtype_data *)of_id->data;
@@ -523,9 +527,10 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
 
 pmu_register_err:
 	pr_warn("MMDC Perf PMU failed (%d), disabled\n", ret);
-	ida_simple_remove(&mmdc_ida, pmu_mmdc->id);
 	cpuhp_state_remove_instance_nocalls(cpuhp_mmdc_state, &pmu_mmdc->node);
 	hrtimer_cancel(&pmu_mmdc->hrtimer);
+pmu_release_id:
+	ida_simple_remove(&mmdc_ida, pmu_mmdc->id);
 pmu_free:
 	kfree(pmu_mmdc);
 	return ret;
-- 
2.42.0



