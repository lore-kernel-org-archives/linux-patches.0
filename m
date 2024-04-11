Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984B61448EF;
	Thu, 11 Apr 2024 10:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830360; cv=none; b=EfSB0fiiLezwHfW6O6+BEZ+E58+3SdrPq879HH7AwhNX+F7A7u8NozYFPRIzwi03lKk/84brVr/49Do+83zHF/2hl4XXgHYznCbftWiDlWxXadVc9qvQ0h4BBpE1jZJy936Co5+HlQgrdsG3xw75aBS9wi8yh0e+2FqXxkpLnn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830360; c=relaxed/simple;
	bh=XbOOO7v2MH+RBoDNPa6ejLHfsCtN6huP1rkX+gx320k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mo/WoLVpkZM5urHTVvN2+KqdZMVSckpycUh9qphpN5E3NPTMxAZQttKVjuZY2KhQhLEgZaEItxW+NymvI7dM0XOV/L5AJv1gbqY31wduw4fvFaZnib+3gjz2vNhP5kU09XXqye2w7oM24blV1AF95vnpNc3fJBvK74qdJ6wfKzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7FOSSXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7FOSSXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A84CC433F1;
	Thu, 11 Apr 2024 10:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830360;
	bh=XbOOO7v2MH+RBoDNPa6ejLHfsCtN6huP1rkX+gx320k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7FOSSXWHYMCMXd7G7OrNmSIgr5cM/bWvsRZ1d746cChQhHBZZNo8w++xNKB/b55m
	 ygjkn8mk45HKf92fOiF6Ep3jGz6/UnGKww61XRmzdkE/hv2qjdOT2uEO1XBn1ouMBh
	 A6SdtHXBu0fypxoJ/xP8wF7icsfD620cldZYzK00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 121/143] thermal/of: Assume polling-delay(-passive) 0 when absent
Date: Thu, 11 Apr 2024 11:56:29 +0200
Message-ID: <20240411095424.548446735@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 488164006a281986d95abbc4b26e340c19c4c85b ]

Currently, thermal zones associated with providers that have interrupts
for signaling hot/critical trips are required to set a polling-delay
of 0 to indicate no polling. This feels a bit backwards.

Change the code such that "no polling delay" also means "no polling".

Suggested-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20240125-topic-thermal-v1-2-3c9d4dced138@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 4d6c22e0ed85b..61bbd42aa2cb4 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -225,14 +225,18 @@ static int thermal_of_monitor_init(struct device_node *np, int *delay, int *pdel
 	int ret;
 
 	ret = of_property_read_u32(np, "polling-delay-passive", pdelay);
-	if (ret < 0) {
-		pr_err("%pOFn: missing polling-delay-passive property\n", np);
+	if (ret == -EINVAL) {
+		*pdelay = 0;
+	} else if (ret < 0) {
+		pr_err("%pOFn: Couldn't get polling-delay-passive: %d\n", np, ret);
 		return ret;
 	}
 
 	ret = of_property_read_u32(np, "polling-delay", delay);
-	if (ret < 0) {
-		pr_err("%pOFn: missing polling-delay property\n", np);
+	if (ret == -EINVAL) {
+		*delay = 0;
+	} else if (ret < 0) {
+		pr_err("%pOFn: Couldn't get polling-delay: %d\n", np, ret);
 		return ret;
 	}
 
-- 
2.43.0



