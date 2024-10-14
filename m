Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA94B1B0137;
	Mon, 14 Oct 2024 14:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917550; cv=none; b=dgjTDW+AAycR+JS/SnMb6AD+4YIUbxbrdIvNlHhlj2Ad5sqfoHJcdQNnQAmnIL9iZ7WMlbRlKgH5BWHwgCf+FEMQH8I0RM7g563AsmA4HmAgU91tStmTGvf84fyjHbQikG9+b7KjPGZC2zCbJeUHV1+66GUnjyussVUOKIw11qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917550; c=relaxed/simple;
	bh=qGKMtT3RiOSlMlSCxYrohnNEQW0mPLakqA+DLvf7XyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IETo8OTeNoBAhwOsaxjtjGUtqObjWewyvtlWxXle1R0tdTm0X/p68Rr+sRhKBWRg9l1AmI1eWGeeKbn+lb9mWY+xfnNht1zXv2WFHk2nM1PbekyOo/cu4npP7RAjpmENDW1Yeud3oCEgzj8Hjn0gUptVgdw1Ditms9QRYlcPbBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tk5K7yvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tk5K7yvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9C9C4CEC3;
	Mon, 14 Oct 2024 14:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917550;
	bh=qGKMtT3RiOSlMlSCxYrohnNEQW0mPLakqA+DLvf7XyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tk5K7yvKlgtwoi/R7m/YgprANHdw9miQM7VVQnsgmfOqQUMcybFAdO2LudikWiQ0Z
	 XtizVTRJsxlM6JiSvxBO+Fb0gmOnPCnAl8Aosr7BhrHRwH5wqrPfDPv7/VvvRQnBPf
	 VKhzXRvut7/m7wJARyPC+fZIkcbycPHDJ0qH0xDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/798] block: print symbolic error name instead of error code
Date: Mon, 14 Oct 2024 16:10:20 +0200
Message-ID: <20241014141220.534073002@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3927f4283f6b6..b71c0c2a6a73d 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -581,8 +581,8 @@ static bool blk_add_partition(struct gendisk *disk,
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



