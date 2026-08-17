Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5557E43B4A6;
	Mon, 17 Aug 2026 14:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977204; cv=none; b=WOBw9kpeOhxP2M5G4gxoKI/kZJZWXD10oBzf+Y8lnsGYGnndoyifPIpIUD2UV+afHFiQxajxUtLDMIWjSTSz1vxre7wQ7PXMeioy7Ltrfi1nJLqzPmc+dLOj9mZyuQy093UQx6l5HWPgxd4q3/qjF4tzQ6+klj8Xa4I5L9yhaYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977204; c=relaxed/simple;
	bh=ZN/ZmgeC6Edzm+SmQ82MXcqM3aVgvAy2ZgMwJNycBUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouos9TFKjS2xVI1Y3vdC0CwqgkXjb6JvUXcuwsi3HnNOlKyqPLl1CDVrZbXnbP8nQz85lzOHZBofP2WkfOJ5gaSqTOvCE2ntVzSjkVhdgrPvtEoCuZdjCzbbUmSh7ZdFeNDKp/xBKfLdWLiQ1JIuql6zR1hyevGhJQ3P9cB/uhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gc0pHi3b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gc0pHi3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CBB1F000E9;
	Mon, 17 Aug 2026 14:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977203;
	bh=Xu4tJV3x9ZNJEVosox9j3ROp7ONL0pznCcV2nqDZ/eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gc0pHi3bISGnXJp8DEWtMiOWbTdjdRS9gCnF8LZBuGrdRZxOKQ4mnYYSg13T2JnCo
	 1bL+PX13SEj7DL5yHk/J9+6mviQzQzkotm0JjSwdiKt94aUYUI1sbM99a0gkoomleh
	 zkPeiI2jrtgNwp0zf2p6AWpwmFi+wr+eDsid53/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/456] ASoC: max98090: fix missing IS_ERR() before PTR_ERR() on mclk lookup
Date: Mon, 17 Aug 2026 15:30:38 +0200
Message-ID: <20260817132549.783328292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uday Khare <udaykhare77@gmail.com>

[ Upstream commit a792ce0fad61a70793ec565743f11d6ca534de59 ]

In max98090_probe(), the -EPROBE_DEFER check after devm_clk_get() is
broken due to a missing IS_ERR() guard.

The code intends to return -EPROBE_DEFER only when the clock lookup
fails with that specific error.  However, without IS_ERR() the check:

    if (PTR_ERR(max98090->mclk) == -EPROBE_DEFER)

is called unconditionally, including when devm_clk_get() succeeds and
returns a valid pointer.  Calling PTR_ERR() on a valid pointer
reinterprets its address as a signed long; the result is arbitrary
and is almost never equal to -EPROBE_DEFER, so the check silently
does nothing in the success case.  When devm_clk_get() fails with
any error other than -EPROBE_DEFER the check is also skipped, leaving
max98090->mclk holding an error pointer with no indication to the caller.

This means a deferred probe will never actually be triggered for this
device, and any non-EPROBE_DEFER clock error is silently swallowed with
the error pointer left in the mclk field.

Fix this by adding the missing IS_ERR() guard around the PTR_ERR() call,
matching the pattern already used in the sibling max98088 and wm8960
drivers.

Fixes: b10ab7b838bd ("ASoC: max98090: Add master clock handling")
Signed-off-by: Uday Khare <udaykhare77@gmail.com>
Link: https://patch.msgid.link/20260720104254.14948-1-udaykhare77@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 3cf41870978da..4f173f86e157e 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -2391,8 +2391,9 @@ static int max98090_probe(struct snd_soc_component *component)
 	dev_dbg(component->dev, "max98090_probe\n");
 
 	max98090->mclk = devm_clk_get(component->dev, "mclk");
-	if (PTR_ERR(max98090->mclk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (IS_ERR(max98090->mclk))
+		if (PTR_ERR(max98090->mclk) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
 
 	max98090->component = component;
 
-- 
2.53.0



