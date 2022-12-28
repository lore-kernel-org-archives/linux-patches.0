Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EA31C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA5CC433EF;
	Wed, 28 Dec 2022 16:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245788;
	bh=RTgiyF7PyQwlATxJ/L3HaIhgwxSfEQgMnY2RYsQO39c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlxJmNXQk7VpfRrr34WspLYGA+upDbQv8aQhEMVMY7DdnZJLOvicUz/LlnpWTyEs9
	 tN5hV25Lq5Lm+8onSca7C8FU2v567TadB5hXnSpkak0KluRYJTUfXSHQEPpdhP6YPb
	 b2v5lW03Jnqvnd2LWX1OEm5HbUamh6Oejf3oOjzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0922/1146] devlink: protect devlink dump by the instance lock
Date: Wed, 28 Dec 2022 15:41:01 +0100
Message-Id: <20221228144355.308980148@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index e8f1af4231db..2aa77d4b80d0 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1505,10 +1505,13 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
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



