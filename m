Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036884;
	b=tY8HIyJX18FlJAtx8rXbda/EOgxpOgJ7syamtVKLCho8OvgfUgZnMiRVlvuwegZGDiIq
	 sknWf925R7E45JUt1ESE730LRzejWv8c5xXXEGJxGdwPuMhsw/1vJ4nzFDhucLqxzG2zQ
	 mfodIPOZ/0jlrj6R/nCZUODyaVwHM24yfBGMc5gw+8dDN6TPQrn9F0y4ySmbhL4JVaC18
	 C/PlAV+74eCkbx45ajnZoNidEHLuYv/b/z+Jo4TqkyDDKCwEhmtbjPthGF3s/zcPN5Pkr
	 KJFR7A+1tW707KcQQSyRa74b4wwz8HtChg0hzQSVjJ25lLCpia6a2eUX4+eKX8ikXDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VXi7UH++vtQ7rJaG/0X1vtJj4U+ZT7hSrgaw3wHGDVo=;
	b=NJujIqu38iDri53kgq/4wxKBaP7qo8N3WW5emMHFV5hckrWnzu2V6hD7HUeBcJkzu8tg
	 VVs+24HmnxZ25tTx+CqeE5ADsPyKWBZPJFixN5y1JjwtME5QAeiiqIDMIRuDuKP1zqMgY
	 9saq/2+lZhmDcD/vhO2/SGwOLisN3q9PvpIIEfEPi8oqlKkn9vtAN0DZ0UMdCWNTVxkaB
	 qsCgkmd11tCbImAi9nFBzv4M4mbf/k+BGgroMOPzUC4aZrm3tfEDo/prT3ayzk+vuz67G
	 25o2ckPnLMrf8tz8IgLgpir9y8a1bm2h61aUMKf241CYY88+AGhH9UFRxhS2270CDbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJsexTLV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD1E606A331;
	Wed, 18 Nov 2026 21:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJsexTLV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C29C1F000CA;
	Wed, 18 Nov 2026 21:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036884;
	bh=VXi7UH++vtQ7rJaG/0X1vtJj4U+ZT7hSrgaw3wHGDVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJsexTLVZsgyezqYn21S7kvsGfgrWl3BOoPSaT7gU0HzoanJIbAyFZe+VVp3b0dGM
	 CpmEv4xeuIDcSun/5fhbMpjyW2KvWSe0sWkoDXhGWBNPDhleSJAR9nJeHneglpJ8i5
	 EiN7eEigqPTSW/HlGAWSKMb5BomD4pXdVEVz/sPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1217/3318] compat: avoid double rounding in times()
Date: Wed, 18 Nov 2026 15:30:39 +0100
Message-ID: <20261118150356.687231406@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 6b30c39a5e333cfb1475acf0f73de6ef954eea8a ]

do_sys_times() already converts CPU time to USER_HZ ticks.  The compat
path converts each value back to jiffies before converting it to
COMPAT_USER_HZ.  This round trip can lose precision even when the two
userspace rates match.

With HZ=250 and USER_HZ=COMPAT_USER_HZ=100, one user tick becomes two
jiffies and then zero compat ticks.  Every odd tick count loses one tick,
so any of the four tms fields can underreport CPU time by an additional 10
ms.

Return the value directly when the native and compat units match.  Keep
the existing conversion for differing rates.

Link: https://lore.kernel.org/20261020210157.52057-1-dennylin0707@gmail.com
Fixes: f06febc96ba8 ("timers: fix itimer/many thread hang")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sys.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sys.c b/kernel/sys.c
index 7465bb7c89193..04bd93528ab39 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1036,6 +1036,9 @@ SYSCALL_DEFINE1(times, struct tms __user *, tbuf)
 #ifdef CONFIG_COMPAT
 static compat_clock_t clock_t_to_compat_clock_t(clock_t x)
 {
+	if (USER_HZ == COMPAT_USER_HZ)
+		return x;
+
 	return compat_jiffies_to_clock_t(clock_t_to_jiffies(x));
 }
 
-- 
2.53.0



