Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0364A37A498;
	Sat, 12 Sep 2026 11:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212574; cv=none; b=AXFgvJGjDVBUZNY3Uz9vj870PJbqlktsXAIsQiHrvD+EqjHHKexhwQf0aTpHggQftbTdGlToT6XMS9GIVzbtpMUo2IJ+mJW3gjOZ1EzdexlwP6fj4og20QEIDWBXFmTNXu66XJyuCUKgg3Z01vDKnJEPWqwRVOm0HOfvZ8akj2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212574; c=relaxed/simple;
	bh=Kmk64qEuvKOi8rGP9bVthYePw80SVaeY/7tLQ8s+7f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqI7G/zhr9TzQt8cbMf44AaIxbK0bNTyYAS4bEAy+gvHUvCDI2aXA7Rk5D8BjI77lpad1xCtt8ELyLAwpQDo4xkaucKCjX8JQQXK6LtUikbEELum+N7c0kNieGBxiLQcqxTo6eTZJgM4h9w9FYstk6ZYatbxlYgU16whJLkfCuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJCQ7lxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJCQ7lxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69891F000FF;
	Sat, 12 Sep 2026 11:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212572;
	bh=uJs57QnLRsvyLh6h3voxIAFc2dO7xm69BXK8Ja79OPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJCQ7lxByRIJQbezetMrBUfrfPqTaDwQi1MNPFEMRixGZATXc9VWA5+dLiu0HRT2z
	 cqSyfl7XuaayecaPxVyEQELmmYMd0XU7YF3P/MBf+Ab8P+YvoX2BmgTGJnlAFPixgm
	 HeGH13hSUW092XrlTV0TICbcx2Qe+SDhVZdJ1Kb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 1462/1518] dm-integrity: fix buffer overflow with keyed discard
Date: Sat, 12 Sep 2026 09:00:31 +0200
Message-ID: <20260912065656.627959497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Ben Cressey <ben@cressey.dev>

commit 59e6f919d77d72ec79cbf171256f2f7819737580 upstream.

Since commit 68c5c42567bc ("dm-integrity: replace forgeable discard
filler with a keyed sector marker"), integrity_metadata computes a
checksum for every discarded block into the "checksums" buffer.
integrity_sector_checksum always writes the whole digest. So if the tag
size is smaller than the digest size, the checksum of the last block
that fits into the buffer is written past the end of it. For example,
with hmac(sha256) and tag size 16, a 4MiB discard writes 16 bytes past
the kmalloc'ed page.

Fix this by subtracting extra_space from the buffer size when computing
max_blocks, like we do for writes.

Fixes: 68c5c42567bc ("dm-integrity: replace forgeable discard filler with a keyed sector marker")
Reviewed-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: Claude:unspecified
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1979,7 +1979,7 @@ static void integrity_metadata(struct wo
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
 			unsigned int bi_size = dio->bio_details.bi_iter.bi_size;
 			unsigned int max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
-			unsigned int max_blocks = max_size / ic->tag_size;
+			unsigned int max_blocks = (max_size - extra_space) / ic->tag_size;
 			sector_t sector = dio->range.logical_sector;
 
 			if (!ic->discard_keyed)


