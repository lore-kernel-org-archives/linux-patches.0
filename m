Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36392243958;
	Sun, 10 Aug 2025 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754844756; cv=none; b=hCS6NihL/hR7dQh2cEk2BbgMu5AQwOhA4C38/6JYQq7bPwd2N0MhN5hDH1dJIGrTek2No1tC3ZlytGhjE1hr0HT2macw6bzsQPi+SL+p7HDQlgh4X4T6+LzMtNF9eQOH4Ty93+htJbmoRk++jH2PpJ5HiWMGNm/eaF5a+Azz+Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754844756; c=relaxed/simple;
	bh=Rc9gcte61KO2vI3yv5oPqQK/jrE1EmDqiOIuzeZCDoI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T5EjFW6phKzHQ5DD4ZQaBlSnKUsGcLEKe3Gi0quPg5G78WnthRFc60qDp1w09jfTRMOamEb8w+bDEetdINV/Zk/0DFi7vlT4Cofhcjkez/LmOFs1GCiRSWYaX5NQYhP9E/5LnzmS6lKP3fbctBW4Wn3ZR5+1NbIrQq4lKh87Lzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTCoucGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTCoucGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD5EC4CEF7;
	Sun, 10 Aug 2025 16:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754844756;
	bh=Rc9gcte61KO2vI3yv5oPqQK/jrE1EmDqiOIuzeZCDoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTCoucGeQzSFRfmxbbXSg+HO6FY0UMLpE8MEn+6NH/bbWOkNgcfe8/l3Dmenocmwo
	 q2d5D+NISd9VHIMwN2diPT7X4xFhjj6OmDvDb9BKzpbQeY1lgVzt5Ey89yMo7HERy/
	 rs2j7VQtAvablpTwchQsANXcGzkMSK+Y81/TBR1YxvL8bfsmtTNklztnNu3SEgRS9O
	 lu3en5VxbPPSBKgedNWG/vOiIfZz/K7sS5hyCUKZvYJrNpYb6Xv71jCKmzT9xYqTeZ
	 cDv14qee2rLsujZcizRGWKkRNB7R7B20RU9ZQIHtgbnYe+Y6yizqKHmnoaUXpVkUQn
	 6MRMXLeriZwVQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16] regmap: irq: Free the regmap-irq mutex
Date: Sun, 10 Aug 2025 12:51:53 -0400
Message-Id: <20250810165158.1888206-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810165158.1888206-1-sashal@kernel.org>
References: <20250810165158.1888206-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit fixes a resource leak bug where a mutex allocated with
`mutex_init()` in `regmap_add_irq_chip_fwnode()` was never properly
freed with `mutex_destroy()`. This is a clear memory/resource leak that
has existed since the mutex was first introduced in 2011 (commit
f8beab2bb611).

**Key reasons for backporting:**

1. **Clear bug fix**: The commit fixes a resource leak where
   `mutex_init(&d->lock)` at line 804 allocates mutex resources but they
   were never freed. The fix adds corresponding
   `mutex_destroy(&d->lock)` calls in both error paths and the cleanup
   function.

2. **Long-standing issue**: This bug has existed since 2011 when the
   mutex was first introduced, affecting all stable kernels that include
   the regmap-irq subsystem.

3. **Small and contained change**: The patch only adds two
   `mutex_destroy()` calls:
   - One in the error path (`err_mutex:` label) at line 935
   - One in `regmap_del_irq_chip()` at line 1031

4. **No behavioral changes**: The fix only ensures proper cleanup; it
   doesn't change any functional behavior or introduce new features.

5. **Low regression risk**: Adding `mutex_destroy()` calls is a standard
   cleanup operation that carries minimal risk. The patch also properly
   adjusts error handling labels (changing `goto err_alloc` to `goto
   err_mutex` after mutex initialization).

6. **Affects widely-used subsystem**: The regmap-irq framework is used
   by many drivers across the kernel for interrupt handling, making this
   fix broadly beneficial.

The commit follows stable kernel rules perfectly - it's a small, obvious
fix for a real bug with minimal risk of regression. While not a critical
security issue or crash fix, resource leaks are valid stable candidates,
especially in widely-used infrastructure code like regmap.

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

