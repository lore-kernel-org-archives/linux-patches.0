Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60E8634F7;
	Tue, 23 Jan 2024 00:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971242; cv=none; b=e0iaoRH9GimTuesGlY3j3lSLMHEAMnJ4WYsUwqyEWBQ+wxtwHHpoZCnCuPL7mEV4Ecu5AX39eX2rO5CInQX+2viKmgtjtUutV0gHtZHPMPNyz3nuo0qkkRmmBdKmQTCI/oNs0sH4ECuy3OY6mNOMtHDfz9hdsgULMZQc8pewizk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971242; c=relaxed/simple;
	bh=ZMCSA2ICz09hGS69XkKIAZodHsobBlETofQ/OYhQCYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/kF9jKq5/GmiLWxsvX2Owmlcxe5RqtrH3F2FRBtxyx1tmkDYrUPI1or1yHMdGXiFeerFuWDcunxKcpiOtlSzCGhvoncqN7XzPSvXmPQ1jRYzTea8cMDi3qTxaVyPdcg5sAg+yRFaeDfhUUlEiBwnGcT2eYfQ5V3lqEV3/3sfVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlKPx1/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlKPx1/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA1DC433F1;
	Tue, 23 Jan 2024 00:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971242;
	bh=ZMCSA2ICz09hGS69XkKIAZodHsobBlETofQ/OYhQCYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlKPx1/1MrVGcFkqbJ7ugLaD41Av5PxCgr88iUw0vpitrtWyM+I7qF0XzWFBAQ4Ph
	 SyYqxWmQ0jG23NZRQQ3Rq3h3X74zFIMQIqZN9YytoiuTcWxY8vUHJmBBdwOriEkguh
	 S9AyuUZvEVsdMMN4uPjZAW8LJWfL0FFrTT/1yydo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Rokosov <ddrokosov@sberdevices.ru>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/286] firmware: meson_sm: populate platform devices from sm device tree data
Date: Mon, 22 Jan 2024 15:57:03 -0800
Message-ID: <20240122235736.621267633@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Rokosov <ddrokosov@sberdevices.ru>

[ Upstream commit e45f243409db98d610248c843b25435e7fb0baf3 ]

In some meson boards, secure monitor device has children, for example,
power secure controller. By default, secure monitor isn't the bus in terms
of device tree subsystem, so the of_platform initialization code doesn't
populate its device tree data. As a result, secure monitor's children
aren't probed at all.

Run the 'of_platform_populate()' routine manually to resolve such issues.

Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20230324145557.27797-1-ddrokosov@sberdevices.ru
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Stable-dep-of: d8385d7433f9 ("firmware: meson-sm: unmap out_base shmem in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/meson/meson_sm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/meson/meson_sm.c b/drivers/firmware/meson/meson_sm.c
index ed27ff2e503e..7dff8833132d 100644
--- a/drivers/firmware/meson/meson_sm.c
+++ b/drivers/firmware/meson/meson_sm.c
@@ -313,11 +313,14 @@ static int __init meson_sm_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, fw);
 
-	pr_info("secure-monitor enabled\n");
+	if (devm_of_platform_populate(dev))
+		goto out_in_base;
 
 	if (sysfs_create_group(&pdev->dev.kobj, &meson_sm_sysfs_attr_group))
 		goto out_in_base;
 
+	pr_info("secure-monitor enabled\n");
+
 	return 0;
 
 out_in_base:
-- 
2.43.0



