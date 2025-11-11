Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A1A1D86FF;
	Tue, 11 Nov 2025 01:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823733; cv=none; b=LUrFXwQyLOr/nMiANf0S/wIRqbvOtzCVJeDAudYeJNigro+J8Ut4gb/xchJdEt5EZ/5w/CD+QShX6IWnFEVqA7PCvRXipmbEGZ0/fHy0OdKBmTCbgyu/19KmlMNrxyJ8jhf97/a4e6e1zGi2r0GCf02TldLL/Mghp37gJhpyTB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823733; c=relaxed/simple;
	bh=wg+/2zkD6A/Cjy/dr7afHiWoD8ZiJAB9s64hAaxpR9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjkubsiM98HYa3xGeF+2MgcgQ7h+SopxdZkxe+oStW6q0kz/Opu+qGjtj0cclnCYkuuhEvnleydo1LnA9fqs9HnrKJb5mleLx1RJcaAJP/UUnwtKf41IshLK//iJ9naDOvhN3pAXzl6F/1/FjqIOhTc2iAWoCDYxEMlcZ+eRG8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZGS5HHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZGS5HHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9276C113D0;
	Tue, 11 Nov 2025 01:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823733;
	bh=wg+/2zkD6A/Cjy/dr7afHiWoD8ZiJAB9s64hAaxpR9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZGS5HHRO/0gcYnAQ3s2Rk4tNMu7KQ4OA6Y7T8oFvaKJIpc2lqp+8bmlmDa0+N9nF
	 xGzPEGPzrcvfkXSdJ167nWJLa5P/V7a6AsQK6Kn8ueebJdxkzSMRF9vJcyv6T43uPG
	 +f4ol4Tdl7S5C2wYsOXZByHnlRpmjSWw2diw8knU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 359/849] extcon: fsa9480: Fix wakeup source leaks on device unbind
Date: Tue, 11 Nov 2025 09:38:49 +0900
Message-ID: <20251111004545.099221386@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 6f982d55f8c5d1e9189906a2a352dba8de421f5f ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Link: https://lore.kernel.org/lkml/20250501-device-wakeup-leak-extcon-v2-3-7af77802cbea@linaro.org/
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-fsa9480.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-fsa9480.c b/drivers/extcon/extcon-fsa9480.c
index b11b43171063d..a031eb0914a0b 100644
--- a/drivers/extcon/extcon-fsa9480.c
+++ b/drivers/extcon/extcon-fsa9480.c
@@ -317,7 +317,7 @@ static int fsa9480_probe(struct i2c_client *client)
 		return ret;
 	}
 
-	device_init_wakeup(info->dev, true);
+	devm_device_init_wakeup(info->dev);
 	fsa9480_detect_dev(info);
 
 	return 0;
-- 
2.51.0



