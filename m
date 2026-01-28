Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764162FF178;
	Wed, 28 Jan 2026 15:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615688; cv=none; b=jhZrj4RGVRrdKAX1Ty/fairyKLB5cfuBxzQoOfz77smExF2SuAUBySQ5k1BmXMe3+dxZFesXeOdti6AzrDahSZjdz8RnF4MeMNByTNXs1QLuMi21kswazRzQvZl3r1ILo19LTqcGgCcI+Cw/OZDDOJ9HV9ne73YuZuvIr/Tv3YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615688; c=relaxed/simple;
	bh=aw+HhDiCqGjLvIY5qRLFf2Vjnsmbv6dOanUb8dQV/sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgbJqpS4gE8OJPXZkfZBn3xur1VOlvVRL+Q57gI6TVvaNiQQ/cAvA3n5xCKI+YoXa8/fEh6sBKo0ahH2TNYyRiR6WSI7aW/Ze1KXOWxn2cJgHjIZdEnoeXdrD/+DdoFw8UOr5fMR1dp+aX4BJuUIX1m16SLfJH+TWgHJIimQhms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ClTfCNrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ClTfCNrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5AFC4CEF1;
	Wed, 28 Jan 2026 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615688;
	bh=aw+HhDiCqGjLvIY5qRLFf2Vjnsmbv6dOanUb8dQV/sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClTfCNrwpYQrxgQ9SHPotcWMX1CHko0hl1COfhh8YtozCfb7FFMDsPR2N9LYYS/S6
	 lcUqi8oqn2doqORHP9ztjr5KmXGHwfCZBz3T4Ey1fAbfd+CzEuHUfulmc0QGebuDBy
	 ml70/qDFTXXSVb6zX5zGk4VQqSUvV5HrZ0oTpNhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgi Djakov <djakov@kernel.org>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/227] interconnect: debugfs: initialize src_node and dst_node to empty strings
Date: Wed, 28 Jan 2026 16:22:09 +0100
Message-ID: <20260128145347.363032844@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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



