Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE4123C51D;
	Mon, 17 Aug 2026 14:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977886; cv=none; b=MIAMU4cjIS+0d57Osm5GNY+rlp/nMlBKsCopx45b/fGa2mKEfBhJhTgZfN8DRf+4bWmAk7F7Ig+gZnm7o23lz6zHBFfyxIROSSYFcClZsqO7CsRbkZhDbQ7W3XJwtacvP8glvBa0ctWIHMHQp+uM4AAAamiB0syprOorlBEkqkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977886; c=relaxed/simple;
	bh=Boqr/7kR6VQCJPDYmU5movJM6D36LLTryZOTvY2lPO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yl3jMBFpvlzYdNElBuV01GttuWMHX8BWQJho+1ImirSdkP8FfR81X2/O3wR/ivzm92gswDcb95y2G/L3afn/Am0aiV+TsutoBlI8TkNyJ51KRP4GnL42D5LI5+ooL+e7JokKHtJRPAsVWL8BjD2oeU9OhGUUl+MccvQeeiIlI1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5RJxAzj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5RJxAzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56FC1F000E9;
	Mon, 17 Aug 2026 14:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977885;
	bh=MrDsQsMKFT7hEPIxn8QWV6ogEqGPJAYa/kPZdbSMQtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5RJxAzj6TECBEfL3SdgVsgEqYd/veDn1DKHgjBDpH7Tu2Yf7iCYJp6LatALsFB8y
	 KsTN/hd6ZF4LqCBlWhNmeE7yOk/HZ+K9YOYYVOSKXzooiM3191OxOj4yDnzFCD7nDe
	 JHzKlCcTAmUCYnLyv93aYfmsndI83QyNdar6dtfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/181] devlink: fix net namespace reference leak in reload
Date: Mon, 17 Aug 2026 15:32:01 +0200
Message-ID: <20260817132536.447954574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 1c4dac9bf1d2ac31da63b794bdec697777cbd0fd ]

devlink_nl_reload_doit() calls devlink_netns_get(), which returns a net
with a held reference. When the requested namespace differs from the
current one and the reload action is not DRIVER_REINIT, the function
returns -EOPNOTSUPP without releasing the reference. Add the missing
put_net() on this error path.

Fixes: 2edd92570441 ("devlink: don't allow to change net namespace for FW_ACTIVATE reload action")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://patch.msgid.link/20260729080600.2427721-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index 13c73f50da3d1..fc109acd4e844 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -579,6 +579,7 @@ int devlink_nl_reload_doit(struct sk_buff *skb, struct genl_info *info)
 		    action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT) {
 			NL_SET_ERR_MSG_MOD(info->extack,
 					   "Changing namespace is only supported for reinit action");
+			put_net(dest_net);
 			return -EOPNOTSUPP;
 		}
 	}
-- 
2.53.0



