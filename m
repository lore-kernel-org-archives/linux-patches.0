Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC923A0B3D;
	Mon, 23 Mar 2026 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275188; cv=none; b=cM7k2WGSXeIJNsxwDhVOdKUXXHOumB3oDlMYvC01IIvGe+fQYJLxD0PMTupU4YNpLTkoikkJvvB723FtB4o0nwvkNBXiR7pt5H6z2mfcFvzlt+TA9qGrY4OOWP7oZc7a3fvGtp27WfVVSuuEJkZMIlwK5dbgkyf439gtGKDeuFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275188; c=relaxed/simple;
	bh=Ww0LOer8bHsHicDG6DfPgCjAVOM7Mz8u0RgdwEWm4A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MXmFFwF3pEVk1YrIOQ31RyZ1+Xu6ZRnWFxp7on57Ohn7vrxbSJKiJy2apscBLaitYNAPBPnwRiEtLP8PPpcpZAnep0yV79D7lrLhJB5U8cAfzCdA2Zdj1Saq5slycUmyrBSpZc3u7C55trcozh99dA8XIar3sojLDWOMOHFhHGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVG99h0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVG99h0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF99C4CEF7;
	Mon, 23 Mar 2026 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275188;
	bh=Ww0LOer8bHsHicDG6DfPgCjAVOM7Mz8u0RgdwEWm4A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVG99h0Y3HBrRwzysr96eVTAOdWgP6dtdgU1QLQvfbXKf0/iItZcJdpF1nSWR4CYI
	 U3Qj/DVmWW+D3TAzCbR0JCCqXuROhi8MFsZEGo1oY6wZmYFfqin3FOs4ak0qoE5Bx8
	 ob4HJ0ZTbsytIvzmCUk+WWD+NfenIKgjKapDpfNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@fb.com>,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/481] btrfs: fix incorrect key offset in error message in check_dev_extent_item()
Date: Mon, 23 Mar 2026 14:39:56 +0100
Message-ID: <20260323134525.596532378@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 511dc8912ae3e929c1a182f5e6b2326516fd42a0 ]

Fix the error message in check_dev_extent_item(), when an overlapping
stripe is encountered. For dev extents, objectid is the disk number and
offset the physical address, so prev_key->objectid should actually be
prev_key->offset.

(I can't take any credit for this one - this was discovered by Chris and
his friend Claude.)

Reported-by: Chris Mason <clm@fb.com>
Fixes: 008e2512dc56 ("btrfs: tree-checker: add dev extent item checks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 6108cfab1ba59..d1b6bb8f08dd1 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1697,7 +1697,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
 		if (unlikely(prev_key->offset + prev_len > key->offset)) {
 			generic_err(leaf, slot,
 		"dev extent overlap, prev offset %llu len %llu current offset %llu",
-				    prev_key->objectid, prev_len, key->offset);
+				    prev_key->offset, prev_len, key->offset);
 			return -EUCLEAN;
 		}
 	}
-- 
2.51.0



