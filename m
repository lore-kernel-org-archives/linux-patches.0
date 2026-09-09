Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D5F566C5B;
	Wed,  9 Sep 2026 14:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962403; cv=none; b=M8B9EgTvqWjicb+6u7E3dQF0FZgOLQNxbcBB0oKDsSt7QJz41QEkzaJvic14/8KSTRvIIgk/SF0Ydebcb10QH+deNqj9+/nrp++MByWJ+ZiPSRzko42Updk0unWKKlH4N6falPYrKrjZd4XOEw8Ki4IUEKgy9x6kgim+DIun0Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962403; c=relaxed/simple;
	bh=855c8QSKSyj4wMJn2sD4fzaivqrj3p9XhJX80xc3/T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Etn42JCVY8313S+1x21k08c7xszMV26SffrelYQloJb9ZajxaMGN4qUEIsNMxB4sbCqgVkWWmWyRPZSh7H0NlXCyosDuaG5VrakbnpHHtr8UluWb5XlAuGF+O4AjVcWp2bHHYs/aGkA03GYQMdveKzMeZj3mO218askh2SQtilU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQ4CI3xv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQ4CI3xv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9F71F00A3A;
	Wed,  9 Sep 2026 14:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962401;
	bh=NwdZ/2g39t6g/huiJaOQlDTo0YywV/Oei3MZqvt9UcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zQ4CI3xvNDYoet4qe+qmFyZ9cq93kcpQSTF47AeWzeOhjpBWeOEpqslYnXYcMBt3U
	 V/CV12zFJh62ET6XIdT6FRgB5l8SWcL07wgsIKORnxP4eBzYEODgKtNMDw7PLEOe+R
	 DxE8oiBNp7MbOG8DFb9MKrTAYfWBhhY+xv2vCfmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 278/556] iio: light: gp2ap002: Disable regulators on resume failure
Date: Wed,  9 Sep 2026 15:39:18 +0200
Message-ID: <20260909134240.417048736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


