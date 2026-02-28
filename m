Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725F0333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301799; cv=none; b=RQdXYYJ4NDLM5NA96Mfk+O0OCjZlGSSfTm/FwXn/6kOe+ZO48gKdG2Ni9LW8j4U4styT09fyIftN0WsWy89S+cSEawj2pCupE63DQjpDfffOfCZfwZ+iOVEZlLlu0VdbSe3UrR94BF95LdSuerMwIP7YOxUTG4OFhra9XXO1ol4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301799; c=relaxed/simple;
	bh=OayclaofFRAgXur9k9CHol0hfA0LAK7x9KHZbjVeLDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phU0nARXahitSHQTjaD8yUc4w09z6l/LCvCsMND6gTqSX7ATQMB0XTUN3PAsXJz6sqkbxcGtIO756vl336CQ/lHGxxdm3xyNjdsQvtkDDZa+CbFnnYgOzK8HPA2+FpqMYa5iJZ4XQLzIhaugjaeW3SYxEUy9XH1RWrr4eecxA/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d4EXuQ+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d4EXuQ+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86706C116D0;
	Sat, 28 Feb 2026 18:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301799;
	bh=OayclaofFRAgXur9k9CHol0hfA0LAK7x9KHZbjVeLDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4EXuQ+uBfOJqbyG5gt/NaBP6OcL7FJfpfR2loIPYZDa62qRCEjl+dCw+Ryc8iYPN
	 uptHnifND0CVFwh7DIueYzZXUP1piRIgIAVtgF74ubIvByRbinDxrg7fNKX4D13BN6
	 GuNnS0R12Ia4b/qwijRynwiao2lC0nVybP8O1tososODQqzk9oNfIzxCXUDRQfmrST
	 NHpBvzNkuVGSINVkrf7vfjjZ3xhl+r3aF7WtC5SGBEgO496kIJqOaMMvPM/jSSu+oH
	 vKkGGbaZB4RA5vG2hsn3eTSYUj9tTbP+2qw+UiiVznWo9wk9g9z3PGCur81YK4MEOt
	 syBUruGNug+uQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/385] wifi: ath10k: sdio: add missing lock protection in ath10k_sdio_fw_crashed_dump()
Date: Sat, 28 Feb 2026 12:57:12 -0500
Message-ID: <20260228180011.1568201-210-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 6805357ee29e6..2ff2dc4a3f58b 100644
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

