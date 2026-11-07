Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062928;
	b=2K9G9FVH7/My60FOg15K6jmkzc/AYQKpl3wJp4UUw0OfaquXzZG17kpJo2d+nVzn6fJO
	 Fu7poYHfYFTBXs2eM2RCyitHIQ/7Pd/CSR164hCPkKYHb5Bltuy6xV/MLDoOTTvfZgJPe
	 FBXYuxQ8HeP2GLom2w7LDcWbanK0tU8bAfSzi+nGantrEGCExzN31X+XLsJz2K3e0PCv/
	 Vk7SpmO4nEv6YYlBrBIfEJctHZEtVwGy+71CT7pLUikioDe4zWRHXLBZFGxNqfOmzN9LP
	 uRg2D/LvbTJYc84joR7xn+/uj4ap2fKPeIsysBKUf0ZfmhsKZGtT/SQYVlYiz8ULe2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1dkX4tMaNgdYaAlI5hDJy7pduZ0CFDYiT1xSiFYz/Qg=;
	b=oNRRNgF92hp0lGn3L/nccqcvAhfrTQH8lUBgrLXM6ZUJ+bPWGQYI23+tusZUxsavf7V3
	 W4pHvufWQsnK3Tv3IK5p+lvcGFln6E3cwZdfGpqGe86wbvMV5ksDn2s8O8aqCx5chh4um
	 fw0zxt09BQRfDlF0K5hEEILZDd2eUUT9/Yp9hlwZUPnqEs1uReI/133dGHp/8lDdRlwSE
	 aX+JbZqdI52vMGOnEMWxErv6TVcm9koAJU9BnGwTH503ZSfsfJupRoDwKn6XXpaBfdUAe
	 xybFKOnnWYRNcTK2QXY9kLMq6Q9cOfkhe2Pj/2AcIpgkc3393+yOz5Sz05nML7emDXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TgYFjn93;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B07A606A330;
	Sat,  7 Nov 2026 14:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TgYFjn93
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1011F0089F;
	Sat,  7 Nov 2026 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062928;
	bh=1dkX4tMaNgdYaAlI5hDJy7pduZ0CFDYiT1xSiFYz/Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TgYFjn93c6UYJKGbXyOiaH6hceVFa5AoKQRo+qHV4JjWjw95l/CLlj5tE9lp6zLVK
	 fT5vYm/CPxt6mOpiJtUz78th7b0E8817vcv6YUXoM1ucFZ0dAgOCOpMoN/AP8AuFxX
	 zlqLa1L5flfyND9dbNmByD3M7i0t3/EoDx4Jce2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 200/869] md: validate bblog_size when loading v1.x badblocks metadata
Date: Sat,  7 Nov 2026 08:48:02 -0500
Message-ID: <20261107134858.810065700@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchao Zhang <ndaugoing@gmail.com>

[ Upstream commit ae5f89b23cb88667cfa1273b42d6a551db9c651e ]

In super_1_load(), when the on-disk feature_map does not have
MD_FEATURE_BAD_BLOCKS set but sb->bblog_offset is non-zero,
rdev->badblocks.shift is initialized to 0 without validating
sb->bblog_size.  The same field is validated in the
MD_FEATURE_BAD_BLOCKS branch ("sectors > (PAGE_SIZE / 512)"), but this
branch bypasses that check.

A forged on-disk superblock (malicious storage device or crafted
image) can therefore carry an oversized sb->bblog_size.  When bad
blocks are later recorded, super_1_sync() sets bb->size from
sb->bblog_size and md_write_metadata() issues a bio larger than the
single rdev->bb_page, reading beyond the page and leaking kernel
memory contents to disk.

sb->bblog_size is never modified by the kernel between load and sync,
and the MD_FEATURE_BAD_BLOCKS branch already validates it, so checking
it in this branch is sufficient to cover both paths.

Fix this by rejecting an oversized sb->bblog_size with -EINVAL,
matching the existing check in the MD_FEATURE_BAD_BLOCKS branch.

Fixes: 2699b67223ac ("md: load/store badblock list from v1.x metadata")
Cc: stable@vger.kernel.org
Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
Link: https://patch.msgid.link/20260922044606.30774-1-ndaugoing@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 44f44219ed7fe..8d9e111939f64 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1930,8 +1930,11 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 			if (!badblocks_set(&rdev->badblocks, sector, count, 1))
 				return -EINVAL;
 		}
-	} else if (sb->bblog_offset != 0)
+	} else if (sb->bblog_offset != 0) {
+		if (le16_to_cpu(sb->bblog_size) > (PAGE_SIZE / 512))
+			return -EINVAL;
 		rdev->badblocks.shift = 0;
+	}
 
 	if ((le32_to_cpu(sb->feature_map) &
 	    (MD_FEATURE_PPL | MD_FEATURE_MULTIPLE_PPLS))) {
-- 
2.53.0



