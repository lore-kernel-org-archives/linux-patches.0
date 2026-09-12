Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBD247A0B6;
	Sat, 12 Sep 2026 15:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228418; cv=none; b=IHVQh5Vs0nWAYmcjMC53aUG4IH5VwKaWBXSTvLGMS50ItyucldusMDYCH1Li15krUjDHYy7uFEJ64kP5HJNE6IOT4HsWghsY1Wah+fqbTs/3PIOnpMOop8VJg1Evf82vCM5ZDjdFIY8Xhwdj3XUOihhxHgkz0yYXMcZdEGPI8Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228418; c=relaxed/simple;
	bh=4zKSWsqUIFb7ywEEm6EpYBTik/HwaBveAdYVXbln9lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ai/hZAuLMAa5Wx+24O1sRFetpzCsZHkc2i2a0crPjzMvJ0VjxtMM8qD8YScsCRgQtTpd2/0zBqJL1kT5DZAdXs1Zee1JVoAU0NHMUi58vOpAjfVqZJcm6EsssobOwDLBfA7riN41WK796FF5hoWdhCe0+RAE5n7SatQm9qUqfTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLQPlW+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLQPlW+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AA01F000FF;
	Sat, 12 Sep 2026 15:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228417;
	bh=gCUyj2RKlIaqw8Eh7lRXMxWChZD1mgaGG6yoVfTxy6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLQPlW+j93eGp7aV5RVOSlPM8CRl9YVfShb6jmtelIbsIjZgcTYfg+J5a1DwjywPT
	 HimK3qNkxmigbOA+5qTZv230Be2vV9BuHoN4sSqtsJ9qt4pB0Lv8z1iqr+yln6H0UU
	 AbF+veNqX+uLaG1XK38uH4EByho6DArSz6tpRGZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biren Pandya <birenpandya@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.1 0382/1191] media: v4l2-fwnode: Fix fwnode leak in v4l2_fwnode_parse_link
Date: Sat, 12 Sep 2026 08:51:50 +0200
Message-ID: <20260912065556.820013615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -565,6 +565,8 @@ int v4l2_fwnode_parse_link(struct fwnode
 	if (!link->remote_node)
 		goto err_put_remote_endpoint;
 
+	fwnode_handle_put(fwnode);
+
 	return 0;
 
 err_put_remote_endpoint:


