Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450AA13790B;
	Mon, 17 Aug 2026 14:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976618; cv=none; b=DuKkbePOtzaQc22zqNdHBYRmiZteeQBUm75XYNs4eSiKEzhUV3Mj/xHDwVBh3byw/DyrxVhqsAbTyMq8bW05ps+jgyCfhb+rJ6rdJlsAf1cbFiNF7Gg6UMzMaztplW3yy4xOFdPFce7/mB0Hov7bqb4oW7oVzvIbziPs0x4D6SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976618; c=relaxed/simple;
	bh=LxlfnCj+xT13IM8cWn/Dft7flNMfKds+FB1PPeS8Kv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tr/lHh/yWnXg/jSFGuCSUju6IR9NCQbgbotje+4Iz8iBoiBAhhOTExbaFAnN3q1Z1xUEj8GuVV6/Mqmd2okUvNntr3CgXVyf8TBl1ch00QPJf5AH8cttc8O/2G7RsEJuar8i7FVU77Gh7W21X6HtwFfeiacZ0J/aVsjams20sQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18dn7eF1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18dn7eF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCE11F000E9;
	Mon, 17 Aug 2026 14:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976617;
	bh=GztGsHzDHHXdEUHnvfW+c7/mWX/dLSdmxe8doPy/G1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=18dn7eF1UAdjvbHu0T9QHFluuqf5SeXhhjvfEkCa7T+GsO70k94x4Sgq/RnUGgnqA
	 s7bgNJv8XUokGjruRrmNbeshEBwRfPxQnu2T10Dt27jimuLQpD12+o1GlzQHR0EAyw
	 PvzCapYZvOiBJALM5UFEmamD596QMXQuvUTXDHm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/456] RDMA/hns: Fix potential integer overflow in mhop hem cleanup
Date: Mon, 17 Aug 2026 15:26:48 +0200
Message-ID: <20260817132540.633246307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 61ae49219e6baa..9649abeadbbf6f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -902,7 +902,7 @@ static void hns_roce_cleanup_mhop_hem_table(struct hns_roce_dev *hr_dev,
 					mhop.bt_chunk_size;
 
 	for (i = 0; i < table->num_hem; ++i) {
-		obj = i * buf_chunk_size / table->obj_size;
+		obj = (u64)i * buf_chunk_size / table->obj_size;
 		if (table->hem[i])
 			hns_roce_table_mhop_put(hr_dev, table, obj, 0);
 	}
-- 
2.53.0



