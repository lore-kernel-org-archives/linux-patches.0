Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C8718991E;
	Thu, 13 Feb 2025 14:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458482; cv=none; b=Rl8gucojPesbCVioS5+3dgi5wUhGnXZH5igaQpXC910hEtAINLp9n9aDfa5XZoSmv7vRLgafQfIr02NNNdqwHywWkOz06nnTCt3rv/i2fQVXWCH0z2DLE4y+R8SenuOCKxzTmLwR3+Jt/npx/Wf0mh/HJSf8VTHwoi9Kgs54vhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458482; c=relaxed/simple;
	bh=z8c+CITP+6rtbIjOHvjyy1XcLwiD7iJ42jP2HXg7x4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vsea7Sv42v8a4Au+dw2x4Ero4NoQ9s3KhfgWBmo+H3/cRvDRCAT4OYxNnN2TwqTEoi4SAIPRWk/p8oF2zx8Ir2OVZBehwZtguTR/fdbIhDaGSCVa2yFGN7mzlfbdTeGs2VkpluTSJGv9o9uHm7Xqw2Gg75HD+0PKrUZtV+UlKRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Egc14aUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Egc14aUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A6DC4CEE5;
	Thu, 13 Feb 2025 14:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458481;
	bh=z8c+CITP+6rtbIjOHvjyy1XcLwiD7iJ42jP2HXg7x4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Egc14aUmNS/STmH9Q2jw82cr6Xo2Ob/K+n8twBxR4LRqZv7zaqQp2pYYV/dOr5YFe
	 82MHfoZrgZPVBN5EvNJgcfun93Mcmzq8zSYDRxwqT7VQinYVmoHarMcEtO0sDFKiMP
	 rsWxNK+20CGdGi0EA+fZZa4wF6QDwMZVyl7IFhYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.12 413/422] md/md-linear: Fix a NULL vs IS_ERR() bug in linear_add()
Date: Thu, 13 Feb 2025 15:29:22 +0100
Message-ID: <20250213142452.501548436@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 62c552070a980363d55a6082b432ebd1cade7a6e upstream.

The linear_conf() returns error pointers, it doesn't return NULL.  Update
the error checking to match.

Fixes: 127186cfb184 ("md: reintroduce md-linear")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/add654be-759f-4b2d-93ba-a3726dae380c@stanley.mountain
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-linear.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -204,8 +204,8 @@ static int linear_add(struct mddev *mdde
 	rdev->saved_raid_disk = -1;
 
 	newconf = linear_conf(mddev, mddev->raid_disks + 1);
-	if (!newconf)
-		return -ENOMEM;
+	if (IS_ERR(newconf))
+		return PTR_ERR(newconf);
 
 	/* newconf->raid_disks already keeps a copy of * the increased
 	 * value of mddev->raid_disks, WARN_ONCE() is just used to make


