Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED222E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88582C433D9;
	Wed, 20 Sep 2023 12:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212047;
	bh=jKTphTkQ8gUMUsLxhGHhGdvRycfalJTHShEqrI2mMJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKaiaIT2EpRrDu66wQb/tuwm5/M/4vm9pfil7nqiu/BrUUjWH9O6SjnYl+bZYpstf
	 UuB3kGp+OFavsgrEf+tcU7voaTOJ4MFFJZbWdJ02kE5PGL9dPV/+EN4qYO7lvVagCF
	 swWGqUNBd+Bm3BkBsnvLRIr6nw06stBG8Nt3VUlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/273] media: v4l2-core: Fix a potential resource leak in v4l2_fwnode_parse_link()
Date: Wed, 20 Sep 2023 13:29:32 +0200
Message-ID: <20230920112850.594845479@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 14530fddbef47..95079229a772b 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -289,18 +289,28 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *fwnode,
 	fwnode_graph_parse_endpoint(fwnode, &fwep);
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



