Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E60248878;
	Tue, 29 Apr 2025 16:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945360; cv=none; b=IuytwWLFrV1QXdU+JGXl77cRs58X5pW49PFqAtQ2/vH7JpXsIE/pmXhCzFyu0z91xZNq/tvcbngrwLlvDNTXimDURxIElpoOAA1dlLRdztHNsR9wMRoVUeTxrxtxMqTJ0/2BAa/1KFT1wH78OhFr/kZXxVDMhMyb297OSjEcjlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945360; c=relaxed/simple;
	bh=ZK6uIxKg+/toJ6SA91/loP44i1p5ND9EWDw5Nr2RlG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=secgTjxv1X10e4fAVRhGwBBAOcUTecNXHBrbima4NYf1SbMQoftd3bTZD80NC1+Qya41ihvhaR9QSYS3PL1c9THPBoZXgRB/bDexaAu/a96XR52rAexFEPl7U8rMsEBcvDsniwLsZJ6I91e/3QoFY5nsM2OC5s3J+lw3K+TfGxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4yWsNgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4yWsNgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB77C4CEE3;
	Tue, 29 Apr 2025 16:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945359;
	bh=ZK6uIxKg+/toJ6SA91/loP44i1p5ND9EWDw5Nr2RlG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4yWsNgXbU9sjmM52hrL43qzjh1gj4ugshaJRJn+4Ez125GOI7FmRFGNuLmqM2Hkb
	 rUtr7ACdeDAl0wwM/KTGc9GttXkVEywdZMZ9aGjuhVVvaloPDt0aRyAbeRGYBCTeRa
	 oJPulms1kkG2F6eN+vZ48GF8IHtEZC5bi9YCmDuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 056/179] net: dsa: mv88e6xxx: workaround RGMII transmit delay erratum for 6320 family
Date: Tue, 29 Apr 2025 18:39:57 +0200
Message-ID: <20250429161051.661081365@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2613,6 +2613,21 @@ static int mv88e6xxx_stats_setup(struct
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
@@ -3811,6 +3826,7 @@ static const struct mv88e6xxx_ops mv88e6
 
 static const struct mv88e6xxx_ops mv88e6320_ops = {
 	/* MV88E6XXX_FAMILY_6320 */
+	.setup_errata = mv88e6320_setup_errata,
 	.ieee_pri_map = mv88e6085_g1_ieee_pri_map,
 	.ip_pri_map = mv88e6085_g1_ip_pri_map,
 	.irl_init_all = mv88e6352_g2_irl_init_all,
@@ -3855,6 +3871,7 @@ static const struct mv88e6xxx_ops mv88e6
 
 static const struct mv88e6xxx_ops mv88e6321_ops = {
 	/* MV88E6XXX_FAMILY_6320 */
+	.setup_errata = mv88e6320_setup_errata,
 	.ieee_pri_map = mv88e6085_g1_ieee_pri_map,
 	.ip_pri_map = mv88e6085_g1_ip_pri_map,
 	.irl_init_all = mv88e6352_g2_irl_init_all,


