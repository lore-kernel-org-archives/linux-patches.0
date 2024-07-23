Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A301586E7;
	Tue, 23 Jul 2024 18:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759229; cv=none; b=mzJ2ljhkcqhVACxa+Mr96uBx7KzFobtWS5WWjD/w5ocpDHsmm10cjy9yaHPsvpu0rKbvqtL043+p/C4NIiKNYqKoBUicJuHxoeoc9ri4zb3Ci8yJjUUnMz9iRtHxyYDQdm9YE+2zO2u3rw/kSv4Wlpc3CRL/2pMWGDvwn7ByrR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759229; c=relaxed/simple;
	bh=RHuRj0v0SWfL49XqYX4l4kQYTe/CC4I0mgriOx+WfVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyffUl4bIa97q8eKXxIZMOnGq5hc+oX4OX+MC4H/mDaOXJI2xb3DhvrAWwhwlh2stPNNqbW4I0zHJczji/tW1lcPQd4BOHVeh0GYavTlr1V4elkuBKzcAN5w0+Mz16jvVqHHDt42rrDx/P0/NOp3cEH6csCCTqpcSs4MCPp/xLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gM+CBIBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gM+CBIBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE31C4AF0A;
	Tue, 23 Jul 2024 18:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759228;
	bh=RHuRj0v0SWfL49XqYX4l4kQYTe/CC4I0mgriOx+WfVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gM+CBIBrytkyuNtVmolQ/G63lK+0kDrFGwJSae/2L85yGSnqpuWHcsUj5vwMWbCuS
	 I/UCrFqcV3Bbd6z9DEtdZJhj1ttFnS/23zkIJz7OoknaMED+JZXmd7VUtmss8WUWl0
	 JIvMQ45PSV9DoCUgd1X+ZsMht3NAlbVbLkAeZ5Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/105] iomap: Fix iomap_adjust_read_range for plen calculation
Date: Tue, 23 Jul 2024 20:23:22 +0200
Message-ID: <20240723180404.983169806@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

[ Upstream commit f5ceb1bbc98c69536d4673a97315e8427e67de1b ]

If the extent spans the block that contains i_size, we need to handle
both halves separately so that we properly zero data in the page cache
for blocks that are entirely outside of i_size. But this is needed only
when i_size is within the current folio under processing.
"orig_pos + length > isize" can be true for all folios if the mapped
extent length is greater than the folio size. That is making plen to
break for every folio instead of only the last folio.

So use orig_plen for checking if "orig_pos + orig_plen > isize".

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/a32e5f9a4fcfdb99077300c4020ed7ae61d6e0f9.1715067055.git.ritesh.list@gmail.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index dac1a5c110c0e..0f7dabc6c764e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -97,6 +97,7 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 	unsigned block_size = (1 << block_bits);
 	size_t poff = offset_in_folio(folio, *pos);
 	size_t plen = min_t(loff_t, folio_size(folio) - poff, length);
+	size_t orig_plen = plen;
 	unsigned first = poff >> block_bits;
 	unsigned last = (poff + plen - 1) >> block_bits;
 
@@ -133,7 +134,7 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
 	 * handle both halves separately so that we properly zero data in the
 	 * page cache for blocks that are entirely outside of i_size.
 	 */
-	if (orig_pos <= isize && orig_pos + length > isize) {
+	if (orig_pos <= isize && orig_pos + orig_plen > isize) {
 		unsigned end = offset_in_folio(folio, isize - 1) >> block_bits;
 
 		if (first <= end && last > end)
-- 
2.43.0



