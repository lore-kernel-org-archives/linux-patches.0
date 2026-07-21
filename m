Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08DC3B6BEB;
	Tue, 21 Jul 2026 21:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667637; cv=none; b=EBIpTzuWitlLn3Dr1iVl83sXuyemd477yR+1n2eD04P3MdwXx6Wf5aIIpPbx5JSaaGG1P84z8KDQqoBuGLCJDtiM36WNSZ0VcCISh8kwjbIHlMaSBV1yhRW1fi55AgWP8TrXhteJruMQAN/L4/UkhqA2SOcYLXb1hSl93TD7GrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667637; c=relaxed/simple;
	bh=vA16qSqZpZFE6yzM487lTBu688ARhDu1JlIUrg3URdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhVpN3SSYbGXxAwXRxS6YcvgRsXLJlSHJwv2GfKYtxESPlGMn1s/riAarfL53AiTvQddsWUqo1oxCPIast6O9k8tNvK3zvBfOt3/w1PpS+U17LG/tThVEZPGRmTVuzrU81VvYrj4l+wFFVPJlL3ykWvrXOtEPNut2V7qn9ACPMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X36deF4s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X36deF4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31FD1F000E9;
	Tue, 21 Jul 2026 21:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667636;
	bh=Bysw7kD0Obh+rmYbvl5HHbn0Wr0+DqVIQiZ2mccTwlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X36deF4s5IShjH4s3mOFzLp4IUeS5lgmiwWZBGI4j2wwuoHl6ILGa9y8B6v2Drd+o
	 siJVVTvmyQxBZ7qrg3vchS5mLdX37tLwsn+by4zNL/BsbSmAN238JCGYyqYFkD8pVs
	 Ga84ATf7uW7GVRhNNpUrN5j1MZM809u4GL0SqYUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 1135/1266] memstick: ms_block: reject a card that reports too many blocks
Date: Tue, 21 Jul 2026 17:26:12 +0200
Message-ID: <20260721152507.193259195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 718178f524b98bc920d74bc771aed823c8b81425 upstream.

msb_ftl_initialize() computes the zone count from the card block count
with no bound:

	msb->zone_count = msb->block_count / MS_BLOCKS_IN_ZONE;
	...
	for (i = 0; i < msb->zone_count; i++)
		msb->free_block_count[i] = MS_BLOCKS_IN_ZONE;

msb->block_count is a card value. msb_read_boot_blocks() reads
number_of_blocks from the card boot page and byte swaps it.
free_block_count is a fixed int[MS_MAX_ZONES]. MS_MAX_ZONES is 16, so the
valid indices are 0 to 15. The init loop above indexes it by zone_count.
msb_mark_block_used() and msb_mark_block_unused() index it by
pba / MS_BLOCKS_IN_ZONE, for pba up to block_count - 1. A card may report
up to 65535 blocks. A block_count above 8192 (MS_MAX_ZONES *
MS_BLOCKS_IN_ZONE) lets the pba index reach 16. That writes past
free_block_count[] and corrupts struct msb_data. A larger count runs the
init loop past the end too.

A real Memory Stick has at most 16 zones. So it has at most 8192 blocks.
msb_ftl_initialize() now rejects a card that reports more than
MS_MAX_ZONES * MS_BLOCKS_IN_ZONE blocks.

Fixes: 0ab30494bc4f ("memstick: add support for legacy memorysticks")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memstick/core/ms_block.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -1339,6 +1339,10 @@ static int msb_ftl_initialize(struct msb
 		return 0;
 
 	msb->zone_count = msb->block_count / MS_BLOCKS_IN_ZONE;
+	if (msb->block_count > MS_MAX_ZONES * MS_BLOCKS_IN_ZONE) {
+		pr_err("Too many blocks: %d\n", msb->block_count);
+		return -EINVAL;
+	}
 	msb->logical_block_count = msb->zone_count * 496 - 2;
 
 	msb->used_blocks_bitmap = bitmap_zalloc(msb->block_count, GFP_KERNEL);


