Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5685836606E;
	Tue, 17 Mar 2026 17:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768248; cv=none; b=PCTO3rJzYjTCKwAkTLHvZ7H03TeRUrJl9XqENfFpyvq1SgweN4WFH+y0o89eJxBU5dDOKD66iTsau0FPo8dkmrMkScR8d3Q8jSYIVYQGYbFvWGG+yl9hBBf31U1FpIjA0GStRheHy84KbPoT1Yb3PchDxXaUYsUZO0xWOMFppeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768248; c=relaxed/simple;
	bh=/z1LfT1IxTk+gOiE6Lj6wS+2+D6G6EgIO2oq8AMXE2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWp6cMXjum4nY4GLlGW8/m0bEdFI7cbWt2wY6T9wCNVAxukNyHOG39wz8mSm+Q2/x3UvhUeMQuZHEEG8wbf1w+/Cavk1hNpL9gYz1rUNprCSrtVB5GjjrVQSOJ0xbQ4p6UzJIyWGjpmo5Ae2YbGPCCBspREVNaS/7Ju2jn/7b/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxkw2sjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxkw2sjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B686C2BC86;
	Tue, 17 Mar 2026 17:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768248;
	bh=/z1LfT1IxTk+gOiE6Lj6wS+2+D6G6EgIO2oq8AMXE2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxkw2sjJsL1VTkhwpaSy/PWq5Z49FSb421A3uupi38HYNDaQZLY4DpS5l+JvTJG8z
	 DZ17PovPrSMWvjIo3UYkApG+GuNIDFEYYGCUXU57urAizfff3tLizU0d8XQp5+QB8d
	 VaOwJFyCbIELyD9Jr1GCPM4CG7GAq1WmT/U7493E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 267/333] xfs: fix integer overflow in bmap intent sort comparator
Date: Tue, 17 Mar 2026 17:34:56 +0100
Message-ID: <20260317163009.270137181@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Long Li <leo.lilong@huawei.com>

commit 362c490980867930a098b99f421268fbd7ca05fd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -247,7 +247,7 @@ xfs_bmap_update_diff_items(
 	struct xfs_bmap_intent		*ba = bi_entry(a);
 	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
+	return cmp_int(ba->bi_owner->i_ino, bb->bi_owner->i_ino);
 }
 
 /* Log bmap updates in the intent item. */


