Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052439;
	b=m2QgO5afHYBEWOlKdcNyZ5MnYRetNDzIdO4WjtcU3B3ttuyklzRm+8O1x5sA6JS2qSWS
	 RxSWN2waLVNFaR9g3/mk5JGKdih+psiVx1m1YfystySXXgGZ7GroBwVrBcxqOgZAJ0X+3
	 6XAiyNW3EnPDloFgG/CugTVZkcEMkfzLhiIGIbT8yF69d+4FFw+yhXqWeR8NWcNWNzmqI
	 MCruqJuphsreVCawLJAh+710Mdu7dbP3JnRcDglYcmrNxnz++HAc2oVqgnJpRoVgFr/Lh
	 173cg59yfTRDS+Y8xHeMBLarGJZ5E/LYpEhNuZLUDUnCD+R5fFqPloCuc49GwiWe4Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qkviXh5O/+NbnmZV0eiZ4x+gtqrT8WQQqoyXHUF6m9w=;
	b=VQHfgkHiZdF6HT9fSePD/OdxCDJwmvkBaeZZlKqGmdBZl+dLm+GUGu85QKq0PP4jy/uD
	 /0FLVXK7QGU2EXAgC2iEethGA2gOu8rgUlfJnrLLlrhJ+he4YRYgcloYU/bJQvIWyln/i
	 uowel69Ar7Afj1zye97AoYhkjwWC4ijnmCyDr/2eBBOBvF5cnBI2GhcqxtTHMVnZSfmF7
	 K/OIzVT1NdO+c1SVwSTl2m9UCwICtmUXHZimz0KgYD2eVstgCVEebD4mtBODBwFbhKGDl
	 HW9UwKzF9/lgNdb1CFcDq28L8RVT+ph4sbAF82dhgy2AU1jSE3UeIH+OcioQQEGBolg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S8qFCbWB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2641E606A32A;
	Thu, 19 Nov 2026 01:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S8qFCbWB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482341F000C4;
	Thu, 19 Nov 2026 01:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052438;
	bh=qkviXh5O/+NbnmZV0eiZ4x+gtqrT8WQQqoyXHUF6m9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8qFCbWBSKBmHeKxDyQKQGoRm73rIjFsxMDboOLez2r6qcGX22gDTsVz1A42mUDWx
	 zPD0h69fjlm0SyCpVDzWwt4R1k1lu7gclByKXsrwugEpEJxkHnmSmhqRhB3u1wInnp
	 IvPz0Bjlr/p1XwusC9D1rKIdrW4CWNXcJKAIdnEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0562/2214] dm-writecache: fix uncommitted_blocks underflow
Date: Wed, 18 Nov 2026 15:37:18 +0100
Message-ID: <20261118150033.478219051@linuxfoundation.org>
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
index 9be9ff6f7e3de..b0d827b84cdb5 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -896,8 +896,6 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
 				}
 				discarded_something = true;
 			}
-			if (!writecache_entry_is_committed(wc, e))
-				wc->uncommitted_blocks--;
 			writecache_free_entry(wc, e);
 		}
 
-- 
2.53.0



