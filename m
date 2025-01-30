Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D547482;
	Thu, 30 Jan 2025 14:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247472; cv=none; b=ilJA4UkQ/6lhleF25deyTyoW19WkAyWpEo/rpNJh3sGHHUa/A4M9t+zNIx+MTBw+rydciQNFxMs+l5VFu/+Xy67qE60ARXms9sa9FNZbkExVqWyg/bHulbsr/y872OK0Fhumyp5w5Qpz/aZJaDDkxZ/m1d7JsbYd5We9+sxUXqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247472; c=relaxed/simple;
	bh=pdlNiUOS/rVm08pp4PCiKllsxhv7IZAwRF9s2hZfAGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLxln8DybYKRTzqGPYubIx/f0k50M2MtaWR9+AjsFS6VkYQDfVVsZXL56Nb9hPJ6n+rQ1tNk0x3d6489lqRVRtmbk8bIuMTqNNvM9O1Xjuv6iy6H48huP1XvEaPvB7V59waY/8GejLcXw3GT6yWlR7UbFGt9+PO5eOP4+ChLVN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCItqMMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCItqMMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0824C4CED2;
	Thu, 30 Jan 2025 14:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247472;
	bh=pdlNiUOS/rVm08pp4PCiKllsxhv7IZAwRF9s2hZfAGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCItqMMpMjTsUTPuHwkqe5uZRH9Oj9vfVkS8iI5dx9vtp94EPW0/jbe8IAHGdC6eX
	 j1SeM5FCQnVl81XlSg9PzoUF8KGahldHsHlOtMzNwuZqj3ro4BnSvktG+006YS50Nu
	 F5gqZB1IoeBYSVe0cvMm5ni/B77qT5d1hqtfdVB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 23/49] xfs: only remap the written blocks in xfs_reflink_end_cow_extent
Date: Thu, 30 Jan 2025 15:01:59 +0100
Message-ID: <20250130140134.770341691@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 55f669f34184ecb25b8353f29c7f6f1ae5b313d1 ]

xfs_reflink_end_cow_extent looks up the COW extent and the data fork
extent at offset_fsb, and then proceeds to remap the common subset
between the two.

It does however not limit the remapped extent to the passed in
[*offset_fsbm end_fsb] range and thus potentially remaps more blocks than
the one handled by the current I/O completion.  This means that with
sufficiently large data and COW extents we could be remapping COW fork
mappings that have not been written to, leading to a stale data exposure
on a powerfail event.

We use to have a xfs_trim_range to make the remap fit the I/O completion
range, but that got (apparently accidentally) removed in commit
df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents").

Note that I've only found this by code inspection, and a test case would
probably require very specific delay and error injection.

Fixes: df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_reflink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -783,6 +783,7 @@ xfs_reflink_end_cow_extent(
 		}
 	}
 	del = got;
+	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
 
 	/* Grab the corresponding mapping in the data fork. */
 	nmaps = 1;


