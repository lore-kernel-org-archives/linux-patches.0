Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AD63B3C18;
	Wed, 30 Sep 2026 19:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796818; cv=none; b=SCBPf8SK1+us79nyrEa18XBsmjU5qm2V6bu6czFfnB/DCCHI8xlIH0R9Fj8ct+0UeulLxwulxcdzKjhyoIuyZb6VWTEnGTIWDEoJWdB+DEq3IH7/kbDJyYzOXXbeAZkwWE5vXhmKgSaCq1hVleCRn0aNfNkTIH2/akwGS6VmUKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796818; c=relaxed/simple;
	bh=bzh8/DgYcwBKg0hbsb1At/YJP6YVHM1LzC1srOPcOnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFVtUL3VWCIRBp1XXbFLmkYocAMRYQ0EZBcEX65lL7pYcGDMpNMpLifuCEIsfOr/zA425BAatADtBT8kTb2n8OW4F6RlE/wEpqSRJ4gBWZJJ3yKoWF4ZlwJADiRD9j/9WRhkKmXQBe50AWwvFzDJhh9+ok53mEv2wrS4ReDukH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXr6cu3k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXr6cu3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD151F000FF;
	Wed, 30 Sep 2026 19:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796817;
	bh=Oq+DJukv+0Z6UHc/zkBksiC1zrB1250IZax7xILC4Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXr6cu3kTVKWahy1qCohTyuxkHMGyYiHZtMzzSmtGqpCtdMi4HkshmVm/5AWdvabI
	 aQjiJfzAJJzHVo6GO6T0rakM9BNMkM9qkMBaa3r+Qi9XjkPD6qRc4tvQMtjJxWgjgy
	 0ERzuxoNptv++I6bMTTezvkE9J81CJQu9MiDgTSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Magazzu <postadelmaga@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1001/1193] drm/nouveau/clk: dont clobber reclock status when restoring volt/fan
Date: Wed, 30 Sep 2026 17:28:05 +0200
Message-ID: <20260930152456.481537377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5f4cd122415fa..e6539931a7596 100644
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



