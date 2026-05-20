Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F03E3F54C7;
	Wed, 20 May 2026 17:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299886; cv=none; b=Wf8nsXFbs9OAeksvAHmPvirzPIpSmAV9u1J5C5pRq3n7sON0fTLgFFgzmlFr67AFuujaktzXsizesWNnCG6EFahREGVVxMW9F2BsTW6YkEHSjWHZUF4v7uWh9wYar1ILe/k2FIYeBAbl5kf30puvg5QXMprjWMYJz71VEAT9Uak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299886; c=relaxed/simple;
	bh=+as0IiY0eyQ2CMg/RJEub8uTFzDTbFcgVnCkiSnPXHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=us74gKno2LLQvuO9A/0pq/NVk0oqoqSokgpXUmyv9BixMykcbJbDB5M8CWdjy8fHyZjwWvYFJnA45owEF8NUAskGaMzsvFCU4rHJZvfkZ7EfTFFam5g7InJ8HAdYLpZgFBotm2CF778s7aVOLxbX/6qlZDxrg4FkdfMdXk9Kffs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEX682T9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEX682T9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB051F000E9;
	Wed, 20 May 2026 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299884;
	bh=ceWILVPF3sQkcJVC2qxGg+MF/ok4fm+boNI/hmUsIqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEX682T9FDQpEd+rvb9hqNZ28ThtS/sTonDC3ZIq4fCjF+KO6LL/dTlgJnvGYzSob
	 AetgC5MDZUI2EoLx2BSI0RkyEbLW5OAEw2EVI1FO4JuYNnAd6ivIGSNRP83/5Xs2RA
	 Uyna4NXT7pW9a+2ysnmoutgNHflCN5xEDh7so4RU=
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
Subject: [PATCH 6.18 922/957] xfs: fix memory leak on error in xfs_alloc_zone_info()
Date: Wed, 20 May 2026 18:23:25 +0200
Message-ID: <20260520162154.575526229@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
@@ -1178,7 +1178,7 @@ xfs_alloc_zone_info(
 	return zi;
 
 out_free_bitmaps:
-	while (--i > 0)
+	while (--i >= 0)
 		kvfree(zi->zi_used_bucket_bitmap[i]);
 	kfree(zi);
 	return NULL;


