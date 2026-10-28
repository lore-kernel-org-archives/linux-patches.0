Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214966;
	b=krRsX5HX8+VjSreiZCuHW6X69+Ubprt553BnrppNU6+0tAD6AeuV+BYqH/t1BnFv9jl9
	 WvW4hYsaRq0FZNpH3/KnpDxouLzjNK2/EQnsEKg/N/1xpXg8UwamYXbz4okniWMYHw7PQ
	 03AocLHTPge42FNgzQ8fEvcDiyDlM5Hzda4GnBMf3K5KO3CXf3FmYPTLxYR2lskdkMjjq
	 Juf3wrTeJqWHgJY0TBDavbEIEoL46Nnf7uOt5oId4BFMv4eB3fdMV9CeIt35CYCgHU+FQ
	 Wf9bT0IhVAo9gNUF1oCQqnjq+pC6BtYfvONFPaZ94QJM1SwgPHWZSPFpOWXlpMKwoFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nqWU2imnGYtr3wh3byVfygcMfgtcxuJFrCjv26/eu4A=;
	b=bU743jMK/jbOmmrtS3Aq1oFAE7hAAHT1lHSeUxD/jhDxXHrcqjyuZBoyTFVsb5Udqj9X
	 ZiBTUNP4OW5IvqLqkfUVAaYe6PSq+IdUxrcWJO4gsdIrjcR8WxfIC9LK495JgsWza3tKr
	 +098Kk8+ddvu6AQ5+iEcg9mtjw/zqp+l269T9/n+FrSkK6VgIEB9Q5lRZ6FHWRCzqOilG
	 cMjKEpF9UwC4LfJA9JmPclm5HgHV1SrrYKtQOcYnfsaYmKPhX4SaE8VH8RiONqtYNUxb3
	 40GhD5cd/SiB2aEZIy58cGbLGeUNK82/SOtrBbHDAOv9Y7Uh5myYztQlpNf6/HwMaWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DM1iP54+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9530D606A31E;
	Wed, 28 Oct 2026 19:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DM1iP54+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81B91F01828;
	Wed, 28 Oct 2026 19:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214966;
	bh=nqWU2imnGYtr3wh3byVfygcMfgtcxuJFrCjv26/eu4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DM1iP54+yGaIVnpw8oWTV/3DheGmTfCz+JtuopjNWIIRKa5Ch6epZmjZH5Nz1Bgai
	 FFrHMwUbuDQq9IqTjuZPtnA5i7Bq6pAYmINWj3Cd5VS4p+RYaIdnAWwGEGiY28ONtk
	 ZCUvx7WsI/wTRFZrJMYwy8R/t/D+ITKzXSWJJ1fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Soni <Ankit.Soni@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1002/1887] iommu/amd: move wait_on_sem() out of spinlock
Date: Wed, 28 Oct 2026 17:51:38 +0100
Message-ID: <20261028170522.213183163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Soni <Ankit.Soni@amd.com>

[ Upstream commit d2a0cac10597068567d336e85fa3cbdbe8ca62bf ]

With iommu.strict=1, the existing completion wait path can cause soft
lockups under stressed environment, as wait_on_sem() busy-waits under the
spinlock with interrupts disabled.

Move the completion wait in iommu_completion_wait() out of the spinlock.
wait_on_sem() only polls the hardware-updated cmd_sem and does not require
iommu->lock, so holding the lock during the busy wait unnecessarily
increases contention and extends the time with interrupts disabled.

Signed-off-by: Ankit Soni <Ankit.Soni@amd.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index d4b6a32f258e7..79833cc4a524a 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -918,7 +918,12 @@ static int wait_on_sem(struct amd_iommu *iommu, u64 data)
 {
 	int i = 0;
 
-	while (*iommu->cmd_sem != data && i < LOOP_TIMEOUT) {
+	/*
+	 * cmd_sem holds a monotonically non-decreasing completion sequence
+	 * number.
+	 */
+	while ((__s64)(READ_ONCE(*iommu->cmd_sem) - data) < 0 &&
+	       i < LOOP_TIMEOUT) {
 		udelay(1);
 		i += 1;
 	}
@@ -1187,14 +1192,13 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	build_completion_wait(&cmd, iommu, data);
 
 	ret = __iommu_queue_command_sync(iommu, &cmd, false);
+	raw_spin_unlock_irqrestore(&iommu->lock, flags);
+
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	ret = wait_on_sem(iommu, data);
 
-out_unlock:
-	raw_spin_unlock_irqrestore(&iommu->lock, flags);
-
 	return ret;
 }
 
-- 
2.53.0



