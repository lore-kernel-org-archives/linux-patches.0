Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4305D3CCFC3;
	Mon, 17 Aug 2026 15:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979290; cv=none; b=g+zYKyxWTkrKAzLesevJB0ZqedemOzm1CZiJ+mBHQSsj2SvpNisDaz3rwLbJKVVHQDA9MnqYQH7r8BsiOdVFpamo6hY4RzbaGK7XEHHJd8tBvLIPNs7x7iFJdRlZZ1Y0IrXpT26wKIaypqVsM0fMN/3gkKiLtfyVRN0IGDxuDEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979290; c=relaxed/simple;
	bh=TfrsNnO3z4IYGuIJV/8+/6B4TRronqW9zSfy768N+Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYTvI7ndXO3N0g/kkz3r9poj4U3u1VFV6sSO70JpzgxFn9HMIY7ykDMAJ1HgCx/MnVtjTqQy4D5YD9Osk4+8Triwa5XzVImwWQuNebfT6+P5FPKUh4c0qfDg2XT8NML97k6CAnA9qBFSyoxErXd49om1Y+IJsSnP8v0RSObYXeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZZqy47D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZZqy47D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9421F000E9;
	Mon, 17 Aug 2026 15:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979289;
	bh=HcWmnLM1KU3jUv0BD0Mm6M3PSDZcwMz2oiYfB3KbY7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZZqy47DHiLxjOnH33cNJe9ZaTwlKxSNK7bDZ9f/LtNkUs4QSXvRKD/yyHKstB3gP
	 IrVSqz9ZxBSH1x56gGPy0axV2/gx04ACYh3f2q2agqlcEL6JWExYULJuyFCp7PPfmx
	 M06uggZwr3XLZ+X6UGjvLLwUmNN3Vj4pCdJWIQqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.1 174/609] drm/nouveau/acr: fix missing nvkm_done() in error path of nvkm_acr_oneinit()
Date: Mon, 17 Aug 2026 15:27:50 +0200
Message-ID: <20260817132549.876134611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -314,6 +314,7 @@ nvkm_acr_oneinit(struct nvkm_subdev *sub
 					  i, us, fw);
 			}
 		}
+		nvkm_done(acr->wpr);
 		return -EINVAL;
 	}
 	nvkm_done(acr->wpr);


