Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA131D0E3E;
	Wed,  2 Oct 2024 13:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876354; cv=none; b=GmJgmi4gZlbtsAYrY8ip6dTAuz5xTAMDzPeXvlnzNzjFZovtuJmsjHHhuttsZrwsMc5UlfNDIrXm9/lmBi+rQI/jV+gMHqZ7ZehtTf3TEs4Vxjjwfw1JT46O9ueEEBJ3BQtF3no+LwV1v+FChfG5iBe+2O/BoNfzjXAFVirbhAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876354; c=relaxed/simple;
	bh=+ViZ37Ilp8ESj+aMEGJaXnVaOhhTSe8WTkBp7tGJRbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxw0luIOuPwI1UXQXorlvq//kAl/HMF+sv/LBfRt8oazA5ObTQoD5OdKkr822ZZnOONDn2snF488UjGOQ/8TEz2a91mbhM4xUlIOo6J3vyAF0vAbfUdjAdkYIcBzKE4wpeTK08jyipoZnACCW82Nh5a6b12yCa/FpCd+iDmvyZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNJcbDSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNJcbDSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AB6C4CEC5;
	Wed,  2 Oct 2024 13:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876354;
	bh=+ViZ37Ilp8ESj+aMEGJaXnVaOhhTSe8WTkBp7tGJRbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNJcbDSWvj3Wpdv3hwuuluKNpFHa6pG2KccgktDMWQ3k1lNdNB4kZTlKl6PXjUHdg
	 cMDR6eEcKPCY7YLgj0UhOBsBDaAMXCdAT3nI1JXyOhMzAXETJ9Yw3tP1gdgimmXOkq
	 JLSuBMCFuIWRwhDn4Nbwh5WbyNweqJKlllCv9P38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 415/695] RDMA/hns: Fix 1bit-ECC recovery address in non-4K OS
Date: Wed,  2 Oct 2024 14:56:53 +0200
Message-ID: <20241002125839.015297159@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit ce196f6297c7f3ab7780795e40efd6c521f60c8b ]

The 1bit-ECC recovery address read from HW only contain bits 64:12, so
it should be fixed left-shifted 12 bits when used.

Currently, the driver will shift the address left by PAGE_SHIFT when
used, which is wrong in non-4K OS.

Fixes: 2de949abd6a5 ("RDMA/hns: Recover 1bit-ECC error of RAM on chip")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20240906093444.3571619-8-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 5483d04b3ab7e..349b68d7e7db6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6285,7 +6285,7 @@ static u64 fmea_get_ram_res_addr(u32 res_type, __le64 *data)
 	    res_type == ECC_RESOURCE_SCCC)
 		return le64_to_cpu(*data);
 
-	return le64_to_cpu(*data) << PAGE_SHIFT;
+	return le64_to_cpu(*data) << HNS_HW_PAGE_SHIFT;
 }
 
 static int fmea_recover_others(struct hns_roce_dev *hr_dev, u32 res_type,
-- 
2.43.0



