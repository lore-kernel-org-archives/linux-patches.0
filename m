Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA783269820;
	Tue,  8 Apr 2025 11:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110666; cv=none; b=GvjcD5JzBrf1a5OMFq4gYgEhFxuw3nRYUZBvd/XdDQT4s4D3uA1EodMpkLbyYdGi+u+yQgpoje4JdUiF4yrJ+04tSCagp9Ra5Y9ptZiIMcwhZPmWp7f+w+MuGsgNTZGh9S1Nq4i0CHy7/7CubAuoQ/7kYjpoYeOyzfio1XVGfFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110666; c=relaxed/simple;
	bh=+RuMi6HcyKcbyXwIgjtb0b3x8BiBwYHrqJnzEeGZolw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unM+EpmwSDyGh5FpAk3AqE+e0tl4cWLEaNCVCvElMwDN/HVH1puBf1NOaC+6FnvdQg995/UdOhEKJMgTHQbH+JUDuLrPtWKg7zn/OufecxMaV9Z7ry/lsU8RhQ1obEdjLCicuDO48TPYgUKQL36bYwxWdl6MfNANGQz4gfz2mEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r29rd+JD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r29rd+JD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABDCC4CEEA;
	Tue,  8 Apr 2025 11:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110665;
	bh=+RuMi6HcyKcbyXwIgjtb0b3x8BiBwYHrqJnzEeGZolw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r29rd+JDx7lgWD4mQSFjowPM/O4Ilwvhsd9C05uHfnCPfmYl+k/GcUOPGziT3tzTq
	 dX5Dit1v82c4ASba/ki3goAn+ymAMPii+3KPIR+bVWWBlDvXXHRQW5DiGhoKZsTqNM
	 +oUz/XMP/i8YKAXUSopWA1cBz+powFuG7rg5Bkjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	M Nikhil <nikh1092@linux.ibm.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 148/731] block: Correctly initialize BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY
Date: Tue,  8 Apr 2025 12:40:45 +0200
Message-ID: <20250408104917.718071771@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anuj Gupta <anuj20.g@samsung.com>

[ Upstream commit 85f72925000e924291a0ebf63d2234994a4f22bd ]

Currently, BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY are not
explicitly set during integrity initialization. This can lead to
incorrect reporting of read_verify and write_generate sysfs values,
particularly when a device does not support integrity. Ensure that these
flags are correctly initialized by default.

Reported-by: M Nikhil <nikh1092@linux.ibm.com>
Link: https://lore.kernel.org/linux-block/f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com/
Fixes: 9f4aa46f2a74 ("block: invert the BLK_INTEGRITY_{GENERATE,VERIFY} flags")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250305063033.1813-3-anuj20.g@samsung.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 0b0641fa33c02..66721afeea546 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -114,6 +114,7 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
 			pr_warn("invalid PI settings.\n");
 			return -EINVAL;
 		}
+		bi->flags |= BLK_INTEGRITY_NOGENERATE | BLK_INTEGRITY_NOVERIFY;
 		return 0;
 	}
 
-- 
2.39.5



