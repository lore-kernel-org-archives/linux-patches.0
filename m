Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E5E33CE8A;
	Thu, 28 May 2026 20:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999269; cv=none; b=sL/okN9+M3GS9vFGDmDoQhElk3YUW27vJqTM43MR5CCL1B/2cgW0R2FqKk4IDogPF0tIw3kk7iXcD7G+zH3JHNegmK7DyjzAS/8ttpPUmVrEjaY79DTfXWQl/tmXq2CJKbLSoMJ0gzkG8eyXHVp+NB82EB3UTAP031Nn4dy36XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999269; c=relaxed/simple;
	bh=8FhZKMq0GTiVgsXlkdegnRIpliB2UIMHswZqVojK/EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlTopMAWP5CWEWeCaVKBfxLy4VyRZ9x39KpuG6vCZ6ZuenQRMqHCHZRUnTAlLSgYFCNz6N3DFpyw6TqaNPCKbASc4An8MJuAK3uAH8lJ09cwy1CQdiO7ybNBz8c6Kj8P0V81sG2AQ9XfKOCELZz4r0Q9h3MF5NU2+dROqfB+lAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLukPZMT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLukPZMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DBC1F000E9;
	Thu, 28 May 2026 20:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999268;
	bh=wM0qT3Dfle7FNzbEZmTdjPXWmvwRiBs9X1XbKP6TnbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZLukPZMTw4TlkIYli0R1ht26v5fKdMmn+h0gLuJifJD0i6Q/6CfRJ3zyjUyU4rfCQ
	 9GeslxVbc4EBPxg8LnxyezYjzoEJ5rtarIHjUR+O0IrYUrnWwb0oBTX2qTGbaV3qic
	 MEewYioT+4sZ3gccCoy4A+eQ/ucxQ7eHgZ+z6zIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 439/461] gpio: aggregator: remove the software node when deactivating the aggregator
Date: Thu, 28 May 2026 21:49:28 +0200
Message-ID: <20260528194700.238435383@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 61fef83f239ecace1cce716135762a2d9b7b1fc6 ]

The dynamic software node we create for the aggregator platform device
when using configfs is leaked when the device is deactivated. Destroy it
as the last step in the tear-down path.

Fixes: 86f162e73d2d ("gpio: aggregator: introduce basic configfs interface")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/all/CAMuHMdVZ=XUvJTGdDAjnkxgtw7Uvnn61iOy3XN_5XNZM2anctw@mail.gmail.com/
Link: https://patch.msgid.link/20260520121631.33976-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-aggregator.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpio/gpio-aggregator.c b/drivers/gpio/gpio-aggregator.c
index b53230065f50e..a9ad809708fb6 100644
--- a/drivers/gpio/gpio-aggregator.c
+++ b/drivers/gpio/gpio-aggregator.c
@@ -991,11 +991,15 @@ static int gpio_aggregator_activate(struct gpio_aggregator *aggr)
 
 static void gpio_aggregator_deactivate(struct gpio_aggregator *aggr)
 {
+	struct fwnode_handle *swnode;
+
+	swnode = dev_fwnode(&aggr->pdev->dev);
 	platform_device_unregister(aggr->pdev);
 	aggr->pdev = NULL;
 	gpiod_remove_lookup_table(aggr->lookups);
 	kfree(aggr->lookups->dev_id);
 	kfree(aggr->lookups);
+	fwnode_remove_software_node(swnode);
 }
 
 static void gpio_aggregator_lockup_configfs(struct gpio_aggregator *aggr,
-- 
2.53.0



