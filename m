Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D152863B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A96C433EF;
	Mon, 20 Feb 2023 13:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901460;
	bh=roMVyCeTwlxU9CK+65juiWQC6lSxkp+XDcq85zYy9A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQxqsXJST03w9E+Kc4Mf5rd/Quefjy8AgJKiAtPRCOb2/nfTBgqtuWr5ObX+foWH7
	 NSuoT2mAVc4GW3DcMNhgA4aN1HSRIcZ+oLwCgROhdN8kN/ubE8UpPq2EHGz1cYG8ns
	 mqZ1kChsuLmvxKr4/vJbqA7JhChXOEwNIjb1Uqf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Hou Tao <houtao1@huawei.com>,
	David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/118] fscache: Use clear_and_wake_up_bit() in fscache_create_volume_work()
Date: Mon, 20 Feb 2023 14:35:41 +0100
Message-Id: <20230220133601.441009966@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 3288666c72568fe1cc7f5c5ae33dfd3ab18004c8 ]

fscache_create_volume_work() uses wake_up_bit() to wake up the processes
which are waiting for the completion of volume creation. According to
comments in wake_up_bit() and waitqueue_active(), an extra smp_mb() is
needed to guarantee the memory order between FSCACHE_VOLUME_CREATING
flag and waitqueue_active() before invoking wake_up_bit().

Fixing it by using clear_and_wake_up_bit() to add the missing memory
barrier.

Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20230113115211.2895845-3-houtao@huaweicloud.com/ # v3
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fscache/volume.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/fscache/volume.c b/fs/fscache/volume.c
index 903af9d85f8b9..cdf991bdd9def 100644
--- a/fs/fscache/volume.c
+++ b/fs/fscache/volume.c
@@ -280,8 +280,7 @@ static void fscache_create_volume_work(struct work_struct *work)
 	fscache_end_cache_access(volume->cache,
 				 fscache_access_acquire_volume_end);
 
-	clear_bit_unlock(FSCACHE_VOLUME_CREATING, &volume->flags);
-	wake_up_bit(&volume->flags, FSCACHE_VOLUME_CREATING);
+	clear_and_wake_up_bit(FSCACHE_VOLUME_CREATING, &volume->flags);
 	fscache_put_volume(volume, fscache_volume_put_create_work);
 }
 
-- 
2.39.0



