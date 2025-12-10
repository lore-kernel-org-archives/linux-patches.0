Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CA22765ED;
	Wed, 10 Dec 2025 06:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765348508; cv=none; b=UcdvsCzut1TXNJfCo9iEjokYPeB3nDcZq/rLRrlluD5Y4j3Xu5i0TpuO/+bDa0pgIUJvM2FWErS7Kv0jijD/VZR0Q2m9FnlMmtKfXmMh7gpbGERzIqqKZekjWV7px+bVs2aGJdQ/if9Vy/0j1SnsY3GfrLlfx7EyogE/0FzhkJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765348508; c=relaxed/simple;
	bh=2abPAY+96Y1qNcmycm/yEHvcX3RLzB0mV1G58gCEx1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2JlvqKZTvjMvcDvNbxtz0e3Yv33/LfYncxXoreUIcjRHGYGF/G3dxXLCOsrCQa5uhgWZ5U7lUx0X2I0fFaWB7XephDUIp1YqT7BZvogh/xCYx0/MEFXQRXNfYOTf21jQ5OQvLMTu3XnW9x6EAPD2WAS+veEa11tQRJ9oA9tdxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MQLJ3ytI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MQLJ3ytI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E387FC4CEF1;
	Wed, 10 Dec 2025 06:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765348505;
	bh=2abPAY+96Y1qNcmycm/yEHvcX3RLzB0mV1G58gCEx1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQLJ3ytIRVomsTQnMpfVWoZpUmR34enoP3tOgAyK5cG2rFwh8yb5FBtj5SJYWy/1w
	 I8Tx1Ak1kd+8QHd1BaedtAC2FnBqBtJmyfII9MgTLVW8I/OD3Tk+SqAkD0fderATxZ
	 MoRDOfL5i+C8sqvnZbAQ4lax9Yw6ZyCwfWhFGbFMN/gs8B+G1wM7ASjC2yPzN/LeJG
	 WYrXWKenHCp36vVuiTggA0Ucj6+0C4fiUAFn2XlJNuUZkv50lI2MsRAmL2qwZ7G6ig
	 PCUKN6dX4/L8qvWDagz89uWlSspiEdxPg8r2KYAtRQGwpkoNLAskZ7lwpamIo9MO7w
	 gaLBFVri23QSw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pei Xiao <xiaopei01@kylinos.cn>,
	kernel test robot <lkp@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	dixitparmar19@gmail.com
Subject: [PATCH AUTOSEL 6.18-6.1] iio: adc: ti_am335x_adc: Limit step_avg to valid range for gcc complains
Date: Wed, 10 Dec 2025 01:34:33 -0500
Message-ID: <20251210063446.2513466-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210063446.2513466-1-sashal@kernel.org>
References: <20251210063446.2513466-1-sashal@kernel.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit c9fb952360d0c78bbe98239bd6b702f05c2dbb31 ]

FIELD_PREP() checks that a value fits into the available bitfield, add a
check for step_avg to fix gcc complains.

which gcc complains about:
  drivers/iio/adc/ti_am335x_adc.c: In function 'tiadc_step_config':
  include/linux/compiler_types.h:572:38: error: call to
'__compiletime_assert_491' declared with attribute error: FIELD_PREP: value
too large for the field include/linux/mfd/ti_am335x_tscadc.h:58:29: note:
in expansion of macro 'FIELD_PREP'
    #define STEPCONFIG_AVG(val) FIELD_PREP(GENMASK(4, 2), (val))
                                ^~~~~~~~~~
drivers/iio/adc/ti_am335x_adc.c:127:17: note: in expansion of macro 'STEPCONFIG_AVG'
	stepconfig = STEPCONFIG_AVG(ffs(adc_dev->step_avg[i]) - 1)

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510102117.Jqxrw1vF-lkp@intel.com/
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I understand the full context:

**Key findings:**
- `STEPCONFIG_AVG(val)` uses `FIELD_PREP(GENMASK(4, 2), (val))` - a
  3-bit field
- `STEPCONFIG_AVG_16` = `STEPCONFIG_AVG(4)` = 16 (the register value)
- `step_avg[i]` stores the number of samples (1, 2, 4, 8, 16)
- The comparison `step_avg[i] <= STEPCONFIG_AVG_16` bounds step_avg to ≤
  16

### SUMMARY

| Criterion | Assessment |
|-----------|------------|
| **Type of fix** | BUILD FIX - compile error |
| **Size** | 1 line change |
| **Risk** | Very Low |
| **User impact** | Prevents kernel compilation failure |
| **Subsystem** | TI AM335x ADC (BeagleBone, embedded systems) |
| **Cc: stable** | No |
| **Fixes: tag** | No |
| **Reported-by** | Yes (kernel test robot) |

### ASSESSMENT

**Why this should be backported:**

1. **Build Fix Category**: This explicitly fixes a GCC compilation
   error. Build fixes are one of the allowed exception categories for
   stable trees because they prevent users from being able to compile
   the kernel at all.

2. **The Error is a Hard Failure**: The gcc error `error: call to
   '__compiletime_assert_491' declared with attribute error: FIELD_PREP:
   value too large for the field` is a hard compilation failure, not
   just a warning. Users with certain GCC versions/configurations cannot
   build the kernel with this driver enabled.

3. **Minimal Risk**: The fix simply adds a bounds check (`&&
   adc_dev->step_avg[i] <= STEPCONFIG_AVG_16`) to an existing condition.
   Invalid values now fall through to the else branch (default
   behavior), which is safe.

4. **No Functional Change for Valid Inputs**: For valid step_avg values
   (1, 2, 4, 8, 16), the behavior is identical. Only theoretically
   invalid values are now handled differently.

5. **Driver Exists in All Stable Trees**: The TI AM335x ADC driver has
   been in the kernel for years and exists in all active stable
   branches.

**Concerns:**
- No explicit `Cc: stable` tag
- No `Fixes:` tag
- The maintainer didn't specifically request backporting

However, the absence of these tags doesn't disqualify a build fix. Build
fixes are essential for kernel buildability and are routinely
backported.

The fix is obviously correct, small, contained, and addresses a real
build failure reported by the kernel test robot infrastructure. It meets
the stable kernel criteria for a build fix.

**YES**

 drivers/iio/adc/ti_am335x_adc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 99f274adc870d..a1a28584de930 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -123,7 +123,7 @@ static void tiadc_step_config(struct iio_dev *indio_dev)
 
 		chan = adc_dev->channel_line[i];
 
-		if (adc_dev->step_avg[i])
+		if (adc_dev->step_avg[i] && adc_dev->step_avg[i] <= STEPCONFIG_AVG_16)
 			stepconfig = STEPCONFIG_AVG(ffs(adc_dev->step_avg[i]) - 1) |
 				     STEPCONFIG_FIFO1;
 		else
-- 
2.51.0

