Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EFA3081CC;
	Mon, 13 Oct 2025 14:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367520; cv=none; b=euevnnCw8DihoxHXW1EquJNaQSNGnN8jP7VlKaoYTdCIS4zjsIDcV4sTBlZ+MVP2zf8giVp0Qd6xiR4TtbWvkpCcShQpbpZVRYCIxILplZae/zcCJD3911T0dZB9QzD4i7l+AxQygATuVHix9Z3k2wYaCVtsmWbKZzLDpYD3BbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367520; c=relaxed/simple;
	bh=ROcEf038plncaEgmhp3k/rT53Uj4lxj8PUkmCW5h7Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DO0hvoF/F4eSEZrHyNE75l06ULczKe63eGm2wWtHR+pEXB9yffy5DsfdkWPndK3SkIrPv2NHueKga1pqH2UVU55dQJg4JV9IXdLVopJX+rhm5uLo6tblMDS49mKSkTuQSZdbDIiWLpvariQf6C7OigU5tCoragtDIeofehmd4Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4VCw27x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4VCw27x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A4CC4CEE7;
	Mon, 13 Oct 2025 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367520;
	bh=ROcEf038plncaEgmhp3k/rT53Uj4lxj8PUkmCW5h7Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4VCw27xJR7N4vl2ehvJ+myxWkQb6YZrqpmw4rn4SmIlkc/mVbxFfmv77Ld2tsTEa
	 y8YfEJKHm+EVHOlKSKMnVdRsMoVBUDqF/7GSzVsIpcCFT859a3sv1oqKHOkoyc+FB5
	 wTbxGe3ZjI6dbp7tXrRnFf6QlxrcYhh1D9DLZhTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/196] cpuidle: qcom-spm: fix device and OF node leaks at probe
Date: Mon, 13 Oct 2025 16:43:52 +0200
Message-ID: <20251013144316.688679306@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit cdc06f912670c8c199d5fa9e78b64b7ed8e871d0 ]

Make sure to drop the reference to the saw device taken by
of_find_device_by_node() after retrieving its driver data during
probe().

Also drop the reference to the CPU node sooner to avoid leaking it in
case there is no saw node or device.

Fixes: 60f3692b5f0b ("cpuidle: qcom_spm: Detach state machine from main SPM handling")
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-qcom-spm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-qcom-spm.c b/drivers/cpuidle/cpuidle-qcom-spm.c
index 1fc9968eae199..b6b06a510fd86 100644
--- a/drivers/cpuidle/cpuidle-qcom-spm.c
+++ b/drivers/cpuidle/cpuidle-qcom-spm.c
@@ -96,20 +96,23 @@ static int spm_cpuidle_register(struct device *cpuidle_dev, int cpu)
 		return -ENODEV;
 
 	saw_node = of_parse_phandle(cpu_node, "qcom,saw", 0);
+	of_node_put(cpu_node);
 	if (!saw_node)
 		return -ENODEV;
 
 	pdev = of_find_device_by_node(saw_node);
 	of_node_put(saw_node);
-	of_node_put(cpu_node);
 	if (!pdev)
 		return -ENODEV;
 
 	data = devm_kzalloc(cpuidle_dev, sizeof(*data), GFP_KERNEL);
-	if (!data)
+	if (!data) {
+		put_device(&pdev->dev);
 		return -ENOMEM;
+	}
 
 	data->spm = dev_get_drvdata(&pdev->dev);
+	put_device(&pdev->dev);
 	if (!data->spm)
 		return -EINVAL;
 
-- 
2.51.0



