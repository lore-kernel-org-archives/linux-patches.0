Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED5731F9BE;
	Wed, 20 May 2026 16:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295109; cv=none; b=tfbCT6b7PYW9lCXBSSC+Q8hEURiKc6kmG9rtrzJcT/eqJyIWALfNw73uxOn7WbkUVQzXH1FqYYf6cKUhl43PxVOs0sMP5ogk1SVvLrq16c9B4AGZBJ6fbYLFW2ZhFmUtaz/6rb91+ZYAlliZ5WsCLhozSQ5Ef6oYhNdZuYm1te4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295109; c=relaxed/simple;
	bh=zVqggzhwyfBQillqcW7/XxHUjF9xjH5VicIvIULKwS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/ZEpWCfCt7gyum/S8irLhxn8i3M3Tc0IMQaSOd5NNHWKtNIG2Lv5rI9AH5N/ibu7wsUhFwxe+GiBd+zFmMvsCWu1zwrCg7UudgKaKXKUwf/kdy58CzZ8CYA69stpxZrP5u+irOGh84SrzKnL1jNUrnNPsPwZoQJTOOeNbAamxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXc+CjjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXc+CjjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265C91F000E9;
	Wed, 20 May 2026 16:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295108;
	bh=2je1IGOMtO/3uLiimTP6wnTOYeU9RArtDAYZjqzBnMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IXc+CjjWDcZAsKm9Me5UGI5zAlcgzSwJhNvCOwB3iBHczP7jq2+1RxU27pc+yI3Bp
	 f3QlIhmB1GS4AaiLCyo+iAo4NeVf9zBpOBdvLzstOBGHhUIu3lOcLK42Odivs52VmB
	 BE27eB9w+aGNOEJRxuLGF4DZeYw8iYApqwzjyw/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0257/1146] drm/amd/ras: Fix type size of remainder argument
Date: Wed, 20 May 2026 18:08:27 +0200
Message-ID: <20260520162154.048305386@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 9f3d543a9f7371622aff389e69010ac6bac69ef8 ]

Forcing an int to be dereferenced at uint64_t for div64_u64_rem() runs
the risk of endian confusion and stack overflowing writes. Seen while
preparing to enable -Warray-bounds globally:

In file included from ../arch/x86/include/asm/processor.h:35,
                 from ../include/linux/sched.h:13,
                 from ../include/linux/ratelimit.h:6,
                 from ../include/linux/dev_printk.h:16,
                 from ../drivers/gpu/drm/amd/amdgpu/../ras/ras_mgr/ras_sys.h:29,
                 from ../drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras.h:27,
                 from ../drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_core.c:24:
In function 'div64_u64_rem',
    inlined from 'ras_core_convert_timestamp_to_time' at ../drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_core.c:72:9:
../include/linux/math64.h:56:20: error: array subscript 'u64 {aka long long unsigned int}[0]' is partly outside array bounds of 'int[1]' [-Werror=array-bounds=]
   56 |         *remainder = dividend % divisor;
      |         ~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
../drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_core.c: In function 'ras_core_convert_timestamp_to_time':
../drivers/gpu/drm/amd/amdgpu/../ras/rascore/ras_core.c:70:19: note: object 'remaining_seconds' of size 4
   70 |         int days, remaining_seconds;
      |                   ^~~~~~~~~~~~~~~~~

Use a 64-bit type for the remainder calculation, but leave
remaining_seconds as 32-bit to avoid 64-bit division later. The value of
remainder will always be less than seconds_per_day, so there's no
truncation risk.

Fixes: ace232eff50e ("drm/amdgpu: Add ras module files into amdgpu")
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/ras/rascore/ras_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/ras/rascore/ras_core.c b/drivers/gpu/drm/amd/ras/rascore/ras_core.c
index 3f56f26abd6da..9df05b3963edb 100644
--- a/drivers/gpu/drm/amd/ras/rascore/ras_core.c
+++ b/drivers/gpu/drm/amd/ras/rascore/ras_core.c
@@ -62,14 +62,16 @@ int ras_core_convert_timestamp_to_time(struct ras_core_context *ras_core,
 			uint64_t timestamp, struct ras_time *tm)
 {
 	int days_in_month[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
-	uint64_t month = 0, day = 0, hour = 0, minute = 0, second = 0;
+	uint64_t month = 0, day = 0, hour = 0, minute = 0, second = 0, remainder;
 	uint32_t year = 0;
 	int seconds_per_day = 24 * 60 * 60;
 	int seconds_per_hour = 60 * 60;
 	int seconds_per_minute = 60;
 	int days, remaining_seconds;
 
-	days = div64_u64_rem(timestamp, seconds_per_day, (uint64_t *)&remaining_seconds);
+	days = div64_u64_rem(timestamp, seconds_per_day, &remainder);
+	/* remainder will always be less than seconds_per_day. */
+	remaining_seconds = remainder;
 
 	/* utc_timestamp follows the Unix epoch */
 	year = 1970;
-- 
2.53.0



