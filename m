Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B114621766D;
	Thu, 12 Dec 2024 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016407; cv=none; b=iXXC9pn6mMI7fGpruKsz89OpjZf0QQTANYdY85RSnWAwDkzCOR+RvYTn5pO01LH/Mg3whb9gZjmqnx5CCLSiJuXXps778URv13Bw804q9AlrsPwDaCDwdxwEVSOB/OENuP05zsV+V91/uH7gJDo/0UJya+qt2XzxCVmOuX6WclU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016407; c=relaxed/simple;
	bh=E3Y7+o0D0aJXY7do7j5uOGPDeaVgL8+oHq+ny3jKckw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbiWP1RRz2g56U8VPjV/T/InmfebO6Hq8RmcOo78jsPk+rh7K+arVnmO+Tl34fuv8D4bKli/8Nq3Pr8WDYK2HMaNu5h28/XSUMEObET5eYDyFiDfpwu3E/Gh2zXcjGX/V/qYPnJAnr2ZPu7yLhlH8+lxocA97MfjgKGia09I2gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGDLOuOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGDLOuOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051EFC4CED4;
	Thu, 12 Dec 2024 15:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016407;
	bh=E3Y7+o0D0aJXY7do7j5uOGPDeaVgL8+oHq+ny3jKckw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGDLOuOJmix80/Jwb/BXuQXPW/6jJpY52izooGZp3jUwHKmlAEl9HK36tx8yiQL02
	 innPQotDIz1Nx2r21G1JVkRxwHzpOOIfbgkhhRcJtrPqhmgr2uYSKHBnwrKHco4fIu
	 vMGVPFrsXHxXsC6pKpDNRV9kWmKVKFyLm+zYX7BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 189/466] regmap: detach regmap from dev on regmap_exit
Date: Thu, 12 Dec 2024 15:55:58 +0100
Message-ID: <20241212144314.265070918@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Tanislav <demonsingur@gmail.com>

commit 3061e170381af96d1e66799d34264e6414d428a7 upstream.

At the end of __regmap_init(), if dev is not NULL, regmap_attach_dev()
is called, which adds a devres reference to the regmap, to be able to
retrieve a dev's regmap by name using dev_get_regmap().

When calling regmap_exit, the opposite does not happen, and the
reference is kept until the dev is detached.

Add a regmap_detach_dev() function and call it in regmap_exit() to make
sure that the devres reference is not kept.

Cc: stable@vger.kernel.org
Fixes: 72b39f6f2b5a ("regmap: Implement dev_get_regmap()")
Signed-off-by: Cosmin Tanislav <demonsingur@gmail.com>
Rule: add
Link: https://lore.kernel.org/stable/20241128130554.362486-1-demonsingur%40gmail.com
Link: https://patch.msgid.link/20241128131625.363835-1-demonsingur@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regmap.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -598,6 +598,17 @@ int regmap_attach_dev(struct device *dev
 }
 EXPORT_SYMBOL_GPL(regmap_attach_dev);
 
+static int dev_get_regmap_match(struct device *dev, void *res, void *data);
+
+static int regmap_detach_dev(struct device *dev, struct regmap *map)
+{
+	if (!dev)
+		return 0;
+
+	return devres_release(dev, dev_get_regmap_release,
+			      dev_get_regmap_match, (void *)map->name);
+}
+
 static enum regmap_endian regmap_get_reg_endian(const struct regmap_bus *bus,
 					const struct regmap_config *config)
 {
@@ -1444,6 +1455,7 @@ void regmap_exit(struct regmap *map)
 {
 	struct regmap_async *async;
 
+	regmap_detach_dev(map->dev, map);
 	regcache_exit(map);
 
 	regmap_debugfs_exit(map);


