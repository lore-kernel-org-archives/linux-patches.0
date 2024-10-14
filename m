Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BFF1AB6FC;
	Mon, 14 Oct 2024 15:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918162; cv=none; b=jLZtieKi8puAAfGswEF4AKwrlJAaXpC6flARhjaw1nEIa3r2bvjyiO/Dy1ItKuKP1VC/MECKGBKEYQZedbCdUnIIBCZB9QrYhykJWvgxYMaqzLF55vqsL/yddZcNyKzd4oqiJAQOpaaQ8dWQV+/Udfg7QzZ1ICYGMrUQC7/ANxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918162; c=relaxed/simple;
	bh=TSnh9govssa+VshHCb9vnYZKgFsydKgDh/3Om0cKu1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiX+8aKZEkUY9/yj9vWVykCOnXMNPmPoymz8mLjgqJ0Vc0WUEFdrZj12o1Cf36NZhxuBJp5CtVpBgzZ2xoXTS6M0BjBG++BlCYluS6ueS5asYfgumvS13g5QjnHS9kWxcXGaomk8Ue0HDTy4x5veY5G/ch7Aa18U+acB8L5UWSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRdwBsr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRdwBsr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AB5C4CEC3;
	Mon, 14 Oct 2024 15:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918162;
	bh=TSnh9govssa+VshHCb9vnYZKgFsydKgDh/3Om0cKu1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRdwBsr6SUwxWSjqlttYo5ChD2B58UgM1okt3mDZyvqqeAh2x0m2BSyhSsXDnumdN
	 tXbF0Zw9LYTlO9CwEN6Q3Dpcqnj9baHcuNMQ2X0UUqwW0d1VMz9wjslqF8KVarYarV
	 bKKoVoCzxHdaYfsd3G02ZEeDlAyf1QqzVaODaHL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 224/798] RDMA/hns: Fix 1bit-ECC recovery address in non-4K OS
Date: Mon, 14 Oct 2024 16:12:58 +0200
Message-ID: <20241014141226.725878782@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 42636aa28b4bb..56c0e87c494ec 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6314,7 +6314,7 @@ static u64 fmea_get_ram_res_addr(u32 res_type, __le64 *data)
 	    res_type == ECC_RESOURCE_SCCC)
 		return le64_to_cpu(*data);
 
-	return le64_to_cpu(*data) << PAGE_SHIFT;
+	return le64_to_cpu(*data) << HNS_HW_PAGE_SHIFT;
 }
 
 static int fmea_recover_others(struct hns_roce_dev *hr_dev, u32 res_type,
-- 
2.43.0



