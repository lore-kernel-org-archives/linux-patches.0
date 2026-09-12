Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7CA481241;
	Sat, 12 Sep 2026 18:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237784; cv=none; b=vDwfxL3aehEfkGnZfF7gmBhwpgtoQVO0EY1fZ3zSrmxgziaTI7fHW8uG8c1x2g7UJeSBgYyxDzsuYSlImExtY5muHB3BLGrDsHu10nsTPB4Eu86z8McXr9NK+wTSt6mr+Sr/HdGTTXP2wW2fEtbsWuXaSMR0nTczMUy7Y0geQuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237784; c=relaxed/simple;
	bh=lf0WWpvh31UNxHSTt2BnEBD+E3WGB7XAapfGysrtBTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSKpGZoQq/PrpUOdk5q82STPtb8BkdvdHwdCifExwQu/T1liVbObiDYVFAL8wkTgH5R/OXWrWtwBaedxCu89VL3tADuTk7rDQEzG4q8ujS9lsNU+yaGujIH/1cK8kqifwTJL7ROw1eOvMcbN0mmvNqKuhOcaVQFTiXGFzUGpDQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKXzUXxP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKXzUXxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47261F000FF;
	Sat, 12 Sep 2026 18:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237781;
	bh=/FVK0ASLFKBCUjiKDdlj09drFy3PQJEHGyqDG2vbugI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKXzUXxP/wEaHEwE38ctHsr85R5ERhIyZpMG1i9JVuzynC2N4GI3FcgR9GhD0o43n
	 66vYKD5o2G3RlaC1pECdBFHdr2o8CRzEHIUmWoGZEGah3YJf8HLjTS4X4d8bcYZPd5
	 VRxNPtC3TBxdcYqByDWhArI/XK1CnDLUmYEtHzPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 5.15 328/935] media: v4l2-fwnode: Fix fwnode leak in v4l2_fwnode_parse_link
Date: Sat, 12 Sep 2026 08:55:58 +0200
Message-ID: <20260912065534.324560416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -563,6 +563,8 @@ int v4l2_fwnode_parse_link(struct fwnode
 	if (!link->remote_node)
 		goto err_put_remote_endpoint;
 
+	fwnode_handle_put(fwnode);
+
 	return 0;
 
 err_put_remote_endpoint:


