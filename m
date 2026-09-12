Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5726D37CD3E;
	Sat, 12 Sep 2026 19:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242122; cv=none; b=e6xBzgQN3ibxeO5zcp0O3mElUETfKCV25gpBW5ZAiI1pOIaGXXfBXtKfAiGZGE/4/19qkWasUhzl72/uYDnYI7R9H1/6xMQngz4QwiB4kdKaT7t2FJjzMiih/2jXUSNc3SRw3oH1g1qPUU7tD5+IFTeVJKWUZGTImJNqZXUVt/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242122; c=relaxed/simple;
	bh=wgKdT47Hv/fnxenZWmqqYMB1R9Is6YHIo3B9YiKgp7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPGtznP99ewFHnel2VHdTPUwaMki1/NJFX2eMIKJs33vyK1u2eY4vocJaI9LUeSKIRriA9fbwiMqHFTaNbZ7vzeOkHVbZb3Xv5fJebCNkdEe5Gd7KN6ytesKSo1x/FuoTy2kcd7kKz5jrygaRH6I/bu72QNF10IynqRPLwzJCAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLpns8ux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLpns8ux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A2C1F000FF;
	Sat, 12 Sep 2026 19:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242121;
	bh=6FE99E7xYQ0PEpDolNNWQDkdIufGgsTMr4ya9PKgBmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLpns8uxdO2n0OJAia7f0ywwHiA1gKdoqHxlRAonOQ+oIx9U3KgEZQMV6uKELizGC
	 c4TMrVFK8+PlQc0IT/taYKNiohQ4YItGj2dlFog1e5Ts3m3duhTfGtMk/eR9qMhBO6
	 8y9D1YaqUuvUbuRRCoZCXR4bGwwK5IJ84hP5T/Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 5.10 286/798] media: v4l2-fwnode: Fix fwnode leak in v4l2_fwnode_parse_link
Date: Sat, 12 Sep 2026 08:58:34 +0200
Message-ID: <20260912065523.718675599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biren Pandya <birenpandya@gmail.com>

commit a6e86efd7f85e519bf48417f41923f8bd51f1597 upstream.

In v4l2_fwnode_parse_link(), the remote endpoint fwnode reference is
acquired using fwnode_graph_get_remote_endpoint(). This reference is
properly released in the error paths, but it is leaked on the success
path.

Add the missing fwnode_handle_put() before returning 0 to prevent the
reference leak.

Signed-off-by: Biren Pandya <birenpandya@gmail.com>
Fixes: ca50c197bd96 ("[media] v4l: fwnode: Support generic fwnode for parsing standardised properties")
Cc: stable@vger.kernel.org
[Sakari Ailus: Fix subject prefix and coding style a little.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-fwnode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -586,6 +586,8 @@ int v4l2_fwnode_parse_link(struct fwnode
 	if (!link->remote_node)
 		goto err_put_remote_endpoint;
 
+	fwnode_handle_put(fwnode);
+
 	return 0;
 
 err_put_remote_endpoint:


