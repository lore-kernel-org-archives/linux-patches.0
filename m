Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D4F56458;
	Thu, 13 Jun 2024 12:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281072; cv=none; b=ci2ilL7tz5RYL4WC9FDiW/vEKhreTkAV/ix8vsjmTL6RI4uMU4RET5ePm/dk+g4BaZVK2Z7p5OeSk84u9MURjqjahuNMGEnB26zl+lMUdFmYB1aoDfD7t6oVPgRQP97stk6mr9Y52PPDVmDwgF6Mv6Ec3A3P8GagaNRgvUUgy14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281072; c=relaxed/simple;
	bh=xKohPR+XVEpBu+cP5bkEP5KNKifF23SpCiH8DchAFpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fo+nmFOs43ZM2RVa7q+cEiotYAG2eRLyb/Ul+oBdmWdoVe5LuCbRv5xFBWURIOdqmcV+vQ2Ra9vYVtBP369cH9jxYzfYa4fsfvM7pC9DbsyIdCb9f9EKGoxmRveE4mQGJlokEp+Xs/v2i3UI2mj5KwB1CAtBzWFhho5dbhQH5I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2fDbTmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2fDbTmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF90C2BBFC;
	Thu, 13 Jun 2024 12:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281071;
	bh=xKohPR+XVEpBu+cP5bkEP5KNKifF23SpCiH8DchAFpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2fDbTmvS98n/SgwhRhDeaQKj0CXgkVKa3Jz6KYHjOYNOFW+c+1Af01PnYlo7gSD2
	 xG8bXu7EmnWJZ4LpbcZEO0znL9uDNrx5887UEdzsTx+ZCSXdbzxNKYdO1jh9lIm2vM
	 JwK3E6jX6MCKWH46KfGbKDQFUEXnBfJYb1FsB/Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/317] drm: bridge: cdns-mhdp8546: Fix possible null pointer dereference
Date: Thu, 13 Jun 2024 13:31:59 +0200
Message-ID: <20240613113251.457797643@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 935a92a1c400285545198ca2800a4c6c519c650a ]

In cdns_mhdp_atomic_enable(), the return value of drm_mode_duplicate() is
assigned to mhdp_state->current_mode, and there is a dereference of it in
drm_mode_set_name(), which will lead to a NULL pointer dereference on
failure of drm_mode_duplicate().

Fix this bug add a check of mhdp_state->current_mode.

Fixes: fb43aa0acdfd ("drm: bridge: Add support for Cadence MHDP8546 DPI/DP bridge")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240408125810.21899-1-amishin@t-argos.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
index f56ff97c98990..ae99d04f00456 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -1978,6 +1978,9 @@ static void cdns_mhdp_atomic_enable(struct drm_bridge *bridge,
 	mhdp_state = to_cdns_mhdp_bridge_state(new_state);
 
 	mhdp_state->current_mode = drm_mode_duplicate(bridge->dev, mode);
+	if (!mhdp_state->current_mode)
+		return;
+
 	drm_mode_set_name(mhdp_state->current_mode);
 
 	dev_dbg(mhdp->dev, "%s: Enabling mode %s\n", __func__, mode->name);
-- 
2.43.0



