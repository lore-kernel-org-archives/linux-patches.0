Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F1F43CEC7;
	Mon, 17 Aug 2026 13:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974778; cv=none; b=P1nauj4ksgR7Y04+QttU8FGNevQanP2eQcMXIGFxkDevFiSdOnyrZ/fmCQnKzFv6errY2c3aGf33CaZ7ZAISNJvA30rDxjyA2uo5IhD/xK8GjP21v4HB6o66V8Z1nB0UmB5plLwO0pWdsgeaYqtEyh7DJ86HcOKcKMzJlQ0COak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974778; c=relaxed/simple;
	bh=0P0b+9ZD5gROOX3Uga1Z4CccMQlxHemQjegj9DLb9YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nr2vzNO5ReTyoqpP1mg0DjQMxN1Tr/jz4Y8DniEqcH3WuSQ6LluwCWFbJM7VolMFloczs9yAGelfxe1SeD/YxrFDOulst3tqgkhmWetns/gS5pjqKxwtB2xPlYH0+pRkqOkCCOVUcU650v1UVuxuZU6Ph52DrIJhuf9YuU8brf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmfFecRI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmfFecRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576EF1F00A3F;
	Mon, 17 Aug 2026 13:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974772;
	bh=bJx/Pc+hVLN1+ReOJBkJRy1jKMfPb/1zavE2jVtQcl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TmfFecRIQc0JI/WZOuHpxg33YC83Xy9ZPuqIV8E08jagSnU4eeWZRnpNewYOYCTcT
	 TgUAo69AEcg+VWyUAfG6X1ZerDmxw0FX6rwAU8M8ZMScwF7eQk4x7FE/CoZiQZWO/e
	 6UbZb/pAZLuGLK6UYpnxbb+KWZUkbFQjZgCDBmEo=
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
Subject: [PATCH 6.18 049/250] devlink: fix net namespace reference leak in reload
Date: Mon, 17 Aug 2026 15:30:10 +0200
Message-ID: <20260817132538.453782760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
index 02602704bdeaa..ed442c1bed8db 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -577,6 +577,7 @@ int devlink_nl_reload_doit(struct sk_buff *skb, struct genl_info *info)
 		    action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT) {
 			NL_SET_ERR_MSG_MOD(info->extack,
 					   "Changing namespace is only supported for reinit action");
+			put_net(dest_net);
 			return -EOPNOTSUPP;
 		}
 	}
-- 
2.53.0



