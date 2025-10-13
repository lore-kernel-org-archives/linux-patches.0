Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423E8253954;
	Mon, 13 Oct 2025 15:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369079; cv=none; b=MX66E7X+CN7eejNOsqDV4lfIHlp3yngd74kYnDxtUNg6fEAWP77FphXZFij5uuFCLFlkP6Oplg1JQraAUg9fRps9tscTykdG4FfbKbbvc/xcR0FRwXXLkrtV8rwdK7ma0Re8u51xtYu+OR80zrOcM+y0Bg+8GEMR2rzVOOOYH24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369079; c=relaxed/simple;
	bh=DgQ3gQs6A5H98fNMZuAp+RHwRYanxc662AdB84EottA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrDf1Q7aLKRDb2aWGUz1hHjI4yH2drNvrWpEZ1J5F3ghNWIKG7d9iIYUlmmVp97wzJppHbHvXQ6yO7QuYjJBebBdT25AvG/NiRiJ/b122Xk1RpGx5PtxBCTceptNKbnk75YVCyYpgGPK1bok1RngVfr3gQrWUswOiiXMB3HB+O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGnhXjiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGnhXjiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E9BC4CEE7;
	Mon, 13 Oct 2025 15:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369078;
	bh=DgQ3gQs6A5H98fNMZuAp+RHwRYanxc662AdB84EottA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGnhXjiqlVmHkWmPirosdp0Sg182/DXhAiXlBoC/utr9H0QmXa4uG41DkbvWgZkGv
	 7KnYZ1JCutDv2HvOh/kr3+kexa26VF+1NH0ajDG29g1hHxE+XsbPvpqqxI4U1p7YNu
	 JJCghYTvJ2osVYsK08spaX/hnPOTKgTK71eRCeBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 119/563] cpuidle: qcom-spm: fix device and OF node leaks at probe
Date: Mon, 13 Oct 2025 16:39:40 +0200
Message-ID: <20251013144415.605349718@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 5f386761b1562..f60a4cf536423 100644
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



