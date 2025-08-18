Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14F5322A1A;
	Mon, 18 Aug 2025 14:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526104; cv=none; b=IyEGiAdqgZik6luZcRU6duFGf/EgUoZoa/rRms9y3udqnWPbRzky5e4dMaTvMH+82da6BS3Fq2i0QjUV/iMBy4Ld7TOSN783CUQa3oVwX7ClbKeKg4EbYSUCX37bgoyil7EbNK/CNOCAmceiUmdWc9Zt+KZqp+i7OVRC+RLj5nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526104; c=relaxed/simple;
	bh=NejPIpGfctKCodSnhHpFTXqEKhZj/FbqT2iiodajsDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plbNKY8IraxupWQUtACvNShEiBsqEpjzrqy+eQgutj6bwqWG3Qc8Z48l0/DOlP8joCGT8v9GnOEwkIoC+A2tcz2QtiH+L2BABYCUBBvblrbOzzJNp0aTRZfGAKdY4RqoSoCI09e0Bn2yYtbTpyph9RMcBhG7ZmD4tZ7sx7OGK3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiQWr9pl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiQWr9pl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31914C4CEEB;
	Mon, 18 Aug 2025 14:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526104;
	bh=NejPIpGfctKCodSnhHpFTXqEKhZj/FbqT2iiodajsDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JiQWr9plCMEU8gY3TytBudJFI2AlgFWPuQ9H+nABj5MYk6pPZv4IXnZPfVHGdesn6
	 Jq9ae6/iDaETCrlWrva3PQonPvXNx1T4uC0fkTIbkA08fSBwAUhVLf7xLe+w2LJlue
	 2dghzp7wQ0gH25DG83cSOgA3LKjLPnIo7ODxFedg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 460/570] regmap: irq: Free the regmap-irq mutex
Date: Mon, 18 Aug 2025 14:47:27 +0200
Message-ID: <20250818124523.581582722@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 1da33858af6250184d2ef907494d698af03283de ]

We do not currently free the mutex allocated by regmap-irq, do so.

Tested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250731-regmap-irq-nesting-v1-1-98b4d1bf20f0@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-irq.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index d1585f073776..4aac12d38215 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -816,7 +816,7 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 						     d->mask_buf[i],
 						     chip->irq_drv_data);
 			if (ret)
-				goto err_alloc;
+				goto err_mutex;
 		}
 
 		if (chip->mask_base && !chip->handle_mask_sync) {
@@ -827,7 +827,7 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 			if (ret) {
 				dev_err(map->dev, "Failed to set masks in 0x%x: %d\n",
 					reg, ret);
-				goto err_alloc;
+				goto err_mutex;
 			}
 		}
 
@@ -838,7 +838,7 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 			if (ret) {
 				dev_err(map->dev, "Failed to set masks in 0x%x: %d\n",
 					reg, ret);
-				goto err_alloc;
+				goto err_mutex;
 			}
 		}
 
@@ -855,7 +855,7 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 			if (ret != 0) {
 				dev_err(map->dev, "Failed to read IRQ status: %d\n",
 					ret);
-				goto err_alloc;
+				goto err_mutex;
 			}
 		}
 
@@ -879,7 +879,7 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 			if (ret != 0) {
 				dev_err(map->dev, "Failed to ack 0x%x: %d\n",
 					reg, ret);
-				goto err_alloc;
+				goto err_mutex;
 			}
 		}
 	}
@@ -901,7 +901,7 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 			if (ret != 0) {
 				dev_err(map->dev, "Failed to set masks in 0x%x: %d\n",
 					reg, ret);
-				goto err_alloc;
+				goto err_mutex;
 			}
 		}
 	}
@@ -910,7 +910,7 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 	if (chip->status_is_level) {
 		ret = read_irq_data(d);
 		if (ret < 0)
-			goto err_alloc;
+			goto err_mutex;
 
 		memcpy(d->prev_status_buf, d->status_buf,
 		       array_size(d->chip->num_regs, sizeof(d->prev_status_buf[0])));
@@ -918,7 +918,7 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 
 	ret = regmap_irq_create_domain(fwnode, irq_base, chip, d);
 	if (ret)
-		goto err_alloc;
+		goto err_mutex;
 
 	ret = request_threaded_irq(irq, NULL, regmap_irq_thread,
 				   irq_flags | IRQF_ONESHOT,
@@ -935,6 +935,8 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 
 err_domain:
 	/* Should really dispose of the domain but... */
+err_mutex:
+	mutex_destroy(&d->lock);
 err_alloc:
 	kfree(d->type_buf);
 	kfree(d->type_buf_def);
@@ -1027,6 +1029,7 @@ void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *d)
 			kfree(d->config_buf[i]);
 		kfree(d->config_buf);
 	}
+	mutex_destroy(&d->lock);
 	kfree(d);
 }
 EXPORT_SYMBOL_GPL(regmap_del_irq_chip);
-- 
2.39.5



