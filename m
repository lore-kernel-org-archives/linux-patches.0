Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9D94A2046;
	Mon, 31 Aug 2026 13:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183713; cv=none; b=GG7NVBHkFjvp5Lm/HSvOtle79sBP0yPi68kHmFyWvnG9TFOjTttoD81FAqpdYgJiiDS6qT/u8t9M9U6oiUVLJgpbUB0xolrR5/zY29QKtgwnA2YeY9ZcW6sg3VTXxwmTTVWNTovA5MYejIyeSbZn9TfVF28M/ygW880nkW9ljFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183713; c=relaxed/simple;
	bh=uH04i0zneTWVGjU0PWpWrCwE0y1syMQX85hqLhm5z18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEfQoDFElgKdXk3HVCoYfKqirr+nKjuVgIZNZi2OTvzWHmkMYKl8zzsXyfyyCN9H1sCwwrT4rHFr8DqwXuZ9wd8zllSzi5PJWHSRwIcmjCGyGPqknE2Z3ie/Qz68I+us7garuZB8Gq1ego8h+Hn1lk0K017bXSH6oE418p4ca+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eC8hXcgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eC8hXcgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AEA1F000E9;
	Mon, 31 Aug 2026 13:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183710;
	bh=NUJYg0hwl8rW+blc/vM8VCb+SfckIty8sRIhU5h9aPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eC8hXcgButWoo8g1xC2JKax+G0SZPPsMFG2f2MAP9qk7YG6TKIN9/e3XjGJgERxIF
	 zp3WducDbrH610sgNNieOIBFFnvnuCGb5GpR4W/O0eB2Gr7wL90NBt8dbA7IxeYJdq
	 hNO9M5TID7kFfa4V/VUTksVgVKwpvmZY5G7wI/u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 17/76] ext4: zero out whole block for clean edges in WRITE_ZEROES
Date: Mon, 31 Aug 2026 15:33:49 +0200
Message-ID: <20260831133400.092339108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit a5179156ac1d9a6646da42254e4c461e1fc20096 ]

FALLOC_FL_WRITE_ZEROES requires that all blocks in the requested range
end up as written extents with zeroed content. For unaligned edges that
were already allocated, ext4_zero_partial_blocks() zeros them directly.
However, for unaligned edges whose underlying extent is a clean
unwritten extent or a hole, the extent type remains unwritten after
partial zeroing, which does not align with the semantics of
WRITE_ZEROES.

Therefore, when ext4_zero_partial_blocks() skips partial zeroing, it
indicates that the corresponding edges are clean unwritten extents or
holes. In this case, we need to expand the aligned allocation range
outward to cover such edges, so that ext4_alloc_file_blocks() can
correctly allocate blocks for the unaligned range. Edges that were
partial-zeroed (i.e., written or dirty) are left untouched.

Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260714080044.4038124-8-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4822,6 +4822,21 @@ static long ext4_zero_range(struct file
 	/* Zero range excluding the unaligned edges */
 	align_start = round_up(offset, blocksize);
 	align_end = round_down(end, blocksize);
+
+	/*
+	 * In WRITE_ZEROES mode, edges that were not partial-zeroed (clean
+	 * unwritten or hole) must be allocated and zeroed as whole blocks.
+	 * Expand the aligned range outward to cover them.
+	 */
+	if (mode & FALLOC_FL_WRITE_ZEROES) {
+		if (!IS_ALIGNED(offset, blocksize) &&
+		    !(partial_zeroed & EXT4_PARTIAL_ZERO_START))
+			align_start = round_down(offset, blocksize);
+		if (!IS_ALIGNED(end, blocksize) &&
+		    !(partial_zeroed & EXT4_PARTIAL_ZERO_END))
+			align_end = round_up(end, blocksize);
+	}
+
 	if (align_end > align_start) {
 		if (mode & FALLOC_FL_WRITE_ZEROES)
 			flags = EXT4_GET_BLOCKS_CREATE_ZERO | EXT4_EX_NOCACHE;


