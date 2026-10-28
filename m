Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215433;
	b=u8KtJQMimwuLPzWjDu1VTrU178NY2RcA5PKccw7JxMKlgJ5huqpnF8mPY8Ro0nhhHH2I
	 702smquA0cEib+yBVEdSvPsr3RSSxDcRIt15mPbKhCM9nrJHE76cgefj1HsQ5+MzlBiGa
	 mdVQRRK0lUcvXYtohuKt0lhV20wy+UBUqQ0y6o2MYQDWt2eINcQEMz+38pxyb5BOaVRuy
	 omyqoRdHPXlgkljjoBtTyJnASYsG2dML9GEiGXcm52EJz6rpE7EeubVN4fMbBvXxCtPOj
	 DU7dM6ahRMDU9zzUsfaIXg5zQj82y00/ARUnklTprqhYsjcsT9xpudvmAMBTrRx6HMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9jDfLvVL1wvYESgXYVVZUKMrLA6u8FP4wyFYK14Upc0=;
	b=wiMbjJCzYRb4OHCGNyhyA8I2BSM1mIMkfAKtEaupoSEtN/I/TdQEfncNkR81YeKCo2o1
	 b73ny2/pm+OE2tbsEfTHcSa3n+CshzwtbIqEKiMDKS+y5+9igJK+i1TtrJ8wE3CY5BQah
	 H3tfvOmyjeua0W//kMmkYn2RvUwcT5BWaJxkpBBvLfWyYaPbsjcpszxiydrGxqvRKSw0K
	 Rnt+nsC3fAOGYm/+DxBDgpOES7Sge+oMb/WDMSUJfDuVYleIpqzU/Nk1+kn74uwsSXVcv
	 62zALoSYG8kFTrEDMdbPguxJBDTFHyuce3SEX0VvtPVWZzrClWTd410HK5lImKkwcMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHSJqzpe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99859606A31A;
	Wed, 28 Oct 2026 19:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHSJqzpe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EDB1F01825;
	Wed, 28 Oct 2026 19:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215433;
	bh=9jDfLvVL1wvYESgXYVVZUKMrLA6u8FP4wyFYK14Upc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nHSJqzpeI8w1GIImBUUDW5aD93hpbghSAgXH5nQTH+Vlmq2RupUQ2E1ZY0pQusAIx
	 Xx+64ZL3iqicZMcgz++6O7uZuCTt/9GN7YJ3nzOs9HPXlAeZseJ8OoS6uwjzzsgjiW
	 zoc/ZLXjkFP8KzZYtIyKe9GTqDkyfNQAvHJsgl+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1182/1887] iommu/amd: Wait for completion instead of returning early in iommu_completion_wait()
Date: Wed, 28 Oct 2026 17:54:38 +0100
Message-ID: <20261028170526.303632988@linuxfoundation.org>
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

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

[ Upstream commit 1e75a8255f11c81fb07e81e5029cfd75804350a0 ]

need_sync is a per-IOMMU flag shared by all domains and devices behind
that IOMMU. It is set whenever a command is queued with sync == true and
cleared when a completion-wait (CWAIT) command is queued. However, a
cleared need_sync only means that a covering CWAIT has been queued, not
that all previously queued commands have actually completed in hardware.

iommu_completion_wait() read need_sync locklessly and returned early
when it was false. This breaks the "block until all previously queued
commands have completed" contract in a multi-CPU scenario:

  CPU2: queue inv-B                  => need_sync = true
  CPU1: queue CWAIT(N); need_sync = false; then wait_on_sem(N)
  CPU2: read need_sync == false      => return 0 (no wait!)

CPU2 returns without waiting for any sequence number even though its
inv-B may not have completed yet (CWAIT(N), queued after inv-B, has not
been signaled). CPU2 then proceeds to, for example, free page-table
pages while the IOMMU can still walk stale translations, opening a
use-after-free window. This is a logical race in the meaning of the
flag, not a memory-visibility issue, so barriers alone do not help.

Fix it without losing the optimization of avoiding redundant CWAIT
commands: take iommu->lock before testing need_sync, and when it is
false do not return early but wait for the last allocated sequence
number (cmd_sem_val). Since need_sync == false implies no sync command
was queued after the last CWAIT, that CWAIT is FIFO-ordered after every
not-yet-completed command, so waiting for its sequence number guarantees
all prior commands (possibly queued by another CPU) have completed. The
common path with pending work is unchanged and no extra hardware command
is issued.

Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Fixes: 815b33fdc279 ("x86/amd-iommu: Cleanup completion-wait handling")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 07d9d2f09417a..dc47692db143e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1184,11 +1184,23 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	int ret;
 	u64 data;
 
-	if (!iommu->need_sync)
-		return 0;
-
 	raw_spin_lock_irqsave(&iommu->lock, flags);
 
+	if (!iommu->need_sync) {
+		/*
+		 * No command has been queued since the last completion-wait.
+		 * A concurrent CPU may have already queued that CWAIT and
+		 * cleared need_sync; need_sync == false only means a covering
+		 * CWAIT is queued, not that all prior commands have completed.
+		 * Wait for the last allocated sequence number so that any
+		 * command queued before this call (possibly on another CPU)
+		 * is guaranteed to have completed before returning.
+		 */
+		data = iommu->cmd_sem_val;
+		raw_spin_unlock_irqrestore(&iommu->lock, flags);
+		return wait_on_sem(iommu, data);
+	}
+
 	data = ++iommu->cmd_sem_val;
 	build_completion_wait(&cmd, iommu, data);
 
@@ -1198,9 +1210,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	if (ret)
 		return ret;
 
-	ret = wait_on_sem(iommu, data);
-
-	return ret;
+	return wait_on_sem(iommu, data);
 }
 
 static int iommu_flush_dte(struct amd_iommu *iommu, u16 devid)
-- 
2.53.0



