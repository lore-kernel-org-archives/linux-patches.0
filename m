Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F3F63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2301C433EF;
	Mon, 20 Feb 2023 13:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901463;
	bh=fmwrvlSnzYMpOU6Bb/kbeD5NAHZC6hAf1LWtjxppyh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JE64hPm2QuZW7y5s3DMkzWgkV0K5LO6nbRiPFLFZq9ApCj2FUYhpysPXrEd0rH5ak
	 vsGMkjb9a8uBZDuqgCx8WrbWEcCL0m7U7eht9zFw0MfYjGP7ffvtr5eWP3d74Du/UA
	 64Mb277FT2CIdjyH+cb/KR1CzLTV6AmJDvmCak84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/118] drm/nouveau/devinit/tu102-: wait for GFW_BOOT_PROGRESS == COMPLETED
Date: Mon, 20 Feb 2023 14:35:42 +0100
Message-Id: <20230220133601.471618553@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Skeggs <bskeggs@redhat.com>

[ Upstream commit d22915d22ded21fd5b24b60d174775789f173997 ]

Starting from Turing, the driver is no longer responsible for initiating
DEVINIT when required as the GPU started loading a FW image from ROM and
executing DEVINIT itself after power-on.

However - we apparently still need to wait for it to complete.

This should correct some issues with runpm on some systems, where we get
control of the HW before it's been fully reinitialised after resume from
suspend.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230130223715.1831509-1-bskeggs@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/nouveau/nvkm/subdev/devinit/tu102.c   | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c
index 634f64f88fc8b..81a1ad2c88a7e 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c
@@ -65,10 +65,33 @@ tu102_devinit_pll_set(struct nvkm_devinit *init, u32 type, u32 freq)
 	return ret;
 }
 
+static int
+tu102_devinit_wait(struct nvkm_device *device)
+{
+	unsigned timeout = 50 + 2000;
+
+	do {
+		if (nvkm_rd32(device, 0x118128) & 0x00000001) {
+			if ((nvkm_rd32(device, 0x118234) & 0x000000ff) == 0xff)
+				return 0;
+		}
+
+		usleep_range(1000, 2000);
+	} while (timeout--);
+
+	return -ETIMEDOUT;
+}
+
 int
 tu102_devinit_post(struct nvkm_devinit *base, bool post)
 {
 	struct nv50_devinit *init = nv50_devinit(base);
+	int ret;
+
+	ret = tu102_devinit_wait(init->base.subdev.device);
+	if (ret)
+		return ret;
+
 	gm200_devinit_preos(init, post);
 	return 0;
 }
-- 
2.39.0



