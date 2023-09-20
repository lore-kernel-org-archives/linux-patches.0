Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B546FBD
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD6CC433CB;
	Wed, 20 Sep 2023 12:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213173;
	bh=H/uluswX6VBD8pZmXHtuiL+ciWg4T0ow3QvcP5keeSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bf/JmPRINkuNFXSia4BBqlxceEwu6GgYP2rYviUS44C/5V8vdCpRcMFoetqAr/CMW
	 YmnD65ov3z0c5d3UWWa7JAx4Nc6M8M5T/3yrAjQWp+ifzV6ykGPIpArmlitkMJqWMy
	 nLvSHSwd8Nhx1XMjYFChef3B5IL2icJWKztOCR1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 151/367] media: v4l2-fwnode: simplify v4l2_fwnode_parse_link
Date: Wed, 20 Sep 2023 13:28:48 +0200
Message-ID: <20230920112902.573636741@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 507a0ba93aa1cf2837d2abc4ab0cbad3c29409d3 ]

This helper was introduced before those helpers where awailable. Convert
it to cleanup the code and improbe readability.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: d7b13edd4cb4 ("media: v4l2-core: Fix a potential resource leak in v4l2_fwnode_parse_link()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 217d67cb31af2..56aad92b80fc9 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -560,33 +560,26 @@ int v4l2_fwnode_endpoint_alloc_parse(struct fwnode_handle *fwnode,
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_alloc_parse);
 
-int v4l2_fwnode_parse_link(struct fwnode_handle *__fwnode,
+int v4l2_fwnode_parse_link(struct fwnode_handle *fwnode,
 			   struct v4l2_fwnode_link *link)
 {
-	const char *port_prop = "reg";
-	struct fwnode_handle *fwnode;
+	struct fwnode_endpoint fwep;
 
 	memset(link, 0, sizeof(*link));
 
-	fwnode = fwnode_get_parent(__fwnode);
-	fwnode_property_read_u32(fwnode, port_prop, &link->local_port);
-	fwnode = fwnode_get_next_parent(fwnode);
-	if (is_of_node(fwnode) && of_node_name_eq(to_of_node(fwnode), "ports"))
-		fwnode = fwnode_get_next_parent(fwnode);
-	link->local_node = fwnode;
+	fwnode_graph_parse_endpoint(fwnode, &fwep);
+	link->local_port = fwep.port;
+	link->local_node = fwnode_graph_get_port_parent(fwnode);
 
-	fwnode = fwnode_graph_get_remote_endpoint(__fwnode);
+	fwnode = fwnode_graph_get_remote_endpoint(fwnode);
 	if (!fwnode) {
 		fwnode_handle_put(fwnode);
 		return -ENOLINK;
 	}
 
-	fwnode = fwnode_get_parent(fwnode);
-	fwnode_property_read_u32(fwnode, port_prop, &link->remote_port);
-	fwnode = fwnode_get_next_parent(fwnode);
-	if (is_of_node(fwnode) && of_node_name_eq(to_of_node(fwnode), "ports"))
-		fwnode = fwnode_get_next_parent(fwnode);
-	link->remote_node = fwnode;
+	fwnode_graph_parse_endpoint(fwnode, &fwep);
+	link->remote_port = fwep.port;
+	link->remote_node = fwnode_graph_get_port_parent(fwnode);
 
 	return 0;
 }
-- 
2.40.1



