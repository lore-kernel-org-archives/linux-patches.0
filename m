Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591445;
	b=qhbK7tUqKObxS83XP5z+AGP0XlXdwkO6E+htGgNTaGiCD7BvcCqpws5UnAThvKkVD1dY
	 YiqU4GDpP68iOE98XRBjR/1hOhfHXERjzac729RsX9GqusXZPoSm1ciifE9Huxrm4HVmO
	 Drz3Jz9qNXsfq+I/FpiPVUfdVIeC74Ku/6NFJjjHIHlOWwrW1jQleqFrAou8mURJsb4gF
	 nxHi9fRWI3vJM/77jVXxCArdZAuND+TPspqgjayGcCpaOmP0QOhCgyKEAathXH0cmru5w
	 JWgCR3UOcVejd4uJAN67E1eONslOzRKczOMqHmZYMtmGVU4kVoY3dS8UfEJQiqQ778w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x08crsXIfE6jAFP3wt5a1pnc4/EwAF7fLvl02YupyRU=;
	b=QScvTG5j7SvQ6o7DKIxODigaR3fZyr5qo6nsjdXKVHfQRPkgv5p7eKp7L6BrVHvve/Bk
	 bxvjbQWWY78v7xCflerUNwYkWdjm7VVIpo3iIOK07JFAwqnA7LuBZwj/v00qScJyEul1w
	 9A/O4I1y8oaRghRsH1nKQPXgtjXe809nHirlAok/a0QJA8Hs+Qk3jvV6XMnhUUUaKGME0
	 o/4ey5ZIP7HLGz1IJWc1DtFHgrsBPassN/d4m1h/mJ5iPD/7t47rQw9FAuoSXIRYr1Kxg
	 qi82IU00usBJ7KLGYK3X+Qu9hvambTmJq775sSsXs9RK6M7FTY0OPha68167Zqopu7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zN1CClVI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE391607C34F;
	Fri, 13 Nov 2026 17:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zN1CClVI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A16B1F000C4;
	Fri, 13 Nov 2026 17:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591445;
	bh=x08crsXIfE6jAFP3wt5a1pnc4/EwAF7fLvl02YupyRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zN1CClVIwfJmPYUzX8OLn0DWhUlk3rU2QLS5vpztlVvf/kTdms4uD4Q8zbsE0h/eF
	 wetmz0boaJouY7otG5oUgDD1llDoa6ha3gYLWLgzwUoJVW9gNmz5cLIRLg2KeUbENu
	 0pnW+ujjWI3tOw3d7pUNvlL4tolTeK3Nll5Isnwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 535/670] ALSA: hda: cs35l41: Fix ACPI device reference leak on probe failure
Date: Fri, 13 Nov 2026 10:51:39 -0500
Message-ID: <20261113153830.037987641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit 8d70e364e866bdfca81eee24d0688fac9472cfb9 ]

cs35l41_hda_probe() takes an acpi_device through
cs35l41_hda_read_acpi() and stores it in cs35l41->dacpi. Only the
failures that happen later reach the err: label, which is where that
reference and cs35l41->acpi_subsystem_id are released, so the early
return taken when cs35l41_hda_read_acpi() fails leaves both behind.

Keep the ownership in the caller instead of dropping the reference
inside cs35l41_hda_read_acpi(). That removes the need to work out
whether a given failure path has already released it, and with it the
double put that cs35l41_hda_parse_acpi() would otherwise cause when it
fails after having released the device itself.

cs35l41_hda_parse_acpi() and the !physdev path no longer put the
reference, and the early failure enters the existing err: cleanup tail
through a new err_acpi label.

The label sits between the reset of the codec and the gpio cleanup, so
an early failure also releases the reset and chip-select descriptors
that cs35l41_hda_parse_acpi() may already have taken, while still
skipping cs35l41_safe_reset() on a codec that was never brought up.

cs35l41->dacpi comes from devm_kzalloc() and is only assigned once the
ACPI device has been found, so the put is a no-op when the lookup
itself failed.

Found by code review.

Fixes: 447106e92a0c ("ALSA: hda: cs35l41: Support mute notifications for CS35L41 HDA")
Cc: stable@vger.kernel.org
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Link: https://patch.msgid.link/20261012084152.3740340-1-make_ruc2021@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/pci/hda/cs35l41_hda.c b/sound/pci/hda/cs35l41_hda.c
index d01691c13bf33..210cf48faceca 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -1887,7 +1887,6 @@ int cs35l41_hda_parse_acpi(struct cs35l41_hda *cs35l41, struct device *physdev,
 	hw_cfg->valid = false;
 	hw_cfg->gpio1.valid = false;
 	hw_cfg->gpio2.valid = false;
-	acpi_dev_put(cs35l41->dacpi);
 
 	return ret;
 }
@@ -1908,10 +1907,8 @@ static int cs35l41_hda_read_acpi(struct cs35l41_hda *cs35l41, const char *hid, i
 	cs35l41->dacpi = adev;
 	struct device *physdev __free(put_device) =
 		get_device(acpi_get_first_physical_node(adev));
-	if (!physdev) {
-		acpi_dev_put(adev);
+	if (!physdev)
 		return -ENODEV;
-	}
 
 	sub = acpi_get_subsystem_id(ACPI_HANDLE(physdev));
 	if (IS_ERR(sub))
@@ -1966,8 +1963,10 @@ int cs35l41_hda_probe(struct device *dev, const char *device_name, int id, int i
 	dev_set_drvdata(dev, cs35l41);
 
 	ret = cs35l41_hda_read_acpi(cs35l41, device_name, id);
-	if (ret)
-		return dev_err_probe(cs35l41->dev, ret, "Platform not supported\n");
+	if (ret) {
+		dev_err_probe(cs35l41->dev, ret, "Platform not supported\n");
+		goto err_acpi;
+	}
 
 	if (IS_ERR(cs35l41->reset_gpio)) {
 		ret = PTR_ERR(cs35l41->reset_gpio);
@@ -2055,6 +2054,7 @@ int cs35l41_hda_probe(struct device *dev, const char *device_name, int id, int i
 err:
 	if (cs35l41_safe_reset(cs35l41->regmap, cs35l41->hw_cfg.bst_type))
 		gpiod_set_value_cansleep(cs35l41->reset_gpio, 0);
+err_acpi:
 	gpiod_put(cs35l41->reset_gpio);
 	gpiod_put(cs35l41->cs_gpio);
 	acpi_dev_put(cs35l41->dacpi);
-- 
2.53.0



