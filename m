Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B131E42EEDD;
	Mon, 17 Aug 2026 14:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978385; cv=none; b=qTrg1XSqGdmOGXfu5Kin98/w5BKc74NO3BL2PtOnJqvZEg5lyj0JhziWUUgxPufWvzzdCUE0OrEPU/LzeA1BV0XY2bFRPlQpynOta3+3tX6aOnKxNzhKtO/Jv4RvMwBC5+h4SF3cOr1mQQVmzw6APEkPeIzMbmu+L4JLvPyROOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978385; c=relaxed/simple;
	bh=vtdYblTabYuImg1HtTRz4YpK98vybaiErNi4bBRlqHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+7VBJYDrNO7dLXEgLJyErQ1bzR4GlBW70PJB6sWTSsejuHSB3NoDnuXZWIjlYm+Gc74R1f0Gqj77oK9MhcHBODqr/8ibi25xuU4aUmDf4mj6D68fY/epBVgq+GzIs+F9oMYjHI2+ZDV01OJ6/54S7YotTkiGSfPQH7SLIydQQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6gKvjkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6gKvjkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153751F000E9;
	Mon, 17 Aug 2026 14:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978384;
	bh=Yd2VMRhfC0OoUR21SMzf7Kl+Dxna4yIHIkakj/CjI94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6gKvjkZZnHC/aGlFRdqW8yeQMeXMoHDELMR7Vf/lHENaIWWV6JaWIBa3nwL3pluU
	 wWyRNRblgr5f0GbJuON1IYERN4B6sKT3m1h94vpHlus0SFothwnXcnxFLUKs9I0oVQ
	 u9hJ1/Iz9UYDszuOIP7qAZwx8ZTZKMkLy16bMipk=
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
Subject: [PATCH 6.6 019/156] devlink: fix net namespace reference leak in reload
Date: Mon, 17 Aug 2026 15:32:33 +0200
Message-ID: <20260817132535.381481680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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
index bba4ace7d22ba..c70d4dc599b85 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -505,6 +505,7 @@ int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 		    action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT) {
 			NL_SET_ERR_MSG_MOD(info->extack,
 					   "Changing namespace is only supported for reinit action");
+			put_net(dest_net);
 			return -EOPNOTSUPP;
 		}
 	}
-- 
2.53.0



