Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D03A27702E;
	Fri, 12 Dec 2025 02:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765505351; cv=none; b=MOaiuQE2bMox/RvNFNTUUSB3/bmYnfrRk5e35kCVEuATef1kz1zljBhGwcKK8K2Br1PWkJQ+A9jj8s3pUdB4jodzsbt7PY+lrdWnKZwrrn0A/Q7Melxsll3t9NGPoKczHUpprv4VgdQ2nsf7zzIMzWj2aNuoZOCsvnz3KhV66+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765505351; c=relaxed/simple;
	bh=KnJsrnXdPjvwLRxT8xQ5io/nClckJO+dlwBTKMBT3Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FUr0WdynZJhwvt1IG8yht6EL8p/OFBSr5qfqm50IAkSGNI5lDiZ5muJSFv+ra+CRbioB+kzmTgiwzxZ8yjjrJAUd9dZthlkjDoAfHZNvySNiIFIKWKNoKBuIPLqjDVg+8a39rPAUoJiY+7Y8r6wI8mPsh/5b+/ZgpfRtQuNgoHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lKV934mD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lKV934mD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69871C4CEF7;
	Fri, 12 Dec 2025 02:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765505350;
	bh=KnJsrnXdPjvwLRxT8xQ5io/nClckJO+dlwBTKMBT3Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKV934mDOq1WnJ/cD/czLvDSDtA666xFoywI75Z9YBxboMrHsy+mwhFjZA3wgwWDX
	 udaJWVXp0E0aS2lOuGdcC6XeZwt2CxgqtViFI0bwSj68eumWMdRiJds1vGl4wPPRb3
	 AUgbXA9bKA6iJUnd0Z06+Tji1xIPthfArXvQZRk3BAhQ5M7tjvzuI/Q7tfAmDS79NJ
	 MN5ryI3jytYy+8cnJM/3l4hWzKtU4cLRWnyqEeZsM8ai66rLEozYg2YyQ2XrPfWYbu
	 O/XNkPyDW88tOKBrNxhr1BjAts0vX0yRRJOatusgiJfNZo91+76u+z6ByiWOqGgsp+
	 s58emRBA4SVww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Wagner <wagi@kernel.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nareshgottumukkala83@gmail.com,
	paul.ely@broadcom.com,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-5.10] nvme-fc: don't hold rport lock when putting ctrl
Date: Thu, 11 Dec 2025 21:08:54 -0500
Message-ID: <20251212020903.4153935-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251212020903.4153935-1-sashal@kernel.org>
References: <20251212020903.4153935-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit b71cbcf7d170e51148d5467820ae8a72febcb651 ]

nvme_fc_ctrl_put can acquire the rport lock when freeing the
ctrl object:

nvme_fc_ctrl_put
  nvme_fc_ctrl_free
    spin_lock_irqsave(rport->lock)

Thus we can't hold the rport lock when calling nvme_fc_ctrl_put.

Justin suggested use the safe list iterator variant because
nvme_fc_ctrl_put will also modify the rport->list.

Cc: Justin Tee <justin.tee@broadcom.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This shows the affected function was introduced in v5.8-rc1
(`14fd1e98afafc`), meaning this deadlock bug has existed since **Linux
5.8** and affects all stable kernels from 5.8 onwards (5.10.y, 5.15.y,
6.1.y, 6.6.y, etc.).

### SUMMARY

**What the commit fixes:**
A **deadlock bug** in the NVMe-FC (Fibre Channel) driver where
`nvme_fc_match_disconn_ls()` holds `rport->lock` while calling
`nvme_fc_ctrl_put()`. When the reference count hits zero,
`nvme_fc_ctrl_free()` tries to acquire the same lock, causing a
deadlock.

**Stable kernel criteria:**
| Criterion | Assessment |
|-----------|------------|
| Obviously correct | ✅ Uses canonical lock drop/reacquire pattern |
| Fixes real bug | ✅ Deadlock - system hang |
| Important issue | ✅ Deadlocks in storage paths are critical |
| Small and contained | ✅ ~6 lines in one function |
| No new features | ✅ Pure bug fix |
| Expert reviewed | ✅ Christoph Hellwig |

**Risk vs Benefit:**
- **Risk:** LOW - The fix uses a well-established kernel pattern
  (`list_for_each_entry_safe` + lock release/reacquire)
- **Benefit:** HIGH - Prevents deadlock in NVMe-FC storage driver used
  in enterprise environments

**Concerns:**
- No explicit `Cc: stable` tag, but this is not required for obvious bug
  fixes
- No `Fixes:` tag, but we've identified the bug exists since v5.8
- The fix should apply cleanly to any kernel with the affected function
  (5.8+)

### CONCLUSION

This commit fixes a clear deadlock bug in the NVMe-FC driver that has
existed since Linux 5.8. The fix is:
- Small and surgical (only ~6 lines changed)
- Uses well-understood, standard kernel locking patterns
- Has been reviewed by a respected kernel developer (Christoph Hellwig)
- Signed off by the NVMe maintainer (Keith Busch)
- Affects enterprise storage users who rely on NVMe over Fibre Channel

Deadlocks in storage drivers are serious issues that warrant stable
backporting. The minimal scope and established fix pattern make this a
low-risk, high-value backport.

**YES**

 drivers/nvme/host/fc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 2c903729b0b90..8324230c53719 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -1468,14 +1468,14 @@ nvme_fc_match_disconn_ls(struct nvme_fc_rport *rport,
 {
 	struct fcnvme_ls_disconnect_assoc_rqst *rqst =
 					&lsop->rqstbuf->rq_dis_assoc;
-	struct nvme_fc_ctrl *ctrl, *ret = NULL;
+	struct nvme_fc_ctrl *ctrl, *tmp, *ret = NULL;
 	struct nvmefc_ls_rcv_op *oldls = NULL;
 	u64 association_id = be64_to_cpu(rqst->associd.association_id);
 	unsigned long flags;
 
 	spin_lock_irqsave(&rport->lock, flags);
 
-	list_for_each_entry(ctrl, &rport->ctrl_list, ctrl_list) {
+	list_for_each_entry_safe(ctrl, tmp, &rport->ctrl_list, ctrl_list) {
 		if (!nvme_fc_ctrl_get(ctrl))
 			continue;
 		spin_lock(&ctrl->lock);
@@ -1488,7 +1488,9 @@ nvme_fc_match_disconn_ls(struct nvme_fc_rport *rport,
 		if (ret)
 			/* leave the ctrl get reference */
 			break;
+		spin_unlock_irqrestore(&rport->lock, flags);
 		nvme_fc_ctrl_put(ctrl);
+		spin_lock_irqsave(&rport->lock, flags);
 	}
 
 	spin_unlock_irqrestore(&rport->lock, flags);
-- 
2.51.0

