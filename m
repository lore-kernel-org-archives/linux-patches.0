Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C25BEC4;
	Thu, 13 Jun 2024 12:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282021; cv=none; b=QY4maD2G8g5nofnhQXnOfUmOzGaM4H0FmUJyERu/vJ8urWkEAzGzmazexZuj13b4rU6pptOmGnNch1KHXGxUd1p4DPK6wau3ul9wp1GpvgAIVM4Pwj+OPF6R+nk1RQpdUarz+VZhIjAQhBeTnHVd6CMlaoJWW+q8yY+coEgiFVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282021; c=relaxed/simple;
	bh=zIZCPlob/6GUe7EFbCfhtSXX957LmpJQdpZH4/Th9l4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDV2fiaurpTSQF+mmL22VbUJyB2zzGbP2rVgC8qcvZRRHLHETa+y4emLDA7EcOZn5jqkvglbS8Svg2YvjAHPEsVJRl9qfIFzmA+wbO09j2H/bcwKaMo8qLBFUyLFzp/Me/ehwO/8rhy01yEW6HNeQkl0UZsIOiUbl/o3RqrY4hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSQYUtg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSQYUtg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82D2C2BBFC;
	Thu, 13 Jun 2024 12:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282021;
	bh=zIZCPlob/6GUe7EFbCfhtSXX957LmpJQdpZH4/Th9l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSQYUtg1Y3vrn45xnhQuud1pM1pJE3+tNbN5OEQpmNNol53Ws/nQM2AquewzAyGoo
	 +LURrTNWRCNCQJBrAs3z7hQC0kT5edgjnGuIrH7Ao7ABcmDnc0HXqA8KKZxEFKUTWU
	 k5goky0MJ14etA3bjDF5qbMzeiUtC3IpaN3U4eRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/402] drm: bridge: cdns-mhdp8546: Fix possible null pointer dereference
Date: Thu, 13 Jun 2024 13:31:32 +0200
Message-ID: <20240613113307.402680550@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5530fbf64f1e4..c8386311cc704 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -2040,6 +2040,9 @@ static void cdns_mhdp_atomic_enable(struct drm_bridge *bridge,
 	mhdp_state = to_cdns_mhdp_bridge_state(new_state);
 
 	mhdp_state->current_mode = drm_mode_duplicate(bridge->dev, mode);
+	if (!mhdp_state->current_mode)
+		return;
+
 	drm_mode_set_name(mhdp_state->current_mode);
 
 	dev_dbg(mhdp->dev, "%s: Enabling mode %s\n", __func__, mode->name);
-- 
2.43.0



