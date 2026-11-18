Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055562;
	b=duIR+lSy5/Ko4prcrWrS1xgHuFRseW3G7g+T0gV1H0u/8PHW8VRPcGRFYPh1Wz/vjag9
	 OAc1Iv4jygG+H9kBFX6OBwGWh05IxPbC1FID/+wJi54T7ign8TdxzFFmChMeJWp/8cc8x
	 DVuwf1u6WnerDA0UsWiDlVDoyovXlSrtvJzgdaBwr+8gxUmTZdKknTyXDYoYUh4zsQuUB
	 FTJx+jPbg6WSMMeMYkwfwsKwgzyxOzaFeGepCNJvgNXL0qEG8s8GC81sEQ585e69Qfy0J
	 nsMctsr1Tv9aAdTV9i4bJJ/9Siz4IAFSkcByXlJLT8JUube7MVrWG94y8UXoPBgoViQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Cu8CG2YFQUeos9MyHpukxm5QNVXOoE75gRDF/yWumss=;
	b=c4eyps+25IMyNwAWwftphnSPb8IfUotg61SBa0KyUWZ5wRKNLE1l3g4Y0Hk06VSVgHzI
	 6Hefh6smLv2sFkVsLoV/1305h2fQglloLB/nc+NnjhrLUxKYhCdJoV6dY5jOeRojZzkl4
	 IztGBmnP7Z0Ql/5h6YuuIGMdyhv7/TXnKQa2iowkMdziKrHY5RjlMtRwxPiTAyaKaasgu
	 K7HSkkCbVcCNEPIATp9ldBJVGt1AV3wGZF/PmOwu4NrAr3+SaHK1P08w8eoIEIuXgA+dt
	 oEMnDRfxDTrnv4E+f1XBklJF+55j4p34SIj+akFspcucSfWY74DFlQGwXTNoNcJVt7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qa4qwnAr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34AE606A338;
	Thu, 19 Nov 2026 02:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qa4qwnAr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26241F000C4;
	Thu, 19 Nov 2026 02:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055562;
	bh=Cu8CG2YFQUeos9MyHpukxm5QNVXOoE75gRDF/yWumss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qa4qwnArMtth1z2+qwYiIHEX05GIukh7MTxC8XgwnwYb4swWREBRTmHXEir82K3DX
	 yAFatGonJd8ErEeRXQLNB2lZEPN5luPUCIOKujAJcJT/JVvAwvh+MfTpf/WeWkfm5Z
	 sNrXVPvkoZpuf5YRTvXTSq57S4QLK8vCZNA0S7Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1675/2214] time: Prevent time64_to_tm() day truncation on 32-bit
Date: Wed, 18 Nov 2026 15:55:51 +0100
Message-ID: <20261118150118.842706579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 2927f7ca78448781e11a4623d347cd653c28adf6 ]

time64_to_tm() accepts a 64-bit seconds value, but stores the quotient in
long. On a 32-bit kernel the day count therefore wraps when it reaches
2^31, even though the corresponding year remains representable in
struct tm.

This is reachable when formatting externally supplied timestamps. For
example, NILFS recovery copies the little-endian 64-bit ss_create field
from an on-disk segment summary into time64_t. Its sysfs attributes then
print that value with %ptTs, whose formatter calls time64_to_tm(). A
corrupted image can consequently produce an architecture-dependent printed
date.

Keep the day quotient in s64 while leaving the seconds-within-day remainder
as long. Use div_s64_rem() for the weekday calculation so 32-bit builds do
not require compiler runtime division helpers.

Fixes: e6c2682a1da3 ("time: Add time64_to_tm()")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: LLM
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20260925165702.51677-2-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timeconv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timeconv.c b/kernel/time/timeconv.c
index 59b922c826e77..aed3af950fa0b 100644
--- a/kernel/time/timeconv.c
+++ b/kernel/time/timeconv.c
@@ -49,8 +49,9 @@ void time64_to_tm(time64_t totalsecs, int offset, struct tm *result)
 	u32 u32tmp, day_of_century, year_of_century, day_of_year, month, day;
 	u64 u64tmp, udays, century, year;
 	bool is_Jan_or_Feb, is_leap_year;
-	long days, rem;
 	int remainder;
+	long rem;
+	s64 days;
 
 	days = div_s64_rem(totalsecs, SECS_PER_DAY, &remainder);
 	rem = remainder;
@@ -70,7 +71,8 @@ void time64_to_tm(time64_t totalsecs, int offset, struct tm *result)
 	result->tm_sec = rem % 60;
 
 	/* January 1, 1970 was a Thursday. */
-	result->tm_wday = (4 + days) % 7;
+	div_s64_rem(days + 4, 7, &remainder);
+	result->tm_wday = remainder;
 	if (result->tm_wday < 0)
 		result->tm_wday += 7;
 
-- 
2.53.0



