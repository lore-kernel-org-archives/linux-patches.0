Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8D0261B6E;
	Tue, 11 Nov 2025 01:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823411; cv=none; b=sfBJ6XaATUgnEQ088wg92xoj7RpYKxI62K5YAqPRz2KI/Phrq6FW7UJvgqY+WEMBNVBLzAFsO3qbHg7U08oSM5LhtjHizrXKZOfmxlL9Tq6QtOGHPYTodVmIsRWerIoIDRG9RRp8pli7yZAHz47wc4mshdRynBMRDm2gY+1VEd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823411; c=relaxed/simple;
	bh=dsgGlbe4oSJ7P8TMsVY9JEHMaI6rbn19a9o0tiAvX5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUOvupkG08ylqaoYwASQUiaLR9wJYSEUhoTf757Fb9e6gRiUNfS23LeOkA0fwdahCYRghE03Qep+A31RlJEwrv3JH+4M8huyxPvWnniPSWvPca8Has+IMdMGN0aHutnj1JDh+57YV0Qzg9w+HgDExclEuqApuL3/neHU5O04NEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yri/6uqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yri/6uqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730C1C19424;
	Tue, 11 Nov 2025 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823409;
	bh=dsgGlbe4oSJ7P8TMsVY9JEHMaI6rbn19a9o0tiAvX5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yri/6uqfvizszcUs6IDWYkn9sTT5K9kFzmvV7GXdVla/jPh7713lmT8ImkW2/ojnH
	 +lrOmoEKE30MrbweHc1pEu1T7nHIS7TApWuuVgkDVd6OsoqBjVAuHc9dfu2d3a7PJq
	 KzanblHkxeNDAkJerzYxfKTEVy3HcwrngDmarTpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 232/565] dm error: mark as DM_TARGET_PASSES_INTEGRITY
Date: Tue, 11 Nov 2025 09:41:28 +0900
Message-ID: <20251111004532.135437466@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 499cbe0f2fb0641cf07a1a8ac9f7317674295fea ]

Mark dm error as DM_TARGET_PASSES_INTEGRITY so that it can be stacked on
top of PI capable devices.  The claim is strictly speaking as lie as dm
error fails all I/O and doesn't pass anything on, but doing the same for
integrity I/O work just fine :)

This helps to make about two dozen xfstests test cases pass on PI capable
devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 652627aea11b6..b676fd01a0227 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -263,7 +263,8 @@ static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 static struct target_type error_target = {
 	.name = "error",
 	.version = {1, 7, 0},
-	.features = DM_TARGET_WILDCARD | DM_TARGET_ZONED_HM,
+	.features = DM_TARGET_WILDCARD | DM_TARGET_ZONED_HM |
+		DM_TARGET_PASSES_INTEGRITY,
 	.ctr  = io_err_ctr,
 	.dtr  = io_err_dtr,
 	.map  = io_err_map,
-- 
2.51.0



