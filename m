Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4081C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12DFC433D2;
	Wed, 28 Dec 2022 16:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245324;
	bh=uxKcc1InI0HN9l0fdKDk6mH8C6h893D41KckS6dhTKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ab8yn9Zy20fK0eGSyK7xyS29oi8tLDHhnsHXmWEhnVU18Z5JQDTjLieDEbZ2a/iPA
	 0gVhTa9OtNjF/+XFP5mV4oAj+rF5fu5m2Xd8XfCEqFTSPwQMK8wjuemgQ1hq1AOt89
	 Caa3gTpVXJ/nNWz5Oi90k5AVvjP5c2rOFncD0MQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0873/1073] devlink: protect devlink dump by the instance lock
Date: Wed, 28 Dec 2022 15:41:01 +0100
Message-Id: <20221228144351.736098985@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 214964a13ab56a9757d146b79b468a7ca190fbfb ]

Take the instance lock around devlink_nl_fill() when dumping,
doit takes it already.

We are only dumping basic info so in the worst case we were risking
data races around the reload statistics. Until the big devlink mutex
was removed all relevant code was protected by it, so the missing
instance lock was not exposed.

Fixes: d3efc2a6a6d8 ("net: devlink: remove devlink_mutex")
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20221216044122.1863550-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/devlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index b3a869ccc8ed..5f894bd20c31 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1498,10 +1498,13 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 			continue;
 		}
 
+		devl_lock(devlink);
 		err = devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
 				      NETLINK_CB(cb->skb).portid,
 				      cb->nlh->nlmsg_seq, NLM_F_MULTI);
+		devl_unlock(devlink);
 		devlink_put(devlink);
+
 		if (err)
 			goto out;
 		idx++;
-- 
2.35.1



