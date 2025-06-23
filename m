Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5581EEA3C;
	Mon, 23 Jun 2025 21:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714038; cv=none; b=TvLY0G4c6oBfbJ2NW1p71w8Pk06KAGJxQPhZqGuuaONK7YMiXOmtQ16z1c5m1V2DPs2LMuS6r2SROORVyKRjL3PwgyLrwzwfmOxApRD62eIIYXb/hUcfwvY6K0mLy3KLsXk6Sa6Lt1o+yzdmgxBbbplgPd4sLYDOriyfjzL5rVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714038; c=relaxed/simple;
	bh=A8yb5dAfip8sRgAkLXAPmpmjEyARjsf7w1YHXdKxwXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTHda0Ec4gaERKtb/lNrAiP3GUyZ1jb7RUah2Z2hcsufk/FPoyO0oT2f/Y6f86kQAA6Mui/l3Yb5rsvvEc2HR9n9qwSzLlRFG0+258LHCk+iNdp8j15MKamiWEcU1xn4njxuUnmKt9NmBwqIQpwLY8z8ZJc5SwXPKmLpe5xKSeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zJQmfor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zJQmfor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8272BC4CEEA;
	Mon, 23 Jun 2025 21:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714037;
	bh=A8yb5dAfip8sRgAkLXAPmpmjEyARjsf7w1YHXdKxwXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zJQmforNssf5Adu8JJ8fy37/NYIQ+4m8Zg4eZe2vYWci2nW5XnKvrBhSeUBoKRAx
	 XhGvOoYT8KfVDHzcWMQUmO5CFu6n6XJeXlF6xHupCpZPSo9lbo59eMO7PhAcdnBXNC
	 3xyJWiby1n56dh+P1g4DlHE9qeH7qJlhvpHukgzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Kevin Hilman <khilman@baylibre.com>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.10 180/355] ARM: omap: pmic-cpcap: do not mess around without CPCAP or OMAP4
Date: Mon, 23 Jun 2025 15:06:21 +0200
Message-ID: <20250623130632.106351272@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kemnade <andreas@kemnade.info>

commit 7397daf1029d5bfd3415ec8622f5179603d5702d upstream.

The late init call just writes to omap4 registers as soon as
CONFIG_MFD_CPCAP is enabled without checking whether the
cpcap driver is actually there or the SoC is indeed an
OMAP4.
Rather do these things only with the right device combination.

Fixes booting the BT200 with said configuration enabled and non-factory
X-Loader and probably also some surprising behavior on other devices.

Fixes: c145649bf262 ("ARM: OMAP2+: Configure voltage controller for cpcap to low-speed")
CC: stable@vger.kernel.org
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Reivewed-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20250331144439.769697-1-andreas@kemnade.info
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-omap2/pmic-cpcap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/pmic-cpcap.c
+++ b/arch/arm/mach-omap2/pmic-cpcap.c
@@ -264,7 +264,11 @@ int __init omap4_cpcap_init(void)
 
 static int __init cpcap_late_init(void)
 {
-	omap4_vc_set_pmic_signaling(PWRDM_POWER_RET);
+	if (!of_find_compatible_node(NULL, NULL, "motorola,cpcap"))
+		return 0;
+
+	if (soc_is_omap443x() || soc_is_omap446x() || soc_is_omap447x())
+		omap4_vc_set_pmic_signaling(PWRDM_POWER_RET);
 
 	return 0;
 }


