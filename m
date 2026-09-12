Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CED3A544C;
	Sat, 12 Sep 2026 14:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221859; cv=none; b=avoDJSkaap0uu93GEllPjnCkifAj4Ch5nn1s7xb9uNER9tRGIpjRvxTpmlXHRWYSDrY5t0tK/sa8lktRTXzCKRoMtDrcO3d9XWg9MSCX0lMMgls9Z6VEWtZdWVlkDdetOIbrwLtyiEbk/mJnvyTziPfBBAixbD6ki9asLQrRoE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221859; c=relaxed/simple;
	bh=5sPNqppKyXd8kFA5hac3E/Kn7wROVO9LYqkZc32VMhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G37F+1dhTMeOHEKa8og2Kt144latW7uC6V9FiGn4Wn9kmb58NLZlnws7/3y3eDJmsEGPR+3u0X4DznytH2BhhWQwWIcO1LXh8lDJ2fhSipYTu4l5u30m6kOwx77ZKiVnOigK0ndN/7qHoDMinKb24cJItl5CgewRFEg2JG8pbM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+f/Y6Sp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+f/Y6Sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FF31F000FF;
	Sat, 12 Sep 2026 14:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221856;
	bh=lxVKXXd6YrD5VQwOaG5qP9j+THYzh+XjIUOmO5lG7sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1+f/Y6Spp9+FPoYBXMixEU78/R5Gk/Ch9LBW7eeMlYmLQNQ1rOtccJfQ5QiRNZIfg
	 OXs8a8u4NlE42oZuRuu4E7qd31BvtE8KfVmDfGVLByWHeeJTYwmNd9QNaaXX6owjgF
	 eHYgi5qWJKAH/D0zi+SsYySv7xbW2hIhI5QAXhig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.6 0467/1424] media: v4l2-fwnode: Fix fwnode leak in v4l2_fwnode_parse_link
Date: Sat, 12 Sep 2026 08:48:19 +0200
Message-ID: <20260912065617.744831375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -582,6 +582,8 @@ int v4l2_fwnode_parse_link(struct fwnode
 	if (!link->remote_node)
 		goto err_put_remote_endpoint;
 
+	fwnode_handle_put(fwnode);
+
 	return 0;
 
 err_put_remote_endpoint:


