Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F82936C9E0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302380; cv=none; b=ITRDHhkb2ZY9B5SyOfKds+fspd4yHBP9ZTEL6gt3eu8S3CepwzvQffRVUWTOl3WW8JxVU7B1Q8oKUOeK8Vm4UIP4RoSH+IKH7C3tr8OKRWtjzUQpagWofU1nFIhekv6z0vyqEnvCaA66G3SnoJ8HT7ucR4tuch70ASZtG9A0Sz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302380; c=relaxed/simple;
	bh=44T8lYkZhdJhLRg4pCVyCcoVkaeH9emMW5d5Ds6smfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNGTXSaDBU+IqiCR/6RQefiiQrs+8JvA7V3sRVNBRKJqZGu/s/hZ+Ql5OEjqJ6vIo3lt2ljMegefoWQbjg9K5ou7Z46RxavuCplI8giFVa/G0LBgZZoRRnG9Ui6Ae6OIXy6s37Clllf3eCJacCSvp7WqATvxNN6k+BoS3kJREec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwaPEYTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwaPEYTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD3AC19423;
	Sat, 28 Feb 2026 18:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302380;
	bh=44T8lYkZhdJhLRg4pCVyCcoVkaeH9emMW5d5Ds6smfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwaPEYTZYGAVRGhxI6NGx63d+9r8DoFTnPSn0KucGOkx61twQ5VcQQQo6IIMWi6xo
	 Nj8+X31vSGU8vLoqs/z14a8DBl69PFHjtkebswFFX6nJI9AzKs1qYXxSI12OSno7zv
	 8zzpf/HMpMpXlYKMgOz4nmnz/kPAbb+g82QbDHBiP/qFlK2MwbduU5WQ7ygQ+i44Vw
	 m+nRAI9G9qKop3kjb0pcwhmPaka408+pnFmvKnOXgTtZ4gPfpuTBL+sbSqpLg9CttP
	 7CaDUejPHmk9obz6NhMmuv7fflWtDg6nIvAugz93BPTYMD4nNcyQgnMX+lVNa6UGw9
	 Q2L8pq2Tmv1Gw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/232] wifi: ath10k: sdio: add missing lock protection in ath10k_sdio_fw_crashed_dump()
Date: Sat, 28 Feb 2026 13:09:21 -0500
Message-ID: <20260228181127.1592657-108-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index d0705f2f46560..b49eeaaadde79 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2485,7 +2485,11 @@ void ath10k_sdio_fw_crashed_dump(struct ath10k *ar)
 	if (fast_dump)
 		ath10k_bmi_start(ar);
 
+	mutex_lock(&ar->dump_mutex);
+
+	spin_lock_bh(&ar->data_lock);
 	ar->stats.fw_crash_counter++;
+	spin_unlock_bh(&ar->data_lock);
 
 	ath10k_sdio_disable_intrs(ar);
 
@@ -2503,6 +2507,8 @@ void ath10k_sdio_fw_crashed_dump(struct ath10k *ar)
 
 	ath10k_sdio_enable_intrs(ar);
 
+	mutex_unlock(&ar->dump_mutex);
+
 	ath10k_core_start_recovery(ar);
 }
 
-- 
2.51.0

