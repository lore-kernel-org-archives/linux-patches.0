Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5260C2D9497;
	Tue, 11 Nov 2025 01:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824067; cv=none; b=ZQHRkhrfZQXXWEhc61bgwilccfyAAqlrWHfNI6oIN2CEUqUiNkYMqXVWsjtpZRBU/YaOQyeuSk+9I8gX/lz7mFnaPFCQJKWwl1OnSrecirRK4XUThSSCGlRf5hMdHRMrCVGSEA1CL2yEK9hKPFbP4YGWxvm6m3O+kOn9o7nxG+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824067; c=relaxed/simple;
	bh=wr3ZarjXOGGbeWbj8QBMAT91SEAdaFSil4L/MLwywnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0mWtmRPEs8MqXxPTEivvOJ4HMxS+3PAh5fdC9z3ejC84CQi/o5kiAKzWy8eAu3/CrlYHc7hRHPhnLJ4K3zNA+NNpntENhHF6HPJf3d6i2zE5MTc0llQ8m7ftObf/TGSLuVjXkyPA+2mqsyCMJWl2njHjIbRXxbBVs0K80wNwhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjupI+zu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjupI+zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03EFC4CEFB;
	Tue, 11 Nov 2025 01:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824067;
	bh=wr3ZarjXOGGbeWbj8QBMAT91SEAdaFSil4L/MLwywnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjupI+zu43umquuBfzRokORDuYYsBWUifQb8s8pHbtuFo9G5B6kJ2Y3GuMOFlSw1h
	 LjrLCjmhiQ7I5K14CfJiFt5lnpx3cOEj+qx3lnHmC8hUx/6RtBkyekAkQXiK6UoujM
	 ZxvqV0lJU7sZ6kkJVVPVuul4LSfKrWaDGVM1EbiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.17 430/849] ixgbe: reduce number of reads when getting OROM data
Date: Tue, 11 Nov 2025 09:40:00 +0900
Message-ID: <20251111004546.829815006@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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



