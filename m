Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065478;
	b=oqMWNY4GMYwrYWosoirddIFhR/RhGoI/wndvLgir0Bi48KYSKTXL0mWSm2VLzVRx6PVm
	 6KmZzCf4dM/uvAdL/ZtxE9cJK6wQuM1bc8JlkltAskF+XWjlohVYjWb5Rz1JfFxnvjNCy
	 FoTcloYxq05wI1W0J67QJzZ4Y4Z6+7d0qUF1KymM7v1chsyM6Bh7Ny3O+B+gfcVFytf4N
	 5puCo/nyEMt9Cnbdy+cZMhjyQdQHv9AgsEs9XlqjGeiq0flKFYdo5XDPS8L9nzvP4TsvH
	 gP6H2W83fm1LNlyCN5s4QF1sesUE5VDnig1WvBY1Szp5BFtuB2+7y4PhwHlpmBLVS8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=erNTJRjiVbB9Djl3/lrsADL5GyxhsxLF3gSPQe//rGI=;
	b=c3QR7VEBTx/kFp6Lq3SPvjCkjdNnQLm98KbS5vjRZDX6IQoLGJ8NR8q60SuzsrMVTsuv
	 9/SmKImbqPrfaGGUdsbZvCPsm4qlxgzFIr3wclMdsSJgSDCeb8HxafvAcXcCyuxPuMNTT
	 27K/zaMPmeJeLEGo+wEupDK0QJ2ZNb390b+0qGzxYwbvf+wz+OaeZrKuKVBnMG3nNlg6I
	 VoKUHZW5JMU52eG9kqU5019GFT3/PxHXFxUNHMxPts36qccU61EztYgoj6y8a0/RSVT5J
	 vV+1zGrapYcVHBUzWhd8KqSoYNe+OIQ4K523ri+lhHcLcXeBpHqVsaFSzXPAl23EfeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qm9G7Y+z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A940606A330;
	Sat,  7 Nov 2026 15:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qm9G7Y+z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169481F0089F;
	Sat,  7 Nov 2026 15:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065478;
	bh=erNTJRjiVbB9Djl3/lrsADL5GyxhsxLF3gSPQe//rGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qm9G7Y+zwjMgx3UUDAakxLvrKtid5eeCjwJY6A2K1AkLyJoAyPnVrIhvyu2ReOfqX
	 4moa4jw7QPLxM8Dfn5e+YOQCn8H4bJrD9c2FGppmUUq4opjV8EDP8bZtWQOoLIkjC7
	 03Ch82m54CEm7CWWHLPgriGpG3ivC2ZzWJwDplWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1174/1257] clocksource: Prevent immediate watchdog rerun after a delay
Date: Sat,  7 Nov 2026 08:57:50 -0500
Message-ID: <20261107135011.603125710@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit f322d7f7ae56bce728ba03a387e35380bc4ad939 ]

The watchdog rewrite made the clocksource check handle long intervals
between two measurements, but missed that the timer expiry needs to be
rebased after such a delay.

When a watchdog invocation is delayed by more than one interval, adding
WATCHDOG_INTERVAL to the previous expiry leaves the timer expiry in the
past. That causes an immediate second invocation. The resulting short
measurement interval can mark a clocksource unstable.

Cure this by rearming the timer based on jiffies, which places the next
expiry one full watchdog interval into the future.

Fixes: 763aacf86f1b ("clocksource: Rewrite watchdog code completely")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261026010200.96371-1-kmehltretter@gmail.com
Closes: https://lore.kernel.org/r/20261010065509.72916-1-kmehltretter@gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index f1253f5795c6e..58c0ca11cdc5a 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -673,7 +673,7 @@ static void clocksource_watchdog(struct timer_list *unused)
 
 	/* Could have been rearmed by a stop/start cycle */
 	if (!timer_pending(&watchdog_timer)) {
-		watchdog_timer.expires += WATCHDOG_INTERVAL;
+		watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
 		add_timer_local(&watchdog_timer);
 	}
 }
-- 
2.53.0



