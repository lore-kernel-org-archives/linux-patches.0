Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28135569F;
	Tue, 23 Jan 2024 01:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974062; cv=none; b=TBBFDjSAiZmn+gFNv6Fv/wXYlyqWb7WXcvmoQh7rp6/ZDpfHyyvllgjiUlKMRWV6f9vHV8Zaet9ZpmcNmxy7K/QOrarsHM6xMX/6Fs11okOJt8nTEmtxtSQxdCBz2XkdcsxhanxIZEwO/oMRI72JXu1EeoKa4Y8HhlYn4q1xA3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974062; c=relaxed/simple;
	bh=rxwu8+Dh1uVSUwGm6gGU50B6fB3elpC9njPzIV30CyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPwW0J84Y2HAwEQIZEpD0ndLa2/W/9wjhS6AMiSvNndNjV7ECWMjLYxKaxjrma7tqNoZBnAYP7//qsYZJZDIDGE83lWSVNrFcSojLqp97U3kGLd07k2i6OjZWiq+fFlWfsXmev//5QpmsV5knO34002VERnNJFAjEDtiJX0LcL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eZAftRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eZAftRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733E2C43394;
	Tue, 23 Jan 2024 01:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974060;
	bh=rxwu8+Dh1uVSUwGm6gGU50B6fB3elpC9njPzIV30CyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1eZAftRgFxjSJCvTQRfIg5pRc874Ho0FupB6w1DLyzHcJAf9KwbdLs7FvviQJUAsP
	 y4YvizAV9KUiKoEtlkFxRrPMJNvdWnsfkv1PKxo28QtemX4WlmQTUIO1UTTcKxvNdY
	 d0JLueTNoitqU8PWCS+SplvsmlesageZqGQGR4P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Rokosov <ddrokosov@sberdevices.ru>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/374] firmware: meson_sm: populate platform devices from sm device tree data
Date: Mon, 22 Jan 2024 15:56:21 -0800
Message-ID: <20240122235748.989267842@linuxfoundation.org>
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



