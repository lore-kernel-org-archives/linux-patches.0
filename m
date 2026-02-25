Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C06A2701DA;
	Wed, 25 Feb 2026 01:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983782; cv=none; b=kuXL7eCP32R81Bi4gE4jIGL0liOcYqtn61oIjQbJDNVta9tqPramiqZixYLhQOWiitniJtYgaiuQYTecp+b/emEVtMA46MpqMWUQFxX69Zw13eZXKBIQz9aGwqsvkL5LyTdaadi373d5VzpJmArtDqU2Vb8+AJnQ00cy4jy5XdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983782; c=relaxed/simple;
	bh=ycJH3d5ZMZWHSOurKzZNV/pMXObtGLULX6uqbaIM6ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXv44UAUduRXWMOUi3lK7QdOydTe8E0TrXQ8r8QwCmDPermK1z1uNYT/7tIJTZPcXhaPpONp4lxw/aA/CtskfGSsuCHZsizY6lmIODMPC4rZ4KMyDb+pGtY6Ga8pAhD4mkgjEaqq33AXyexaymQ9DSVeDn2LWKVxVK+JMYYXL9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfGSupdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfGSupdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF06DC116D0;
	Wed, 25 Feb 2026 01:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983782;
	bh=ycJH3d5ZMZWHSOurKzZNV/pMXObtGLULX6uqbaIM6ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cfGSupdliXCK565NDBndpnQBEzxO8OM3aSWsGSLba01gSIUPUOgZAATaAZZIOAxXK
	 vB5/zegofwphgsp3CK/X5ZP8kmPM/YCCPfwSsUJRlie7YmBe2xpVmEJod7b/OYwatA
	 +UfYMWDBhuBsZfkSXrSv3BE9rzn1Dabpd2AaGMqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/641] md/raid10: fix any_working flag handling in raid10_sync_request
Date: Tue, 24 Feb 2026 17:16:10 -0800
Message-ID: <20260225012350.094424517@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Li Nan <linan122@huawei.com>

[ Upstream commit 99582edb3f62e8ee6c34512021368f53f9b091f2 ]

In raid10_sync_request(), 'any_working' indicates if any IO will
be submitted. When there's only one In_sync disk with badblocks,
'any_working' might be set to 1 but no IO is submitted. Fix it by
setting 'any_working' after badblock checks.

Link: https://lore.kernel.org/linux-raid/20260105110300.1442509-11-linan666@huaweicloud.com
Fixes: e875ecea266a ("md/raid10 record bad blocks as needed during recovery.")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 14dcd5142eb47..d58ae150b4502 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3402,7 +3402,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				    !test_bit(In_sync, &rdev->flags))
 					continue;
 				/* This is where we read from */
-				any_working = 1;
 				sector = r10_bio->devs[j].addr;
 
 				if (is_badblock(rdev, sector, max_sync,
@@ -3417,6 +3416,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 						continue;
 					}
 				}
+				any_working = 1;
 				bio = r10_bio->devs[0].bio;
 				bio->bi_next = biolist;
 				biolist = bio;
-- 
2.51.0



