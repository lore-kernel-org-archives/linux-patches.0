Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2444756AB;
	Fri,  7 Aug 2026 15:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117464; cv=none; b=oh4aQfnfNLefA2H0hK9zrr5n920tClEzNPTcJ2cF6BZKABGiUU5VSeGAKiIf13H3199NihfD/kilgTZd6MU+BSPr4JWyutIWJ8UpU24JZTUZodiA2M8o4e/8tjVnVyezQo/00bnA84GWvwc6e6qV/NpZ9F7U2KdXBT/N5U3DL3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117464; c=relaxed/simple;
	bh=i2QrkrLPYwH24070dh+sPYK31CJ3OUrRIOfntnU6j+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2ojTU2HtzruCbb0W5VhR2/a7FAyJXwA7u5F0BFYNWUr6V0cSpiGuxZmAi52eBsuWVInsH4X2vEqD0fXiDebgRKV6g6tO1r38xEXkMMLneFCkcWmYwXp8HF2juh9xL0/3h0wvLwq766CX9HpsYcEb36ANR2gxDlEMHFO6tAqnYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZbfMZrT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZbfMZrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048781F000E9;
	Fri,  7 Aug 2026 15:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117463;
	bh=8JAHf/25Qg/0jU2MW0TiGsr+qMUxmHaba/85kXfWN1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZbfMZrTuzLt398B3LPGAIAR0a722IX74xzzA8CMLWInR3HD5I7N/VQJu0gMHyCJt
	 zjax9c63kcS/99QWnAAjV1TDZjvMsQ2GmKsTurl2+YKHXKf/AeiP3exdUY4wnKf6BD
	 P12+YgNpEuSK7rP42pTyfmXYgJ4pOz23EdACZwKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.1 328/438] gpio: pca953x: fix cache_only and IRQ state on restore_context() failure
Date: Fri,  7 Aug 2026 16:38:44 +0200
Message-ID: <20260807143434.967427416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1373,9 +1373,20 @@ static int pca953x_restore_context(struc
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


