Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D98D3451B3;
	Thu, 30 Jul 2026 15:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427080; cv=none; b=indZtZOec1LMJQhxxIPRP0sGolJi6xCCDC2143OjDk8jgX0i+UUltLaMlXWu2WgTpdxfa+5W9sYWG2bMseulSrwJ5Gfx+p8Vn3wfhRlyMH9juveaPNcPtSpo09zCIixdJbpE91W3qIAQBU6nSJtJszS7ckTfvJaJOypS8Z0s9EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427080; c=relaxed/simple;
	bh=2FTpO44ifXcGi3JfKMiFrhtVB5ebl7ThSqQ0tOpY6/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNAywYynAS0BrHLwl+/0f6zVUiaqZ3LHRp0DqAa3FKipXEi7lRj4mRfEdZBO4o29evEYuM1oJtUmYIBRKUnz4WtfOcxUsW9dBjKqgSSuDTViBKXdPQS7VxIZ7d6SCa9JC3ZHbJXrrNglhKCNU+8lVB/qgxf1qO2l54/uDiHER8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnfMDWKQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnfMDWKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF611F00A3E;
	Thu, 30 Jul 2026 15:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427078;
	bh=05qaOenoJoqYBalboJWU6M3RLUJc5wGjWh+100Isitk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cnfMDWKQYRDHHx7rXn7032e462xETSlT+g1LGUCUldIS9UvDj4d+4NOcMt9ZYD1/Y
	 FoQlGzN4HGaa3eQFVLRwpjzLcHprTUjO0t8iwUWHTyRSAi+iTbQYOJ0DWtQuYOPpVu
	 qufC+RZpkSJlVrVwWH+Q325vdq/tbL12Wxvxwg+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/484] RDMA/hns: Fix potential integer overflow in mhop hem cleanup
Date: Thu, 30 Jul 2026 16:09:02 +0200
Message-ID: <20260730141424.403619645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d6fcb1a4bd4fca..112248ddf02367 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -907,7 +907,7 @@ static void hns_roce_cleanup_mhop_hem_table(struct hns_roce_dev *hr_dev,
 					mhop.bt_chunk_size;
 
 	for (i = 0; i < table->num_hem; ++i) {
-		obj = i * buf_chunk_size / table->obj_size;
+		obj = (u64)i * buf_chunk_size / table->obj_size;
 		if (table->hem[i])
 			hns_roce_table_mhop_put(hr_dev, table, obj, 0);
 	}
-- 
2.53.0



