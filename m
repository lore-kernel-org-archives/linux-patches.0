Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49193435A88;
	Mon, 17 Aug 2026 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980035; cv=none; b=nqkHFImqRCg1Ze+QisKkDZrQ7ypvIBNPKfcmS2v1vc8KVwnmhTt3tuiiL5ZYdOaaGDNClXDZm5c1Qr4dHL+EA/qOFEF9+N7ynA0GcIm+gNqVwkO9ecsOmMBy6DHK7Sa1k5KI82zzQZMW00TjA/YOaUnbigB/f4GJ8Lr37mwxB3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980035; c=relaxed/simple;
	bh=yBj4BEg90Za4uZC4y3Gf3cl3uJsmT8e2ymvvaL/PsMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoP//P+dZHmd7mrn8RpmHAe7uPVN61E9BfrQR971iABj1JbxbIDONTH+hRWeCP8LgDmAxWmG9NxwcTcE9zAGF1wAlpKFcT7db9txTyBsSqVwrWasf//Dq5d0bSGlkiWO9D6Ocj5LurZp7Rnb39yQhPw7retFQIoUucWIAM3Zgoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q90RNYAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q90RNYAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C581F000E9;
	Mon, 17 Aug 2026 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980034;
	bh=z0DxRbLqS1pOXM2dEI5R8zDIGVhDZKSCU3SLMpFaO1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q90RNYAq9Ligc/oIHI4q/L3Wwm6zW3cq0qWK8QY/uyzE4lpgBkFCV3BiZulkErxVz
	 DW4Vl8FTrOdgCRMtuKPqyGkawfIL5TNAN8+W7byHvOQ8lxwKu16HAHkb8Q3Pq2QWdB
	 OlYB7aYuFeGBZj2WmWm8oV0BCsMu5Q1xN1Qe/zlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.1 432/609] gpio: pca953x: fix cache_only and IRQ state on restore_context() failure
Date: Mon, 17 Aug 2026 15:32:08 +0200
Message-ID: <20260817132558.539794259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1247,9 +1247,20 @@ static int pca953x_restore_context(struc
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


