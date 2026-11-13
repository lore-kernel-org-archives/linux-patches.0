Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591614;
	b=aRlTE8uDjLkeXytGZaMfKRfNpOo+YnZFqmg3PohKAPb8muL9ThJOHoLLu0nCUq8VGYQd
	 xL16KNGINcZMRlYhnMbaCeSaNSMhHCLgsmQkUKUZf7qKYazLFX8AXlZN5Of+VkuicdZaB
	 xfpGGfUDSAWbqIaeFVR8KqT98lExGB3EFGEOSsVbBZSAM7Ve9Sp58hwWwHK9wwm15mnMg
	 dIO8g2RR2ZO8IsGLzx8Jj/BNhtYq4BtXRxAKQy8nyd9Rhn7UKX8a6gBFtNXKSmsRWFMXI
	 6MmfyfNtBTtzPBVLpElVpTKP/JDnXD7rzHPKLtOabbjX8QLmHBhfZMGFASvJZIr19SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MX/saBua8NEYraahwEdbXl2gpwmyym9u2wXiz+k1MjI=;
	b=JOKBZNPvWF7A+3kGCMO4B64Scfr0yOlq31ytOyAAECwhKivh0ijh35cgbOi/pqlbTsQI
	 Zj0WfcQqNAuzMdcOGZbKsArsqJP+BxNgvFhR8X5MlBEKL7TdUpGlP/PBuFQAjYpliaJNr
	 43bH6fMbEoaHX1LJO+F1ZNne4mET2KVzGokFflOZInBezFOaNOQfZBYfVhJDDRct/B+mD
	 8pRh1+NwtX8JXB0p1KzhiZf8vRrmb+2NzBfblEvBcsCaxr2FaydfchsLPLGAMO3PRMNXQ
	 UmQaWHgunuEkHxQwJci/QLqSh3trv72n4bJdg9wiBWq/hMQlXPtF4vDXHmIeQfHaw/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kKYOx/NA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49222606F70B;
	Fri, 13 Nov 2026 17:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKYOx/NA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74D21F000C4;
	Fri, 13 Nov 2026 17:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591614;
	bh=MX/saBua8NEYraahwEdbXl2gpwmyym9u2wXiz+k1MjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKYOx/NA4C+9ipiqGz2eO39G0ll2AQo/8Dt0FYJBJb40P6bSPuq2xENW8bDE2bA/o
	 2ZYGKm0F3/irtLRajbOe8aefuLOMiHCTO/sAGamh89Oay/SQ6hTpY7pyLc0PEbhJ9i
	 WNEtpOlmrit2OTL9/jGIQCkdcX4jSphCEEKY6pWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolaos Karaolidis <nick@karaolidis.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 613/670] fs: dont lose inodes that another LRU walker is isolating
Date: Fri, 13 Nov 2026 10:52:57 -0500
Message-ID: <20261113153832.588488248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolaos Karaolidis <nick@karaolidis.com>

[ Upstream commit 8dc4116041e2b377e5e1b62ba98b37636f9f3968 ]

When inode_lru_isolate() finds an unused inode that still has page
cache, it sets I_LRU_ISOLATING, drops i_lock and the list_lru lock,
invalidates the page cache, clears the flag again and returns
LRU_RETRY so that the restarted walk can free the inode.

Another walker of the same list can reach the inode in that window.
It sees a non-zero i_state and takes the inode off the LRU, as it
would an inode that is in use. Page cache deletion requeues the inode
once the mapping is shrinkable, so this is harmless if it happens
before the last deletion. If it happens after, nothing puts the inode
back: it stays in memory, unused, clean and without page cache, out
of reach of the shrinker and of drop_caches, until it is looked up
again or the filesystem is unmounted.

Before commit 2a0629834cd8 ("vfs: Don't evict inode under the inode
lru traversing context") the pin was an i_count reference, and the
final iput() put the inode back on the LRU.

Skip inodes that are being isolated and leave them to the walker that
pinned them, which restarts its walk once it has unpinned them.

The window is reached by any unused inode with page cache on
CONFIG_HIGHMEM kernels, and otherwise by inodes whose page cache is a
single shadow entry at index 0. On an i386 HIGHMEM guest, eight
concurrent "echo 2 > /proc/sys/vm/drop_caches" over 2000 freshly read
one-page ext4 files leave roughly 400 of the inodes off the LRU per
round; on x86_64, with the files' pages first evicted through
memory.reclaim, 3 to 4 per round. With this patch, none in either case.

Fixes: 2a0629834cd8 ("vfs: Don't evict inode under the inode lru traversing context")
Cc: stable@vger.kernel.org
Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
Link: https://patch.msgid.link/20261009142431.713875-1-nick@karaolidis.com
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Replaced unavailable inode_state_read(inode) with direct inode->i_state access. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 50f0a5d756bdc..87396234d1e25 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -889,6 +889,12 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	if (!spin_trylock(&inode->i_lock))
 		return LRU_SKIP;
 
+	/* Another walker is dropping its page cache, leave it to that one */
+	if (inode->i_state & I_LRU_ISOLATING) {
+		spin_unlock(&inode->i_lock);
+		return LRU_SKIP;
+	}
+
 	/*
 	 * Inodes can get referenced, redirtied, or repopulated while
 	 * they're already on the LRU, and this can make them
-- 
2.53.0



