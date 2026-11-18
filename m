Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040447;
	b=Kylz84vvw4/VfR4myZPtWTx8EgZ7xE20mDdMRxkb0ZI3KTqej8Mf9/xePKHC1JZIb8M9
	 X7BwOHybElntgZNaPenKptjTjRegJ7V9WAnpMr0aDjYXzD0EBoP2SJ4Ti+QAnsbJkJP3D
	 MjlAPOCDD3nTMwIQTh0nmRAe/iUm5CZ1mgCKi/NlkYCuEwTDernfbwMYQ9VKHmv+Cc2TX
	 /A74MYvpQUmBEpLIz0kd4+jsT9Q4jfGP3mZfxnvUIGbOuV4JixYA3fX9l1nlO5nk3Z8Gm
	 ljdN7MQhCUcTIdSX+Ew1EichlWhlMpHOWqeNexL5MVEU8Sr5V+sB6lD5UyeGW22G9sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=89tWSFTEnMDwSx+IUiQ6ScP59zVwx4OeFJLNoILDigg=;
	b=KbhwZCHcnqOTEy2gKyfJ8b1hlknu3PrzkTC6Iz3ybM1p4K+/i7dGJWeKsO2+jzrm/aZg
	 GgCLaGuZxAHvuoid20rWV5SoPW4pp7jUuzm/phdhJK5XwDrnRcmZ/5w5vJNpQlZjNj6Wb
	 O7Fjeeh1WfF4052SwE8JDNJyYSroOSBEeKg3BRiGMBtWhezI5tNM4lKVS5/+THvUNp3zS
	 l11D7EwRAfdU2nJXy9IHFhnt3yPMJPBmzrWHzWeh5sU4PWhr8919gOE1KcPoULs+gU7WO
	 Y5vC0z2tEqQiAgN/ZdVGWnhSJ8DQkpibBCuBaYJCQnu0xoB04AwEX0F6zq7dLNTjOqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZMyJNdHs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147E5606A32A;
	Wed, 18 Nov 2026 22:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZMyJNdHs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BC91F000C4;
	Wed, 18 Nov 2026 22:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040446;
	bh=89tWSFTEnMDwSx+IUiQ6ScP59zVwx4OeFJLNoILDigg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMyJNdHs4rIKKtpFll4bpECFOcBLbQxeRcjvAOnlQYJjvQ6ppSIu1yshE8DR64kxF
	 VjGYsq6AKe0B8Eu6w0Lez08qxEl38DBMsEUa7/eVXqyTqIDRT+MjwYahbtjdFI53BS
	 0uTkGtS670zeS+VTgHf67y96WSSURdlFwjyQI/ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2461/3318] time: Prevent time64_to_tm() day truncation on 32-bit
Date: Wed, 18 Nov 2026 15:51:23 +0100
Message-ID: <20261118150435.261068670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



