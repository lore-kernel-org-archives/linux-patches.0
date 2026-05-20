Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470EF3EF0D7;
	Wed, 20 May 2026 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297229; cv=none; b=Uf3uvLhZsIfqRIV1A8g7ZlKgcW1ZN0GYbxNIOpCmTvwE5IU6Ah63t15b3Zaz6xhvoUVBnnODwF5+eOuIlXXKDgTogDdHrXA9yfRGqT+jGXmBztco6WA8RzwbNXBqU8yjzpmIIF/6T6T/cZX6Ob+PmqRNc9f7LfVmAMcOGZrnaNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297229; c=relaxed/simple;
	bh=ZufGhK4s+kfTNjdx6FzUPujytNQY7cuWYisG2GACvW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aViugArZzkT+K5W+SBfHPpQSL2Bau+tCBYGROwJhjJHbM1uwUSTC7rZ8pQTQXgtpfM11EY6ZWy4YFeXp9AWwmRJVtgYLVDyQktju+sXaeI5F2JevyiL112R116Cc6J2aAumbqugsfuEvTdQNiGcXR/1ChZSj5r2jvUnxLwml37A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q3FVp4l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q3FVp4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A771F000E9;
	Wed, 20 May 2026 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297228;
	bh=rZZ0ku0+JX48NY5MSp0YOvJIDiYvFxpYwsCM+VqyV/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1q3FVp4lKE4AMSuT8jw7HDbvkD4wDKgJuOdWJfItKJvstBuTK9Bxvn/hJlRkgDhrG
	 cpLG3YpjrDbM5G6sfSrP43s+8eiBy35xIDFHGbuQsU4ROrb42pdXXAqFY9m7eADr/D
	 /XMzUJpn1aP/09qzF0oxa89y42vE3K6aWrbU/Op4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.0 1100/1146] xfs: fix memory leak on error in xfs_alloc_zone_info()
Date: Wed, 20 May 2026 18:22:30 +0200
Message-ID: <20260520162213.137431815@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

commit 592975da8c3ca87b043077e6eafa37665eae7936 upstream.

Currently, the 0th index of the zi_used_bucket_bitmap array is not freed
on error due to the pre-decrement then evaluate semantic of the while
loop used in xfs_alloc_zone_info(). Fix it by allowing for the i == 0
case to be covered.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Cc: stable@vger.kernel.org # v6.15
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_zone_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1214,7 +1214,7 @@ xfs_alloc_zone_info(
 	return zi;
 
 out_free_bitmaps:
-	while (--i > 0)
+	while (--i >= 0)
 		kvfree(zi->zi_used_bucket_bitmap[i]);
 	kfree(zi);
 	return NULL;


