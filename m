Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE4251CF5E;
	Wed, 30 Sep 2026 17:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789228; cv=none; b=gTSIcc2d6O5C8UYs/akw4AmktGdm7F0ZUKBophWqzZYa2cNkDbYD04Ia1CSK4FNLZwXr3wChgEDTNMU+8rmNNJiFb2KtqH9bQW7LhqrMdL6W9R3cWWXcBZfYyIgkr0yuTsUStCbSt4Jd82yiXqMciZr6BcD5p0bVS5dz5O4a298=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789228; c=relaxed/simple;
	bh=CsG2A5G0XZEoBR6ZXp3C923OrjagGcwOBZ7v09DrNZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQEaOgyOqDTcwQ2iTlVYCsNUl0YKfNDDHrsZej7KbbzsjssC1tkQ1CDNogy51k7UYJzJrYpyMEfP+NNxfcIrY7PLJwxzbtsLZTxaTDQVNcKyKwyMryf5WwfcQSik9P6hLz9lZ4x9euXqow9++cY2kOzI8g6fmXgjIk7edZlFdMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpLl+4GG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpLl+4GG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7429B1F000FF;
	Wed, 30 Sep 2026 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789227;
	bh=9/5s9gyd2Jf9apreLKJ3jNFDGqzoy6cCLHlMDYr80yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpLl+4GG0TAJHSMAi19lV0SY87wBSRg38gWImX19/trvISI2/ZItVq6qG7Jc4rB1i
	 Tab+KeI2jrgmNMow5tCk3ifFxAmRUbHG4YXt+uMyLbMR57SW4Q7j5bUFDSerGM9a74
	 W8qLqAInJP/ol+L4lLJbhiNNqJoros46fiGWE2TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Ranieri <giuseppe@ranieri.dev>,
	Tano Dzhinski <tano.dzhinski@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 357/877] drm/nouveau/disp: dont reject HDMI config on cards without SCDC
Date: Wed, 30 Sep 2026 17:21:08 +0200
Message-ID: <20260930152422.375739703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Giuseppe Ranieri <giuseppe@ranieri.dev>

[ Upstream commit 1717fcc5be575d4768279148ae9465a8b13d4339 ]

nv50_hdmi_enable() passes the sink's SCDC capability from its EDID
straight through to nvif_outp_hdmi(). On pre-Maxwell-2 cards there is no
hdmi->scdc callback, so nvkm_uoutp_mthd_hdmi() rejects the whole
configuration with -EINVAL, and nv50_hdmi_enable() returns before
hdmi->ctrl() runs and before the AVI and VSI infoframes are sent.

The result on such a card driving an SCDC-capable HDMI 2.0 sink is that
HDMI audio silently stops working. Video is unaffected, and nothing is
logged, which makes the failure hard to attribute.

SCDC is optional, and the hdmi->scdc() call further down is already
guarded against a missing callback. Requesting it on a card that cannot
do it need not invalidate the rest of the HDMI configuration, so drop
that term from the condition and let the existing guard skip SCDC alone.

Fixes: 6c6abab20b99 ("drm/nouveau/disp: add output hdmi config method")
Signed-off-by: Giuseppe Ranieri <giuseppe@ranieri.dev>
Co-Authored-By: Tano Dzhinski <tano.dzhinski@gmail.com>
Signed-off-by: Tano Dzhinski <tano.dzhinski@gmail.com>
Tested-by: Tano Dzhinski <tano.dzhinski@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260917215114.1136715-1-tano.dzhinski@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/uoutp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/uoutp.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/uoutp.c
index 377d0e0cef848..9887b3898505b 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/uoutp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/uoutp.c
@@ -253,8 +253,7 @@ nvkm_uoutp_mthd_hdmi(struct nvkm_outp *outp, void *argv, u32 argc)
 
 	if (!ior->func->hdmi ||
 	    args->v0.max_ac_packet > 0x1f ||
-	    args->v0.rekey > 0x7f ||
-	    (args->v0.scdc && !ior->func->hdmi->scdc))
+	    args->v0.rekey > 0x7f)
 		return -EINVAL;
 
 	if (!args->v0.enable) {
-- 
2.53.0



