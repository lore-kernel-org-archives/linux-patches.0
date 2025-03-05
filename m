Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912C624C07D;
	Wed,  5 Mar 2025 18:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198427; cv=none; b=rDDOBTVoSrRP6AHxdprE53UummfQr1eYOsl0Ck4Snq8k+5LLzKioQ5dw3xqcUNvwu3cn866ph3GpKFKEDHNKrPQMqfndj5WwNd91dS8EG+5Cjjh3+y4kzM6ZdOFNPPM7UB305RU74WjBmARJxhT7MDzr4eaYp7zxjagg1RfBub4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198427; c=relaxed/simple;
	bh=LXq70PEjj2xXr/YoSdOJLLxfh8PimtHPqzbJy83KEjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzZ61LgSawIuF1/tL9xcZBZfJjlP4A9uIr0QfQ8SEhb3gVnao1Q/EpjxjcWIV0jOzUEq2YKRLL9O5gCqW9aHFHXk3tWRcZ/EWTX3iqxAHEUgzyqr2szvYjCLLGf5re6urKBDwM4oPZCeGnqFXQ98r9BotmXqV/zH/7k1Po8cQLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbMz7f+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbMz7f+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8A2C4CEE0;
	Wed,  5 Mar 2025 18:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198427;
	bh=LXq70PEjj2xXr/YoSdOJLLxfh8PimtHPqzbJy83KEjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbMz7f+BvzPowlzIthY7i9bjzG8hO5gEmwPAoBhke7OffJrVEHW8/zyCi5ZzGwr/J
	 NhGdKJ86FO6F7v3Y+hkGtIHn2oLl7SNfOUwqAXLzapgk7MPLFTwsDtRhiT0BypBwfr
	 IEn0RvyX9j26Lm9sUQ1oX1z/ew9y0czpkC0RRG4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 007/157] RDMA/bnxt_re: Add sanity checks on rdev validity
Date: Wed,  5 Mar 2025 18:47:23 +0100
Message-ID: <20250305174505.571739741@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit f0df225d12fcb049429fb5bf5122afe143c2dd15 ]

There is a possibility that ulp_irq_stop and ulp_irq_start
callbacks will be called when the device is in detached state.
This can cause a crash due to NULL pointer dereference as
the rdev is already freed.

Fixes: cc5b9b48d447 ("RDMA/bnxt_re: Recover the device when FW error is detected")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1738657285-23968-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index c143f273b7596..7368b0482bb87 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -321,6 +321,8 @@ static void bnxt_re_stop_irq(void *handle)
 	int indx;
 
 	rdev = en_info->rdev;
+	if (!rdev)
+		return;
 	rcfw = &rdev->rcfw;
 
 	for (indx = BNXT_RE_NQ_IDX; indx < rdev->nqr->num_msix; indx++) {
@@ -341,6 +343,8 @@ static void bnxt_re_start_irq(void *handle, struct bnxt_msix_entry *ent)
 	int indx, rc;
 
 	rdev = en_info->rdev;
+	if (!rdev)
+		return;
 	msix_ent = rdev->nqr->msix_entries;
 	rcfw = &rdev->rcfw;
 	if (!ent) {
@@ -2356,6 +2360,7 @@ static int bnxt_re_suspend(struct auxiliary_device *adev, pm_message_t state)
 	ibdev_info(&rdev->ibdev, "%s: L2 driver notified to stop en_state 0x%lx",
 		   __func__, en_dev->en_state);
 	bnxt_re_remove_device(rdev, BNXT_RE_PRE_RECOVERY_REMOVE, adev);
+	bnxt_re_update_en_info_rdev(NULL, en_info, adev);
 	mutex_unlock(&bnxt_re_mutex);
 
 	return 0;
-- 
2.39.5



