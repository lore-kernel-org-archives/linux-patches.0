Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022174;
	b=Y6Gd/OSBuwQtXY3UNeCnCMRBtrVENobpRI7iCelOIUqWzaFFHeL9/lRuEIUBzGYX15qq
	 LWfZccF0OVxupYuDQsgyxlHen4LWkY83I+wwel0FchEcrbCQVoG5Gkw1SSPThEX5QkcLM
	 wTKkssZdvcESU++0g4gLgRPD2+A61zIVqQVEeRs3Pcf69w9bUzUskepj6bV9+4Hx5PsnY
	 zwAUHL49nK+78uHflAikmZ2dws7mwgTJkdCCUBWGAYoQlbMyN2DHuvcWuA0SkQh69QBlC
	 zwi4n1ESxCy9RmWYx3tOovZ20qRqj9BbS+WOy1RXiBff/1Ft5OiPHILfSdbUccYGQ2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5cNyYGx+VR+gMeOR14L56LR2gwiurZI2uwCtqP1BGLs=;
	b=1pTwaOIkvbKqplJXpHaNuDLRiWhZV+IzQ5IUjyJ4A4CiWii6xKr314an84gUN0HiJAcE
	 1uGImyDdcmVTnGNYGfab1fiOvl6CDjvpkY9rKBCouXRuIY2ilqSvAh2Jv98W2uRriuRnf
	 p3ZH7PDStJg6KJbe5jBNLSOaH0/uvVSwBeS5/NShCT5DNyho5a7UBFH5oqIESyAQTATCd
	 0YufwTYi31Rrj8LMcPC/leO/qNUVs9BYG2poXC36ChWOeGGZE3e37mykIGTClPe7Q7/rf
	 +13YSp/5/wFRPl5pi29K5/2lez4qfEkBfnEa2secge6k+HzL+LKRLTH4AxwK6NS8jdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rhs4KK2B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67C8606A32C;
	Wed, 18 Nov 2026 17:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rhs4KK2B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D3E1F000C6;
	Wed, 18 Nov 2026 17:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022173;
	bh=5cNyYGx+VR+gMeOR14L56LR2gwiurZI2uwCtqP1BGLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rhs4KK2Bge40olqueSeSoCHyTxm4h4xCVGzUXDNx1erdmAX8Pa/6QnLwnsjUC6GuU
	 rPQg75Tm4fUbd+s6q1cjaH2bT+NyMDWFmeAqAPc+bn3NrTwO1ZvDb4JTfwc3QSle9v
	 Lo/nyk1+wC/aYfQdQg5WL9FYWZVu76loRMeq7hE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2567/2651] writeback: dont kick a missing wb for dontcache writes
Date: Wed, 18 Nov 2026 16:03:27 +0100
Message-ID: <20261118150416.820023113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit aa6439028dc39230e62917ba0a7dafdc103564cf ]

With CONFIG_CGROUP_WRITEBACK, inode->i_wb stays NULL until the inode is
dirtied for the first time (folio_account_dirtied(), __mark_inode_dirty()
or wbc_attach_fdatawrite_inode() attach it).  generic_write_sync() calls
filemap_dontcache_kick_writeback() for every IOCB_DONTCACHE write,
including O_DIRECT ones, which never dirty the page cache.  The function
then passes the NULL returned by unlocked_inode_to_wb_begin() to
wb_has_dirty_io():

  fd = open("/dev/ram0", O_WRONLY | O_DIRECT);
  pwritev2(fd, &iov, 1, 0, RWF_DONTCACHE);

  BUG: KASAN: null-ptr-deref in filemap_dontcache_kick_writeback+0xec
  Oops: general protection fault, probably for non-canonical address
  RIP: 0010:filemap_dontcache_kick_writeback+0xfd/0x7a0

The task dies inside rcu_read_lock().  blkdev_write_iter() gets there for
any block device whose page cache has not been dirtied yet.
nfs_file_direct_write() calls generic_write_sync() the same way.

An inode without a wb has never had dirty pages, so there is nothing to
flush: skip the kick.

Fixes: e1bf79628453 ("mm: kick writeback flusher for IOCB_DONTCACHE with targeted dirty tracking")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 0a8839a8863ec..c75c6d8b6714a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2579,8 +2579,9 @@ void filemap_dontcache_kick_writeback(struct address_space *mapping)
 	struct wb_lock_cookie cookie = {};
 	bool need_wakeup = false;
 
+	/* An inode which was never dirtied has no wb and nothing to flush. */
 	wb = unlocked_inode_to_wb_begin(inode, &cookie);
-	if (wb_has_dirty_io(wb) &&
+	if (wb && wb_has_dirty_io(wb) &&
 	    !test_bit(WB_start_dontcache, &wb->state) &&
 	    !test_and_set_bit(WB_start_dontcache, &wb->state)) {
 		wb_get(wb);
-- 
2.53.0



