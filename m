Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6695D17E90E;
	Mon, 27 May 2024 19:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837230; cv=none; b=UaG5YvU8lclSUelAG3rMkDQHIIjhcQxEFV/fRgR6MYAmiDIsPX65gAvIr0mV9nRv+YGespg6ng2x+6BBuFDQoDXGyIG2tv3ljDy4uydCyDcF97uWz+51V0HpVwdPKoeOvo0x7/PGik9OY3/zmQWFz9T5F8gRdW9Xk0HI5DH1lUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837230; c=relaxed/simple;
	bh=QcBowhhJo6zwIp2G8p0h+ueHcPYgVljq5E8w1WlE0E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5//AjmGDlGJKP+CgQqRwg7ZB1iogsLO9YBlnHISYtuUdhjND7I5MgyjoaVQeq2Q5wdwBkgjTV5xM2bXzp9R5AVxuBhqwry8jqg5JIgU1L3pE7NAlGNxwoPz4ov88FaYxlitAOmPJlureF7R6jgpEOH6aa42g7+aBTKQ+RSdcNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwUMEPZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwUMEPZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E865CC2BBFC;
	Mon, 27 May 2024 19:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837230;
	bh=QcBowhhJo6zwIp2G8p0h+ueHcPYgVljq5E8w1WlE0E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwUMEPZ4UVI8AGxEVWQybOsuA/TZFi6wHDfkLgBe2ZyS7WjQhchIh0lufApYSQJ6P
	 /8Zpd46RZZ1minzTQPhpZT3o6p3Gf834ZqwYt6GYfgOs9exW6ZKQe1yW27qe/g+IjX
	 COa9n+M5gP6/UDYYJQLAUxDMhBX/wDJE59t7ANJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 358/427] RDMA/hns: Fix mismatch exception rollback
Date: Mon, 27 May 2024 20:56:45 +0200
Message-ID: <20240527185633.778320723@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wenglianfa <wenglianfa@huawei.com>

[ Upstream commit dc3bda6e568e9310b7cd07769dd70a3f0cd696ca ]

When dma_alloc_coherent() fails in hns_roce_alloc_hem(), just call
kfree() to release hem instead of hns_roce_free_hem().

Fixes: c00743cbf2b8 ("RDMA/hns: Simplify 'struct hns_roce_hem' allocation")
Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240412091616.370789-7-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index a4b3f19161dc1..658c522be7583 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -281,7 +281,7 @@ static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
 	return hem;
 
 fail:
-	hns_roce_free_hem(hr_dev, hem);
+	kfree(hem);
 	return NULL;
 }
 
-- 
2.43.0



