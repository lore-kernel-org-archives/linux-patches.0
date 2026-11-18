Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045773;
	b=bmsY5pcFj+oT70mHITHK1nKxz18B23zq27BbGtvxoRMeZaOXvfpQtc2uRJqvW4wu+sQs
	 THJBErpQCeCV76uSz4MAHdT87Kqnt5JVJmEUwzisiW1+yPm95ZuLgO3AAJ7IsReOWFERI
	 mKBJmtO6F71sG+YXS2EmkzpndXOC9PqgzeSaqOoOvHNQgl3TBBue0yKI22FMm0hqTjyhc
	 OvO/jiHq9jUvvxHgrcNl1cSSjolLPj+QhqDYl4avs4XX6+GwKNuAYE6QJqLdkr/JJT0ia
	 4+pELvq2AjuV4r2x6i9AuQcK2V1S/ovxubcNrtUA7WVw8FTX5cJOz7eJw58QrpmwwgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=djyyD6J0Kpt4JWH7oIAC7TsvSiqQxndB0wmraBwOZLc=;
	b=osRIcto1Umvst8M1xz+MOfTyujZgnjMWVQjk9M2OzWMFJa/x7+w9TvoG/d6C4pxKkKjw
	 SZjAV3H5IeLL2mUSzDnZlTJi/b6l2yvwr/n8GTaweiPSb9FAKhCXhFXqCGJLDlyILYymG
	 DmIWkKfHgI66YNUUO7wnDk92x5uQLL6oO9tdRPh1ZpkUKN7+pNzu1nqXW1/Pp8ZZoXpB8
	 B+WrtCTvHKqi2SEBj3qWyxNFzB20mHSdEdXZt/Y1z6gkckSuRWUhCQvAcLXwaRyBapu3V
	 MbH7YdpbWm1WJq6PzuhGFHRDRca9fkYVfsQYSwsj3qfcB35AVyYf0F/MdyspDIf+0Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U6/2sEsW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE88A606A31C;
	Wed, 18 Nov 2026 23:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U6/2sEsW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC271F000C4;
	Wed, 18 Nov 2026 23:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045773;
	bh=djyyD6J0Kpt4JWH7oIAC7TsvSiqQxndB0wmraBwOZLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6/2sEsWy2eD56ifpUDy/pgKUON5OVwt5v9/5adzpFniQX4x72RpueiXsE0A+ZUOe
	 XO44B4WFzrYABih96981USfV+Jx7RganvSH8Kk6wW3SMgQPo9wYRU3UeAlNsIFMLLZ
	 OhU9TasPNX6tx3YVGamBQrJZXj9qT2GPjrsR17TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1044/2857] time/namespace: Fix overflow when converting absolute deadlines
Date: Wed, 18 Nov 2026 15:34:38 +0100
Message-ID: <20261118150239.186314552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit d69cfd33b5a8d176124c564513b9ceb933595d93 ]

do_timens_ktime_to_host() subtracts the namespace offset from an absolute
deadline and clamps the result to [0, KTIME_MAX]. A negative offset can
make a large deadline overflow to a negative value. Since ktime_t is
signed and KTIME_MAX is its maximum value, the subsequent comparison
against KTIME_MAX can never detect this overflow.

For example, with a -1 second boottime offset, an absolute CLOCK_BOOTTIME
timerfd deadline of KTIME_MAX can expire immediately. An absolute
clock_nanosleep() using the same clock and deadline can also return
immediately instead of waiting.

The earlier tim < offset check already handles the lower bound. A
negative subtraction result in the remaining branch therefore indicates
overflow. Detect that result and clamp it to KTIME_MAX.

Fixes: 89dd8eecfe961 ("time: Add do_timens_ktime_to_host() helper")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020233433.20997-1-dennylin0707@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/namespace.c b/kernel/time/namespace.c
index 439a5e6f5ae4c..d0890c9f93470 100644
--- a/kernel/time/namespace.c
+++ b/kernel/time/namespace.c
@@ -49,7 +49,7 @@ ktime_t do_timens_ktime_to_host(clockid_t clockid, ktime_t tim,
 		tim = 0;
 	} else {
 		tim = ktime_sub(tim, offset);
-		if (unlikely(tim > KTIME_MAX))
+		if (unlikely(tim < 0))
 			tim = KTIME_MAX;
 	}
 
-- 
2.53.0



