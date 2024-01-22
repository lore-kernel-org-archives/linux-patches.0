Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3223F73199;
	Tue, 23 Jan 2024 02:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975442; cv=none; b=g3+uCMr+/0a16l3bSRTo/BBTvmcGSAqkm8oA98JEry21oIruFFLyJyuR4nzIjuzCTXFZR3VYujfuMktBr04tzi1MLLtR5z+NJtnDyBiW1xec9jB7qOMFZdPCdZ1CJbTyoiu39QkrI/kXDtGidgB+Z2d3gQKDg9kK/TpCso4udlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975442; c=relaxed/simple;
	bh=zx0YYqVmYPwww3Yq6xTar/tZsvecaeU4yBLVHvY7kok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhOwKgro7ICPd6OhiXdqLGh19VF+uo7NQbZNSdPJdC+Wf0iWbxxmHcETPZAlFZFiPcTu46XpzYjrJFGCAl8jseHv0zsUwOk7OEwd27i9L46naRKC4qfW8ZdY3zVXv3P98NTn7EDWvVsN90BfekuZY1th7TiEy00fhbpOSlMhYhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F05jMsO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F05jMsO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881D3C43390;
	Tue, 23 Jan 2024 02:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975442;
	bh=zx0YYqVmYPwww3Yq6xTar/tZsvecaeU4yBLVHvY7kok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F05jMsO4gZlB+2PT/raE+za6c0XETyqngoo+cLVkE00q2v81LubisNpK+beTIm1hY
	 tevWPMlzrhVL206wq7H3kPju/5N7Vgp+F8DKCEhYhc/aiaJQpSGRozGS25GyXggaHQ
	 PKhD07Nh/id6iHPb3AZqdcbp5qwGTNYG2L4BdcB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.6 399/583] md: bypass block throttle for superblock update
Date: Mon, 22 Jan 2024 15:57:30 -0800
Message-ID: <20240122235824.195211768@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -940,9 +940,10 @@ void md_super_write(struct mddev *mddev,
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
 


