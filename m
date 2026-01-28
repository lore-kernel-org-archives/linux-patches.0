Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDE3306B3E;
	Wed, 28 Jan 2026 15:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615043; cv=none; b=SU6thoDQpvCz6M6RFgUM4WfDE/QNCkLwQBiwtKx2CuERek6k+IDSjkmgTJmujyYUYj1GYtQDmEu5Vg/zufsGrnxkQTvE31Xo8kipURqcrbGBIDIpGazZBUYX3R+qWz9bA1+fQhlaqZy0LdMaMwnzzYzryBhVj6tfdFDJZwwTh5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615043; c=relaxed/simple;
	bh=GlDycr+SejXvsdJTkM5cB+ALeFDi4dxbfmzoj+qhups=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjkx+Twfdrn0I/VV18An+iA/MgwvfrSQw6jkHpQfVkxPsdOrPVDbfOJ23JevBwQyEWudnTLgK6rymO2V7WRJc7/TA68FgWibCp4riCZ3RTVZvFM6DcEt6MvEH6dlEMoA6QAvZev/aRZnxQZ/9+Oe+t54L//pdHSZF2tN85uj4P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYzK5lwV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYzK5lwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B18C4CEF1;
	Wed, 28 Jan 2026 15:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615043;
	bh=GlDycr+SejXvsdJTkM5cB+ALeFDi4dxbfmzoj+qhups=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYzK5lwVJzdjFmkZ7PKjhc/u7rWhL/Fn72a/wib7MdXH1K7OLQKGiMuzaMX7OGFK7
	 5sOlPu+Ef7oEFo9q+37IpDs0xkfqYqoRO4mCK1FqySmZUB8CSCn9Fay7aKMF3lGNbX
	 ne95y51Bd2cFx+i+AyRnaahi746u8e3/yMYcvnIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgi Djakov <djakov@kernel.org>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/169] interconnect: debugfs: initialize src_node and dst_node to empty strings
Date: Wed, 28 Jan 2026 16:22:25 +0100
Message-ID: <20260128145336.243200807@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Georgi Djakov <djakov@kernel.org>

[ Upstream commit 8cc27f5c6dd17dd090f3a696683f04336c162ff5 ]

The debugfs_create_str() API assumes that the string pointer is either NULL
or points to valid kmalloc() memory. Leaving the pointer uninitialized can
cause problems.

Initialize src_node and dst_node to empty strings before creating the
debugfs entries to guarantee that reads and writes are safe.

Fixes: 770c69f037c1 ("interconnect: Add debugfs test client")
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Tested-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Link: https://lore.kernel.org/r/20260109122523.125843-1-djakov@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/debugfs-client.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/interconnect/debugfs-client.c b/drivers/interconnect/debugfs-client.c
index 778deeb4a7e8a..24d7b5a577945 100644
--- a/drivers/interconnect/debugfs-client.c
+++ b/drivers/interconnect/debugfs-client.c
@@ -150,6 +150,11 @@ int icc_debugfs_client_init(struct dentry *icc_dir)
 		return ret;
 	}
 
+	src_node = devm_kstrdup(&pdev->dev, "", GFP_KERNEL);
+	dst_node = devm_kstrdup(&pdev->dev, "", GFP_KERNEL);
+	if (!src_node || !dst_node)
+		return -ENOMEM;
+
 	client_dir = debugfs_create_dir("test_client", icc_dir);
 
 	debugfs_create_str("src_node", 0600, client_dir, &src_node);
-- 
2.51.0



