Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058764;
	b=kzZrw2g8DdtzPpOCh7lcO61IxTzb7wjxQjYqEl0K44DiP9vrlLN+KyiNIyAR1FKfsC0u
	 Tb7i10YUlzY+1kY3E36N842BjXaN54T8z/p/jd33DvHiD5+IJGtjrmivk2RIeYClJhghg
	 mx29QI7/T/7ElumctJELoM310TJgtN0qdr1JZ3oBxJE+SLwkW6D/+gqk6RHqeFZ3utSPM
	 hy0tJqHGfgTrCNQRb+kcFzJxhOQEm7deSt3BebP8YDSiKt+boEulKcX33zulwOHQF14ed
	 eAwEFtH/NPan2QV/tGxbRuGfrmKKlBO7zufwmkRCy7iCm94naHSQ5XjxZPPbmnRsYQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8t3WfXLjyl1C/UzzWviK+l0BzncPob3ByDO0cqlLtVQ=;
	b=mRquL8TcN8PpLsoZ3HhWuc/Na6mR93PL5ydMNP0Sq4ZW674M0Cl4yNXVZQpYmlRpOwlf
	 dz/xgVhbJCGRKEgV9NmGuxOq6CTpVa7mW2iN1guVS4YP6zJEnlmEfuidclHwBqiqJH68X
	 2camG2bQxs0HpbYb6raJ+rpywcivbbscULgi2eCw8Ip8hcFYlX9D258nkJAm3QqL/B7yV
	 eJ5gKD+ARa/+mGH36vy/UFFktZPFEPKpsNoj0F+ADJWz7tI7mPQJzjBP3mfwNoDmoujSo
	 6XPznscjtgFnTWn8nty5QyvpIqsPFALgeWynw61YU8R0tkg6OBrKVxsFG/nobDWGP9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVxqnnTo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314E4606A31C;
	Thu, 19 Nov 2026 03:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVxqnnTo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0AF1F000C4;
	Thu, 19 Nov 2026 03:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058764;
	bh=8t3WfXLjyl1C/UzzWviK+l0BzncPob3ByDO0cqlLtVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVxqnnToIn3T6GgGNzywHIsnHGVKHTpWJzqmv7O33GAnfZjTcZdxuAkO35akPxQK8
	 rVobsAlZDii6x2zvdmw46lAXFo0y4cNDUwN+ldUpjHomOFAEiHYMaKqMXrjO7OeZK4
	 Kt32OKYxzI9pdW3KY/095AHg/Gcs5HTH+O8ulE/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0575/1848] time/namespace: Fix overflow when converting absolute deadlines
Date: Wed, 18 Nov 2026 15:43:33 +0100
Message-ID: <20261118145939.195652913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index afc65e6be33e4..82abbeb96f204 100644
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



