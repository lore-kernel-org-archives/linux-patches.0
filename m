Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046B36FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F205C433C1;
	Wed, 30 Nov 2022 18:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832844;
	bh=MrW+MLMnSaaz552UWpAVfbRHkwkLHvHiI3bRh2/NUi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFTVTbJX4FnkwnBzK4pLOl4+IscIhF/k2QP+d9wQc7A5+Er7EmmF9/D92fqcpaCSv
	 ijN3RiRPbtCdjGjbEk4O2O2w0OiZKedJAB7Xume7BoU63rOqrS+xFHhbONWBOs3HNH
	 xY6lu3WRSMgsm3I6AA8+3HN6TZLoE1NuoNWzci10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diana Wang <na.wang@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/162] nfp: fill splittable of devlink_port_attrs correctly
Date: Wed, 30 Nov 2022 19:22:21 +0100
Message-Id: <20221130180530.135603944@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Diana Wang <na.wang@corigine.com>

[ Upstream commit 4abd9600b9d15d3d92a9ac25cf200422a4c415ee ]

The error is reflected in that it shows wrong splittable status of
port when executing "devlink port show".
The reason which leads the error is that the assigned operation of
splittable is just a simple negation operation of split and it does
not consider port lanes quantity. A splittable port should have
several lanes that can be split(lanes quantity > 1).
If without the judgement, it will show wrong message for some
firmware, such as 2x25G, 2x10G.

Fixes: a0f49b548652 ("devlink: Add a new devlink port split ability attribute and pass to netlink")
Signed-off-by: Diana Wang <na.wang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 7a8187458724..24578c48f075 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -363,7 +363,7 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 		return ret;
 
 	attrs.split = eth_port.is_split;
-	attrs.splittable = !attrs.split;
+	attrs.splittable = eth_port.port_lanes > 1 && !attrs.split;
 	attrs.lanes = eth_port.port_lanes;
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = eth_port.label_port;
-- 
2.35.1



