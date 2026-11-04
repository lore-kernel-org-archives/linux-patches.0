Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830827;
	b=3/ta6IVI02+IxTHkPbFrSHe0PH8GCty3SyBhGi+nXBBb7pFfOVg91jxHdrcqrda89EfV
	 kehxZR+RhtcMZAnkk2KDPE+Dc8jsBg60Vw3i0Gy9dNUZZlV9pthaWonkLMw4xIBGhr/L9
	 zAmYELsFSiaXxKMNOQZmHPClUWA90uyQ79/VCqIpmO9CeB8E8G/HM7WcKJjdmbHOAoUqD
	 kHorwB9p+cXAutOBkpW4Fp+JOlHqv+GoiXJWYsIv8aeTnigOakUNqiiLOutPsfmJPc3Dy
	 mpFdH+NMeMc2cLE80K0kptcogpr6YSGwojmJCBnNH6jkn/2GVWr12sjVTv6CU6RgyPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A3MBBRVG22YsVonQY3co9MKgHW9XjtVemYIaGUPbFTI=;
	b=crOoYd8GIDK3Zxm2C1q/kYp0qkoVukQvoWAIDhOIbyOLI7i0j3kBcziYyMF92kM5dxYh
	 lM+/rxCpX0AOKl/VWgg+iJ1cOXEWBSD5lY3ge6fBboJmqY3EiUod2OkZ0+Kxyo0cDdLSt
	 N9bOfFRmAWM4RzxZ/G7Tzz1OGKRHbClRnlu1Ck2ADLob0GzjpOF5+heKfmC8zGnZiiL0g
	 C8lw0V+l778+sdHk8TLi1JgTXiTJa7gA0SnfT2hLZk8DniM0rjf9da/AHmWsjO7PeZME5
	 LAyT2m+ANjSFFhXS4X4ylmh7gyLCFZlWCBIWxzZS4SsEHDVVZl+9YlX+u3qMp4beX0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vWa40NAX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D0D606B2D5;
	Wed,  4 Nov 2026 22:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vWa40NAX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A511F00919;
	Wed,  4 Nov 2026 22:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830826;
	bh=A3MBBRVG22YsVonQY3co9MKgHW9XjtVemYIaGUPbFTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vWa40NAXEmZlc3cl6H4SRpmksJj9QHD46OEF1r2ltiITXgDS4LEl6SX9Yqt3i9jkB
	 XH4PM+C1obnwAceuEx05Iv1SiJtCgpveguaYGSZX4/mIzK8sdI4ArxYELbrrjpGPL4
	 0VE1LgHKIHRksek5kJ6ZjqH9EzAswDf/cU3UsYxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0342/1005] md: add cond_resched() to md_do_sync()s skip path
Date: Wed,  4 Nov 2026 16:01:15 -0500
Message-ID: <20261104211053.541771243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index ce3bd127e3bb3..44f44219ed7fe 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9751,8 +9751,10 @@ void md_do_sync(struct md_thread *thread)
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



