Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35E637FF60;
	Sat, 12 Sep 2026 11:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213768; cv=none; b=uAleQcSdTHL86lj/k5T8KVDZ13xVgF8f/OB8QPJwSwNOWTIKUZ9Orc0R+ZhE0xAgp+IXsjdYo5VUXuTdQ2mrMQ2W4zfD5owbJ0NSPPTaLT287NSLv0Zi86GmhZryMNUuFVjNz3w3NzpScYP5lqHmtV/0zXOBm8U11y+uMYUcIRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213768; c=relaxed/simple;
	bh=lxyJUGOBVtQxKYTpAMjsa3+KBFEQoe19l8K/snBFXHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2UQjOm2Nzxmyg9pxJe02gi9WTuiy+rZdbsWv3eKhY6rxtObMwpKKIlqUpBUXUiBu6/BaLZRxzYR/NBCZRp0TuKAjWUuSoRbjabUhZjRxF2hEFg/DfbQS/dq4JVtj7/RHcOYixVgYzrOmbIUOJzc4zxpuIe/CPW0Ia48yqCQSRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaNkN/+I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaNkN/+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA80B1F000FF;
	Sat, 12 Sep 2026 11:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213767;
	bh=qzND/xGRjXI0xBTqu79zSpilLmVJiimAz4UZISdMP5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EaNkN/+I39zxjXcL+ED1hy0qRYRj5MlguGZJNkKR74S+VE6Zi8jyGXWBcs2dAKVfx
	 cI13XlEQOa3IlP7hgNhmXwXkWFMqo12fafyMFMg4T22RzpF70JtTubxE/S/5HOPXOp
	 KTJ9cT3LW9oGgTLS/t0CcaWzOW6z1+1WA72HmQOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0145/1376] iio: light: gp2ap002: Disable regulators on resume failure
Date: Sat, 12 Sep 2026 08:42:51 +0200
Message-ID: <20260912065610.784268407@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -671,7 +671,7 @@ static int gp2ap002_runtime_resume(struc
 	ret = regulator_enable(gp2ap002->vio);
 	if (ret) {
 		dev_err(dev, "failed to enable VIO regulator in resume path\n");
-		return ret;
+		goto out_disable_vdd;
 	}
 
 	msleep(20);
@@ -679,13 +679,19 @@ static int gp2ap002_runtime_resume(struc
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
 
 static DEFINE_RUNTIME_DEV_PM_OPS(gp2ap002_dev_pm_ops, gp2ap002_runtime_suspend,


