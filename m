Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E593C78C9C;
	Sat, 12 Sep 2026 12:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217396; cv=none; b=eaKy8spRNadyZI2a9eNY6Qwthhj1mmqhiYLZ3qtZ5xCE/F9vw0zxzOluK2jVXDjLCJfph3a0QvLX66L8I6TE+Oilt7JMj8zUbWon7C5ZgygDWbNasGNqPCCJk3sJM2YUmmLVEwSfPBE1k97aM+bACjFbST9CBvhe31/aMVhF5bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217396; c=relaxed/simple;
	bh=l1UyFJOrLEm83ZMdaJgxz+lve9l6p3hSHvf7241vTUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fM4ZDclptY9w4m5T5e/pOuQHFb1eaYNlO8wx95d9tyjlHgiPQ0G8MYez6HZSQu972V+bzWRgYD5TCNVX/nyEHLkNL9hYqosOj3u4bYVdZ9qOjlem5m4NRna2hcgO/XcgIlwsxhkDgREeDzi48r5iHenxJlK7QUlLcI9M4o3wT30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WDlnkDt9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDlnkDt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0C61F000FF;
	Sat, 12 Sep 2026 12:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217394;
	bh=LRiL9IGEnytWDCVlqdugUZ2EhP22O/0adr2uqB0KMak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDlnkDt9XfxOJceJUPBkkbtpPv2eeLDK6IXeUzmODVq1PSsLBBERLlMo9zy34XDWk
	 KrJHcI4HZ7lqY3PVABFN5PsOEICAcpY01o7/uPSPu5jvlk4EpRuqbXLbY/G8d4rMW/
	 I3yey8BcpeiOCSt/d9JASqX2fnDki/RxjU8Q9L38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0880/1376] o2hb_region_dev_store(): avoid goto around fdget()/fdput()
Date: Sat, 12 Sep 2026 08:55:06 +0200
Message-ID: <20260912065627.176512847@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 554ceb7a5e14435725ac59a42bf0708f95721405 ]

Preparation for CLASS(fd) conversion.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 688bc88e2046 ("ocfs2/cluster: keep heartbeat local node stable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/cluster/heartbeat.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 6914d615ec2dd..5743dff6af4ea 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1778,23 +1778,23 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	int live_threshold;
 
 	if (reg->hr_bdev_file)
-		goto out;
+		return -EINVAL;
 
 	/* We can't heartbeat without having had our node number
 	 * configured yet. */
 	if (o2nm_this_node() == O2NM_MAX_NODES)
-		goto out;
+		return -EINVAL;
 
 	fd = simple_strtol(p, &p, 0);
 	if (!p || (*p && (*p != '\n')))
-		goto out;
+		return -EINVAL;
 
 	if (fd < 0 || fd >= INT_MAX)
-		goto out;
+		return -EINVAL;
 
 	f = fdget(fd);
 	if (fd_file(f) == NULL)
-		goto out;
+		return -EINVAL;
 
 	if (reg->hr_blocks == 0 || reg->hr_start_block == 0 ||
 	    reg->hr_block_bytes == 0)
@@ -1916,7 +1916,6 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	}
 out2:
 	fdput(f);
-out:
 	return ret;
 }
 
-- 
2.53.0



