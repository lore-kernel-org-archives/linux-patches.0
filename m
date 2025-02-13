Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6A623A9BC;
	Thu, 13 Feb 2025 14:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457849; cv=none; b=RkayC0b8csfjfMQ7u6eLsG66yTZO1FcMVx0E2xD0Te3w0FS65pAFMzNS9IpTbXuTX0M8qTJol3A0W2QEGvCWbjEggu+DqyTKnh/yCBSklVdx/BiAmCxCTAuoGFZIkiCUSC5oK3ISFXdRxjaQI4M/sc5DGuOQv9FgbNl7X3DwL7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457849; c=relaxed/simple;
	bh=8NkTaN1zO9ve5FmYzsDov8hGovTjxnaN5lIcDE7Wpgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocTY7J/Uy+EJpoeO5omEloSxJxkZJjTKKdHFmdsEsEbai0nwJcgmXmhQW8A60SCaEpjMnj+sIEtZYm1zO8r8n/71F8fleo6qKXu0Xuox1ADYhWlTrNmfExeQAXAbInmzJte1GYMYHOrTZOlRHvUIJsmc6wkkiVLt0W2plmz1qHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjUq7JWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjUq7JWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CACC4CEE2;
	Thu, 13 Feb 2025 14:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457849;
	bh=8NkTaN1zO9ve5FmYzsDov8hGovTjxnaN5lIcDE7Wpgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjUq7JWVcXSNMp/V4iLmIvlSG9vB2PgmbUUV04UzVFkXSjhBfTDdpEKsFMXf4hDyE
	 Ht3g7cY+n1tNlPFtXkQchLo/UXrFPgsDX2B0eqB3yaR1ltARArYg/GhC5SXoP3Uwek
	 L19ZtCk6Lyo1HdP76s0qxnjN1icHULLp2v+8L6W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 198/422] Input: bbnsm_pwrkey - add remove hook
Date: Thu, 13 Feb 2025 15:25:47 +0100
Message-ID: <20250213142444.185244479@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Peng Fan <peng.fan@nxp.com>

commit 55b75306c3edf369285ce22ba1ced45e335094c2 upstream.

Without remove hook to clear wake irq, there will be kernel dump when
doing module test.
"bbnsm_pwrkey 44440000.bbnsm:pwrkey: wake irq already initialized"

Add remove hook to clear wake irq and set wakeup to false.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Fixes: 40e40fdfec3f ("Input: bbnsm_pwrkey - add bbnsm power key support")
Link: https://lore.kernel.org/r/20241212030322.3110017-1-peng.fan@oss.nxp.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/nxp-bbnsm-pwrkey.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/misc/nxp-bbnsm-pwrkey.c
+++ b/drivers/input/misc/nxp-bbnsm-pwrkey.c
@@ -187,6 +187,12 @@ static int bbnsm_pwrkey_probe(struct pla
 	return 0;
 }
 
+static void bbnsm_pwrkey_remove(struct platform_device *pdev)
+{
+	dev_pm_clear_wake_irq(&pdev->dev);
+	device_init_wakeup(&pdev->dev, false);
+}
+
 static int __maybe_unused bbnsm_pwrkey_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -223,6 +229,8 @@ static struct platform_driver bbnsm_pwrk
 		.of_match_table = bbnsm_pwrkey_ids,
 	},
 	.probe = bbnsm_pwrkey_probe,
+	.remove = bbnsm_pwrkey_remove,
+
 };
 module_platform_driver(bbnsm_pwrkey_driver);
 


