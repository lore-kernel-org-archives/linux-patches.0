Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C5839B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302565; cv=none; b=bEbXPVtJKqn5K/7tNMPJ8Idmnkp/tzTPh1S3ePm6KCXmfbgwGgYgl7DmKXcYwxsEJzlaEYkvlusdfCnPIZ4CtG0ua8l7nTcce2b6reQH02nJw1aQtFM/4rDV03NvoPk4WNP0f56V+DMfKMh7aEGe7uNzQq5knAEyzBmPw7kMzTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302565; c=relaxed/simple;
	bh=QtXxN1ENEl+VOmB7KV0pUInaA7LMzg7AP8VlA/V/dqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJ4ziQ1j7XexEmZ7wdZrlbgk+WxU1/hd0A6xBZ+mls4iYdjFtXCzoXuENzSKd0HWkTp1vGtlqYA5+tSONRFK2fHEQk4snnZc0A+ekS3RkytKVWreaP/9egMCaokhpIE7wBvsuDcQzV9oweySlFj2m77W2TZKyQpf722BttTZot0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bowraXEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bowraXEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF59DC19424;
	Sat, 28 Feb 2026 18:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302565;
	bh=QtXxN1ENEl+VOmB7KV0pUInaA7LMzg7AP8VlA/V/dqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bowraXEbNRQMmV79z+1iZFie+NjPXp2wt4O8+CM/jupmIqIg/0P84x/9sf0UF8aU4
	 ayeP5Y6YUaSaOK+fIcBDEj7yMgz6BK6QiRJ89sw+FKHuTzEZ3x3P9eP2mX+5gBZlp6
	 HF+w3qEuvpkpWyihBdHTUJSdef9T6waob1+C0RqmfYWbSE5HGsE9Mi2X4OzoJ+B49x
	 pYfmruZf1vCgOXq5AwIbPC/pS4g9YP2H1uYkJhzAE0XmZ8WIZrqb//PTsNAouYbTGb
	 D4z7FjRfb3f+nFGhUZYYk5ShI2+Oh5AmzDS0LVopaMKbyGJ/2Zjcxg39d2JXV58ll+
	 5eMv3zEazqIcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/164] wifi: ath10k: sdio: add missing lock protection in ath10k_sdio_fw_crashed_dump()
Date: Sat, 28 Feb 2026 13:13:30 -0500
Message-ID: <20260228181505.1600663-71-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit e55ac348089e579fc224569c7bd90340bf2439f9 ]

ath10k_sdio_fw_crashed_dump() calls ath10k_coredump_new() which requires
ar->dump_mutex to be held, as indicated by lockdep_assert_held() in that
function. However, the SDIO implementation does not acquire this lock,
unlike the PCI and SNOC implementations which properly hold the mutex.

Additionally, ar->stats.fw_crash_counter is documented as protected by
ar->data_lock in core.h, but the SDIO implementation modifies it without
holding this spinlock.

Add the missing mutex_lock()/mutex_unlock() around the coredump
operations, and add spin_lock_bh()/spin_unlock_bh() around the
fw_crash_counter increment, following the pattern used in
ath10k_pci_fw_dump_work() and ath10k_snoc_fw_crashed_dump().

Fixes: 3c45f21af84e ("ath10k: sdio: add firmware coredump support")
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260123045822.2221549-1-n7l8m4@u.northwestern.edu
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index b2e0abb5b2b53..e092702d25b34 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2486,7 +2486,11 @@ void ath10k_sdio_fw_crashed_dump(struct ath10k *ar)
 	if (fast_dump)
 		ath10k_bmi_start(ar);
 
+	mutex_lock(&ar->dump_mutex);
+
+	spin_lock_bh(&ar->data_lock);
 	ar->stats.fw_crash_counter++;
+	spin_unlock_bh(&ar->data_lock);
 
 	ath10k_sdio_disable_intrs(ar);
 
@@ -2504,6 +2508,8 @@ void ath10k_sdio_fw_crashed_dump(struct ath10k *ar)
 
 	ath10k_sdio_enable_intrs(ar);
 
+	mutex_unlock(&ar->dump_mutex);
+
 	ath10k_core_start_recovery(ar);
 }
 
-- 
2.51.0

