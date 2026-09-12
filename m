Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095B447A0C4;
	Sat, 12 Sep 2026 11:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213894; cv=none; b=HEz/MOpiLIaE6sHx1Z2JKBXNt6rL1JT6d6OswNBVC9UMP0sNY5cLFNaOMpvMNVx9C30wxj0soqW065BVBf8gqLN+c5WjZRrlOLKwSwceyIMkqZr0RgFtopqCwacgSgzt1DHmM1h+YHq8Jn8hk1ImRQ94Lzv2lwSJIksKpXiLYtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213894; c=relaxed/simple;
	bh=qmYi2pjZYO4+uxhnqYVP9w6rQNCoYzbGhfsqUcVcjEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFGY5cMv+Q2rjTAFGq3Kf5YzF3ivx62drb7Xnz4wnQJ3lstn80IPYOqa7t+hdiAUldmLHQCh6w726Db7TXNIGPHeVTnGLqbgegz1GwdKUVmU7dKWAd2mebXpqROyUd1T4jut3yT5dW3L4a3UVVxplOQsDilDZkm5q116LKG2pi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGpxovK0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGpxovK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732DF1F000FF;
	Sat, 12 Sep 2026 11:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213889;
	bh=nmDKQ1uaooepLj4T2DXDN067PS+yIAukhAHpNcYJmzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGpxovK0ZGFbWoyQXpx9vSnJRBi3syz93vI2EQ/ZKxLX281aF8T3skxVfltGxHrbN
	 ad4ENjtJdDHAyUpG+gDNQZpnkqEpFldrwS6S5TS8GftErTV6hUctE87schrcPcPD1e
	 om5RcX0EQZwKY1QLdLwDQaGiKVITe/TaCFDPW+24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.12 0213/1376] media: v4l2-fwnode: Fix fwnode leak in v4l2_fwnode_parse_link
Date: Sat, 12 Sep 2026 08:43:59 +0200
Message-ID: <20260912065612.295669623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


