Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057503;
	b=DAZ/NW6MuRVhVRdD1FAC7CdiOfSuBQ52BDGK3LxzE4p/zvM2k/EUx++u4yDgHjRwEIf7
	 Ty5YHhUm5jSi+EVfOdVnqHCtkeQYonENS2vVLD2vOYnOm8ywIz8UzCCEQNFTPYI2zzrc1
	 uyJCMc3B2At+FAaYQNLDc4YumLQYoT+vpHBnqzdfVbmOC15FO7MZ/L8BtR/1gw0PD6eAf
	 IivsrfpJz1+t3ClrPQmRE+NbYMiV/cp0+7zFWReiuxcUw3yEZWIBOtGaQi4COXHPfOMe+
	 zgKtd6Y1qAQEclnBunRYL3ht2N/eApVBDHaUgKrOm0z2W4lkJgK1Ii65MnjhMlLYoVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+8i1c/6sHplaLZ7TxRy53N7BdoEks0XqSIFEDqax8kg=;
	b=Ep4V8yUMnpmf1mPeJvf3JxZsQ4urUNmLHSf3W0fR368Uf2CkiPXhbz1CqsvSHSRCqrQQ
	 yPFl14axv+K4vM55E9Y9HmaecTZ6Da0Blw33jCsxgjEBUJGfHSKVo2Z0EktxS4GrxKK0z
	 zCFn4qyDqoZWp7sLSU7LbwjniBM5HbYiHZ7sROpoaoZckJBZEBA5iUz377M+LCYYW3daO
	 STDA7fjf07UuKOhH3vIijx6Pyj799SUTyCqWUEyFOp5cf1BJrhcIES/lD1JWlshyjP42w
	 GSFllyLTvM5bvElB7/mxtKDMw0SceHSJLV0IMo1Dt88PpRXoR3mJ17aV/q84rURhfYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Blx4S9r3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F0460A2617;
	Thu, 19 Nov 2026 03:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Blx4S9r3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DE11F000C4;
	Thu, 19 Nov 2026 03:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057503;
	bh=+8i1c/6sHplaLZ7TxRy53N7BdoEks0XqSIFEDqax8kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Blx4S9r3x35MuS97MLXoOWZ0N2c3Qh4LfxQa1pdi39WFeTKdajSbgQJM9Gy1BbVXH
	 AYeqxuRk86nY1sM7WcAMfEdHR2IydgqaeLAr1qY41R8gK6+EKEZEug0G2t7pY4HvHp
	 B8EF6jz2oOmL5ewHTNJyHtO770FVurBv5epEigik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0154/1848] md: add cond_resched() to md_do_sync()s skip path
Date: Wed, 18 Nov 2026 15:36:32 +0100
Message-ID: <20261118145917.817426588@linuxfoundation.org>
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
index e4cc896ebb493..8c8b654e7fbe7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8974,8 +8974,10 @@ void md_do_sync(struct md_thread *thread)
 			 */
 			md_new_event(mddev);
 
-		if (last_check + window > io_sectors || j == max_sectors)
+		if (last_check + window > io_sectors || j == max_sectors) {
+			cond_resched();
 			continue;
+		}
 
 		last_check = io_sectors;
 	repeat:
-- 
2.53.0



