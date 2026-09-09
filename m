Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C929576EA1;
	Wed,  9 Sep 2026 14:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963844; cv=none; b=KrzIxzkobuLjvU03e3K++ziGfgt8k1RsPYt+thpRXE7nokZ4SDwIzu6ucXs34d5BIHzizn3KkvJxCSzEkEGgSME512b0Khpm64V8W/+chVQdMpIGGsebarMvM8xBXtw4giEA94ODQsKYTjkTUYBwz8sIprPhsyIAlWaA+009c80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963844; c=relaxed/simple;
	bh=DcfPSClCgcvQfAGkLBOz2jkXxHlEE7wfQfcLtqT1XTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihnGpBxkpxUHIwSztiBxf9ubQ7PemJx0R1KVBJSnxfoKq3odF9PFwVq+JfFjdOmgsKVwyw+KTPZ8Q5Ri8nbqOVf882+Vnce8b2SoAj6u7LSG3u57GzsrucrptsM8qVC28V0dF8DcmjquPVD5eNF737nO3Hj5GG8WhhJuTUtRxAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOQZRFzY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOQZRFzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835861F00A3A;
	Wed,  9 Sep 2026 14:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963843;
	bh=7iAFhc37Z0AhNPommXcpMBXyqQgkTyyYe7KPo6XGf0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOQZRFzYKc239tTkzid2u3PGL1XsZe66VAFMuhljjgtzumj7F+DOUXj9onrOXBJBd
	 JRT0aG1qXfVe7YBLc4gogDSUmkjpOo+SdXJ04FOamNelROxb6K68NjAXgC5eDmDQMf
	 mmo89lIDEi/ImFz/Pz3hzf9Q9CP6z8WcRTdGczlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 216/583] iio: light: gp2ap002: Disable regulators on resume failure
Date: Wed,  9 Sep 2026 15:38:21 +0200
Message-ID: <20260909134245.628959569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -669,7 +669,7 @@ static int gp2ap002_runtime_resume(struc
 	ret = regulator_enable(gp2ap002->vio);
 	if (ret) {
 		dev_err(dev, "failed to enable VIO regulator in resume path\n");
-		return ret;
+		goto out_disable_vdd;
 	}
 
 	msleep(20);
@@ -677,13 +677,19 @@ static int gp2ap002_runtime_resume(struc
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


