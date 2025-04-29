Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C626B221719;
	Tue, 29 Apr 2025 17:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948679; cv=none; b=KMqo85kHqfeMHvX6OlYD7lu00Bf5JZ1RtMdN02bTCUM4iBmHFom7ZRI7vWUiIcxt0xeiV3T/E5C/+Pigbex5+INDgNr6GAGHS8Azui9za2RdaznRa7e4O20YzQNo7OJcIucnIlSzvS4GVM7DGkSy1wnlqjD4i1PBpQRfp0UuLTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948679; c=relaxed/simple;
	bh=T7FvCwzBeWpyN8wRXfiZYxIeYS9lBCufghOm+EjjaAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qYnUY6G+YQ4U78KH2kZtDkgXZ9Q6p0TtQbXRE5wHo9t44hPLm1gyHiOF71OIYETnfmGsqQqHrnPn2B7XMFyDp6zRz1y9+z8Duy0yDqUoQC2KF1S/nafrU8MI1c7pkbYNjAF+RGXync1ceE5ETWVEUXiwaDdQsb944iQTkIHIJZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPofiLxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPofiLxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595F3C4CEE9;
	Tue, 29 Apr 2025 17:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948679;
	bh=T7FvCwzBeWpyN8wRXfiZYxIeYS9lBCufghOm+EjjaAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPofiLxJyF//WyctgYv7rJXJRQmTjugj7J8WYgUCXW3RwUQShZ6hnbip2fba5aHW/
	 gqLA7UG/K9iqZ7BJU10vh8n5wFuoOhsfJHjn5rhrqJ4uZng3eHPSRijkt6iEEuXLcn
	 G79BLqARq67jYrDBFskwLRsf3hBwdORuKAQfVPbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 079/373] net: dsa: mv88e6xxx: workaround RGMII transmit delay erratum for 6320 family
Date: Tue, 29 Apr 2025 18:39:16 +0200
Message-ID: <20250429161126.402303208@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3192,6 +3192,21 @@ static int mv88e6xxx_stats_setup(struct
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
@@ -4569,6 +4584,7 @@ static const struct mv88e6xxx_ops mv88e6
 
 static const struct mv88e6xxx_ops mv88e6320_ops = {
 	/* MV88E6XXX_FAMILY_6320 */
+	.setup_errata = mv88e6320_setup_errata,
 	.ieee_pri_map = mv88e6085_g1_ieee_pri_map,
 	.ip_pri_map = mv88e6085_g1_ip_pri_map,
 	.irl_init_all = mv88e6352_g2_irl_init_all,
@@ -4615,6 +4631,7 @@ static const struct mv88e6xxx_ops mv88e6
 
 static const struct mv88e6xxx_ops mv88e6321_ops = {
 	/* MV88E6XXX_FAMILY_6320 */
+	.setup_errata = mv88e6320_setup_errata,
 	.ieee_pri_map = mv88e6085_g1_ieee_pri_map,
 	.ip_pri_map = mv88e6085_g1_ip_pri_map,
 	.irl_init_all = mv88e6352_g2_irl_init_all,


