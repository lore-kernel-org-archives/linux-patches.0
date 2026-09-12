Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A064147986D;
	Sat, 12 Sep 2026 15:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228253; cv=none; b=WfaP7NvM+3mB2/TcqQTllJBjNZoAtk88C2RLjyOPQDswZsUN1lgrpySJO8zvylVQCiD+18RnlKTq8T+wH6L85ms5jVOPmv+wPowpo/WDj8vACtxR+OvzfTuCM6NbygRHxmP7TRLsJZRw/O8ETW8CQdY6Z7uIWd60TVtbMwEDeXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228253; c=relaxed/simple;
	bh=YOh4T4JB2a3vLFChLYwjMEDVaOSqRbN4S8BlLDn/imo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/bOVY6t354y+jovd/bic6gNUrUJ23QBuYb0bxP0cu64kW/f0h7rOJpdmhkQ+elTtp1WptuDh+CrM8JBPmjqQG6GWT+s68cUfzdJw0KUYvV5C7umDakG0uDHVsVuIrBIUp+74P29KYoGT762lN2kSa0CKqZieaevjcW5/C9TRS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+h+2OSo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+h+2OSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC6A1F000FF;
	Sat, 12 Sep 2026 15:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228250;
	bh=79fHxsCyRxn8qqXQf25Jy6K/4jWkYwLmeSt4h9oOA9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1+h+2OSoAHLhfnb/AUhGI1so8QctCSE5xwCXkFPf2obvG4mu+ib23BHU9JEkCWuWs
	 JPp0aEAYNHRqOsDH3WYZExwMxLTxBy2IslDUYeQUv2IsXs6xawjl29EZ+iqCXvVgt4
	 EIJlPzgigspHbfQpvIrhv50jQt6NSLpq1dV00kbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0347/1191] iio: light: gp2ap002: Disable regulators on resume failure
Date: Sat, 12 Sep 2026 08:51:15 +0200
Message-ID: <20260912065556.023118278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
@@ -672,7 +672,7 @@ static int gp2ap002_runtime_resume(struc
 	ret = regulator_enable(gp2ap002->vio);
 	if (ret) {
 		dev_err(dev, "failed to enable VIO regulator in resume path\n");
-		return ret;
+		goto out_disable_vdd;
 	}
 
 	msleep(20);
@@ -680,13 +680,19 @@ static int gp2ap002_runtime_resume(struc
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


