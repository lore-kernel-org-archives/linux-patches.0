Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051360;
	b=qBn3/jWyCoHtUqoL2WyNALGHHoF3MzgiSVg214GYGOYJVEui6k/MwME0wu6jHAoxO9uK
	 7hh4kL+UWfoLFL3elLxyfvoSaWfyBbylX74vEy7TpgZpdIHlsn3m0DYf7FKVaWeXPccAM
	 QrJ9OpPV7fhzRl4xBBANkQFYAX4z5qGItNzWdhIXInYqXZ8Rkq6H1aKtdaX7BRgQIbw4V
	 kh2eQyDAwhpAKIEBIFWa+gGLPS7cSDRrQNDbDbal92i3jUD5y48yaAVtMibLK6WILV0Lv
	 IiSVrxk5i47v4j6wkzVeLmDulKVzDKWAX+tpre5oobiinnO/Psi6WXZdd/EqR9snTdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NpWW7nTNQQ78Q2RLeTM1Y8h3FZ52E4tn4+XS5Jgkhqk=;
	b=qx7ynB3810jBzKNdACO+1VCnyeECqjNoRUVMLQNn8j1Vx2noqMnHriqbFzWywGBtJkRe
	 nBZlEtOPB0VrtxSExBZfJvqXWmA1Taw/CJ3LGnqjBga6C612ROrluUdCjykRW5dMP32x9
	 HHY+ncNzLZbiZwKvwse+0s9aPmNALlHvr0jRB/aAG+nb4MBeVWkTjSZWMiXXhJv2OcbXB
	 hFmwoFUpSskyw9l0HG1BaMgHoDRm67/evQDgYfjCCYtISZ75EZbVLQv+NIwR4J/gqnRUv
	 DN98ln0M4zeSjgMKYb3vnjHbkQKH4fqvsfRDyEQkWk277aDC07ykhl6yogJWULyiX+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fa7DAYFC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECCA606A320;
	Thu, 19 Nov 2026 01:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fa7DAYFC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAF01F000C4;
	Thu, 19 Nov 2026 01:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051360;
	bh=NpWW7nTNQQ78Q2RLeTM1Y8h3FZ52E4tn4+XS5Jgkhqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fa7DAYFCyK9gZdyDzvMVkIfquOuoHdVxvXENF+2L58XQKDIrNwvoAI2w06efl5GRK
	 FBeYh2wOkmv7aZsE4p1/OdKXDQuJF6oOrHJ+n1t2aWa78hNJPvzBiJenBh2vHu/NkM
	 5IrwDb97ylj0A7WxTPbo3bQk5myYFM8+i0rF5tTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunye Zhao <yunye.zhao@linux.alibaba.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0182/2214] md: add cond_resched() to md_do_sync()s skip path
Date: Wed, 18 Nov 2026 15:30:58 +0100
Message-ID: <20261118150017.319352294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ab95d77ce8831..059816d04edc8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9038,8 +9038,10 @@ void md_do_sync(struct md_thread *thread)
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



