Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B76335C1BA;
	Wed,  3 Dec 2025 16:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779155; cv=none; b=iVRxUxx46JKLcoQpyUZzNiLzDRLmcPzaDtVY774Sgy9pHot7zcCqDL6R7Hycgm4lsXmSermsmvnIIRetewnU4/qapBGspq6ySIFDCVWmynFV7g0mV0hL1cDCcQhGnpAu0GJk8d4isABhjDhESGNqSei2SHzuLp9DNiMaMK1n4s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779155; c=relaxed/simple;
	bh=dd0REasp3gXENDGQ9cImuFpCVrYZynemOrbbQyUcK9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S73SIGQtXv4cezQVmtiXE7fOB1OPi+U4OszmBaLNbK9YMlZi9K7EOmailgcQT6By1UxkrPG9YK8Rs124Ee6eWUd7CD1CQWmfe2boBaDktH621jSY9mIqy+rxAnHL0Eq3Pi5zKhhncehOW7UCTwPmLqkLKlUkfbutlnEWetumI5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Am50wC4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Am50wC4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2198DC4CEF5;
	Wed,  3 Dec 2025 16:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779155;
	bh=dd0REasp3gXENDGQ9cImuFpCVrYZynemOrbbQyUcK9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Am50wC4q6A+wVtzRiluNszUGloOV2ylu0xmlbR9i/QqYpNo0zA+YvM/S/STkxsAZQ
	 HlIpQOT891IizDlM4avEh6ztmevV4SEQ3uLb6q8lTJndgqsbRlWrwOTaF3MnjCQV7a
	 cznjG9F6gzIGAlUyc1jAY0xnRz8iusmU5KYP2OCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/568] extcon: adc-jack: Fix wakeup source leaks on device unbind
Date: Wed,  3 Dec 2025 16:22:52 +0100
Message-ID: <20251203152446.950314371@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 78b6a991eb6c6f19ed7d0ac91cda3b3b117fda8f ]

Device can be unbound, so driver must also release memory for the wakeup
source.  Do not use devm interface, because it would change the order of
cleanup.

Link: https://lore.kernel.org/lkml/20250501-device-wakeup-leak-extcon-v2-1-7af77802cbea@linaro.org/
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-adc-jack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index 0317b614b6805..ea06cd4340525 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -162,6 +162,7 @@ static int adc_jack_remove(struct platform_device *pdev)
 {
 	struct adc_jack_data *data = platform_get_drvdata(pdev);
 
+	device_init_wakeup(&pdev->dev, false);
 	free_irq(data->irq, data);
 	cancel_work_sync(&data->handler.work);
 
-- 
2.51.0



