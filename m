Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D40435A9E;
	Thu, 30 Jul 2026 15:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425507; cv=none; b=DrjYcp1aXeFrzR417gcP9seaesyI9uRPnbM0YTPS1QhMCI2Dt8UhvrZiB/AH0NViuomHwGZ5QiSIt6sLq/tDb8gtGpUbMvp381qDrusB1QlUkl94ujZucusVHyBG2KnWGukEK7zac0d67gQ+LWhT970uT1pVClDoe0Nn224gVV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425507; c=relaxed/simple;
	bh=1c9x5V5ZqReLnldw95xnK1JcON/NUWo5UUFkUWMyB3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpb0wE/Ry+90Q1l5UeAy7K65aD8iSMbuZUJsQj5J39MPJyIShtmvkFb/OxVIh8ydL+s3gT3K6P2x+ouOTJC0fbSWHax6qDvoCV74hnK1Js+Yud4e/bscBdA1wWpeI8D8NQtW089S+nxkfNh0Q4ntVnZLq/l4eLe3kWAjBCCmQEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmgRWkwo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmgRWkwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F55F1F00A3A;
	Thu, 30 Jul 2026 15:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425506;
	bh=WG/GU0w2b3m2rIcu/rzN5MHljWJFluB63X+gq2ldrGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmgRWkwo9mCvZrrYi2qV8aEr10Z1adyEAbAVvm3LStQ/b6oYcwEadI6cG8frW7rsR
	 6XH95vMkVOT/09a6q378i1YqXeVMNWlJduyyYi571GvelW2hpng3QOKVU2jkD/7BQj
	 M8SHX6BKWmyY4D7IxtrUTvi8QTBk8uXOLC3N2UIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/602] RDMA/hns: Fix potential integer overflow in mhop hem cleanup
Date: Thu, 30 Jul 2026 16:07:20 +0200
Message-ID: <20260730141437.015430329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 1680d0ac071ed1..ae7a3939124f23 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -842,7 +842,7 @@ static void hns_roce_cleanup_mhop_hem_table(struct hns_roce_dev *hr_dev,
 					mhop.bt_chunk_size;
 
 	for (i = 0; i < table->num_hem; ++i) {
-		obj = i * buf_chunk_size / table->obj_size;
+		obj = (u64)i * buf_chunk_size / table->obj_size;
 		if (table->hem[i])
 			hns_roce_table_mhop_put(hr_dev, table, obj, 0);
 	}
-- 
2.53.0



