Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E520532ED40;
	Mon, 17 Aug 2026 13:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974010; cv=none; b=Jxex2H1GGVZI181suSR5jydVSexnqSjUpj97AVZHjFJCQr3EOe1tQf1QrrJapB22WKvAHu7bF1CUd/34ubEsGRrap1nsE8bO367qE7WGNRv+mcZ1GynSnyY4NNpNxUZIEV23WMcWGuLYjVjz8Ql2Iota+Tf/4FvynFOZVLSU8DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974010; c=relaxed/simple;
	bh=gmsps2TjOdpATbzELg4QeN2hs0TzZcJJLxQzio1NLpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGshL6WvTzM/AEJK++Yqt6y1wYlsngt24TcBw2Qg+HFx9ic0gJp4Jf5SJz6/JG27J8jLL9A/o1xrIh8iwq9/5VFfeZdojfFfGoN37hiEmTgmfr6AaTcmJAOIiJobNIZVaDAb43i0ft7K1OE26qMJTO7ZGQy2uBTG9gNEuGYjUEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wiyo/C/A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wiyo/C/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069661F000E9;
	Mon, 17 Aug 2026 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974008;
	bh=KThBSFpcIxxhaLzTrv4b/Wllfq9HR1Sdr562FDCMOBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wiyo/C/AISfU7BjiaKw+ch14tCXwCsX6ie1VWi1tj/CV+IbFUA/20/vcDz+nH4urf
	 6AslUfkoS7lXk9T8ztz//dHwVMa37z8ML2cfDVjRMX6EwX5nLM813GNKfs0yh04pNO
	 LvCKucDk1VTM+phn8DLpXZlgvDNqC6L/7JuM6EaI=
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
Subject: [PATCH 7.1 057/271] devlink: fix net namespace reference leak in reload
Date: Mon, 17 Aug 2026 15:29:42 +0200
Message-ID: <20260817132539.092653044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 57b2b8f035436..fd5633fa88ecd 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -578,6 +578,7 @@ int devlink_nl_reload_doit(struct sk_buff *skb, struct genl_info *info)
 		    action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT) {
 			NL_SET_ERR_MSG_MOD(info->extack,
 					   "Changing namespace is only supported for reinit action");
+			put_net(dest_net);
 			return -EOPNOTSUPP;
 		}
 	}
-- 
2.53.0



