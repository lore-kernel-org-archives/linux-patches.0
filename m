Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037848;
	b=D1g2Wd5Vy63g/B8MSyfgx6AV+xP4B2bc2PjzGF0KyPXA1LqXP/KbyRsr3yAuL2rxPsso
	 PMnpzTZsl8liqin22lyYTYLHMKRGEJcPiNs0IWOy4ZvMOJLM8kafxv6NWhdi/LWEsUctb
	 R12iYLdJCR0vrExc0gjDUe2ovlwEXqaiC/LAw5uX5ttc8aNpgnIUbuJ3ijfolOLEVwVOu
	 4P25R6ntfTvVc6E3Ykt2LU66oWJ3x0mdtmDuf/Tjifx93bm1yWLGgJOZzQ/UF4ioHCBH+
	 6QK3c00+Bd2ZKrX7RCpYe7iHLG9f5bc03rDGWvCC4OBrn5kEhSehR76I+r/Rvj3BOVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VD3AOU+ekqmozmALghuld7gCbowQG6NzxN4Bc/wbVdQ=;
	b=yZrMTcNU53pDRH0h0GTH0Rv0GykPr39KOZt6AWgxMhpZBWSZyJvq3CJ2aKykp0LnAzmF
	 o4cNaZLNFOtTX3/69Rp+NMxgDVrms6AcZVD2MH/5M98487D3TcZko4f4blmvkwZ3j2X+S
	 KD8jOuGclzBwxfR8YYzjWJuNfQ4uySvKdX4RmvCxwmrB0K1ohKIWSMAfixl+RGEmUuTj8
	 4ttVVY/Vdb+CI236JDoxB0Ln1slzAf9GE3VSr3S/ufE14O6GzvGEikeqFHr3Up3TgO6db
	 NeaarsdPAYd0gVLnLYpGvGriu0lDL9KOyHApiLORSU5DK9dazJ3mVe2Q1t6/m2D9SoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DinTe9kN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69E9606A32A;
	Wed, 18 Nov 2026 21:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DinTe9kN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F0B1F000C4;
	Wed, 18 Nov 2026 21:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037848;
	bh=VD3AOU+ekqmozmALghuld7gCbowQG6NzxN4Bc/wbVdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DinTe9kNTDcUfjdVzqngABuwWY4tz2c+ceHX5Xk4sdOEXfZq6Tk61tuwDcotGpYOF
	 cJljCYhZKgmMT8/NQkktJ6bQcDIRhpTVB9NaCbbkcwNZZ73LQ8dpZ2R315zJylZR5b
	 B9iaqgRPLorUjOXqdAB0Fu+GsXOy4uATdEzdyCCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Mirkin <imirkin@alum.mit.edu>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1539/3318] drm/nouveau/devinit/gf100-: try to avoid double-running vbios scripts
Date: Wed, 18 Nov 2026 15:36:01 +0100
Message-ID: <20261118150407.146502292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

[ Upstream commit 2139cb633d48ebbbaec88d2e5a8ebe8e774df4fb ]

Turns out some VBIOSes don't actually set the bit in question in 2240c.
Use the nv50-style detection to try avoiding running the vbios twice.

Fixes: a6a0f67ca7aa ("drm/nouveau/devinit/gf100-: detect if BIOS invoked devinit")
Link: https://bugs.freedesktop.org/show_bug.cgi?id=97620
Cc: <stable@vger.kernel.org> # v4.6+
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20170128205347.17453-1-imirkin@alum.mit.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/nouveau/nvkm/subdev/devinit/gf100.c   | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c
index 5368e705e7fd6..186e09ea0cb10 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c
@@ -27,6 +27,7 @@
 #include <subdev/bios/init.h>
 #include <subdev/bios/pll.h>
 #include <subdev/clk/pll.h>
+#include <subdev/vga.h>
 
 int
 gf100_devinit_pll_set(struct nvkm_devinit *init, u32 type, u32 freq)
@@ -99,6 +100,25 @@ gf100_devinit_preinit(struct nvkm_devinit *base)
 	 * can use it as a reliable way to know whether we should run devinit.
 	 */
 	base->post = ((nvkm_rd32(device, 0x2240c) & BIT(1)) == 0);
+
+	/*
+	 * However some VBIOS init sequences miss this bit. So fall back to
+	 * the nv50 method of checking if the bit is not set. Running the
+	 * VBIOS multiple times may have detrimental effects.
+	 */
+	if (base->post) {
+		u64 disable = nvkm_devinit_disable(base);
+		/* magic to detect whether or not x86 vbios code has
+		 * executed the devinit scripts to initialise the
+		 * board. only works if there's a display engine.
+		 */
+		if (!(disable & (1ULL << NVKM_ENGINE_DISP))) {
+			if (nvkm_rdvgac(device, 0, 0x00) ||
+			    nvkm_rdvgac(device, 0, 0x1a)) {
+				base->post = false;
+			}
+		}
+	}
 }
 
 static const struct nvkm_devinit_func
-- 
2.53.0



