Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C564388E58;
	Fri,  7 Aug 2026 15:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115400; cv=none; b=kUFjdHwQnRrwZjvykPOJsHBxZW+8kqLw3/ItpZ3/52bC0yewLK60PDNWMCM1L8uc46Y11ytzp2a02iTedw07MNzDvXU0XvJG8VzkkwZrZdT6RVV6CmXvHl654L3LK9yESCnyhO4wKNMFkMYRdv+nT8BD0oSkvrJ3yxcUA4f2B58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115400; c=relaxed/simple;
	bh=LOkRQzJS0vrtBnHmsKVSRSfoX83FMBYY6ZJLwFzYtPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNzd7h8/JbGF9Ivvr8/EaWAxl4jQImP0P41yHB2apicuF/tTGmXEMS4jCmlif4m8AD6T/2wZRjaW/3OhNa//96TTRbuPHTKrZDBnFSVexBmzE9Qx1qmB3JBPixas6QDgH6Ov0RJ9d+v+eRsqWXjEP7YpGtIJRWgp7nvawaBcFAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7HajvmU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7HajvmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035471F00A3D;
	Fri,  7 Aug 2026 15:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115399;
	bh=u/7rmn9d7Rd8NKLQJd10M531idiDvFQEUXnxZV/g77o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7HajvmUSLTM0I2y4/RX0kf0xExpxydNYZy8EHJ3MXrY/7Gx+nrVELb3qhr1OAmF+
	 RehA3MTTd2lAmjpHv1ejpBwHjlxdF2D9kB+aeGPXmXbum4KlH/nvDLEUWtz2G1j6F4
	 rrci2+evIetTQdkcCZbF83Zbwx46UYUP6JYjWgA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 263/396] gpio: pca953x: fix cache_only and IRQ state on restore_context() failure
Date: Fri,  7 Aug 2026 16:37:03 +0200
Message-ID: <20260807143429.930983769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

commit d233087c19f6607ef926ac3f47d776e2406ffd1f upstream.

When pca953x_restore_context() fails, cache_only is left disabled and
the IRQ left enabled, even though register synchronization may not have
completed successfully. Restore cache_only and disable the IRQ again on
failure, matching the state set by pca953x_save_context().

Fixes: ec5bde62019b ("gpio: pca953x: Split pca953x_restore_context() and pca953x_save_context()")
Fixes: 3e38f946062b ("gpio: pca953x: fix IRQ storm on system wake up")
Cc: stable@vger.kernel.org
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260727080205.16353-1-phucduc.bui@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pca953x.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1370,9 +1370,20 @@ static int pca953x_restore_context(struc
 	regcache_mark_dirty(chip->regmap);
 	ret = pca953x_regcache_sync(chip);
 	if (ret)
-		return ret;
+		goto err;
 
-	return regcache_sync(chip->regmap);
+	ret = regcache_sync(chip->regmap);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	if (chip->client->irq > 0)
+		disable_irq(chip->client->irq);
+	regcache_cache_only(chip->regmap, true);
+
+	return ret;
 }
 
 static void pca953x_save_context(struct pca953x_chip *chip)


