Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62240384CD4;
	Sat, 12 Sep 2026 19:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242030; cv=none; b=l2Jg+o78UWqulKiBAzecc699cSUfSojGF4/HoiKcpdHEbK45I+uROivUDHSXIcWoJEe+CtpitwcVATzOaJMa/UcooVRuHnXzFwRN1zEsIeUVNVQ7WUhGJJ14jG7DqmWskaae3mJqxSLRKEcwnza6DWk8HQvYDy79c/u7dWdYezs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242030; c=relaxed/simple;
	bh=fPVTReNs+8yLVhMQK/KiSiVph5n0WxpzbHvgLFfc1LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2zA2wTDLZ+mXqobDSwykpRNr/bkfOmu98dfqI0hLVqiwdbaZwEA7lFw1HmLReKpdGHtL5kZg3Nj6Yh7qoqbeKyWgeFrwcLawULi5UTlA5gNxI4Rnb705KAIR9DIRCLqSPhnlAOi9Xe0VIeFsZATGMK1sYNwKHf8iC6pmr4k03E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rifaNaq4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rifaNaq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD28D1F000FF;
	Sat, 12 Sep 2026 19:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242027;
	bh=0RyKnSnJt0h4FW9K96yQpMT4oLz3BWdyTpwVrGSp04I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rifaNaq4OS1PaspEBBSgt8tsFMBdylphDXm5+LDziEA0W5oEQXS0tZYJfAGS/Zn0n
	 i3wroeo9HVhfnAn2j1C2XQ4MeFUriQ6GFgEQ65q+rU5qWpEmhxVL0VSWjLIFxJTbUW
	 o+I0BqAG7oP723zNcTkvGAHtLH2gcH+0bWFSFoUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 260/798] iio: light: gp2ap002: Disable regulators on resume failure
Date: Sat, 12 Sep 2026 08:58:08 +0200
Message-ID: <20260912065523.119594000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

commit a41000ba3a230bed1e422f283486ff8f77fe0d30 upstream.

If enabling VIO fails after VDD has been enabled, runtime resume
returns without disabling VDD. Likewise, if device reinitialization
fails, both supplies remain enabled. The runtime PM core keeps the
device suspended when its resume callback fails, so the supplies must
be restored to the suspended state.

Disable the supplies enabled by the callback before returning an error.

Fixes: 97d642e23037 ("iio: light: Add a driver for Sharp GP2AP002x00F")
Assisted-by: Codex:gpt-5
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/gp2ap002.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/gp2ap002.c
+++ b/drivers/iio/light/gp2ap002.c
@@ -679,7 +679,7 @@ static int __maybe_unused gp2ap002_runti
 	ret = regulator_enable(gp2ap002->vio);
 	if (ret) {
 		dev_err(dev, "failed to enable VIO regulator in resume path\n");
-		return ret;
+		goto out_disable_vdd;
 	}
 
 	msleep(20);
@@ -687,13 +687,19 @@ static int __maybe_unused gp2ap002_runti
 	ret = gp2ap002_init(gp2ap002);
 	if (ret) {
 		dev_err(dev, "re-initialization failed\n");
-		return ret;
+		goto out_disable_vio;
 	}
 
 	/* Re-activate the IRQ */
 	enable_irq(gp2ap002->irq);
 
 	return 0;
+
+out_disable_vio:
+	regulator_disable(gp2ap002->vio);
+out_disable_vdd:
+	regulator_disable(gp2ap002->vdd);
+	return ret;
 }
 
 static const struct dev_pm_ops gp2ap002_dev_pm_ops = {


