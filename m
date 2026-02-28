Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9045D3A2AEA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302670; cv=none; b=p3mMZuKWU6g6mRZj8BkFXflDGk6BnjCYr2v7hkBu9zBidTziWgBb0wr2TNTdTEEL3/KsZh0eiL+L7oTzFZG7DqZHgc24eCdqX+m4uxnfBbIV03xw/MetkZrj6JGCDS0qOSU/HjRWUwtcZ4PO3C1UfohaKHT+QIeibXCcc09Ect0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302670; c=relaxed/simple;
	bh=eJqEAgwneIClnQzo40eg2bbC5uuZFPdRojSvCY70EFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vD8C4PLGdoQGPEYttvJ/mu616zzqEggb1UmDBplz9UIBblboKWOsyr5xKiwj12dofhSI2Q7OSyXwIDk1MsUhTHJ7qbQiRZdqlrKGYYbc4J/0Ju4Bq7lffClbRPiO3xV/9UKDp5ez66zh7R4ZuNlsBp2uyA8iab6gpvQQEVhSdWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T2QJWPkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2QJWPkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA48AC19423;
	Sat, 28 Feb 2026 18:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302670;
	bh=eJqEAgwneIClnQzo40eg2bbC5uuZFPdRojSvCY70EFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2QJWPkXtBsaFDInT9cTP8ZPj47Z0wmV10qP4Ikvi2ChaKuNAFKi0OA+DnHeIje1t
	 SKx7YM+M6mWzcsQ+gEV10j07I4lnB45TgGQOFo143PTHbRtcQYCkl23ABF+hbs6d5B
	 vx9WU+XEmwfdw/jvpNRGvjFUMIyqmtbH5W/MdMXljoBzACCcOHxiCdBRoLk3yg+LeI
	 mTb6IB1Iur3J9fJrQ4pA96ofYYIUUtk2Quwz+RLqffw+JDt/AFkZSFTfDN+6BJ+XMT
	 7W98Hyw1t115B4c4u31AqXf6hrat4lcDpAC7Ka2+9jHrubHt0OjkD4ujCDItZqGaxE
	 pKxKxk5nTct9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/147] md/raid10: fix any_working flag handling in raid10_sync_request
Date: Sat, 28 Feb 2026 13:15:26 -0500
Message-ID: <20260228181736.1605592-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 177cfc9f45d0c..94d3e7b27d6bf 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3148,7 +3148,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				    !test_bit(In_sync, &rdev->flags))
 					continue;
 				/* This is where we read from */
-				any_working = 1;
 				sector = r10_bio->devs[j].addr;
 
 				if (is_badblock(rdev, sector, max_sync,
@@ -3163,6 +3162,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 						continue;
 					}
 				}
+				any_working = 1;
 				bio = r10_bio->devs[0].bio;
 				bio->bi_next = biolist;
 				biolist = bio;
-- 
2.51.0

