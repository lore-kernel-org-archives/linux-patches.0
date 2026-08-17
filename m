Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3863033E7;
	Mon, 17 Aug 2026 14:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975402; cv=none; b=qk+2z3n0vT++/EEj+9bNr8Qq+rJOQGzogVYrW+AW7DcTWMventG+LgIeDXHdHpYXeGExTA6c1O1cdrv2tvoPKV1bTvHZZ9RsUvAsf/IHdjZ7JmWxErGTTylnC9r+WXU0VkVg61BdooQGtzzUuTItv9uLK/QEI5FN5TqE2np9Z2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975402; c=relaxed/simple;
	bh=B9MPRIHWDaX58zeMIiamxASzvmovRhlsASDJRN3ewQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MltjdBOsr4KLuCrkKe3dQ2h6ZIONaLKZQLD91ZtZhVSRCUehckbK1jGuhiu686lcVdZkPLX+qNxS3tEFvOi/skFXyhqMyGVLZprerh0/U00zwzdYKYpM6IpFrHJVnzq9itEZA1qjIsDU8XjU/gfKFLWiQeNutDvrKj6EYkJJu0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlbkQp7D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlbkQp7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D369F1F000E9;
	Mon, 17 Aug 2026 14:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975401;
	bh=8rp45pWkwLeoS2knozuCe+IyXILOiUTumV2UcFFtlbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QlbkQp7DuYARpsXgBsyiUoyFhNl3qp75VZ8Zozyf5J7pyoUoaNOIHkc/S36zdNj5T
	 hmvHZYbuLuQjfPJJfAShZXOR+lJlLHsTuaTipsVYSKGp0M+n9Gs1SubUkBKhJ+IAxy
	 4+oxwxYhQferXdlSvnSIPdkT9hBewRg6UEOsRXZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/389] RDMA/hns: Fix potential integer overflow in mhop hem cleanup
Date: Mon, 17 Aug 2026 15:27:35 +0200
Message-ID: <20260817132539.492890482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit 9f0f2d2121f16d420199a82ac5bbc242269133b3 ]

In hns_roce_cleanup_mhop_hem_table(), the expression:

    obj = i * buf_chunk_size / table->obj_size;

is evaluated using 32-bit unsigned arithmetic because
'buf_chunk_size' is u32 and the usual arithmetic conversions convert
'i' to unsigned int. The result is assigned to a u64 variable, but the
multiplication may overflow before the assignment.

For sufficiently large HEM tables, this produces an incorrect object
index passed to hns_roce_table_mhop_put().

Cast 'i' to u64 before the multiplication so that the intermediate
calculation is performed with 64-bit arithmetic.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a25d13cbe816 ("RDMA/hns: Add the interfaces to support multi hop addressing for the contexts in hip08")
Link: https://patch.msgid.link/r/20260627095951.51378-1-listdansp@mail.ru
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Reviewed-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 570a1bc24fd5a7..f36ea9141c7a1a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -896,7 +896,7 @@ static void hns_roce_cleanup_mhop_hem_table(struct hns_roce_dev *hr_dev,
 					mhop.bt_chunk_size;
 
 	for (i = 0; i < table->num_hem; ++i) {
-		obj = i * buf_chunk_size / table->obj_size;
+		obj = (u64)i * buf_chunk_size / table->obj_size;
 		if (table->hem[i])
 			hns_roce_table_mhop_put(hr_dev, table, obj, 0);
 	}
-- 
2.53.0



