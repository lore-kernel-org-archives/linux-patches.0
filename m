Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046597;
	b=rrwAAtDj2/a94n3Ftda12moggK9koN5fXo5LxxfDupbKBsVV14FeDqm0iZbB+iNMyhVR
	 6sfiaGiDOaKliVkmVRMkTVEJ47IiaIY4rv0E3yeEUCel4wR2fNavRfIDwBzWkECdPkWcj
	 Z5xtoWFvjSXuz/JY9uXoJeXYBPTwOJFR9osZdClmFxVip3ac1imRwnSbdh+7JNT4Xmv3W
	 LMGnD9IOK2jrv+vjmZqtR1c3oavnpCjR5cE3cABwXUmgGh54JnRmnWkjlKMmnYVN10JOr
	 vL1+8qhZ+vG/2PkayjeBMog0gYrdPFvVA/dCBS3Gj8jX9url0vXRwwY/o7bo47ff63g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5bNkprkbaKfAVetbJUve3cEWhN2mPT8KFcaarvOjgAc=;
	b=U0LIY9+ip8ijsDoJilIb6ghfn3XmIy4FIzM7CjMtBdZgUBxi0ocmvf8dNW8AH5A7/x5l
	 IcbkK8ug2Xfg764XzneEcLuM//HLaKtpwe8BQMRZMJPUSvUVv7vsHYqprQGV7P0toLtQJ
	 0oEUIvtPloHRd6BG4jtRsg1SZFMZzChDWLz36zwJeo36GqiDBkywyldPMDcGaEAhKdwn7
	 Ie7z91lW54OMSgLb0cbOo1wuOHLCzkDAuUhpU3zm/YhKoCxdZsStgz0Buc2qZ6XHp3Oer
	 jCjwNHLcRSSySJJDvfFJTwkuj1vW0c2btlL8RRR+5Jq5xmYur74UTbhgaCPs7AFdSew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b5C9cbQa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB671606A31C;
	Thu, 19 Nov 2026 00:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b5C9cbQa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379681F000C4;
	Thu, 19 Nov 2026 00:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046597;
	bh=5bNkprkbaKfAVetbJUve3cEWhN2mPT8KFcaarvOjgAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b5C9cbQaPhj4qAjXug0SvK3q/9+85mL7sXlsWjwlwsD386paCcsVA1fV/jNcLE+Xg
	 oZ3AWgo5JtiQxZHS4bCLRFYf394sJR0M4DY324UtKrKlGUbXkwF50p2f5QwI53dgPc
	 Etkkh4oqh9ZNkJKuT1VqUTAOQn43++q8nJMapM04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Mirkin <imirkin@alum.mit.edu>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1297/2857] drm/nouveau/devinit/gf100-: try to avoid double-running vbios scripts
Date: Wed, 18 Nov 2026 15:38:51 +0100
Message-ID: <20261118150248.184392226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5b7cb1fe7897b..0670b7fc95515 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c
@@ -27,6 +27,7 @@
 #include <subdev/bios/init.h>
 #include <subdev/bios/pll.h>
 #include <subdev/clk/pll.h>
+#include <subdev/vga.h>
 
 int
 gf100_devinit_pll_set(struct nvkm_devinit *init, u32 type, u32 freq)
@@ -101,6 +102,25 @@ gf100_devinit_preinit(struct nvkm_devinit *base)
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



