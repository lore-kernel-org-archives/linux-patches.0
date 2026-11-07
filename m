Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062550;
	b=bUnh8CXz1NQQX+zmqKoO1n2Um/R8RIlqVPyjZHvAnf9MLDoSWXZmqMX6Th2IznUxTYv7
	 c4T0ShNuMw5ITFZLZbP0b6G9uB8f1kfCVstvA/XP7TI6lsqRyZ3o5k4EV0Mccm2ned7a4
	 yVO5VQ36IqNjnBjMVuSMa05xzuss+8eSesn65X3QdjF+lZ7KgblG4Xhlum+uN76LBeRDY
	 6QO5XPJ1qhMDdtfKwqBGDUThN56t5q33RGtkBNFLxI/api0sYN2kIpmw6Sg4dCRHVrTLj
	 rqmZU5TzRj7+yBhXyjU/AvNjDYtnoHTA5F7CBLzfyWiIYS3g0EzdGfyPI0YUSF3kWKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TmmUp2RFiLaSMc8u8jjem5edC87R3icepKan116lSTk=;
	b=pKH1HzMojr+YTHHGkOTuTEZGc36oqcimU6X/ULA85Gq/FnREfoQMgNGUpzwLIAsrsYB0
	 NXTecEh7F4NWsCQHaayfxcqjMBCms6rG8MGcxTFBWzX9rE1ip5+Na/Jb/abgUxb7tPu8d
	 WxGB24F9nqQM4IcVTvUzeBGYmk7AWdlNPw/ShaVKrO8epYPpR8id7b0o6t9UXUnFT7X8V
	 xCQcgyd+qc3r0+90PIjMU/Hs1xNn29p6dN2DlbLhPibUL8ZQQo7V/jNW2JeqvM2VvlRh4
	 acIcffdALk8qCYrglkf7G8g2Wb8D9c/QkJmEp8S7lNnr/mhBwtwc36COmG1lP1RqfiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFa0XNdv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5E1606A33C;
	Sat,  7 Nov 2026 14:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFa0XNdv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD72F1F0089F;
	Sat,  7 Nov 2026 14:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062550;
	bh=TmmUp2RFiLaSMc8u8jjem5edC87R3icepKan116lSTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFa0XNdvm81PnBOEvTCWtolzm0y5P9I+tWegrIPrbaQA26Di6/qxuALn2tyvfB/36
	 Ok5mn8sVSLj4EVrrGsIAgCuI0QZ74UTcKJHiO9xyMbczMSIYpuiEn+4czhhQtxyop0
	 j8aCKVDOTmNuxslBlI94FALlTTUVCUsEdCi8ETF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1437/1536] compat: avoid double rounding in times()
Date: Sat,  7 Nov 2026 08:57:33 -0500
Message-ID: <20261107135038.197523227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6c870636ea73c..fe64ebfddf010 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1045,6 +1045,9 @@ SYSCALL_DEFINE1(times, struct tms __user *, tbuf)
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



