Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8084534A2;
	Tue, 16 Jun 2026 15:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624801; cv=none; b=ZzmGw64botwwMNM/rombW5p/7pfsKNccV59QF5nTuQhzwAVgJ0y4yzwd0bRnMzZdaExzYrfOQU7Foxe7KiJiDjcbG70go+vzuegfzBTRz50tT8qpMBauC/ecZqjBMNXUzHMpZZoQdHp4ujXitX3p4sX/4/iInGNCD3SFrwYuk0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624801; c=relaxed/simple;
	bh=5ZaULK4t+OmBWF1X7csedcG2xZiBvy+LbGfXMzLt1b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHmlA+0HDZnupJZihufVf0K/Scqs/CZHRWgNT0LnXh6ORH+q/f/2QWm/4FBSzF7etlvnXrv6ol/LVA+zBvZEhY7VVDgxCtHyZGWgRWTEMfmmZpNy1Qa2PcDGix1cKDAYf2fshvLdAhFO0WMSWbvOAmOpbp0LRbLygQYLt3Z6PVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7/flxGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7/flxGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF031F000E9;
	Tue, 16 Jun 2026 15:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624798;
	bh=smi4+V6zvDL1nvI717cdaQ6pbCkbA1Uf99IClUYmViw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7/flxGHekBUKInQG/FjDCNNj1fv5RfFHuU2XmgsndHtpMTVuGGcGdrJ998KxAvoe
	 gmThZrsNh6AKDvl62itz9i3wV8vG90tL1tucpYujFCcaeilBr9BZXiTpvVqt/MZ2kF
	 Ahvy7wkC0iGWIVE0emxazGqwZPovENf736EVetVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/325] devlink: Release nested relation on devlink free
Date: Tue, 16 Jun 2026 20:27:07 +0530
Message-ID: <20260616145059.306320413@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 3522b21fd7e1863d0734537737bd59f1b90d0190 ]

devlink relation state is normally released from devl_unregister(), which
calls devlink_rel_put(). This misses devlink instances that get a nested
relation before registration and then fail probe before devl_register() is
reached.

That flow can happen for SFs. The child devlink gets linked to its
parent before registration, then a later probe error calls devlink_free()
directly. Since the instance was never registered, devl_unregister() is not
called and devlink->rel is leaked.

Release any pending relation from devlink_free() as well. The registered
path is unchanged because devl_unregister() already clears devlink->rel
before devlink_free() runs.

Fixes: c137743bce02 ("devlink: introduce object and nested devlink relationship infra")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20260528191411.3270532-1-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index 58093f49c0905e..d8f875b229897e 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -469,6 +469,8 @@ void devlink_free(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
+	devlink_rel_put(devlink);
+
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
 	WARN_ON(!list_empty(&devlink->trap_list));
-- 
2.53.0



