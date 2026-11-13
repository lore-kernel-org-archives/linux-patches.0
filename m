Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585805;
	b=HEAm79IZrdajXw11qeVp/z8K2zVF/32cBggAyImzmVxk3ZxaOBdZXjfQ+9C8OCVXH2/J
	 PHI8xVpqL3zFyJuWhQWWi7n0QuXZpwAGww5Sgb0kPojpkbixmiGvSwoHi51WWQxDg4T/T
	 Jga/wT9C3nBAUGDlHM4q1zd+5PmecFWOhL4WMpgJmZlcBSxoAxlgy+X9yfq3ZuJ8SL2eR
	 I8YMjGlf16ZwTFh2wER4r6+NkhVMxh6EoYRZjfYmruHqOe74Tg2KD1POEJl+Py/VPEHKM
	 2wVyGpoZFbLb0w0x6KDuw1E3wfI00Cl21MkdMh3MDgUpZO2z0N1N27IXZKKE9HOkfEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WhNax8DuIrl7/41RyISTMl/d13Y9BRR1m0D69L+ytRU=;
	b=JO24yawBUJxgnkmTvtti723Mg0k/alKdwP8T0PczdGmJfIOsOZP/4b6Xw8M5vJiT5Q5+
	 aM8PfBL4SUtALYs05nsFHcjlzDMAJQdWL4jRW7w5VJbZPdewc5CmdpYjISJOrQ3YIXaY6
	 VqyN/qQKZt2uBU60FWfsloKRhQsboZypCDJcePlwyTNH5t6Jyz/OgcPn0PhQJpfukqbAp
	 hsD3QQPMHcduSLg3HY6eEe6yMHu775F8/SDcIYJPXkqleP6SpKatLZFXNnNieVOdiYMRF
	 fAz8M50K76GyzN9uDGvUw0Qa9+13ZvwmDEq4CXGd0vqS2A3VFl9n7zoVBUuI4WwSAWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYUXf9Sa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655D7606BA8A;
	Fri, 13 Nov 2026 16:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYUXf9Sa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117BC1F000C7;
	Fri, 13 Nov 2026 16:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585805;
	bh=WhNax8DuIrl7/41RyISTMl/d13Y9BRR1m0D69L+ytRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYUXf9Sah0+DkUQbRUHIn8luJ0WtDOMZkjbSlBLJGEPAzG8kjFw8xTiZgY4b6f/jC
	 y09KKLUpQJgoFFmRxDLaU1yvA9/u6BeukWlKUfF0RBMk1oq6Lkllfxg2oSvJxnwuLE
	 6iGRVKNtaZZ/s7w7AH0gaE/hQbsvYCtg13ZKxXOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Mirkin <imirkin@alum.mit.edu>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 390/507] drm/nouveau/devinit/gf100-: try to avoid double-running vbios scripts
Date: Fri, 13 Nov 2026 10:51:34 -0500
Message-ID: <20261113153809.875657316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



