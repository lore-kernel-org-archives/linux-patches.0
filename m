Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BDA3168EE;
	Mon, 13 Apr 2026 16:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099099; cv=none; b=D9DKKts4SwKPzXLn3sai81H+ELKITLGPjV56GsKGJSiOFGDr36KmtrQJ+qxOH70WYsWXX9eNINx5qhSQvjKL8HMrm8y3nr9FCKURD1MmGwfSCHdZav/LuAMISuS/Qh22pYi9H5HoWLjU0S+guh2Lzpz51GhDJsIlqCO/RMI47uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099099; c=relaxed/simple;
	bh=4gMYLysjEiXu/RjfpHsLIvpZahnC/W96qDSNk0kBboE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSGQxx9Iru2GaQEhx1tkxlL6ZNDX9OACD567WNK74CyPSb0hCFVG80RJT50cXORzhzPr/YEfBquR56BQHAV1t7TC2GoyVl8vk/OrDS8rSBa8fr+ZemnspyV4/QlbFPGZMbSSV4/dQNGGGhhO+3jPtiJDt1Omuq314qkhXVZ1/tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVG1+gai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVG1+gai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87539C2BCAF;
	Mon, 13 Apr 2026 16:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099098;
	bh=4gMYLysjEiXu/RjfpHsLIvpZahnC/W96qDSNk0kBboE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVG1+gai06OmZvJ0r1U+ZoF4potYLg9qJKXQQMFeMaMRBA41K58Bkxw4M2dKulVgF
	 IkgLWHogH6aL1GgYunWaadULdeVJEvRrIj2GQmRpbv17X4OX6Kk4aHRO052pD3eJw0
	 K9PpqvtR9Fs2tP9kG5PuumJJd2vRMghCCwdXcOCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/491] xfs: fix integer overflow in bmap intent sort comparator
Date: Mon, 13 Apr 2026 17:57:03 +0200
Message-ID: <20260413155825.717679418@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 362c490980867930a098b99f421268fbd7ca05fd ]

xfs_bmap_update_diff_items() sorts bmap intents by inode number using
a subtraction of two xfs_ino_t (uint64_t) values, with the result
truncated to int. This is incorrect when two inode numbers differ by
more than INT_MAX (2^31 - 1), which is entirely possible on large XFS
filesystems.

Fix this by replacing the subtraction with cmp_int().

Cc: <stable@vger.kernel.org> # v4.9
Fixes: 9f3afb57d5f1 ("xfs: implement deferred bmbt map/unmap operations")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ replaced `bi_entry()` macro with `container_of()` and inlined `cmp_int()` as a manual three-way comparison expression ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_item.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -273,7 +273,8 @@ xfs_bmap_update_diff_items(
 
 	ba = container_of(a, struct xfs_bmap_intent, bi_list);
 	bb = container_of(b, struct xfs_bmap_intent, bi_list);
-	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
+	return (ba->bi_owner->i_ino > bb->bi_owner->i_ino) -
+		(ba->bi_owner->i_ino < bb->bi_owner->i_ino);
 }
 
 /* Set the map extent flags for this mapping. */


