Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DEE3093C9;
	Mon, 13 Oct 2025 15:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368141; cv=none; b=fesY7kqjI+hWD61ZMtMlXJfqR3h8Dvqblop29J7QcFmmQSwVnZZy1xafbb9fjfaiZ/WY4Cs8J+Hh1DRteLJ0agxrN5vTb3/+CBM3igX9h8vmtfoNi89IB+DQSatfhr9p1qE9PzlwOb6oJW81Y1bR+f0vwSTEkje7D7uBFIVe9Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368141; c=relaxed/simple;
	bh=YeD5iW/bySKObCl73uQbWdtVZa/+9nyxrWBHsS8OdlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxE+Iq33D8t8RXEkfHz5uFS2vW3Gza1krvKjmowRr3KsV/wcdsLw/WMfQYWBVw6bDTYVeWiARzYLuMIpGl1NCGgmIVP5R2tjqAQqFJrYJ0X/pzSYsgIdOXKysnyO5lqWpl8t6tHFaLA1jqjZUYeCGHBQw8HKcDV7zE32x7iOpG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VL2vNqFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VL2vNqFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D3FC4CEE7;
	Mon, 13 Oct 2025 15:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368141;
	bh=YeD5iW/bySKObCl73uQbWdtVZa/+9nyxrWBHsS8OdlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VL2vNqFloZI/DHY2Y+yQ+h0m70NIAZfcLDkdzDrMoRmE5YOdUkaQtV1d408HRoTMm
	 O0S0IVyaxLMeldqHC9fwmoj6bFlMyM8FrcgtmQo8z/vGiwvuQFzYdcfTYpjqY8N31t
	 g4R9xA7Qc9A4v69KVq2GKbuiX++ebm+FSWjXWm4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/262] cpuidle: qcom-spm: fix device and OF node leaks at probe
Date: Mon, 13 Oct 2025 16:43:20 +0200
Message-ID: <20251013144328.219083010@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



