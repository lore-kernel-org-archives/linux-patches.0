Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB311E507;
	Fri, 27 Sep 2024 12:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440389; cv=none; b=HGI7srPhAoYff4YLV0R7YlGhd+RHgVKljZaz99hsdlgMm6posUpOusa4+E/U/84rqwvFoqxlD8sVYovsB+9JFpOXkg1Cl2Im53VgSIeDPiKoy/cjn6tK264KMELf/kw19wC1BshRHMlsd31sH0r+4d6614nXyKH2UvZfErmM9oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440389; c=relaxed/simple;
	bh=0Mt4KK44hctO1cAtfDFWRRWEP5ILeM+AeZ/O1kg5b8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RahdigYntmXO353DNoGGQgl6bRagUGHrzFvDhccbSmk4kKNnKEqnMo7CNCOepp34KdW+3jqIylyPTSkM9p5Qf3jEMYlBU45kmirHu57xUz3gI3eXWyoHQgatDx5uJk+RX7ACz/t8yXdEO+5JOcyPX9FMKVy78hR+s5A2MsGyifM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywkV2qb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywkV2qb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCBDC4CEC4;
	Fri, 27 Sep 2024 12:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440389;
	bh=0Mt4KK44hctO1cAtfDFWRRWEP5ILeM+AeZ/O1kg5b8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywkV2qb1MOXLaKZ6ibkPYCpl6rA7P5oe2FXXrKyWqmFAPRGPsssclMOJL6mOdOHH2
	 sKkBUZgKZazVYAGwVxNlda/YR1jjlb5XKhIPYeEiN8Zs1+yjiwaTK0khrD9BWMGI7G
	 iZ3P0h1PM4vOgms/4YuRApGK1e02fEAFUfc34a6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+090ae72d552e6bd93cfe@syzkaller.appspotmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 39/73] xfs: fix uninitialized variable access
Date: Fri, 27 Sep 2024 14:23:50 +0200
Message-ID: <20240927121721.515184530@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 60b730a40c43fbcc034970d3e77eb0f25b8cc1cf ]

If the end position of a GETFSMAP query overlaps an allocated space and
we're using the free space info to generate fsmap info, the akeys
information gets fed into the fsmap formatter with bad results.
Zero-init the space.

Reported-by: syzbot+090ae72d552e6bd93cfe@syzkaller.appspotmail.com
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_fsmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -761,6 +761,7 @@ xfs_getfsmap_datadev_bnobt(
 {
 	struct xfs_alloc_rec_incore	akeys[2];
 
+	memset(akeys, 0, sizeof(akeys));
 	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
 	return __xfs_getfsmap_datadev(tp, keys, info,
 			xfs_getfsmap_datadev_bnobt_query, &akeys[0]);


