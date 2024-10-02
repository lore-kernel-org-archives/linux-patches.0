Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5221D221B;
	Wed,  2 Oct 2024 14:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879347; cv=none; b=QzLHTXzRS8PQ29tSBRjk2cwCobRn93J1jIb/uMnP0kXMyfGRGzeUdQMF7m1/6/VQGf6Hufl5EmCSuAP2hQgRZuVtE9Ur0Rv9qzMXxwBvn3/iX0LzW5ouMbCkwshaXcrdVwVS1baE441vDrd8L83sP1+sT+zvhjWQWDTMI5DgG8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879347; c=relaxed/simple;
	bh=tvwLy9X61DmD2HKzF1u3ovnWOF+VqsqC5tVq/I+EzY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1eyJpT3eJXDeM2Wp0gWiq0ibBXa40rcVC10iK8kQnNOAWA5NFUFiqYl8j8GP5cq55Am1opVa1DqK1jlrY4H9a2dPEguVrw3THSTGfKxEABDEzYtqxSY0V5yxwBlaYzCVFM6ZAzmocRcwd9RQwycAXf1mO8SxPNoQWkMLSZFIs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YytKKfz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YytKKfz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751E1C4CEC5;
	Wed,  2 Oct 2024 14:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879346;
	bh=tvwLy9X61DmD2HKzF1u3ovnWOF+VqsqC5tVq/I+EzY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YytKKfz1/mSknKcsi9u2ohPfm6yxn3b4Zz65RfuJQcsZPYkOJbBk3B9uToUinSL2i
	 Fs5sY7usNdFSdaRI6KyQTQSuhKlf/EtRkAo4+5X6+d3zGA1JBImDGH5h84QqI6YXy+
	 RrtS/xxGg6R/zIEU85Ci+iZKMmFIATtiXyprEXJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/538] block: print symbolic error name instead of error code
Date: Wed,  2 Oct 2024 14:55:26 +0200
Message-ID: <20241002125755.658061280@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Christian Heusel <christian@heusel.eu>

[ Upstream commit 25c1772a0493463408489b1fae65cf77fe46cac1 ]

Utilize the %pe print specifier to get the symbolic error name as a
string (i.e "-ENOMEM") in the log message instead of the error code to
increase its readablility.

This change was suggested in
https://lore.kernel.org/all/92972476-0b1f-4d0a-9951-af3fc8bc6e65@suswa.mountain/

Signed-off-by: Christian Heusel <christian@heusel.eu>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20240111231521.1596838-1-christian@heusel.eu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 26e197b7f924 ("block: fix potential invalid pointer dereference in blk_add_partition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 962e4b57d64ab..6b2ef9977617a 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -575,8 +575,8 @@ static bool blk_add_partition(struct gendisk *disk,
 	part = add_partition(disk, p, from, size, state->parts[p].flags,
 			     &state->parts[p].info);
 	if (IS_ERR(part) && PTR_ERR(part) != -ENXIO) {
-		printk(KERN_ERR " %s: p%d could not be added: %ld\n",
-		       disk->disk_name, p, -PTR_ERR(part));
+		printk(KERN_ERR " %s: p%d could not be added: %pe\n",
+		       disk->disk_name, p, part);
 		return true;
 	}
 
-- 
2.43.0



