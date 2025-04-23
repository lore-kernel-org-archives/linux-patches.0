Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBECB281376;
	Wed, 23 Apr 2025 15:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421128; cv=none; b=aGArCBqKUrig+zfTmQcP8aPQzF1R3pyuRM9Iou8jPipT17ZiDbSm4W+b/KCNP3d1NCGv2Ur1WQLNLbNh3enwjhVeY+WsfkcLkpbhlhyQr1Yba0nHZv34mdm4fcuYdMHPYrED/Qm1ojBjYISmt0HlNsYpViCOp+4JZ2yhbZqseMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421128; c=relaxed/simple;
	bh=s8ROOpClq24505Tsy8X/qfxtJKZHfLWUKW/W/N1Vb/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sXYjXgd3yHnBhKnwGHdXHNGHR9rqklkR6VWvP1BxQV8agiOtR7qwMorvRreKFDF41IRQyAObAvwIDbz1n1x8pDa3sKh4tGdXK0/Wtc47VuZ5jbqJCChe335edKqUj05HxA1AhzJES9nGFs/NkA4NTTD6j8SHOx6atuTa8/Zqepw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wm90gbn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wm90gbn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E61BC4CEE2;
	Wed, 23 Apr 2025 15:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421128;
	bh=s8ROOpClq24505Tsy8X/qfxtJKZHfLWUKW/W/N1Vb/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wm90gbn70roM4rM2Y3bimqa78wP/ar+bghiq7nZsDSqsTdMZJUzdntDX7gxSTuPxU
	 dZuzfW6mSX3hf5QHhuAcsVcdAog0QGeNgrbKD4Ui1vpOsYg9YKPMpKXW2gS3iPVx6i
	 tmsshErIofaTi6wDHRWW9scQ4mElhqUMelEdMWf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 149/393] net: dsa: mv88e6xxx: workaround RGMII transmit delay erratum for 6320 family
Date: Wed, 23 Apr 2025 16:40:45 +0200
Message-ID: <20250423142649.535982523@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

commit 1ebc8e1ef906db9c08e9abe9776d85ddec837725 upstream.

Implement the workaround for erratum
  3.3 RGMII timing may be out of spec when transmit delay is enabled
for the 6320 family, which says:

  When transmit delay is enabled via Port register 1 bit 14 = 1, duty
  cycle may be out of spec. Under very rare conditions this may cause
  the attached device receive CRC errors.

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: <stable@vger.kernel.org> # 5.4.x
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-8-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3555,6 +3555,21 @@ static int mv88e6xxx_stats_setup(struct
 	return mv88e6xxx_g1_stats_clear(chip);
 }
 
+static int mv88e6320_setup_errata(struct mv88e6xxx_chip *chip)
+{
+	u16 dummy;
+	int err;
+
+	/* Workaround for erratum
+	 *   3.3 RGMII timing may be out of spec when transmit delay is enabled
+	 */
+	err = mv88e6xxx_port_hidden_write(chip, 0, 0xf, 0x7, 0xe000);
+	if (err)
+		return err;
+
+	return mv88e6xxx_port_hidden_read(chip, 0, 0xf, 0x7, &dummy);
+}
+
 /* Check if the errata has already been applied. */
 static bool mv88e6390_setup_errata_applied(struct mv88e6xxx_chip *chip)
 {
@@ -5005,6 +5020,7 @@ static const struct mv88e6xxx_ops mv88e6
 
 static const struct mv88e6xxx_ops mv88e6320_ops = {
 	/* MV88E6XXX_FAMILY_6320 */
+	.setup_errata = mv88e6320_setup_errata,
 	.ieee_pri_map = mv88e6085_g1_ieee_pri_map,
 	.ip_pri_map = mv88e6085_g1_ip_pri_map,
 	.irl_init_all = mv88e6352_g2_irl_init_all,
@@ -5054,6 +5070,7 @@ static const struct mv88e6xxx_ops mv88e6
 
 static const struct mv88e6xxx_ops mv88e6321_ops = {
 	/* MV88E6XXX_FAMILY_6320 */
+	.setup_errata = mv88e6320_setup_errata,
 	.ieee_pri_map = mv88e6085_g1_ieee_pri_map,
 	.ip_pri_map = mv88e6085_g1_ip_pri_map,
 	.irl_init_all = mv88e6352_g2_irl_init_all,


