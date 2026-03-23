Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216AD3C07A;
	Mon, 23 Mar 2026 14:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274825; cv=none; b=aHjXqHej7O3p5L25YHVoFiF7MmU2xuAb3rrVFbDMgzXVkMlvXkPXFTdQcilYDxoBGDAr0BZkitAlIgJo3tPusscSGbofZDBJF83yTZ7iBDMnX8Xv4SbIdDe/1fNO9gkNAyA8UF0Y58iTxwHSPuvc+QNwwjsASJY7EJFdT/h17N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274825; c=relaxed/simple;
	bh=axOXrUrKHoBXcc2wQXkdBSZ1iuen2a+ubJWgT/pFcug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cH8chqG/UyBKUA/87wvwMjlJPGniM6BjB53a+3pCMT1LSGzX9JtlMPh4wqcxT/trUFdJ9vEty/MFOlZz3OgD5U4pExnBQxCO5lAhkKxGVkx5axRpMheZozz0MXo1DFs2v8A1eNjv1mBVhf/5uWdBRIvjUYgCxMEes4wy20FQ2v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rf38Mwrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rf38Mwrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA45C4CEF7;
	Mon, 23 Mar 2026 14:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274825;
	bh=axOXrUrKHoBXcc2wQXkdBSZ1iuen2a+ubJWgT/pFcug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rf38Mwrc2B5vyYtKDix3GhPQTLx3xM9Li2pkKXkEb7LXCKnYyBaMTV/feQ15zVjdx
	 QPKlTPKhD8iNU9XfQyAlO8IjxRXVKcFB635wAruC8DnpnPv1nC6wKdh71Z3E8NfyAQ
	 V14KfJgLW1jjd39LRq/6IVbyECqW4mlK0jiCZRWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/212] arm64: dts: renesas: rzg3s-smarc-som: Set bypass for Versa3 PLL2
Date: Mon, 23 Mar 2026 14:45:39 +0100
Message-ID: <20260323134507.501741009@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 6dcbb6f070cccabc6a13d640a5a84de581fdd761 ]

The default settings for the Versa3 device on the Renesas RZ/G3S SMARC
SoM board have PLL2 disabled. PLL2 was later enabled together with audio
support, as it is required to support both 44.1 kHz and 48 kHz audio.

With PLL2 enabled, it was observed that Linux occasionally either hangs
during boot (the last log message being related to the I2C probe) or
randomly crashes. This was mainly reproducible on cold boots. During
debugging, it was also noticed that the Unicode replacement character (�)
sometimes appears on the serial console. Further investigation traced this
to the configuration applied through the Versa3 register at offset 0x1c,
which controls PLL enablement.

The appearance of the Unicode replacement character suggested an issue
with the SoC reference clock. The RZ/G3S reference clock is provided by
the Versa3 clock generator (REF output).

After checking with the Renesas Versa3 hardware team, it was found that
this is related to the PLL2 lock bit being set through the
renesas,settings DT property.

The PLL lock bit must be set to avoid unstable clock output from the PLL.
However, due to the Versa3 hardware design, when a PLL lock bit is set,
all outputs (including the REF clock) are temporarily disabled until the
configured PLLs become stable.

As an alternative, the bypass bit can be used. This does not interrupt the
PLL2 output or any other Versa3 outputs, but it may result in temporary
instability on PLL2 output while the configuration is applied. Since PLL2
feeds only the audio path and audio is not used during early boot, this is
acceptable and does not affect system boot.

Drop the PLL2 lock bit and set the bypass bit instead.

This has been tested with more than 1000 cold boots.

Fixes: a94253232b04 ("arm64: dts: renesas: rzg3s-smarc-som: Add versa3 clock generator node")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260302135703.162601-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/rzg3s-smarc-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/rzg3s-smarc-som.dtsi b/arch/arm64/boot/dts/renesas/rzg3s-smarc-som.dtsi
index 39845faec8943..a5d4d70e83c90 100644
--- a/arch/arm64/boot/dts/renesas/rzg3s-smarc-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/rzg3s-smarc-som.dtsi
@@ -166,7 +166,7 @@ versa3: clock-generator@68 {
 				       <100000000>;
 		renesas,settings = [
 		  80 00 11 19 4c 42 dc 2f 06 7d 20 1a 5f 1e f2 27
-		  00 40 00 00 00 00 00 00 06 0c 19 02 3f f0 90 86
+		  00 40 00 00 00 00 00 00 06 0c 19 02 3b f0 90 86
 		  a0 80 30 30 9c
 		];
 	};
-- 
2.51.0



