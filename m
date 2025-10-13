Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E30145B3F;
	Mon, 13 Oct 2025 14:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367049; cv=none; b=LkEtFSZTNB+Fize6lrl7qcFvGWIs3Cs+hAEtn++fbGQHj5Je7suarjBWJsccOn4xTN44XnbVXdxLPPaTUNxR1kkEOFvzSsZ8x9JixCKBAxNGmzmKNJRo+FUw5+vIkqUKtHTcd8SksZ4IG0GhVf4Y9170UJz35UrOT3vDnX3iFaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367049; c=relaxed/simple;
	bh=+6nqStFnkz8mtUPOFH01cCwBf6dP9ibXUVn7ITpfbLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XraSMfg/bJ84KxpaTXu04lRlUoZaOBrp85440BBzN68QFLgwQ5ak/pHJnJGhVHvaqvvB5U6d9GdsiBF8hvSaBkxzAXMAOd/UQX40gNnsD4LNiOtQILDbKa+3QTOhbHnnmgC+kpINXVbNeWr8YZssuypx0+CMwb7y5nCeY6wneuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmq8WkOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmq8WkOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B57C4AF09;
	Mon, 13 Oct 2025 14:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367049;
	bh=+6nqStFnkz8mtUPOFH01cCwBf6dP9ibXUVn7ITpfbLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmq8WkOnBCwEH3JF/YJPrHGVGWQvwXV7m79Xs6F3v8X3Z7ziAdH51pQaF+A23XLY/
	 REUvgdluAdoi5qjEmO6qguYbwwkwfMIo+k9EYK1VSFcyfrSpz1JbztJaoHIdU+uwlU
	 7Rljy63q76LgAFg9tBHrF8Xi/MvbobNFZx57GuSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/196] cpuidle: qcom-spm: fix device and OF node leaks at probe
Date: Mon, 13 Oct 2025 16:44:07 +0200
Message-ID: <20251013144317.254052757@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index beedf22cbe78b..716474a793817 100644
--- a/drivers/cpuidle/cpuidle-qcom-spm.c
+++ b/drivers/cpuidle/cpuidle-qcom-spm.c
@@ -97,20 +97,23 @@ static int spm_cpuidle_register(struct device *cpuidle_dev, int cpu)
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



