Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C1442049;
	Thu, 15 Jan 2026 16:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496020; cv=none; b=mFlWdDxdek+KnRmYbtUagMSeK2HSKR886UnZXmPEPYUVVQBk9QyVqVNO1DpEbvw378IqEDADQy35f1t7Y/013vqoaL8z3NmUGpMWtBePpNpysAn5ZGBDbE/wJQFCAkOMos4s7xuFxbN9OqKeqb60Sbk9EvaKLYpubpIjK3cxpp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496020; c=relaxed/simple;
	bh=7aCoXu/RrFu/5ZKrBQnt2dS+W/ZL74S6xVKhety+LGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2WCbKsFCBm26KRfQ/Wufsl4q375Oyre+ETb0kQJaGpGkGNBsyjNVi3HaGIyw07CIgpVVb0jfoH/gIdW5YA3XAA3/xeJUv0Cyc0Au/S773SZlQjWwajwMfbgFy2NraAlv9GSJGhsGhUBIKEnDJBiKd5GhjPXOlpMVN8GHX+WV9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9j769pr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9j769pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB6CC116D0;
	Thu, 15 Jan 2026 16:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496020;
	bh=7aCoXu/RrFu/5ZKrBQnt2dS+W/ZL74S6xVKhety+LGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9j769prGoRiPmoY+1xifINyx+6XMLW38w8b18FqWkRh5KLKlAEGOtu3kYBmuRRpP
	 0raubtAdkzLROVBZ8CD8HxkJAWDuRYzwZAxu8+NL3t2dr6o1uy1+CPzynLTtneyrE0
	 pQ/OG2tlmQsDNa7wREaKkLogTixxd8b8qVGPJNQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Guangwu Zhang <guazhang@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 050/181] dm-verity: disable recursive forward error correction
Date: Thu, 15 Jan 2026 17:46:27 +0100
Message-ID: <20260115164204.136101700@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit d9f3e47d3fae0c101d9094bc956ed24e7a0ee801 ]

There are two problems with the recursive correction:

1. It may cause denial-of-service. In fec_read_bufs, there is a loop that
has 253 iterations. For each iteration, we may call verity_hash_for_block
recursively. There is a limit of 4 nested recursions - that means that
there may be at most 253^4 (4 billion) iterations. Red Hat QE team
actually created an image that pushes dm-verity to this limit - and this
image just makes the udev-worker process get stuck in the 'D' state.

2. It doesn't work. In fec_read_bufs we store data into the variable
"fio->bufs", but fio bufs is shared between recursive invocations, if
"verity_hash_for_block" invoked correction recursively, it would
overwrite partially filled fio->bufs.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Guangwu Zhang <guazhang@redhat.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-fec.c    | 4 +---
 drivers/md/dm-verity-fec.h    | 3 ---
 drivers/md/dm-verity-target.c | 2 +-
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 72047b47a7a0a..e41bde1d3b15b 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -413,10 +413,8 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 	if (!verity_fec_is_enabled(v))
 		return -EOPNOTSUPP;
 
-	if (fio->level >= DM_VERITY_FEC_MAX_RECURSION) {
-		DMWARN_LIMIT("%s: FEC: recursion too deep", v->data_dev->name);
+	if (fio->level)
 		return -EIO;
-	}
 
 	fio->level++;
 
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 09123a6129538..ec37e607cb3f0 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -23,9 +23,6 @@
 #define DM_VERITY_FEC_BUF_MAX \
 	(1 << (PAGE_SHIFT - DM_VERITY_FEC_BUF_RS_BITS))
 
-/* maximum recursion level for verity_fec_decode */
-#define DM_VERITY_FEC_MAX_RECURSION	4
-
 #define DM_VERITY_OPT_FEC_DEV		"use_fec_from_device"
 #define DM_VERITY_OPT_FEC_BLOCKS	"fec_blocks"
 #define DM_VERITY_OPT_FEC_START		"fec_start"
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 66a00a8ccb398..c8695c079cfe0 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1690,7 +1690,7 @@ static struct target_type verity_target = {
 	.name		= "verity",
 /* Note: the LSMs depend on the singleton and immutable features */
 	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
-	.version	= {1, 12, 0},
+	.version	= {1, 13, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
-- 
2.51.0



