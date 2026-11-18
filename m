Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036218;
	b=mWB/i28y7H/j0dXoznwSjGpc5s41CGUyHK1Bs0NJfUJ2ZvMOi645hwnBgwpCDhIpxi//
	 SRJ6NK8yoWlPcGfjhoOfsrLlzSECfSr/3GuJUinCrMKRgKWsI5akTsNjUNeMyE4fscARn
	 BB3aQ97sdw3mgAf4bFXXxoMnEGSQICOSPtEvT5CH7W7Vsrbaipa/d1wTp8o4rCOZ+1NXD
	 cNMW5eY6pnbeQgs1adNsRZb1wHIgR3E6VSU8JQ9sDXCWg+7s8LGlFDSoQRqq0dINqkKax
	 vwsHm6KehRFsXFnxZNTnt2uKfeEc7wBSNtLSYCRcghzz6Rri/i0jzkeO2VFT8q4O8iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X5EDqWkkr5zRCYBO9bC88XLy7Re9+zFBgdMlBgrTQv0=;
	b=ZuZXXyixSyM8kZuDXx3iaDChen/xx4XhVx/lDfYIV7VlelePGnvlQkxY72tAbNFHZzpo
	 PebtFnYmCcd0zcxb/B+w0NCbuRVgmPZ5oPrniw6SMcIViZuBV40XyCtVYFh1uBWBIjJM+
	 q2zSQ5Jjd7XNE4ZCB0tjXDVRb0osur7R3bcFxIBthbriDDsbwB0kdIgZOTfIG23Spsb9i
	 opcOOv6t17b7/lY6X6rJ3dQTLiD1XiLWdWgV9ozcdKZXCwnkAsAaeXidhKdffI3TjrAJW
	 SXhRVzGadnF4GQ8EJPb+J4DLXEuj5ePQxq400wM8wDy366ZLmJgxWZGfO68jTQvA5AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUBCL9Xq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F31606A32A;
	Wed, 18 Nov 2026 21:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUBCL9Xq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40C81F000C4;
	Wed, 18 Nov 2026 21:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036218;
	bh=X5EDqWkkr5zRCYBO9bC88XLy7Re9+zFBgdMlBgrTQv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUBCL9XqT758Ror8x90ES/WxxPMFoZxjdi3e+v5qdUoMf2AldpcWuKK5SRs+nKIoD
	 XmF/oxOh+8LP/A85Q48mf9xQQ7al4snxhtRj8b/abl7l3rDWl0+c8VOsK7fNRD+FCa
	 bwyHPZkQLFGwLMY19oko6+IqyoKdxvyWnAkLPhPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0982/3318] dm-writecache: fix uncommitted_blocks underflow
Date: Wed, 18 Nov 2026 15:26:44 +0100
Message-ID: <20261118150349.216465410@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 8a0cc5f3446a324b13f62020eeddb32d6ba1c2db ]

Revert the commit 39495b12ef1cf602e6abd350dce2ef4199906531

writecache_bio_copy_ssd sets wc->uncommitted_blocks = 0; and then queues
the flush work: queue_work(wc->writeback_wq, &wc->flush_work);

It may be possible that discard is dispatched in this window, and the
discard would decrement wc->uncommitted_blocks to -1U.

Note that this bug is benign - wc->uncommitted_blocks is only used to
trigged autocommit, so decrementing it to -1U will trigger a spurious
autocommit, but won't cause any data corruption.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Fixes: 39495b12ef1c ("dm writecache: correct uncommitted_block when discarding uncommitted entry")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index e2c81dd236419..4765f151b48d0 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -898,8 +898,6 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
 				}
 				discarded_something = true;
 			}
-			if (!writecache_entry_is_committed(wc, e))
-				wc->uncommitted_blocks--;
 			writecache_free_entry(wc, e);
 		}
 
-- 
2.53.0



