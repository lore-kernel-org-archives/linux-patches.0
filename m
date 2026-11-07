Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065314;
	b=BcbHgUw5k0XqWwAzRiw6B3pakOGjQTt2ztWKvzMvabfvpcU6BhNVK8/3TLyvSMQOoATu
	 xMg/ahIQPPr6MDDenpfQLwTs9z3t/jEYN10502p0mLtZxiHptpAhtOaz9KjjbfWytgMFv
	 n5r5H+tX6q9KyHEsuaFw99hAsPwqe9Ukm0bUJXAOwjqoactPdDicIzjklolvSkrUa+9DG
	 i98Kf+1NV+t4BaCEoiEvMVwk/jtLgV7TdTjxUBxUBCSV24bVZ3mFm7r2j1X2NKhxFbsOl
	 ow7u0gsvqCaS4s2hQ1+m8p2KdQ5nwETvTGXPFeLdN5vzMEmfOFwcnCQng8QXzJyWVlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mh4elqeJ1JWnspvsgJn9iCllf7yZtH/3JAZQI96YxWQ=;
	b=EUP+6Dz5yYFKbUQ0fI4H2JI9hnh12E/nxO3TvpUBM+UVM8fPdEcNhR5eR+xtFoEgKmcO
	 ZiGR9D3TjnI674ixJ2S9TycyJGoZtVzakVM76bDDTL9EvMUYR43B/nsYPBCdQPtfcO4NZ
	 k7MzI9ZJOOxwfrl2CXgltX3kn+cNaIa77VOzQMZlefjoZvV0z69NQzISTenucmt4tmk5L
	 9bzpa3cYo26g+6NRs/V/Vcpr0WGunnHCXooxsEHx+yHtNyFDu0BEO8DE8cO71rWnGtGt7
	 BIm70krSU5qFeE94V94IqsMuqCTwcahWKFl8Sh8wZ526XrC26QoQAvB8+ICyBpm9pjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EMuuNfzy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF93606A32D;
	Sat,  7 Nov 2026 15:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EMuuNfzy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AAE1F0089F;
	Sat,  7 Nov 2026 15:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065314;
	bh=Mh4elqeJ1JWnspvsgJn9iCllf7yZtH/3JAZQI96YxWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EMuuNfzya43YHHKyOYn4xsvaSfBdZlyR7WUO/wVSNEjo02eTvCo3wgWhRXqzb6AzH
	 deZ1O/8mOJrcmGkKDuKI2+grDcujYpadKGlqX2dzv11Bj46JMc2lFUR+DT9C0N6zrd
	 Lsmqd0tSx8wVZgYx1L83CFnarTeCQnpQ3GMFQp/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1063/1257] compat: avoid double rounding in times()
Date: Sat,  7 Nov 2026 08:55:59 -0500
Message-ID: <20261107135008.637221933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 35b538ba843c7..755bfa5ccd92c 100644
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



