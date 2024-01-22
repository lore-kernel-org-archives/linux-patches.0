Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBC45D909;
	Tue, 23 Jan 2024 00:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969769; cv=none; b=P6tazG20wo/9PH2OqLeIYfF/98u2Rx3OE+Ekh7TMBkaJ11UpYJbdFl5CWi2zF5Lr9go4MBg0QE6BwQX4ay8QxPx0NY6bqZqXT+1E3UNkTyPKbFQQJOhpKsLXdJ6wosvWkebafqPaIWhKzT9idWwmoO4iOUOO9FjjWnxxa6GQWKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969769; c=relaxed/simple;
	bh=WspuN2o7u2MWDw6XT44LGybx7IZO3a+lbnMZ3lul2ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gc7S6zo1DsSpzMVPqzxOdci/QT9n2JXFINtuWv6NyCMNl+vCqsszoV0lzorx1NeXE3/qUIplmr0qHI0SNxlbstERrdiRFoPPXfuhLCiut9FDs/FoK3ocefIpxIaRaF3AodR7aiKHwaNPveymXjQZAOndQNI1iGjNgqiJQj7TsKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7OhZGgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7OhZGgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA6DC433F1;
	Tue, 23 Jan 2024 00:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969768;
	bh=WspuN2o7u2MWDw6XT44LGybx7IZO3a+lbnMZ3lul2ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7OhZGgpONwYbQ2laVPpOoQkNYNJSLxpe3SNOtXsJziDoy+HS2+JpZTwPhwTAawwz
	 dMP+b10E7MBZ5RjAXZMs8FiIzNscVlXH2cn/rRDXbuLDNo77clymFjTA/3qwqjrBXA
	 VnIrgNpJgD11wDw2NNZnignMLWzCH6R7JLmPexh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.7 438/641] md: bypass block throttle for superblock update
Date: Mon, 22 Jan 2024 15:55:42 -0800
Message-ID: <20240122235831.717823754@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

commit d6e035aad6c09991da1c667fb83419329a3baed8 upstream.

commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
introduced a hung bug and will be reverted in next patch, since the issue
that commit is fixing is due to md superblock write is throttled by wbt,
to fix it, we can have superblock write bypass block layer throttle.

Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
Cc: stable@vger.kernel.org # v5.19+
Suggested-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20231108182216.73611-1-junxiao.bi@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1037,9 +1037,10 @@ void md_super_write(struct mddev *mddev,
 		return;
 
 	bio = bio_alloc_bioset(rdev->meta_bdev ? rdev->meta_bdev : rdev->bdev,
-			       1,
-			       REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH | REQ_FUA,
-			       GFP_NOIO, &mddev->sync_set);
+			      1,
+			      REQ_OP_WRITE | REQ_SYNC | REQ_IDLE | REQ_META
+				  | REQ_PREFLUSH | REQ_FUA,
+			      GFP_NOIO, &mddev->sync_set);
 
 	atomic_inc(&rdev->nr_pending);
 


