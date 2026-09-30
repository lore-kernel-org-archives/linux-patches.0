Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3025A374A16;
	Wed, 30 Sep 2026 16:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787042; cv=none; b=jt7MEqknut3UuS42vPZnfom1Lz4SCUEf4xov7ASlCkh5BVlQP1XkBzEkMmDHj11Jd7J6TKndft+iymYVTYeIWyavJNpJbKrN+SLNBCu3iIutuzYVzr4h9I44YQDv+0NyeKmCtnr6dEg4AveASH/hMsDDmf5nBX8PA8N97+2AqXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787042; c=relaxed/simple;
	bh=wcBS6REkhYlOvM3X/TOxiL+4DHIN2oudRVAwPT4HILM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVoPILHrn8HR5lywo8rfPihkrkafLT+2nNYe7chKxjhSEKjTC+8KDr9SDLGXXDZpP4V+46l14Ce5FP/HUa+mU4jAwyGTMQc1s/rwNJd9b4b2ICMaKOIOThjG8RYygtzUj5InAQcDeSIjMDc0YOTA9O4MVViopnljeyHJvqKUVTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfIlEcT9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfIlEcT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8E81F0089B;
	Wed, 30 Sep 2026 16:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787041;
	bh=2RG9kjPdMFToARJm5Is3SlFgVNWY7kHMiMh4u/zwi/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfIlEcT9dCq3/wax+ZBdRdSQVr1a3Dz2mo+BwMFZmOOE1+urZWufBmySdhZ9OJ8Xx
	 WTen5lX0IekCLxdYfqyOsLAkWT4Mqxwev+5rO8BcULNxsTZ4hX0JEioqyWP3z7Ktkw
	 R5abDw0M5MUv4sfI4bpobB6ThJNGU+U2+cjKOQ18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Magazzu <postadelmaga@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 090/457] drm/nouveau/clk: dont clobber reclock status when restoring volt/fan
Date: Wed, 30 Sep 2026 17:23:15 +0200
Message-ID: <20260930152347.993535520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5da82db71dde2..fd2a9d64caba9 100644
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



