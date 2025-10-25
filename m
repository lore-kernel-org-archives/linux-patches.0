Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045EF3093C0;
	Sat, 25 Oct 2025 16:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409377; cv=none; b=s+rc256f2vQPPzV4xaLxGNuVEuZZUUYwoPya/18roqf+F3MOev3/+sC57KQ30dZkmk93HH6VdvMQ1UWKtISkAsJJYGl2BBrxj0FMvUntjF5PtyEcaOogRWEK/bVh6njzBg0AGbze1vbu9XMGVeudFmSlgXX5MGM75whDGjU7d8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409377; c=relaxed/simple;
	bh=7Xua/PkJ2ZUgdoURScr9y/6c6x0YYmZ+qOXuNljxnFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hSG/yJHaT6elQ0T4gXMVdCylohGKKV+mc8uKvQtuzmJxstpZOfOdxPjUZiRj0yDUyNY1Haj4J1JRJMyf2bDvEcuCjCJ+59tkoVBnqyGbdtxCMEQ5zFfw+t/WJopBWO4FZjq+PUkCUgDiuhXwBv0jGijbSLsayhJy7yv40i8yLRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pkBfI/2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pkBfI/2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92102C4CEFF;
	Sat, 25 Oct 2025 16:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409376;
	bh=7Xua/PkJ2ZUgdoURScr9y/6c6x0YYmZ+qOXuNljxnFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkBfI/2tqHQtv05VQUbrwMLgGTMQkLh9k1jNhKOjmnbZJ+SnkWQIsTF7JvkYT3YFB
	 9+rQ5t6jlpG/lIKDu15zg1c0rCfsnDKm/zumXx0MKYRVGDLJ2ghd7AKvpRJ3Fv9HA1
	 m3e5EbOasYQQHoLw3EwINMYEpKGymVooOgJ+uSoA8FoHP5BQUn52dXJASIoe8Zg9DV
	 3Hd27+lvA++D3acSoo6I5+m+04M/yZb6z1ROkTbWiNEAee60F/a6DaXPtqS/doc17t
	 QjIGqZ0A9r1ynxCiWm0h4faiiEZ4NVxFrn2VR9+UftFWFXWbpEWY9E3/IRG+y2cid6
	 7/Ris+dLlyqYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Rinitha S <sx.rinitha@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	przemyslaw.kitszel@intel.com,
	intel-wired-lan@lists.osuosl.org
Subject: [PATCH AUTOSEL 6.17] ixgbe: reduce number of reads when getting OROM data
Date: Sat, 25 Oct 2025 11:58:47 -0400
Message-ID: <20251025160905.3857885-296-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit 08a1af326a80b88324acd73877db81ae927b1219 ]

Currently, during locating the CIVD section, the ixgbe driver loops
over the OROM area and at each iteration reads only OROM-datastruct-size
amount of data. This results in many small reads and is inefficient.

Optimize this by reading the entire OROM bank into memory once before
entering the loop. This significantly reduces the probing time.

Without this patch probing time may exceed over 25s, whereas with this
patch applied average time of probe is not greater than 5s.

without the patch:
[14:12:22] ixgbe: Copyright (c) 1999-2016 Intel Corporation.
[14:12:25] ixgbe 0000:21:00.0: Multiqueue Enabled: Rx Queue count = 63, Tx Queue count = 63 XDP Queue count = 0
[14:12:25] ixgbe 0000:21:00.0: 63.012 Gb/s available PCIe bandwidth (16.0 GT/s PCIe x4 link)
[14:12:26] ixgbe 0000:21:00.0: MAC: 7, PHY: 27, PBA No: N55484-001
[14:12:26] ixgbe 0000:21:00.0: 20:3a:43:09:3a:12
[14:12:26] ixgbe 0000:21:00.0: Intel(R) 10 Gigabit Network Connection
[14:12:50] ixgbe 0000:21:00.0 ens2f0np0: renamed from eth0

with the patch:
[14:18:18] ixgbe: Copyright (c) 1999-2016 Intel Corporation.
[14:18:19] ixgbe 0000:21:00.0: Multiqueue Enabled: Rx Queue count = 63, Tx Queue count = 63 XDP Queue count = 0
[14:18:19] ixgbe 0000:21:00.0: 63.012 Gb/s available PCIe bandwidth (16.0 GT/s PCIe x4 link)
[14:18:19] ixgbe 0000:21:00.0: MAC: 7, PHY: 27, PBA No: N55484-001
[14:18:19] ixgbe 0000:21:00.0: 20:3a:43:09:3a:12
[14:18:19] ixgbe 0000:21:00.0: Intel(R) 10 Gigabit Network Connection
[14:18:22] ixgbe 0000:21:00.0 ens2f0np0: renamed from eth0

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Reasoning and impact
- User-visible bug: The old implementation read only a small struct per
  512-byte step across the whole OROM, causing thousands of NVM
  transactions during probe. The commit reduces probe time dramatically
  (25s → ~5s), which is a real user-facing issue (long boot delays,
  timeouts). This is a performance bug fix, not a feature.
- Scope: The change is contained to the E610 flash/OROM probing path and
  limited to a single function in one file. No ABI, IO paths, or
  critical runtime datapaths are modified.

What changed in code
- Batch read OROM once:
  - Allocates a buffer of the OROM bank size (`orom_size =
    hw->flash.banks.orom_size`) and reads it in a single flat-NVM pass,
    then scans in memory instead of doing many small reads:
    drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:3010,
    drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:3015,
    drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:3020.
  - The read goes through `ixgbe_read_flash_module()` which holds the
    NVM resource once and uses `ixgbe_read_flat_nvm()` that already
    chunks reads to 4KB sectors, so this is supported and efficient:
    drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:2788,
    drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:3533.
- Search logic preserved, just done in-memory:
  - Scans 512-byte aligned offsets looking for “$CIV”, verifies a simple
    modulo-256 checksum over the CIVD struct, then copies the struct
    out: drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:3032,
    drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:3039,
    drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:3042.
  - The struct layout and size are defined here and verified with a
    `BUILD_BUG_ON` against 512 bytes:
    drivers/net/ethernet/intel/ixgbe/ixgbe_type_e610.h:929,
    drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:3036.
- Error semantics clarified and unchanged in behavior for callers:
  - Now explicitly returns -ENOMEM (allocation), -EIO (flash read),
    -EDOM (checksum), -ENODATA (not found), 0 on success; matching the
    documented behavior and typical expectations of
    `ixgbe_get_orom_ver_info()` which simply returns on error:
    drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:2992,
    drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:3134.
- The OROM size and offsets are sourced from Shadow RAM in 4KB units,
  already discovered via `ixgbe_determine_active_flash_banks()`:
  drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:2687,
  drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:2602.

Risk assessment
- Memory allocation: `kzalloc(orom_size, GFP_KERNEL)` allocates the OROM
  bank (typically small/hundreds of KB). It’s probe-time, immediately
  freed, and far less likely to fail under fragmentation. Even if
  -ENOMEM happens, failure behavior mirrors other probe-time allocations
  and cleanly propagates (and the previous code would then spend tens of
  seconds doing many I/Os).
- Locking/IO semantics: `ixgbe_read_flat_nvm()` already chunks to 4KB
  and is designed for larger flat reads. Holding the NVM resource once
  is safer and faster than many acquire/release cycles.
- Callers: The function feeds OROM version parsing
  (`ixgbe_get_orom_ver_info`) used during `ixgbe_get_flash_data` at
  probe; reducing time here improves user-visible driver bring-up time
  without changing logic:
  drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c:3345,
  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:11666.

Why it fits stable
- Fixes a significant user-impacting performance issue (probe delay
  ~25s).
- Minimal, localized code change without architectural impact.
- Maintains existing behavior and error handling expectations for
  callers.
- Limited to E610 hardware path; low regression surface.

Conclusion
- This is a well-scoped, low-risk performance bug fix that materially
  improves user experience during probe. It should be backported to
  stable.

 drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c | 59 +++++++++++++------
 1 file changed, 40 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c
index bfeef5b0b99d8..e5f0399657097 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c
@@ -3008,50 +3008,71 @@ static int ixgbe_get_nvm_srev(struct ixgbe_hw *hw,
  * Searches through the Option ROM flash contents to locate the CIVD data for
  * the image.
  *
- * Return: the exit code of the operation.
+ * Return: -ENOMEM when cannot allocate memory, -EDOM for checksum violation,
+ *	   -ENODATA when cannot find proper data, -EIO for faulty read or
+ *	   0 on success.
+ *
+ *	   On success @civd stores collected data.
  */
 static int
 ixgbe_get_orom_civd_data(struct ixgbe_hw *hw, enum ixgbe_bank_select bank,
 			 struct ixgbe_orom_civd_info *civd)
 {
-	struct ixgbe_orom_civd_info tmp;
+	u32 orom_size = hw->flash.banks.orom_size;
+	u8 *orom_data;
 	u32 offset;
 	int err;
 
+	orom_data = kzalloc(orom_size, GFP_KERNEL);
+	if (!orom_data)
+		return -ENOMEM;
+
+	err = ixgbe_read_flash_module(hw, bank,
+				      IXGBE_E610_SR_1ST_OROM_BANK_PTR, 0,
+				      orom_data, orom_size);
+	if (err) {
+		err = -EIO;
+		goto cleanup;
+	}
+
 	/* The CIVD section is located in the Option ROM aligned to 512 bytes.
 	 * The first 4 bytes must contain the ASCII characters "$CIV".
 	 * A simple modulo 256 sum of all of the bytes of the structure must
 	 * equal 0.
 	 */
-	for (offset = 0; (offset + SZ_512) <= hw->flash.banks.orom_size;
-	     offset += SZ_512) {
+	for (offset = 0; offset + SZ_512 <= orom_size; offset += SZ_512) {
+		struct ixgbe_orom_civd_info *tmp;
 		u8 sum = 0;
 		u32 i;
 
-		err = ixgbe_read_flash_module(hw, bank,
-					      IXGBE_E610_SR_1ST_OROM_BANK_PTR,
-					      offset,
-					      (u8 *)&tmp, sizeof(tmp));
-		if (err)
-			return err;
+		BUILD_BUG_ON(sizeof(*tmp) > SZ_512);
+
+		tmp = (struct ixgbe_orom_civd_info *)&orom_data[offset];
 
 		/* Skip forward until we find a matching signature */
-		if (memcmp(IXGBE_OROM_CIV_SIGNATURE, tmp.signature,
-			   sizeof(tmp.signature)))
+		if (memcmp(IXGBE_OROM_CIV_SIGNATURE, tmp->signature,
+			   sizeof(tmp->signature)))
 			continue;
 
 		/* Verify that the simple checksum is zero */
-		for (i = 0; i < sizeof(tmp); i++)
-			sum += ((u8 *)&tmp)[i];
+		for (i = 0; i < sizeof(*tmp); i++)
+			sum += ((u8 *)tmp)[i];
+
+		if (sum) {
+			err = -EDOM;
+			goto cleanup;
+		}
 
-		if (sum)
-			return -EDOM;
+		*civd = *tmp;
+		err = 0;
 
-		*civd = tmp;
-		return 0;
+		goto cleanup;
 	}
 
-	return -ENODATA;
+	err = -ENODATA;
+cleanup:
+	kfree(orom_data);
+	return err;
 }
 
 /**
-- 
2.51.0

