Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C9657D221;
	Wed,  9 Sep 2026 14:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964125; cv=none; b=p8UT6czvw7uMOV7L2AZMmyqysqBxJMpueUUPlypCl07awqbAKX9AEel8F2AkV+6K4MQzSfF+TOmpLRhrj0juhwh/RPt4SBrF7QG7V9cJVA05UyB2fK466IoE4KJUmdp2/LUaFr2+TRJriYsh/96XPjTs4P5w7RkRleeWZJAR3ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964125; c=relaxed/simple;
	bh=2ZBfvLHgefFc4/O5+wI5+t1H7Hnqmgcjxa9eYYBh62k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AC7Dwv5NI9tsdYFuzYhiEwNvnHHvx9v9mufmb0QwlsXa6mvmbLsZ0TmhNv8iIxA/fvC5BIKONeA7TUs6pFX8iKvNNZVy6AlL0VYxr9Faln4T3dVaGbmIVxiftj8eO/CXfZexKTrPx5RqLICergP22AdpZS+ulFtxhiRS9fisQXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3DmjpeY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3DmjpeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C83B1F00A3F;
	Wed,  9 Sep 2026 14:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964124;
	bh=tbyQwN3x23pPXGmuHg7GuGIgUvNwfuA7irAGnyP1G/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3DmjpeYYB8o2kBZ5sknKdSY+ZKmrLB1DdhiXPZCnIEdB3ZFwUs4fgMUeXDgP/yq5
	 82LQLNqTGl2cGyJcbRGO4Rr+XZJoN33DJFQFKMJKccgE58upe+4weuBa7mNAUFPnI6
	 p4/oV7ezSIsjs3E+JoY6GOA3h5xyntCFGzE791q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 313/583] media: v4l2-fwnode: Fix fwnode leak in v4l2_fwnode_parse_link
Date: Wed,  9 Sep 2026 15:39:58 +0200
Message-ID: <20260909134248.850761335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -623,6 +623,8 @@ int v4l2_fwnode_parse_link(struct fwnode
 	if (!link->remote_node)
 		goto err_put_remote_endpoint;
 
+	fwnode_handle_put(fwnode);
+
 	return 0;
 
 err_put_remote_endpoint:


