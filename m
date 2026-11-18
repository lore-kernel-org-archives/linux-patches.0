Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034073;
	b=za8ZduOpgK/aunyIMBmdZj7Maj59KVymSlT9sHSiV0Bg1UHWmycPp18m1P7v1wII92bg
	 ygft8L/gFXRNoWJIDJeCmPClfYJ4hz4c5YSk68AI4ZGqkQKJWRLpIJjfsgHTRHMfyaXYJ
	 zmhewXLk7L5U4J03GWPrm9eU47W4Sl/9+B687qSfyQE7MWHvog0+KoaSWJfxIwz+CtOed
	 iKbP2vpaZDD0e9/jywbeO8kmLnFPBef6xxFXH10BR5yFEOTBf/aZxX1BQbqQqYddkLmKC
	 MYfbA4bCZgAcQ7qXcRVPZ1cDYxx1ar00T+Nn+7q7iXdaRXTfsGb3ugmegGOYF/eagWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nl63lYhqf5Puyuq2wBjjOjQFE/daGCrPDvHJ7XVryjU=;
	b=buNqZZQCqAwywsoPfQ5llJeyFwyju2BZrCIuc/Evf+IzkiiGneuNL53PYuDb/QYmv/0l
	 zVqpyMEdBv8LuDqqgFkKPm2jNSWydlouATCbhw+Sp62C/7oKclda4/S0mPCkCT0t8daVK
	 T+hyJn5s1v/QU6jjjklUlqH3peIL4CNZdi5DEau713YrNv2PO0J6e5TO3I1t7c2N/yxDH
	 7Wh+F1eT8TOhB9iwfKP0sK1J9VN2fTw1eO8rTAhAxdBnBvnACZIeQZuYdRaIDEWWbK554
	 pShEr4HOtumb0eld8OQmo5SbcCuheGuk/jGcPTOVf7ZTXuZ3jOcfkO8zjtQp8+M3udw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvIqtqta;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5E1606A32C;
	Wed, 18 Nov 2026 20:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvIqtqta
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2D61F000C5;
	Wed, 18 Nov 2026 20:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034073;
	bh=nl63lYhqf5Puyuq2wBjjOjQFE/daGCrPDvHJ7XVryjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvIqtqta4lgaE6Tii4SfrBdjAQMrRBu6p87FhuwDoZfAcMzLRDbazln9HEz4N6xHc
	 eP/Cyak4HbTlxWJ5nUeV3ux7o4Hmyi4KyT7v6Gfgx/Ehz1PInsC5ySMLqAxcFDPV7C
	 yw+kEZUksm2lvQzwCV7LU0C0sA8EmdRNjz2USdVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0239/3318] md: add cond_resched() to md_do_sync()s skip path
Date: Wed, 18 Nov 2026 15:14:21 +0100
Message-ID: <20261118150322.292180902@linuxfoundation.org>
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

From: Yunye Zhao <yunye.zhao@linux.alibaba.com>

[ Upstream commit 162eb5ba791f6260fdaabae75fa2df20134f67d8 ]

When sync_request() reports a skipped region (*skipped == 1),
md_do_sync()'s main loop advances the cursor and takes an early
continue:

	j += sectors;
	...
	if (last_check + window > io_sectors || j == max_sectors)
		continue;

If the personality returns a small span per call (raid10 recovery
returns only 128 sectors), syncing a large, mostly clean array iterates
this branch an enormous number of times without ever yielding the CPU.
On a non-preemptive kernel the resync thread then trips the soft-lockup
watchdog:

  watchdog: BUG: soft lockup - CPU#149 stuck for 313s! [mdX_resync]
   md_bitmap_start_sync+0x6f/0xe0
   raid10_sync_request+0x2c9/0x1530 [raid10]
   md_do_sync+0x810/0x1030
   md_thread+0xa7/0x150

Add a cond_resched().  This does not reduce the wasted iterations; the
excessive iteration count is a raid10 problem addressed separately.

Signed-off-by: Yunye Zhao <yunye.zhao@linux.alibaba.com>
Link: https://patch.msgid.link/20260723135535.101995-3-yunye.zhao@linux.alibaba.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 49770a698aab8..5bbb0fdd06eb5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9197,8 +9197,10 @@ void md_do_sync(struct md_thread *thread)
 			 */
 			md_new_event();
 
-		if (last_check + window > io_sectors || j == max_sectors)
+		if (last_check + window > io_sectors || j == max_sectors) {
+			cond_resched();
 			continue;
+		}
 
 		last_check = io_sectors;
 	repeat:
-- 
2.53.0



