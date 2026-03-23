Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D10F387593;
	Mon, 23 Mar 2026 14:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276970; cv=none; b=oxcLozJCtBDb2DDk5utY92fVdioUpAmbEvxFG7Oj2q/QrIkLcRTBa1/K8q7fgB3eWe0B/S2dWwKHR93Srtwnmai5DVR6kMw+lGdEhE58Rhl4ilofsdaA/Z363r4mAXFzBUiJ2qDbJ7+P9BkiUXRq51rhBDjnRB3yyyU34XuB+uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276970; c=relaxed/simple;
	bh=Ujfk0x0K3lJoef7Wx/Ry+Y2ntPOf+KZZy2Uj2695cys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYY9l5VEdibC2VY65VF8/VzBkC+mzxQ0JQwn8gy7/zZ19dvBesoo5UkdDAWCduEPdJPXusERa0ckm1TgM02qZeE9HQ67igdVhYvfCjp5voR/PlJJh6mISPnE7d3+FfE/FzwESRNdv+wB6/jhB+t4g2n5hMR3SwxaN0i8GGdew08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnP/kENF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnP/kENF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C52C4CEF7;
	Mon, 23 Mar 2026 14:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276970;
	bh=Ujfk0x0K3lJoef7Wx/Ry+Y2ntPOf+KZZy2Uj2695cys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnP/kENFGKjKpoMV7bBFlDiIL/W/7LndY+vjAv1iaL1QqLhGbmSrRrfqJQp3rpIyB
	 9jj6qqwM4TbCfGKsObHfhDe2j/beQo/syb8+piJQ3E7lnk6rL73uvDGMHMFZLQKmkv
	 Bc6i844mcS1yX4cby9uoq4P3FHR3eXx0tssdbmyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 272/460] xfs: fix integer overflow in bmap intent sort comparator
Date: Mon, 23 Mar 2026 14:44:28 +0100
Message-ID: <20260323134533.169213671@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ No cmp_int() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_item.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -237,7 +237,8 @@ xfs_bmap_update_diff_items(
 	struct xfs_bmap_intent		*ba = bi_entry(a);
 	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
+	return ((ba->bi_owner->i_ino > bb->bi_owner->i_ino) -
+		(ba->bi_owner->i_ino < bb->bi_owner->i_ino));
 }
 
 /* Log bmap updates in the intent item. */


