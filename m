Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEF754279;
	Tue, 23 Jan 2024 00:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970646; cv=none; b=iTG+HOu/jpg6ICD5m3WW3TjpFhXINYTDJ/uEN+sGrbafyZaajqo61XUcdU6t/shpc1A+N9PzMZZmUqRRncAGkRcdLdPE6bfE1By73cYnySxEBqGIGfse0wTDE2x0/QWCfZxvdzOk+/p7NTN5/yTkWobYBi6RPTHn4WK/MKubosw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970646; c=relaxed/simple;
	bh=zx3+LR75HQJcmhvRVTBtpIdEwNaJeBsd5LefPB/eJic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvIZNpVhqu3SaxKx8dP2+VmlKwkfuBTV5JTsyu7nYr7oLXGjvfd70K3UgwF2l4LD1gRUZW7xXBde7CgPCJYvrIquUsHXGS/PNojF5aBXA2ZlSb093i/kMx8QTkSIutV/PWZF3ENvwMGfEj6DLcReEEhnsZeNZK1Ef9k4rg3VS2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cc5RgAkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cc5RgAkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27ADC433F1;
	Tue, 23 Jan 2024 00:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970646;
	bh=zx3+LR75HQJcmhvRVTBtpIdEwNaJeBsd5LefPB/eJic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cc5RgAkL5N612KJN4h+Gg5ojF93h8bNV9Qlt+SWtB8Luy9oNWCGSMf7LhwvESvjeP
	 4IlkovPJOObWaBzTN/yyiJojtKHr8GbVRC7OvJt+gR27c0MHZzI17ld1QJm6q1xgtr
	 OKF4C3jfxxX8txWsB22lf2RQVQVuv3ScqNdHLBM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Rokosov <ddrokosov@sberdevices.ru>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/417] firmware: meson_sm: populate platform devices from sm device tree data
Date: Mon, 22 Jan 2024 15:54:05 -0800
Message-ID: <20240122235754.371274701@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d081a6312627..bf19dd66c213 100644
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



