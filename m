Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB21138C437;
	Tue, 16 Jun 2026 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622792; cv=none; b=jbA0X043QufPlzS8AxRVHstcUQHVOfT/GAiLoFRRuZc8KSYHGKMx41Ovej8UMTO7spbShEde59J3tG5WZ2VWc6tSXFlqla38IDBdOi0JD/wFRA2LkXUDyT+QwqOPlxkjxWd1Ux1KUjfrM4qWgmktSnbr0ndapM06EG7IVvkXZis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622792; c=relaxed/simple;
	bh=XM+qkaP7069Yvk0TKpoA4ec2lahupL3SF6bsFI3zz8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kadpWoAmlBiwR8FKrPy7kHxhJNWFceYDW1OFHjfedKKrUKVH517hMySaWaWlyf17PxX0o0x9C3C3yQqsMeY0GxXpmYDx08GbwBLtoYbsoaqGzYv7Dg5dsv4bmnvxZ7KyIikTtYxpU4sKteLP5MQy5pERLU7uxMD7+CfUkDtZL1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6ofyMLz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6ofyMLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811881F00A3E;
	Tue, 16 Jun 2026 15:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622791;
	bh=QPd3dHma+vF/LyLUq4rqc8bY4CrYj+yO2V0fwbcoz/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6ofyMLzANFGghnzyI44N68QlWhXI+TmMOI4L92Wli9Rkymj6+vdtAZG08M5kNmek
	 Sr57pAvg9hUsfIHntT9B/ozHHkmxt5B0uWTYUVD+iLTzWlYWaAtubATVQGACxL/Vhw
	 5oalb22gHQGr7pnLMOzknKM2R6Z0YgOSkrmwc3NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 029/378] devlink: Release nested relation on devlink free
Date: Tue, 16 Jun 2026 20:24:20 +0530
Message-ID: <20260616145111.391186855@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index d8e509a669bf6c..998ba9eae9aed6 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -467,6 +467,8 @@ void devlink_free(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
+	devlink_rel_put(devlink);
+
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
 	WARN_ON(!list_empty(&devlink->trap_list));
-- 
2.53.0



