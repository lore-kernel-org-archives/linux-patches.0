Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67151F8911;
	Tue,  3 Dec 2024 15:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240224; cv=none; b=gHMEpi16T1CZQcISfy04Aas4ynfQlopDltOGtqSenGxebckBlFhYK4dShedD3Cj6fnFi/B+yk+lJDgjMSS2V7gsKqq5YZPJrvgA+WnfeZq2zs1CAMjwy0QHJKXnWkmc7kpqGPYUbEG2g4wU+H2i1pghohf34Jhhux95HM5f1jwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240224; c=relaxed/simple;
	bh=VWZZwnrDZ30LGNeNCyVwSfmbW7d0dA3nMv2I4NJoPBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAU/HIanB2x55n1gJa7pL84E88VyDK/9G4uuN7PDmFpLC/jvng/isFTvj8W8OlU1tpRE+wuo9pbJqUZ4Ve+nG/DQfJH+eecJa7A49U1/4SDbGPtNq7kjIP92rbq1JfAcET3hzVKc82yO5A/0xdZNy8Ncu3mlB/KKzxJ6ARcOeCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exGol7Eh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exGol7Eh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C13C4CECF;
	Tue,  3 Dec 2024 15:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240223;
	bh=VWZZwnrDZ30LGNeNCyVwSfmbW7d0dA3nMv2I4NJoPBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exGol7EhmYBTijNM/TfkHj5G7/2MtO2H9mU0kL/oJzpm2g+Jrogv/hbRGhz9RV2Fq
	 n3jx5egY6kRqey7PKnQCGfhTCvGVKamS3SJfqoL+fXLhZHJzvLf7jDIleRzog0/5NM
	 xYLuZHbln/i3UZpeLYJtIuHHa4UGEwVK1Qy1oS7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/826] crypto: qat - Fix missing destroy_workqueue in adf_init_aer()
Date: Tue,  3 Dec 2024 15:36:31 +0100
Message-ID: <20241203144745.969871930@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit d8920a722a8cec625267c09ed40af8fd433d7f9a ]

The adf_init_aer() won't destroy device_reset_wq when alloc_workqueue()
for device_sriov_wq failed. Add destroy_workqueue for device_reset_wq to
fix this issue.

Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index ec7913ab00a2c..4cb8bd83f5707 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -281,8 +281,11 @@ int adf_init_aer(void)
 		return -EFAULT;
 
 	device_sriov_wq = alloc_workqueue("qat_device_sriov_wq", 0, 0);
-	if (!device_sriov_wq)
+	if (!device_sriov_wq) {
+		destroy_workqueue(device_reset_wq);
+		device_reset_wq = NULL;
 		return -EFAULT;
+	}
 
 	return 0;
 }
-- 
2.43.0



