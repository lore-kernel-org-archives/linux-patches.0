Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2D43218CF;
	Mon, 18 Aug 2025 12:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521960; cv=none; b=Lvn0gEkOiZmDyyZJ8t+e1lw1lrgKHV0ZUd6wvWQPz73aMIzNy27E2WyzMtAFKuIYOaBDn7TX5RPm5IEec2Od7+psTG5fCXognqUP/eak1gvX8JMT2cmBWxnDqwd5kFdUuUaQsiz9+vVyAr3vhDtzwWFAqtq07DIoRMNrYPgcnvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521960; c=relaxed/simple;
	bh=/y/8wgBwhrwOXHikcxvpv9hNEjb8S5n0GI2oIrcoruk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0/JPH4Jn8QtVTH7k9bW6HB//3EjvXwHnXX6xuaWQpgiA8B3AAT3SShJTd7l4rsgii9qhymYN3UMXADHc8C0Dw+JToCVYn4t/SjkO6ugRpxsdoxI/++f9nZ+/TJOC6DlUGB2sy3AlscpZctvxForvcKBEqx1fo+V3Qjj9y9nJE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iO2kT3Fy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iO2kT3Fy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB3CC4CEEB;
	Mon, 18 Aug 2025 12:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521960;
	bh=/y/8wgBwhrwOXHikcxvpv9hNEjb8S5n0GI2oIrcoruk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iO2kT3FyIyz/YA5wYq0bMYCDPFzyobg2CMpOeDni52/93xQoWl0J+NPhasadeHHyB
	 9tVF//up4I9VD96P07e9hleUTtlSfbsXZVimEgtCPAhg11/7aJ311zfIdS85oKUMqB
	 sZT9Xja18hVonhNw2waKUoGAtcYTLMmceqnJms+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/444] s390/time: Use monotonic clock in get_cycles()
Date: Mon, 18 Aug 2025 14:43:19 +0200
Message-ID: <20250818124455.370586448@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 640901f2fbc3..811ec531954b 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -192,13 +192,6 @@ static inline unsigned long get_tod_clock_fast(void)
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
 
@@ -226,6 +219,12 @@ static inline unsigned long get_tod_clock_monotonic(void)
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



