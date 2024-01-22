Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF95937C;
	Tue, 23 Jan 2024 01:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972177; cv=none; b=DhIhQR8hXW7OVRTyBq4GrBUKhVluFBusouFBAd5wG+uyT5YIZH5fgq3akdS4WLGSSy96RgJvt7iS2w0/mkVgx/ddhWuqIVgIJjgxgGtzj8q4TLTkbdJurDd+nYapGtMRyGG63708NDMRwQqefzVRvVQo7pIb+yHqO1i/5suz62A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972177; c=relaxed/simple;
	bh=b+/ad4Cf26qPk7IawLoKEWSSJY3ooSw+xvBBbaqKLAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPU3MqNoaZp3kL8vservSkKddBD1Ey2TEvv0f3jTOpJTlSn7IS//i+jfPLsFX8D65gkhdnDI34RkOqi+VvjOU4YCpYiB9w83uCkSNEsV2uMbYJSkJ6scFxs5wBWO7qqQ6Lh9OckPbi2FLr1JlSFaRr8xlEiqI3vadbNIbeY4Pak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tE5jaN2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tE5jaN2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C5CC43399;
	Tue, 23 Jan 2024 01:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972177;
	bh=b+/ad4Cf26qPk7IawLoKEWSSJY3ooSw+xvBBbaqKLAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tE5jaN2A3ff3SkuhXXiQrZkp6Qr0N5cjAwD7ZngaeNxq0nVfUhkBOEq9rvU2paLto
	 +dRRoLKKDKiEk5n2AkM3+hRJQzGbOzIuzCwIZu8vVteGBo8hHxC+MwJO2aKz5VCdwU
	 yx8mgAFVjT8G5tGtaOby+zFhvZ6GPZz+liqwaRis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Diupina <adiupina@astralinux.ru>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/374] cpufreq: scmi: process the result of devm_of_clk_add_hw_provider()
Date: Mon, 22 Jan 2024 15:55:41 -0800
Message-ID: <20240122235747.573338492@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Diupina <adiupina@astralinux.ru>

[ Upstream commit c4a5118a3ae1eadc687d84eef9431f9e13eb015c ]

devm_of_clk_add_hw_provider() may return an errno, so
add a return value check

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8410e7f3b31e ("cpufreq: scmi: Fix OPP addition failure with a dummy clock provider")
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scmi-cpufreq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index 82e588c3c57b..c24e6373d341 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -299,8 +299,11 @@ static int scmi_cpufreq_probe(struct scmi_device *sdev)
 
 #ifdef CONFIG_COMMON_CLK
 	/* dummy clock provider as needed by OPP if clocks property is used */
-	if (of_property_present(dev->of_node, "#clock-cells"))
-		devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, NULL);
+	if (of_property_present(dev->of_node, "#clock-cells")) {
+		ret = devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, NULL);
+		if (ret)
+			return dev_err_probe(dev, ret, "%s: registering clock provider failed\n", __func__);
+	}
 #endif
 
 	ret = cpufreq_register_driver(&scmi_cpufreq_driver);
-- 
2.43.0



