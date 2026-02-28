Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7D838D017
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302136; cv=none; b=Om+eQtXxqKJJ6xWGZDGZJ2pWvS+ojKFF38zM4hqy5bTwPcVFZ4ZZJ2BdM8M3beZUCOP9TXCbU32seoTg67FODX+i9khSuJTpTM32W1MFgzAtJZirSlwB9h6n9X5OZK1NGwNCwW2F8lxUs6JCVSbjIyQVTU331HCzkRiZJlyNUm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302136; c=relaxed/simple;
	bh=3sPWU3hsE+rQWNU8z75puDN0IoKrfis9rhRnQV9Go6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fs2TwrIluW/hLhLeqQq6K3QxFOCyKXGcuvZaY3HM/DNg9J+VgMpdRf5tKYs752ssRkpoolFNY1HFwgfhM2RnE+bOudkPNUJ0L/VQaD3ZpQCrnHICzUbsUU0hyzZkmj9BBeI7YzFJB8Wx//bBdZ7IwHeBla3FjJTqbqhkA1Krh98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I+jMCQZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+jMCQZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24670C19424;
	Sat, 28 Feb 2026 18:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302136;
	bh=3sPWU3hsE+rQWNU8z75puDN0IoKrfis9rhRnQV9Go6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+jMCQZgzZLigRCeMER1FFzsx7BOITQKsZWLRUycOMtRGGXVA6dRT+FWbrc4DTh1F
	 SpnBBc3/fW5Etwtkvtr2kc/8ZONV1m7I5/6A+UsbxISl73R9O6CnXwgtfpDLLPEj8H
	 CjVdLUCWPw24rifsVMsEPEGh7eD1XIN198QZ8lYuoZM82edP/JRTn96dZAQj3vZMLp
	 KEwAcwpLAVQtreh/wTJty8gXKsGBupIUe5iJ6nrodkqygRQ2FjTFYpsrq/cdqmrt73
	 K+WiJiICKbOWTeTu1ra0eOA3kKm9jYB6rQzPiUC6G4N4RMoe3+4TYiJK1xRAvf74V8
	 HddZ0PEWxrZgw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/283] wifi: ath10k: sdio: add missing lock protection in ath10k_sdio_fw_crashed_dump()
Date: Sat, 28 Feb 2026 13:04:30 -0500
Message-ID: <20260228180709.1583486-128-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 850d999615a2c..7d0a522e5402e 100644
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

