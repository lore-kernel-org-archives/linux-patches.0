Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5059757FC;
	Tue, 30 Jul 2024 16:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357861; cv=none; b=ixabfWudJwl9Aiw808Vv9rABQ9LEeNpdfzcWedWk4u068HmyTX8Q+a66ix8O7guWG1OVui8TpAtJxNkKstjrkm6tyJvWLgrzf8U4pt7ToQYOptynZsmAc72hMN4VCL53tkLSPuaMJiCGX/nvM1eTBnnimWN7yB+Nxs2epPnkR8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357861; c=relaxed/simple;
	bh=wHw8lOWsJwjLiHq1+/LdUp57Suv1SO+mFEPyCqsa+Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQzQun9QJYdFD5cGxOt5m9XFxaSikNkKcasW0fxk+tYYvI75DRVzyXnp1fcVZdmCmIGi0HoOVJSJVQY/gHwJWGZOhpjPgQj+6uv7tEhcxV8kUQdGjxkSM72O3HfRHJt7G1vqCTEq57zh0gLmhokEajwQNweMSo8HzOuuX9PKqQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlWdPQrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlWdPQrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A6BC4AF0E;
	Tue, 30 Jul 2024 16:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357861;
	bh=wHw8lOWsJwjLiHq1+/LdUp57Suv1SO+mFEPyCqsa+Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlWdPQrdb2qSyLBVUA9x06inwGJDDxozDGWHTjOfzkPO7pzIYFzZJoAli1/6hqKKT
	 V/nZ8FDm/D1AlYPz6rbkyBSFV3K6xF264U0y1i3WCId9y6I5cKUXidqxcDYL/QCsQV
	 rgqnyCQkopeXhkabjVspmy2kBVYKMNVhyYRcO0Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 299/809] drm/msm/dp: fix runtime_pm handling in dp_wait_hpd_asserted
Date: Tue, 30 Jul 2024 17:42:55 +0200
Message-ID: <20240730151736.403100423@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit aeacc39e2088a15ee31c8af4f68c84981fa08eb7 ]

The function dp_wait_hpd_asserted() uses pm_runtime_get_sync() and
doesn't care about the return value. Potentially this can lead to
unclocked access if for some reason resuming of the DP controller fails.

Change the function to use pm_runtime_resume_and_get() and return an
error if resume fails.

Fixes: e2969ee30252 ("drm/msm/dp: move of_dp_aux_populate_bus() to eDP probe()")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/580137/
Link: https://lore.kernel.org/r/20240226223446.4194079-1-dmitry.baryshkov@linaro.org
[quic_abhinavk@quicinc.com: resolved trivial conflict while rebase]
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_aux.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_aux.c b/drivers/gpu/drm/msm/dp/dp_aux.c
index da46a433bf747..00dfafbebe0e5 100644
--- a/drivers/gpu/drm/msm/dp/dp_aux.c
+++ b/drivers/gpu/drm/msm/dp/dp_aux.c
@@ -513,7 +513,10 @@ static int dp_wait_hpd_asserted(struct drm_dp_aux *dp_aux,
 
 	aux = container_of(dp_aux, struct dp_aux_private, dp_aux);
 
-	pm_runtime_get_sync(aux->dev);
+	ret = pm_runtime_resume_and_get(aux->dev);
+	if (ret)
+		return ret;
+
 	ret = dp_catalog_aux_wait_for_hpd_connect_state(aux->catalog, wait_us);
 	pm_runtime_put_sync(aux->dev);
 
-- 
2.43.0



