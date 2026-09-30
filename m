Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F00B4D1787;
	Wed, 30 Sep 2026 15:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783860; cv=none; b=WgzbgYa/zx4+02ZIQyZBF+6w++VzgEbfMhERiYToMwpGPYoBzppZ0EHjmL7YAX+TEzEBHcNI/r0W9SxBKdY1K6h/b9aQ4fuPo89AwEcgnbsEq0/vISkfOX9qQzpIJPJkIbQYWtvl2mqFcCcztoM5mrQX5up99qY60sUnKs7xzH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783860; c=relaxed/simple;
	bh=n0kSD8Bq3KmG+TeW3vXx3CkRGkA//OhSQsCt+uhvGJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTSbAGeyz21aK9AtfULXUUxTCUYTl01ZSVkdZWsmewVLJ0MBfNWAy644ABCZHAExfKckyZ1kc4dQl4GH0IbgbXTO78FOqtxs29GhqtRlnNYDDOPzHseHXZ80IRpeAIr9ATqz254k845Bu5aZ/+Tz4X8U9ZLITuC4oR6EHsqchKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vm69nQjj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vm69nQjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47B51F00898;
	Wed, 30 Sep 2026 15:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783855;
	bh=rwdJh2Ssu52dHFX5LB4ZgyYCEkBryxA0YKX190K4Hn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vm69nQjjbXW1i5pgbnfYKauE+WPmXteQoXx0lRs+mkhzCGfaOOIEO5vZcIExNV7Vb
	 G3MBFvssKLr6L15q1oZnvsPY86Q2ngAakqwFE4qmmTnTFSUbV7t5jYafs04/PQQWnK
	 2VtgXJ5RXUzL5aJVtHBGC4mTK/Qj+YXu0Pin9qfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Magazzu <postadelmaga@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 501/595] drm/nouveau/clk: dont clobber reclock status when restoring volt/fan
Date: Wed, 30 Sep 2026 17:26:34 +0200
Message-ID: <20260930152358.472957093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Magazzu <postadelmaga@gmail.com>

[ Upstream commit e5cccdafc855cd5f96f4b51d38114a0360b075d7 ]

nvkm_cstate_prog() reuses 'ret' for the voltage and fan-speed restore
calls it makes after reprogramming the clocks.  Those calls almost always
succeed, so the status of the reclock itself is overwritten and the
function reports success even when clk->func->calc() or clk->func->prog()
failed.  The converse is also true: a successful reclock is reported as an
error if the final restore call fails, even though that failure is only
logged and otherwise ignored.

The only consumer of the return value is the error message in
nvkm_pstate_work(), so in practice a failing reclock is simply never
reported.  Nothing else changes, but a function that returns success on
failure is a trap for the next caller.

Keep the calc/prog status in 'ret' and use a separate local for the
restore calls.

Fixes: 3eca809b3c05 ("drm/nouveau/clk: cosmetic changes")
Signed-off-by: Francesco Magazzu <postadelmaga@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260918131620.405133-5-postadelmaga@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
index 9ba062707f446..0927f4b25d675 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
@@ -199,16 +199,18 @@ nvkm_cstate_prog(struct nvkm_clk *clk, struct nvkm_pstate *pstate, int cstatei)
 	}
 
 	if (volt) {
-		ret = nvkm_volt_set_id(volt, cstate->voltage,
-				       pstate->base.voltage, clk->temp, -1);
-		if (ret && ret != -ENODEV)
-			nvkm_error(subdev, "failed to lower voltage: %d\n", ret);
+		int err = nvkm_volt_set_id(volt, cstate->voltage,
+					   pstate->base.voltage, clk->temp, -1);
+
+		if (err && err != -ENODEV)
+			nvkm_error(subdev, "failed to lower voltage: %d\n", err);
 	}
 
 	if (therm) {
-		ret = nvkm_therm_cstate(therm, pstate->fanspeed, -1);
-		if (ret && ret != -ENODEV)
-			nvkm_error(subdev, "failed to lower fan speed: %d\n", ret);
+		int err = nvkm_therm_cstate(therm, pstate->fanspeed, -1);
+
+		if (err && err != -ENODEV)
+			nvkm_error(subdev, "failed to lower fan speed: %d\n", err);
 	}
 
 	return ret;
-- 
2.53.0



