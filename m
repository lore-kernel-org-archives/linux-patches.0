Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF9932B10B;
	Fri,  7 Aug 2026 14:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114273; cv=none; b=I/kV9FVcq5fd2Jms6X4AlESWIWYSbPo0NsQ5prk21a5yasEzG092nNuyNpgIpdL2t8yk3FVQ1XeT363RK2q/gI/RHMLITNICAfTfTatlyMZeN5si5+qD2egR6XxsbiAl9OyAsZ4IEq6pVcTJtqrF08mmdBnAgvj5tUVQNwdeUjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114273; c=relaxed/simple;
	bh=Ww8EI81cQzc7121ikT/9qO42+G/CpAvhtzeGHxoUwww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0Rs/gP8zbEjhdYrOOvWGngnkc+4brTg6NAuiF+HlH0AXqRhZziIu+29ClKwrHmK05t5yC8zqVabPR5CjPeDeQrLzn55aHpaeGYlLQb3JsJJS6XcqF0bc4XowpYi7XEqPgv27JtzrF4Znyy06dxiwt2siW9dFneahmHtr71QEBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCrBRH03; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCrBRH03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF45C1F00A3A;
	Fri,  7 Aug 2026 14:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114269;
	bh=vIYds4NvOy3pbArcuWIpWPFkU6Kk7SN8/hyOaUQcP4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kCrBRH03ZyCf4gZ+nNLOG8u5BnzkkBUDUxmZINo6e2759a+TuV05l4ETzgYPBoMdr
	 l2U6MioY9uOQcvPiMd6d7nRm//3tzcVBfkRLDSAtWZRTPtPKHp96ehqCfAWvSrEDOm
	 F4zMYmA/JkojchLtH1Dz1ceOdcpH3WbTG5FY0um0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 203/337] gpio: pca953x: fix cache_only and IRQ state on restore_context() failure
Date: Fri,  7 Aug 2026 16:36:46 +0200
Message-ID: <20260807143422.955746992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1256,9 +1256,20 @@ static int pca953x_restore_context(struc
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


