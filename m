Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADE62236FB;
	Mon, 23 Jun 2025 22:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716757; cv=none; b=is6EQeh7BQ6QWHJUIh1qe/bWmJqOTJd/msOqK+0phnwha+PqpH1FFehIQZZVKfuon5xMUMC992vvMmA9/dOlWvV1l/dbU2Y3rk6MU9eM4ehekeoXqWiWcmYQHAHyjCv1p/Zvf3pHdA/hZCkA8D5F5RHwu42aYBDPLq4Ow3gTvag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716757; c=relaxed/simple;
	bh=xv0odZEmk2ZQqSh6xLSUaFwdRDM65O4xzs/ogef+DEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e877FXruUJ/5dZTBXEt+suni/I52Mwxow9j1tO0LHvpn8zSDm2q+86I4MaNx5i+fyeK6yyHcHKPYDyV5xft9X1ljNdyJVU9f7b7N4eIeRISzG4MYm7RweUz6cs7uPnD71g94uoOLf2OqQVqBE+j1FGS46IJEX8eZBAdIbQF5tKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeBpa81k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeBpa81k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85C2C4AF09;
	Mon, 23 Jun 2025 22:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716757;
	bh=xv0odZEmk2ZQqSh6xLSUaFwdRDM65O4xzs/ogef+DEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeBpa81k+r+9HELvrTO/2EtAut45d81pJIM339UKT8Vj6/8ngQflUTlX3tUfTnbK6
	 LiqcEP9frgYEqoHDkomJydB5JIMHRYnAFpawv97/3fs5kiRR/6AxctqXvarn6UCl8G
	 yWdW9OP4Wr4ckcu+XblSkZOjz2ik2h6u6MGEgE8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Kevin Hilman <khilman@baylibre.com>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6.1 326/508] ARM: omap: pmic-cpcap: do not mess around without CPCAP or OMAP4
Date: Mon, 23 Jun 2025 15:06:11 +0200
Message-ID: <20250623130653.347084511@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


