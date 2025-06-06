Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE88728A1F8;
	Fri,  6 Jun 2025 15:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224565; cv=none; b=gTpY6opVv4Pymd1kUoHh6qd6mpkX8YOE6bYymoolSdcRB86fqyaimcfugkSLjnkpu762yZRXHRwbde+jKyBBwHVw3timoD34IMewUHA8359+15bf24S87rSFe3wf+6znMnNG90xV8a86DFFfPD5s25TI6UjCLEK2nYLOFFv8a30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224565; c=relaxed/simple;
	bh=3JpeczwQLVI3xj5GeoUodGCtRP2PFojaoMV7mgOmhP0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=etKnGb7Z3iSgua4YqTB5EAyWLKywOcWFOAmnewggYNAArA+9A+m/igOvsJkXoRV7W/hn620oWwsp2rBiArCF03fsK0ARFkktIKZ/MMVLXaKvAItvVHabdGXqsWAhN1TBidxWKy0RUjTsgY5XBIIAd5sc9LjvUNRju2qVNx+ZniA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CXjdzHQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CXjdzHQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B813BC4CEEB;
	Fri,  6 Jun 2025 15:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224564;
	bh=3JpeczwQLVI3xj5GeoUodGCtRP2PFojaoMV7mgOmhP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXjdzHQpdQl1XFrcqq8ui6Xp7TuzWTHoFdPoL9P5bZ0lBOc7X8ZvERmsyLE5tz0eJ
	 T9xP/xZEBMwiRaVQugILa/EdM3jFxGrTFP7H5NwazCnNHOdkS1KlpqOuWhOxOU3HYv
	 esXM0ruMMtqZ2q4tz/RzANq4AiyWjmdOXQah6eSxm3CsdF2cyouuvQRV7PG4+T6wrs
	 hH6y/VR7JfW88ZwFbcdN4jKbPGIC/ABSZ0FD9JgGxQp93heM74GvIePcgOC2wpnb4W
	 /p78t/4sdsSZdDmtZ1Yb1GchBOPBDO2+Nz1KYMEZDGQ6IhNd6sIj9jjZKK8S9RTKrJ
	 FCeqaNCdbP2rA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yikai Tsai <yikai.tsai.wiwynn@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	mail@carsten-spiess.de,
	jdelvare@suse.com,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 13/19] hwmon: (isl28022) Fix current reading calculation
Date: Fri,  6 Jun 2025 11:42:19 -0400
Message-Id: <20250606154225.546969-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250606154225.546969-1-sashal@kernel.org>
References: <20250606154225.546969-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
Content-Transfer-Encoding: 8bit

From: Yikai Tsai <yikai.tsai.wiwynn@gmail.com>

[ Upstream commit b2446a16dbf2347a07af0cf994ca36576d94df77 ]

According to the ISL28022 datasheet, bit15 of the current register is
representing -32768. Fix the calculation to properly handle this bit,
ensuring correct measurements for negative values.

Signed-off-by: Yikai Tsai <yikai.tsai.wiwynn@gmail.com>
Link: https://lore.kernel.org/r/20250519084055.3787-2-yikai.tsai.wiwynn@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Now let me check for similar current register handling issues in other
hwmon drivers. Let me look at the commit to understand the exact issue:

Looking at the commit changes, I can see that:

**Before (broken):**
```c
*val = ((long)regval * 1250L * (long)data->gain) / (long)data->shunt;
```

**After (fixed):**
```c
u16 sign_bit;
sign_bit = (regval >> 15) & 0x01;
*val = (((long)(((u16)regval) & 0x7FFF) - (sign_bit * 32768)) * 1250L *
(long)data->gain) / (long)data->shunt;
```

The issue is that the ISL28022 current register is a 16-bit two's
complement signed integer where bit 15 represents the sign bit
(equivalent to -32768), but the original code was treating it as an
unsigned value.

Let me analyze based on the established criteria:

**Analysis:**

**YES - This commit should be backported to stable kernel trees.**

**Detailed Analysis:**

1. **Bug Fix Nature**: This is a clear bug fix that addresses incorrect
   current readings for negative values. According to the ISL28022
   datasheet mentioned in the commit, the current register (04h) is a
   16-bit two's complement value where bit 15 represents -32768, but the
   driver was treating it as unsigned.

2. **User Impact**: This bug significantly affects users who rely on
   accurate current measurements, especially when current flows in the
   negative direction. The bug would cause:
   - Incorrect reporting of negative currents as large positive values
   - Complete failure to detect reverse current flow
   - Invalid power calculations that depend on current readings

3. **Code Analysis**:
   - **Problem**: Lines 164-165 in
     `/home/sasha/linux/drivers/hwmon/isl28022.c:164-165` treat `regval`
     as unsigned, causing negative currents to be interpreted as large
     positive values
   - **Solution**: The fix properly implements sign extension by
     extracting bit 15 as the sign bit and manually computing the two's
     complement value: `(value & 0x7FFF) - (sign_bit * 32768)`
   - **Consistency**: The fix follows the exact same pattern already
     used in the shunt voltage reading function (`isl28022_read_in`) at
     lines 120-122, showing this is the established correct approach in
     this driver

4. **Risk Assessment**:
   - **Minimal Risk**: The change is very small and localized to the
     current reading calculation
   - **Well-Tested Pattern**: Uses the identical sign handling logic
     already proven correct in the shunt voltage function
   - **No Side Effects**: Only affects current register interpretation,
     doesn't change any other functionality

5. **Driver Context**:
   - The ISL28022 driver was introduced in October 2024 (commit
     39671a14df4f), making it relatively new
   - The driver is hardware-specific and contained within the hwmon
     subsystem
   - This follows the same pattern as other successful backports shown
     in the examples

6. **Comparison to Similar Commits**: This commit is nearly identical to
   the reference examples that were marked for backporting:
   - **Similar Commit #1** (ina2xx): Fixed sign extension for current
     register by adding `(s16)` cast
   - **Similar Commit #3** (tmp513): Fixed sign extension with
     `sign_extend32(regval, 15)` and type casting
   - **Similar Commit #4** (nct7904): Fixed sign extension by converting
     to `s8`
   - **Similar Commit #5** (ina3221): Fixed shunt sum register bit
     shifting

7. **Critical Subsystem**: Hardware monitoring is critical for system
   health monitoring, thermal management, and power management.
   Incorrect current readings could lead to improper system behavior or
   failure to detect dangerous conditions.

**Conclusion**: This is a textbook stable tree candidate - it fixes a
clear functional bug with minimal risk, follows established patterns,
and addresses a real user-impacting issue in hardware monitoring
functionality.

 drivers/hwmon/isl28022.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/isl28022.c b/drivers/hwmon/isl28022.c
index 3f9b4520b53ef..ed5a3ef1aef88 100644
--- a/drivers/hwmon/isl28022.c
+++ b/drivers/hwmon/isl28022.c
@@ -154,6 +154,7 @@ static int isl28022_read_current(struct device *dev, u32 attr, long *val)
 	struct isl28022_data *data = dev_get_drvdata(dev);
 	unsigned int regval;
 	int err;
+	u16 sign_bit;
 
 	switch (attr) {
 	case hwmon_curr_input:
@@ -161,8 +162,9 @@ static int isl28022_read_current(struct device *dev, u32 attr, long *val)
 				  ISL28022_REG_CURRENT, &regval);
 		if (err < 0)
 			return err;
-		*val = ((long)regval * 1250L * (long)data->gain) /
-			(long)data->shunt;
+		sign_bit = (regval >> 15) & 0x01;
+		*val = (((long)(((u16)regval) & 0x7FFF) - (sign_bit * 32768)) *
+			1250L * (long)data->gain) / (long)data->shunt;
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.39.5

