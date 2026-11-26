Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705579;
	b=3WW4maH0xFRmdiTCdh4rilektYKHU1NiAnzR+TESxXX6zTy3GrcdaSnbDhw1vpqqRrZ9
	 D9tqsAUT/I9DE3Wjg9LgGnz750o/QF7jTgzaHcEg/buWV/GPMc11gvCdyBdoRL0yd4hlN
	 hDdNem1cCn0DXbQjBmPQnEGfV/sChSznLfLFolMGzLITCvLGW6A/34T6b50pqtQacvIBD
	 vhvo4PfLnkDIn4gV9XEEAG+ZHUxvvD4ZH6acNZAsfrLLMFE16TxlFB+t8V92HiN6ERLoO
	 NVjsU5LqR/27T3iP4iC8cyrvfzmkptqflN975F2kECRO+8hteX9kGPQwC637r9dUIUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/CpwxczCaFgBifcoaqJBRua6SxO2FQ051lLgtrMH5Cg=;
	b=SsXHb9Vav6ffooVdA+NlXI1Y0tjd8XAs0N13euIYQVbOoz3JViGfiFMxAMvBSbzcN4wu
	 vM+Vc1PZ0HWKnHs/xMRhyUdrYB6dL23cYWoZ39T7WqiM5jN2fInaUUIocXci9fbfQ2jx+
	 3+D/5whYqeisLvT2vw1DY878W6Bj889I02on/bZplXtXrANDBrtz23WhdRWZZujqpKl1X
	 T3FzxPbyGPaZEJKRpRYMrPfrfcDUfZBh1stRZ3cF7zjL2PA5jsRo5SJgFROtPQONf74cg
	 SJNxpgARJTsh7TGSCyyaQAAh8vnj63ojFXpeaAU/73VoyPzmSLVTUsXgM15O8k9ykpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvMlpM46;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E301606A321;
	Thu, 26 Nov 2026 15:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvMlpM46
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFC31F000C6;
	Thu, 26 Nov 2026 15:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705578;
	bh=/CpwxczCaFgBifcoaqJBRua6SxO2FQ051lLgtrMH5Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvMlpM46YybX+rrdCRqlPv6qRP5eo19+NT7VgTNJ6kTtlaMmZuQB/yeGCTIoqnOXZ
	 I2+Dj+9+s557K7r4V9dyr7iKmM5H+DE0lTsaUx8EoAOJCwYV8XqqL9ZrcPR6UyZQTt
	 F+MgptuPAtI3H1Y2lpNNhPWAvS2PEL3Decxo43hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 245/319] dm thin: avoid wrapping no_space_timeout
Date: Thu, 26 Nov 2026 15:40:13 +0100
Message-ID: <20261126144012.274741499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Yingjie Wang <1075151112@qq.com>

commit bcb78d49620f666b4a9d62997691e8d031fd4ebc upstream.

set_pool_mode() converts the no_space_timeout module parameter with
READ_ONCE(no_space_timeout_secs) * HZ. The usual arithmetic conversions
evaluate the product as unsigned int, so it can wrap before being stored
in the unsigned long delay. With HZ=1000, 4294968 seconds becomes 704
jiffies: a pool that runs out of data space switches to
error_if_no_space and fails queued writes with -ENOSPC after about 0.7
seconds.

Widen the value before the multiplication and cap it at
MAX_JIFFY_OFFSET / HZ, so large timeouts no longer wrap into short
delays. On 32-bit kernels, values beyond the supported jiffies range
saturate at the largest whole-second delay not exceeding
MAX_JIFFY_OFFSET. The timer wheel's existing handling of very long
delays is unchanged.

Fixes: 80c578930ce7 ("dm thin: add 'no_space_timeout' dm-thin-pool module param")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2531,7 +2531,9 @@ static void set_pool_mode(struct pool *p
 	struct pool_c *pt = pool->ti->private;
 	bool needs_check = dm_pool_metadata_needs_check(pool->pmd);
 	enum pool_mode old_mode = get_pool_mode(pool);
-	unsigned long no_space_timeout = READ_ONCE(no_space_timeout_secs) * HZ;
+	unsigned long no_space_timeout =
+		min_t(unsigned long, READ_ONCE(no_space_timeout_secs),
+		      MAX_JIFFY_OFFSET / HZ) * HZ;
 
 	/*
 	 * Never allow the pool to transition to PM_WRITE mode if user


