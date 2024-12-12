Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC38D217F40;
	Thu, 12 Dec 2024 17:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023222; cv=none; b=DuvjDkGYyJbxgWAbSTn132oHKd46j1jqhKf3npxA+JU+cVW50SEdqYvvzLJdlWhhlOr896ijqFEsuMgqPagG6Yv3QBWSCSsBALorhlGnVoj0UkjGdfoakjPRciOY5pr6UVBi2mkxFiAGtz1SZcWa3/xZvucUfywMABNmnjZJENw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023222; c=relaxed/simple;
	bh=wmmt3VGqGaTNbt1PNZ5eky598xYl4IXIacpvfpsjWN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/b55MfleAlMnh6gvcxUSr5Umum4MYnp5iOW7Vk/JbvBUghhULxb+jXYUj41vgJpXAgu3DAmVDd2oHzZOjMtQTOqlpXxvsrnchffM+KtDJqFaKpIpFwDXtsvA9KFBTptO3HwG4mdjlCPpbC39HsSK2VAmWpYrESf0k3fvZfhiQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/2so/su; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/2so/su"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D98BC4CECE;
	Thu, 12 Dec 2024 17:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023222;
	bh=wmmt3VGqGaTNbt1PNZ5eky598xYl4IXIacpvfpsjWN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/2so/surLocqqk2eyfNVfDKfT4WsRDMSpBiWYwdOBM96WO9+WeKlFw12wzeb51br
	 llNfPO3ts42XZSrjKty2dKX4Dh/Pnx/2jZFWxQlwF+zVr6FSMjFi2xDuUTh2eNlRhr
	 k6NiZi6S2WeDz7C5Gq2Viw38zac1NlGPF1gu5ZCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 464/565] regmap: detach regmap from dev on regmap_exit
Date: Thu, 12 Dec 2024 16:00:59 +0100
Message-ID: <20241212144330.075814519@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
@@ -663,6 +663,17 @@ int regmap_attach_dev(struct device *dev
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
@@ -1497,6 +1508,7 @@ int regmap_reinit_cache(struct regmap *m
 {
 	int ret;
 
+	regmap_detach_dev(map->dev, map);
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
 


