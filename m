Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B371A8F63;
	Wed,  5 Feb 2025 15:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767666; cv=none; b=bw8MdBTkjUVFaTT0lMNne9QvjKXYIxHEZ225EVYZ8ua72JJprOa42F0tCvFRdRuSuZJAOXitKZg7w2e9uodwlRzdKlBxzQpvX7unFNDSX4jzHlJsDdkktBCbWdGMByU8N4qsVfsbOMnyK40XRVijhOTsnGatVA/xvAMRgFs/WcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767666; c=relaxed/simple;
	bh=j3aOCCOhhjcgtXUZmJWa+DDKluWnIR7dDaFzE+W/0oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vuf1277zgvL1Z16ymjEIq12GN/p48GSrH2dKaDV4s/jkHadb2BZA2+ua5H0M3eguvt2YgeoFNkqpt6T1jV12+9jfw6iK55JeVBJ+6emN1Uda1Dml2wZTsQTjU7B5RMokOf50xI+7c8H5OlYuhUFN+UK8PwtOujGtDPHgmUsbWkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYCNrrx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYCNrrx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DECC4CED6;
	Wed,  5 Feb 2025 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767666;
	bh=j3aOCCOhhjcgtXUZmJWa+DDKluWnIR7dDaFzE+W/0oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYCNrrx0xRWYvLlTlM4Y/ZRKUiNUnlcCjy8Z5lwcj9S3KD1UUqFFw1Ta8avT34jtI
	 dky7MJJhjvV0RbljYVHcrH5J5qj1qKqdGG4V005K0kfPAFfmFyB4csePQ0lwQIjyAk
	 ZHTxv2OkgJj+XusB/Jucd4saEIAg9iZmHDJsAnSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+85992ace37d5b7b51635@syzkaller.appspotmail.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 436/623] iommufd/iova_bitmap: Fix shift-out-of-bounds in iova_bitmap_offset_to_index()
Date: Wed,  5 Feb 2025 14:42:58 +0100
Message-ID: <20250205134512.898181182@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

[ Upstream commit e24c1551059268b37f6f40639883eafb281b8b9c ]

Resolve a UBSAN shift-out-of-bounds issue in iova_bitmap_offset_to_index()
where shifting the constant "1" (of type int) by bitmap->mapped.pgshift
(an unsigned long value) could result in undefined behavior.

The constant "1" defaults to a 32-bit "int", and when "pgshift" exceeds
31 (e.g., pgshift = 63) the shift operation overflows, as the result
cannot be represented in a 32-bit type.

To resolve this, the constant is updated to "1UL", promoting it to an
unsigned long type to match the operand's type.

Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
Link: https://patch.msgid.link/r/20250113223820.10713-1-qasdev00@gmail.com
Reported-by: syzbot <syzbot+85992ace37d5b7b51635@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=85992ace37d5b7b51635
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/iova_bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
index ab665cf38ef4a..39a86a4a1d3af 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -130,7 +130,7 @@ struct iova_bitmap {
 static unsigned long iova_bitmap_offset_to_index(struct iova_bitmap *bitmap,
 						 unsigned long iova)
 {
-	unsigned long pgsize = 1 << bitmap->mapped.pgshift;
+	unsigned long pgsize = 1UL << bitmap->mapped.pgshift;
 
 	return iova / (BITS_PER_TYPE(*bitmap->bitmap) * pgsize);
 }
-- 
2.39.5



