Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA24335BCE;
	Mon, 18 Aug 2025 13:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525311; cv=none; b=dbwQOVd+r14bbhoB8k7zRkkzkGijg7yMNYADyFS2soiTu5LezQXUEk6vCeNgvX8WWsuGBuQC0nvGph7Lm0VaHLntEKWsTHgqUmkTPx9eNoeyIagd0Qt2z66oC44i0YtN9hQdFqxds/zYFnw/dV356ZexA993JP4Trh+XRqNBfQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525311; c=relaxed/simple;
	bh=q0bTLkVPjtXQrBlcJ17odCev1FbnQMo8spvEjViagPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2C/42PuyhPgLvL5OmahPG0KslBhaWndiOSvHi0+Rz0OaLbzYgH9ls9NaRy5SyWN7uHe+suwnS+HnPG52V/gmyBEaz9pyDp37tZCr9mk7NKtzWvPjdV3BXZmVq9Eo4JKQKMH+3YEG1GUa2LTyfWp0jfuKcAD6ss+Q/hJnEgFFgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ox1koUlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ox1koUlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A79C4CEEB;
	Mon, 18 Aug 2025 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525310;
	bh=q0bTLkVPjtXQrBlcJ17odCev1FbnQMo8spvEjViagPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ox1koUlGHOC01xT2eLnaNsSFv7cAAJ7rCz0MzZDL9DOy5ZrihbdYJdcXqC5owi9xT
	 x26CAB8WA0xAkLEgg+bQUuUGvSi1QVCEgBaIPHL+CB8JAAfyHNVV27tvl+iw1ZS9kP
	 mdR6lGJwXSzZ30nJ5mgt0yl61F/di20V6eZzydVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 223/570] s390/time: Use monotonic clock in get_cycles()
Date: Mon, 18 Aug 2025 14:43:30 +0200
Message-ID: <20250818124514.403158799@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 09e7e29d2b49ba84bcefb3dc1657726d2de5bb24 ]

Otherwise the code might not work correctly when the clock
is changed.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/timex.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index bed8d0b5a282..59dfb8780f62 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -196,13 +196,6 @@ static inline unsigned long get_tod_clock_fast(void)
 	asm volatile("stckf %0" : "=Q" (clk) : : "cc");
 	return clk;
 }
-
-static inline cycles_t get_cycles(void)
-{
-	return (cycles_t) get_tod_clock() >> 2;
-}
-#define get_cycles get_cycles
-
 int get_phys_clock(unsigned long *clock);
 void init_cpu_timer(void);
 
@@ -230,6 +223,12 @@ static inline unsigned long get_tod_clock_monotonic(void)
 	return tod;
 }
 
+static inline cycles_t get_cycles(void)
+{
+	return (cycles_t)get_tod_clock_monotonic() >> 2;
+}
+#define get_cycles get_cycles
+
 /**
  * tod_to_ns - convert a TOD format value to nanoseconds
  * @todval: to be converted TOD format value
-- 
2.39.5



