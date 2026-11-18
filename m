Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046100;
	b=MBlFEbgMRCvet3B6HqNuKANUlYehG3KG2fTEgOXuyg+t+RsgtZmSV1ZM/BjebMMmn0+p
	 2tf678KroILDuX7/Dt72ZFoVTWrOa0rOFlfiuUVfJzPJj9lTschu0XoeuHlGAO6Qp7/H+
	 vrX2kE2LlyAuY/82fyT+OeaI7SAEznX+Xmt/4S/DMiawWnGdA0X7ke873bS9+YCjUoeQH
	 TXZIi9v3fGyare03dmdOfkYZoQ+RadcBZuBoRcTyY0R7ll895LHFiS6v/Li4PV/2DMM4j
	 y+aB+jEF7O2LnpCcSNAWe2qGtCjhnRJtaKOE4DiEZi7PGvcEAphUuMMnxm8zc3Zog1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GYOJl/tx74DgTqzbdNjFV1l2YiF1k9YO/DKTIR8CbLE=;
	b=vK45u1UiF8niIubY1tK14plEiekP8WZKrcFmAPtzHPp4TMT06gXTRKk7ZvEI/06+bk2/
	 87gH+hOoLg2E2wU/EDD3wU+tm7i/Zj6nqss/ekh6hG/2Z3TzIotBFTGV8kd3UhEMsO3p/
	 /mx8NykbJ6KAbURTU0wpFOVC2vo/R5mugCDdiYnl5KrT2d83dq2txNUaBJ5uKTo38ShXb
	 lRvVK966APwMlzAhDLrSVbl6JlbQAxJ7L4+9w9lnAQIsXkeVw0VWIZkGsSchLqYRia4VG
	 9uSJcrSo32PwYzgmch+YMCwI5dR8V9GdXcJCgd2OiRba2Suu1+ye1smQ0LAxvgys/Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aj2xsiIN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D69606A325;
	Wed, 18 Nov 2026 23:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aj2xsiIN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864C31F000C4;
	Wed, 18 Nov 2026 23:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046100;
	bh=GYOJl/tx74DgTqzbdNjFV1l2YiF1k9YO/DKTIR8CbLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aj2xsiIN0KX5zR22RWZ89ufTsT43OxglrKWJcN+vrEZek8VvhEUxN5+AOgyg31rUb
	 v3fZRux1ExEJlt4w/9IT/r/MEqt3Uy18wQcTYPq9uO7sdRavsk2VQWNiuSJUrzYG6D
	 tMitUYzgYMqmBHGz+VX39Tj4mNa5Ef+K9xaWcCrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1158/2857] xfs: bound da-node entry count against the correct geometry
Date: Wed, 18 Nov 2026 15:36:32 +0100
Message-ID: <20261118150243.281595847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit 3df5e5aaa3bc0913236c48ab29b7df3a785aa29f ]

xfs_da3_node_verify() bounds the node entry count against the larger of
the directory and attribute geometries because, as a buffer verifier, it
cannot tell whether the block belongs to the directory or the attribute
tree. When the directory block size exceeds the fs block size (e.g.
mkfs.xfs -n size=64k -b size=4k), an attribute node buffer is a single fs
block that holds only m_attr_geo->node_ents entries, yet a crafted attr
node may claim a count up to m_dir_geo->node_ents and still pass the
verifier.

xfs_da3_node_lookup_int() then indexes btree[] up to that count during
its binary search -- an out-of-bounds read via getxattr/listxattr on a
mounted crafted image.

The buffer verifier is the wrong place to tighten this: it has no fork
context, and the transaction-less read path used by getxattr does not run
xfs_da3_node_set_type() either. xfs_da3_node_lookup_int(), on the other
hand, always runs on that path and holds args->geo, the geometry of the
fork actually being searched. Bound the entry count against
args->geo->node_ents there, before walking the entries.

Fixes: 7ab610f9e0f1 ("xfs: move node entry counts to xfs_da_geometry")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Omitted the xfs_da_mark_sick() call because the helper is unavailable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_da_btree.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 3ec681fdc075b..510e1e8e26230 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1670,6 +1670,19 @@ xfs_da3_node_lookup_int(
 		} else
 			expected_level--;
 
+		/*
+		 * The node verifier cannot tell whether this block belongs to
+		 * the directory or the attribute tree, so it only bounds the
+		 * entry count against the larger of the two geometries.  Here
+		 * args->geo is the geometry of the fork we are actually
+		 * searching, so reject a count that would walk btree[] off the
+		 * end of this node buffer.
+		 */
+		if (nodehdr.count > args->geo->node_ents) {
+			xfs_buf_mark_corrupt(blk->bp);
+			return -EFSCORRUPTED;
+		}
+
 		max = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[max - 1].hashval);
 
-- 
2.53.0



