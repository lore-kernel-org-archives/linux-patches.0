Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5F6268FD5;
	Tue,  8 Apr 2025 10:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109943; cv=none; b=Cbe4S5jzlZzXyFy/XJGQoRAb8eIm1cxuulOGega/ALTC1E2fUaBxsp2M2cOLALZBf6h190ToyhdpF7NC7yCheN0QRytANVSUw9imZqrrgYcX7tjK6Ui9r4T8nUy5RVq4xtx7oAN/PuA6Pk9f7fn7hl0Y8R47qQvs7gV3mr/S7z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109943; c=relaxed/simple;
	bh=stpgVO5/sv2Dsx1iEVVs0sgKEH7l7+AAD+8p6ptXy1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNDN278GqbSqVS0lf47yrOleZq6YnKRB0nye6u+4QxUGEzMQlLm2Byy+V+aRyI3TIopQcAVh5m83ViJu5hlux6jaiwHLAvBBN2NmwX3iLmlXhTrdoozRdgd+Th5THK2cbwZH7sU0LlyudehgOunWmeVBWAf7AKj/W4566JToD68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5O6Qrt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5O6Qrt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51ED1C4CEE5;
	Tue,  8 Apr 2025 10:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109942;
	bh=stpgVO5/sv2Dsx1iEVVs0sgKEH7l7+AAD+8p6ptXy1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5O6Qrt9Kc2T57cTHsLMCZdjORx4a/sBGaNNGGAfm9e6J6izxSBlTkcOuWYLRpznq
	 X6QKcui91BITxOPx1vb4y+gq6kObwIxcejAuzAm0yqx9DGnXC/hJCesHFqyAfvHTtK
	 jSXjSi6dnwcAaMPmd/g9gzsKAkZ6eW/He3SpdmsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>,
	Feng Liu <Feng.Liu3@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 5.10 110/227] i2c: dev: check return value when calling dev_set_name()
Date: Tue,  8 Apr 2025 12:48:08 +0200
Message-ID: <20250408104823.652057367@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 993eb48fa199b5f476df8204e652eff63dd19361 upstream.

If dev_set_name() fails, the dev_name() is null, check the return
value of dev_set_name() to avoid the null-ptr-deref.

Fixes: 1413ef638aba ("i2c: dev: Fix the race between the release of i2c_dev and cdev")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Feng Liu <Feng.Liu3@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-dev.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -669,17 +669,22 @@ static int i2cdev_attach_adapter(struct
 	i2c_dev->dev.class = i2c_dev_class;
 	i2c_dev->dev.parent = &adap->dev;
 	i2c_dev->dev.release = i2cdev_dev_release;
-	dev_set_name(&i2c_dev->dev, "i2c-%d", adap->nr);
+
+	res = dev_set_name(&i2c_dev->dev, "i2c-%d", adap->nr);
+	if (res)
+		goto err_put_i2c_dev;
 
 	res = cdev_device_add(&i2c_dev->cdev, &i2c_dev->dev);
-	if (res) {
-		put_i2c_dev(i2c_dev, false);
-		return res;
-	}
+	if (res)
+		goto err_put_i2c_dev;
 
 	pr_debug("i2c-dev: adapter [%s] registered as minor %d\n",
 		 adap->name, adap->nr);
 	return 0;
+
+err_put_i2c_dev:
+	put_i2c_dev(i2c_dev, false);
+	return res;
 }
 
 static int i2cdev_detach_adapter(struct device *dev, void *dummy)


