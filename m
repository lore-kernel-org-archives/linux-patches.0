Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A0B6FD6
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D349EC433C8;
	Sun, 17 Sep 2023 20:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982394;
	bh=CGU4xlNLkcZMGKyzywBdtT0is+2gfP8k9Ly1fv8O2kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrtaIMZipECr+Ry+3kkQN4ivKST6T/sq0R4HIZkcC6PTXjrjjnSUj5CsmxYoD8dDE
	 MHaxUk42GTsEHndGMf3zNcMp80M0ot+uRddh85X8IROAGfrP3FdVl0ic1zxQBWjU0U
	 GsMfKae9IrZ1jsfK4Sx+/kzW73hNsExn7vAel2vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/511] media: v4l2-core: Fix a potential resource leak in v4l2_fwnode_parse_link()
Date: Sun, 17 Sep 2023 21:11:04 +0200
Message-ID: <20230917191119.535937272@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d7b13edd4cb4bfa335b6008ab867ac28582d3e5c ]

If fwnode_graph_get_remote_endpoint() fails, 'fwnode' is known to be NULL,
so fwnode_handle_put() is a no-op.

Release the reference taken from a previous fwnode_graph_get_port_parent()
call instead.

Also handle fwnode_graph_get_port_parent() failures.

In order to fix these issues, add an error handling path to the function
and the needed gotos.

Fixes: ca50c197bd96 ("[media] v4l: fwnode: Support generic fwnode for parsing standardised properties")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 843259c304bb5..5d2eaad1fa684 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -549,19 +549,29 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *fwnode,
 	link->local_id = fwep.id;
 	link->local_port = fwep.port;
 	link->local_node = fwnode_graph_get_port_parent(fwnode);
+	if (!link->local_node)
+		return -ENOLINK;
 
 	fwnode = fwnode_graph_get_remote_endpoint(fwnode);
-	if (!fwnode) {
-		fwnode_handle_put(fwnode);
-		return -ENOLINK;
-	}
+	if (!fwnode)
+		goto err_put_local_node;
 
 	fwnode_graph_parse_endpoint(fwnode, &fwep);
 	link->remote_id = fwep.id;
 	link->remote_port = fwep.port;
 	link->remote_node = fwnode_graph_get_port_parent(fwnode);
+	if (!link->remote_node)
+		goto err_put_remote_endpoint;
 
 	return 0;
+
+err_put_remote_endpoint:
+	fwnode_handle_put(fwnode);
+
+err_put_local_node:
+	fwnode_handle_put(link->local_node);
+
+	return -ENOLINK;
 }
 EXPORT_SYMBOL_GPL(v4l2_fwnode_parse_link);
 
-- 
2.40.1



