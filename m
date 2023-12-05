Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B126FAF;
	Tue,  5 Dec 2023 03:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ml5H3yIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866A1C433C7;
	Tue,  5 Dec 2023 03:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746646;
	bh=G9+m6T0wFQLXLzIJar1OYgcC30rAJFJbv+9Gicczqb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ml5H3yIWcqondR0j8KLVsHBSt7azaR/wsbiazscIZX5iji1LrpyDKlV7lw7W6tVVV
	 jdbN7lVLcay7Fqmc7WpaRHBBc6bfu2Y4EdoySR/wBZssjutawKR0jmNummAjn1ujnG
	 ozUZ2yaJIFrXF6NhpDdlASTBQ3OlLcJvJVfJd784=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/134] ethtool: dont propagate EOPNOTSUPP from dumps
Date: Tue,  5 Dec 2023 12:16:15 +0900
Message-ID: <20231205031541.943172990@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit cbeb989e41f4094f54bec2cecce993f26f547bea ]

The default dump handler needs to clear ret before returning.
Otherwise if the last interface returns an inconsequential
error this error will propagate to user space.

This may confuse user space (ethtool CLI seems to ignore it,
but YNL doesn't). It will also terminate the dump early
for mutli-skb dump, because netlink core treats EOPNOTSUPP
as a real error.

Fixes: 728480f12442 ("ethtool: default handlers for GET requests")
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20231126225806.2143528-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 3bbd5afb7b31c..fe3553f60bf39 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -505,6 +505,7 @@ static int ethnl_default_dumpit(struct sk_buff *skb,
 				ret = skb->len;
 			break;
 		}
+		ret = 0;
 	}
 	rtnl_unlock();
 
-- 
2.42.0



