Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705080;
	b=LjMklJmZWhrT1SMQKqcQfPCdYiw6Yd4OaWEhs26Fn4bF/PUPNu3pLihSQmCIRierVzTm
	 NdndJXgYnWy3JiXfm2GisekoCAM2JRfna1TnjnTw4hlawF5/euXTdRoC5AAaDCyCRr1ZN
	 K3WyZitMSe3WinutnMgGAiv1YkBtl5hYi+yLWGRTxqIWfqxNxwmfnH44/hWJc8CkveL4+
	 f4HcovbIshkTDN/OnfU1HFr0akj9rddG4bJen0QMlwdZ2QfKe5Nab8QuXwLn0AeTAQ42B
	 WUjgJVAoerRf9E77Y2JvcOpOem9M3vQ8gaB6CPebYkIlSf5sHTlesWTuAG5PjZ7ozvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YB7E/mNW8rf2+79tAqa25O2Qo7OxosPd/rt9dhIjO8U=;
	b=zmhpOeSDivlhq2RlQDx2sQI3nDATSBNsLt7o4fIDtx+JtquDp5dBW6IlgydJYZSZl/R8
	 dhAWgri7a3Zx+WULpZyynZAok4bRDPuLVExuSQ+uQ+JVL6OK3orwbuiH8+2wgUe75qBVf
	 jwDxNTjEb9UjAfAEKoCH961Ij/sBYhuhBjXjLEJpb/UWAfwbRtQfVVkbj6pa87b3TIAsc
	 hFDZa0XtICmXqJTIUehn/1H/GSc1N8xzrQEbdDjxx/6KTEB5fqSG/cdloTPWf3VHzk6oi
	 tTMfzVH/Oh0YQsvUJbhUvoQPN2pD8a0T4Okxti0ketHtn6S4d16x8y5dCh+7iA5v3XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U8eNOdTj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21CD606A333;
	Thu, 26 Nov 2026 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U8eNOdTj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E8B1F000C0;
	Thu, 26 Nov 2026 14:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705080;
	bh=YB7E/mNW8rf2+79tAqa25O2Qo7OxosPd/rt9dhIjO8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8eNOdTjJ83WaxRsue7ljgyPayvs6pwkADVnEGxBCxQNRzNQxFmHamVB2MPR7dGL3
	 quozfjGbnVEly+eIA1Rz5XjbRGw2aUif9TkC/DZf+joAL5TCxnfV1M+s8S878OEBr9
	 ikJjSGFt3hbstMWSEJq5Hx1NzZ8XMWiZVyoD7lmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/319] btrfs: scrub: fix lost wakeup and hang when cancelling a scrub that is finishing
Date: Thu, 26 Nov 2026 15:36:39 +0100
Message-ID: <20261126144007.442994602@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit bda65e5115fe66ee0d8cf4ade11807f9fca4f0e1 ]

When scrub finishes, it does a wakeup on the fs_info->scrub_pause_wait
wait queue and then sets dev->scrub_sctx to NULL. On the other hand the
scrub cancel code (btrfs_scrub_cancel_dev()) waits on that wait queue
for dev->scrub_sctx to be NULL. So this means if btrfs_scrub_cancel_dev()
is called right when scrub is finishing and sees the wakeup before the
NULL is assigned to dev->scrub_sctx by btrfs_scrub_dev(), it hangs.

Fix this by doing the wakeup in btrfs_scrub_dev() after setting
dev->scrub_sctx to NULL.

Fixes: a2de733c78fa ("btrfs: scrub")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 5a44cd54d0717..df98aa5c099fd 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4233,7 +4233,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	wait_event(sctx->list_wait, atomic_read(&sctx->bios_in_flight) == 0);
 	atomic_dec(&fs_info->scrubs_running);
-	wake_up(&fs_info->scrub_pause_wait);
 
 	wait_event(sctx->list_wait, atomic_read(&sctx->workers_pending) == 0);
 
@@ -4248,6 +4247,13 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	dev->scrub_ctx = NULL;
 	mutex_unlock(&fs_info->scrub_lock);
 
+	/*
+	 * We have set dev->scrub_ctx to NULL, now do the wakeup as a concurrent
+	 * scrub cancel (btrfs_scrub_cancel_dev()) waits for dev->scrub_ctx to
+	 * be set to NULL.
+	 */
+	wake_up(&fs_info->scrub_pause_wait);
+
 	scrub_workers_put(fs_info);
 	scrub_put_ctx(sctx);
 
-- 
2.53.0



