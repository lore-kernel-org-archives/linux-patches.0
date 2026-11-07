Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063616;
	b=sm7kLWdsYR4gXk4q0KFhOY4hEKcJVAIRioX2v3ZnCtCpwnDH8F5OlYre7fUfztsq6sRE
	 qfngH+ugmZijj0fZoHoPulFDoBySO7hm+BCgwz8cemwWtyV/x9gluwzy/rrrEeRnm7LSQ
	 4fP5aIQ7gtGrupRWYm1EdlXmIvb4T40azVcF+tD3gh88e19Bw9wLd48fuDBUejtyKKN7W
	 +bwBBLr4GpsA+iVNqphJX47aw3v5A1PxBTeYa9d649AIrO7j6Iy1B1F05JKXcYJKOCY6s
	 d/hP2sEJl6r2yxgdvfVTS59oz/ob/VvikQlM8akzqyaVrgShsx2q7DRFJq/U7tkdcCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EuwknmXehDX1nw6S2UH1y2kRkut7NWv6kwgTSN83SIE=;
	b=tSaPm/t0eR4222PNixElPnFycC8cL52YS449R2R0PO8icL766BgRJhOoYEg89mhr48Os
	 Q7OGlcRj/Q3HK0jx55E133kSnSZutj4Eaqc4WjJN9VQx9bQ+0iTc9YjkT+0GaLpN6Haf4
	 H4ITFLoVKiWHKYlxf4qAw5ni3UCHCYscEyL43+0HAzJLwJlbSoT2zXTlwBp9WwIAvxWek
	 i3rH5fKFxysdMQcam5uNNKauUMiibBLEE58X9gi6bgTv2HSiBaE6zpZJLlBwEkZPfkPrL
	 gVfhH+LIBN72/FbmjnX//nx+zRq+gqMVUOnmR/nIk1ag7TgIJ7k26k1OgDP8d4CiHYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zM43aaSR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FEC6082BEA;
	Sat,  7 Nov 2026 15:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zM43aaSR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DAE1F0089F;
	Sat,  7 Nov 2026 15:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063616;
	bh=EuwknmXehDX1nw6S2UH1y2kRkut7NWv6kwgTSN83SIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zM43aaSRfBTcUImUHsNUF8NpbUuJzlQysrBOrBew84j22mTGl62HMqqbCpYStXYUM
	 kBSqlWw9wzTlBkZ44A+M4+yZua8zblFmhWEW0jCesSchEfvdlz/GMfTgGCKQXPwZJ+
	 SEu1o1KRcmFnfNwIkL1gYMiuagD7LJZrvSR5gMXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 737/869] compat: avoid double rounding in times()
Date: Sat,  7 Nov 2026 08:56:59 -0500
Message-ID: <20261107134917.818132631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c8376d7a0741b..bc89bd1331119 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1077,6 +1077,9 @@ SYSCALL_DEFINE1(times, struct tms __user *, tbuf)
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



