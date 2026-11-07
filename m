Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062568;
	b=a1uEmea8l8Ub2Ygo19cwWNBsnUcavSubaiq95skBRA/QWmPcWXQBd4Vr9c9i73oLrXvp
	 a0HJGfVSzswmJi5AWH853bO4hacAXaAEhf51MKr8npg2dbTCm9lYoXpw7MrPpsTM+RWFg
	 w2KHl84gAkQRQ7BzgaMsIaAGYzc80G9s4VZAOURXsq4iNe2DYqmkakT4xFGEeVFE3wdAi
	 Faad8z4flSXx+EzpBi6Qwy7DYU52jCYMLdES+dL7InCfScbvwZD3/plQcaKRef7WGdAMn
	 w2JGVetjJp91zwd9OtU+Bj1nLaQqS0iECgofYk5kOJf4pa5vVjooDMu/MjJE85+WNmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wzRdEkQh+7EEAZFfU4256yf3qeJA1tPc8c2QdUZMLrc=;
	b=1tfP+91OTuWnewXRRqiwXlu0K4/e7kXxqP0y7n9CmZnTWa3PJoJn6Pya0njola+yDfR1
	 Hx5aWX2vJWrX+37XwBruF+YxaH5qbY0+S3mEdH8X0LwrNG6OShczRJwHlRu5PXDN9cfmO
	 cThkEwLDTgS7RPwc2aCm0QQ6pV567xcBw6sE780OAdFT+Gn6we4zXpjpohM2Uvtnfmw0O
	 MYsMrpum/F/+GLpUzozIpSDhUHtcJy0X80huQ9R2kVBUJIj2wY94JosACNNR+BhJopf5f
	 3hyQ4p0IgdoJNuEUn8l86ds5obY0Xt2Ch7UVL8QDrq6Nr96xr9h+rmRGqqF86meqF8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="S/Mhd5XR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81209606A65B;
	Sat,  7 Nov 2026 14:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S/Mhd5XR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3028D1F0089F;
	Sat,  7 Nov 2026 14:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062568;
	bh=wzRdEkQh+7EEAZFfU4256yf3qeJA1tPc8c2QdUZMLrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/Mhd5XR7k0Jl8GygEeXrHV+fr+9/SxDyLIQYHbe4IOSEbmQ4YMDBKBeDJT1BGAUc
	 PzNvCevYmXFDGX2dFqyh6leRobOaxvSQj7raNOSuqhj8MAVl57jJX8fWsN1i6rinbc
	 hHcBypAy3wn2tHyr7K+CkSKi5oifJvd1VwZeUDWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1452/1536] time/namespace: Fix overflow when converting absolute deadlines
Date: Sat,  7 Nov 2026 08:57:48 -0500
Message-ID: <20261107135038.620411155@linuxfoundation.org>
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
index 09a4cc85a9fbc..c7782f6f272ac 100644
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



