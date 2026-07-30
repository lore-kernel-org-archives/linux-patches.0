Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA18537BE9C;
	Thu, 30 Jul 2026 15:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426004; cv=none; b=rWwkH6fNGA/IGi4tosAoCcA2XoZZo0gGaEVxZbTPjLn7xPWftwu/S3k1/oBdvumdMRUUeU6r1duAW37yRbP4ZaV8hMeCFdT/uPRGpDaW4Dvxo7eV9+GYYwJV+ETklFmRyAApZLQ1WsHcEAdJlGKkhJ1VXzK+8qx9kNWrMSfZ5FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426004; c=relaxed/simple;
	bh=e1mK02M4AIkiVe4Lb3g/R/U9QwJ5J4nRQUVPNDtGp5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPCXcX6tCbWSdmNjRKW5fYe9icxdnms8HajziydABINmSCqaTcrD1SsNjkbCHkgzWigDQMaXSPgaPIBbLVzCsBUgp0JH0/F4j8NVp6s8UKHJ/z8ee3va1/0e0HGcnn8r1GX7YdIfgmaqAITAs8vp/5HQ476a9XU8JBM55HdPi5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWi+HecD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWi+HecD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3DA1F000E9;
	Thu, 30 Jul 2026 15:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426003;
	bh=TOaZ+7H6PGMNHivgGVf7YjCb/eMHIi5ocSScaxOs20Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eWi+HecDgJiNPep8G/oe6l83Jo5gk1MuZJr23eJkdIye2Hk2NrSa+0udYEkePOvT5
	 R7Mu83CZd/t+WKDyzKJH+qC9QvQ+kB+N0rdbuwWFOygKnATo55v9Th6RuFRgLYVirw
	 H91h1udd1suMUuSluPP5/h7mons8nLDalQz929qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 266/602] drm/nouveau/acr: fix missing nvkm_done() in error path of nvkm_acr_oneinit()
Date: Thu, 30 Jul 2026 16:10:58 +0200
Message-ID: <20260730141441.561654510@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit c3027973f692077a1b66a9fb26d6a7c46c0dc72c upstream.

In nvkm_acr_oneinit(), nvkm_kmap(acr->wpr) is invoked unconditionally
at line 309 to obtain a mapping reference. Additionally, when both
acr->wpr_fw and acr->wpr_comp are present, a second nvkm_kmap() is
called inside the conditional block. Both mappings are expected to be
released by nvkm_done(acr->wpr) at line 320 before the function returns
successfully.

However, when a mismatch is detected during the loop within the
conditional block, the function returns -EINVAL at line 318 without
calling nvkm_done(). This results in a leak of the kmap reference(s)
acquired earlier.

Fix the issue by invoking nvkm_done(acr->wpr) prior to the early return
to ensure proper release of the mapping references.

Fixes: 22dcda45a3d1 ("drm/nouveau/acr: implement new subdev to replace "secure boot"")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260606155606.77593-1-vulab@iscas.ac.cn
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c
@@ -315,6 +315,7 @@ nvkm_acr_oneinit(struct nvkm_subdev *sub
 					  i, us, fw);
 			}
 		}
+		nvkm_done(acr->wpr);
 		return -EINVAL;
 	}
 	nvkm_done(acr->wpr);


