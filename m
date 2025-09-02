Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E656313558;
	Tue,  2 Sep 2025 13:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819748; cv=none; b=NRv7Psqq4Mr7ofXeaLDJ7c9fnK6zvPRC6QgpzAAtHNKsRMTb2fr+uCG5ZU93vGltESdUsMe/Q8qKUCgMp0gbFnI9HIDHeIz/9KZYTDDDaPmPGLHYxnSIkHagqMvjceY2ZgXEB4/GjVNx9CNqo/+ttJ8tKB8dZZjg1Krmh7VQiis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819748; c=relaxed/simple;
	bh=a1wVJx8MLbDXgWsqMY55ccuEg8z9zVfA7Ut4XP74XJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEOU22zjifLIH3h7CLGx901ms7z7lTf7jECks+0D0vESx9UnOcjK6sxAcrv7UT9Y1eIf4zrTV5uMZ4Rj/7JNWioimwFXhUKrVdh18VGxC5KuGHbQ+WrYE4ovjLR6ecMSsU21Cnkp2nF3ojFzdTSx8f1+e9XUxHI4AZiZcwJeQDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5RZx4sF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5RZx4sF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6305C4CEED;
	Tue,  2 Sep 2025 13:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819748;
	bh=a1wVJx8MLbDXgWsqMY55ccuEg8z9zVfA7Ut4XP74XJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5RZx4sFuUHI+RXIGYv6MwacR0LC/P01gPyeq+oaW58BtvSTKHF/YpIkq0j4CSLc3
	 cLRLrsOPWxjemqtJ8ag5U+q4uRro0Leum3elhJNtom55xYOgYAbjYFc7vaH/qq54DU
	 /ajdl1BWB3c/r4fZtWS5UTArnT7q9Yxw+MA6XEXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.16 126/142] drm/nouveau: fix error path in nvkm_gsp_fwsec_v2
Date: Tue,  2 Sep 2025 15:20:28 +0200
Message-ID: <20250902131953.112979635@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <ttabi@nvidia.com>

commit 66e82b6e0a28d4970383e1ee5d60f431001128cd upstream.

Function nvkm_gsp_fwsec_v2() sets 'ret' if the kmemdup() call fails, but
it never uses or returns 'ret' after that point.  We always need to release
the firmware regardless, so do that and then check for error.

Fixes: 176fdcbddfd2 ("drm/nouveau/gsp/r535: add support for booting GSP-RM")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Link: https://lore.kernel.org/r/20250813001004.2986092-1-ttabi@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c
@@ -209,11 +209,12 @@ nvkm_gsp_fwsec_v2(struct nvkm_gsp *gsp,
 	fw->boot_addr = bld->start_tag << 8;
 	fw->boot_size = bld->code_size;
 	fw->boot = kmemdup(bl->data + hdr->data_offset + bld->code_off, fw->boot_size, GFP_KERNEL);
-	if (!fw->boot)
-		ret = -ENOMEM;
 
 	nvkm_firmware_put(bl);
 
+	if (!fw->boot)
+		return -ENOMEM;
+
 	/* Patch in interface data. */
 	return nvkm_gsp_fwsec_patch(gsp, fw, desc->InterfaceOffset, init_cmd);
 }


