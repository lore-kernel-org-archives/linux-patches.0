Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8736D439343;
	Thu, 30 Jul 2026 14:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422315; cv=none; b=ZKt3n3Xp4+e+Y4rOieXAAApwsGZeYG+BIIV5JjzXa3uTbSufnEht1ujBoL8qrF8aNNoO0+oAVpVIC2l8g1LjaJKcIgdT17ZYR6LMpwqouxgno7csdpH+RL6Y1v6T4SGdmyzpTpSgieXSYe620HDsG90PxnMV7/NQaFZrwSY/fxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422315; c=relaxed/simple;
	bh=q0xJlyj9xMfURJzdW2Sv1mJUKB27cuKlbfugAYiA0eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gm9iUAnBedyB1LzCQzJfcCdpfuDS6DJEUlr30Qtwi6LCVIixlc/v4V0GIjw1OcKOvLLqukT18M9XKNE6Et8aGE+UNIsDbX8Ig4MQtw1AV/ZUC0W5vwu6kvr3R1UCzwlZSJa7dPZG6OYQKQoK2Q0i/J+aT3tCrZbBzMeo53x57f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tG6jRV2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tG6jRV2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B6D1F000E9;
	Thu, 30 Jul 2026 14:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422314;
	bh=aTocAzyUDzzLbk2XCTqlRTAfHuMygoyQdbxAkj9Pzx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tG6jRV2q+mXggsLb0MsR7oEqAJCIOG6c9ljAuUWkAmJk/spXnELRlzfQ46vveBuBW
	 UBaJKk2v8DN5g66oqGYl7JkY/0TU3gioovfTHPeV34Phb0WPlU6SSTctoYcTJn5eiX
	 aHYu7PM4X+OIaPfA1er0I37Sz7jGxTuXnrg2R0Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.1 395/744] drm/nouveau/acr: fix missing nvkm_done() in error path of nvkm_acr_oneinit()
Date: Thu, 30 Jul 2026 16:11:08 +0200
Message-ID: <20260730141452.685862818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


