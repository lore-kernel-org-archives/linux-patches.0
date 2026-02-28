Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B38634252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301696; cv=none; b=TrzZV0OVIOPU8SBgzYVMpfg1d9UNKzyPFW59XLqOlexusMqZuAYW2M1b2xQfwDVZo3ia1c5VXw/3eGfvqFQWnfgRgKQNjGTDPn0s96tb8wtt40G7Ja1sdd3bQ2KyZT5InOWPmYSVscQ34X/pf+qrPiZREkZUemqwL0bVUsuJu/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301696; c=relaxed/simple;
	bh=p3Iyn/xCyc4P2qLDbpXnKPQWVeSHHmo4oHOLWoYB6Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAvNFIPyZFAaNEURI6Phs8Gukkr0tm5vvznLKHhrxBB9pMNaiMnL0dPRe0zXuwzuawvHwZq7u3sGq05Vey1oKVyFRnncFksy4hCGQNQCesJMmDtdEXljvnG0fhFTsVjYqBh95i3LMtDxGxEs5z6TWKvW6pgk5lvAl9wRh1oF2d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJ1jM485; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJ1jM485"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCCFC116D0;
	Sat, 28 Feb 2026 18:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301696;
	bh=p3Iyn/xCyc4P2qLDbpXnKPQWVeSHHmo4oHOLWoYB6Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJ1jM485jFgUSovNmJdrC+VDk66axsXAiFaZkuEg7q83INRuufNoLrxBnNHxZYtY4
	 Ckxg2qC/H5GhG8YrX60fYiWlWaJoCMdyRLiQV7p+2Z/idEuim1y1Y+1ACQGx8YfXdu
	 2QTViOPIg/qx1vDMYfUaRTlFJ93J6QEhF6tauwdoE0k1t+s8ttN2xlDnE3dhI0NeRb
	 dC85pHgdXZAhVESLiSUdUiQcO1y+1aecRcfcbxSjcHJH7n8kScHN5sHlVx0T9e+Euk
	 zKmOX771tX4G8cRnFKgvjS3Ytg++15kPIGGf3OuKnVCmXmHUp176hcto8/0stYTp4z
	 zBjUEJHR2wbhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jonathan McDowell <noodles@meta.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/385] hwrng: core - Allow runtime disabling of the HW RNG
Date: Sat, 28 Feb 2026 12:55:10 -0500
Message-ID: <20260228180011.1568201-88-sashal@kernel.org>
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

From: Jonathan McDowell <noodles@meta.com>

[ Upstream commit e74b96d77da9eb5ee1b603c937c2adab5134a04b ]

The HW RNG core allows for manual selection of which RNG device to use,
but does not allow for no device to be enabled. It may be desirable to
do this on systems with only a single suitable hardware RNG, where we
need exclusive access to other functionality on this device. In
particular when performing TPM firmware upgrades this lets us ensure the
kernel does not try to access the device.

Before:

root@debian-qemu-efi:~# grep "" /sys/devices/virtual/misc/hw_random/rng_*
/sys/devices/virtual/misc/hw_random/rng_available:tpm-rng-0
/sys/devices/virtual/misc/hw_random/rng_current:tpm-rng-0
/sys/devices/virtual/misc/hw_random/rng_quality:1024
/sys/devices/virtual/misc/hw_random/rng_selected:0

After:

root@debian-qemu-efi:~# grep "" /sys/devices/virtual/misc/hw_random/rng_*
/sys/devices/virtual/misc/hw_random/rng_available:tpm-rng-0 none
/sys/devices/virtual/misc/hw_random/rng_current:tpm-rng-0
/sys/devices/virtual/misc/hw_random/rng_quality:1024
/sys/devices/virtual/misc/hw_random/rng_selected:0

root@debian-qemu-efi:~# echo none > /sys/devices/virtual/misc/hw_random/rng_current
root@debian-qemu-efi:~# grep "" /sys/devices/virtual/misc/hw_random/rng_*
/sys/devices/virtual/misc/hw_random/rng_available:tpm-rng-0 none
/sys/devices/virtual/misc/hw_random/rng_current:none
grep: /sys/devices/virtual/misc/hw_random/rng_quality: No such device
/sys/devices/virtual/misc/hw_random/rng_selected:1

(Observe using bpftrace no calls to TPM being made)

root@debian-qemu-efi:~# echo "" > /sys/devices/virtual/misc/hw_random/rng_current
root@debian-qemu-efi:~# grep "" /sys/devices/virtual/misc/hw_random/rng_*
/sys/devices/virtual/misc/hw_random/rng_available:tpm-rng-0 none
/sys/devices/virtual/misc/hw_random/rng_current:tpm-rng-0
/sys/devices/virtual/misc/hw_random/rng_quality:1024
/sys/devices/virtual/misc/hw_random/rng_selected:0

(Observe using bpftrace that calls to the TPM resume)

Signed-off-by: Jonathan McDowell <noodles@meta.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: cc2f39d6ac48 ("hwrng: core - use RCU and work_struct to fix race condition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 57c51efa56131..7be3d504d8c01 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -334,6 +334,9 @@ static ssize_t rng_current_store(struct device *dev,
 
 	if (sysfs_streq(buf, "")) {
 		err = enable_best_rng();
+	} else if (sysfs_streq(buf, "none")) {
+		cur_rng_set_by_user = 1;
+		drop_current_rng();
 	} else {
 		list_for_each_entry(rng, &rng_list, list) {
 			if (sysfs_streq(rng->name, buf)) {
@@ -385,7 +388,7 @@ static ssize_t rng_available_show(struct device *dev,
 		strlcat(buf, rng->name, PAGE_SIZE);
 		strlcat(buf, " ", PAGE_SIZE);
 	}
-	strlcat(buf, "\n", PAGE_SIZE);
+	strlcat(buf, "none\n", PAGE_SIZE);
 	mutex_unlock(&rng_mutex);
 
 	return strlen(buf);
@@ -537,8 +540,8 @@ int hwrng_register(struct hwrng *rng)
 	/* Adjust quality field to always have a proper value */
 	rng->quality = min_t(u16, min_t(u16, default_quality, 1024), rng->quality ?: 1024);
 
-	if (!current_rng ||
-	    (!cur_rng_set_by_user && rng->quality > current_rng->quality)) {
+	if (!cur_rng_set_by_user &&
+	    (!current_rng || rng->quality > current_rng->quality)) {
 		/*
 		 * Set new rng as current as the new rng source
 		 * provides better entropy quality and was not
-- 
2.51.0

