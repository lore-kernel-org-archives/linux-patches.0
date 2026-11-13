Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590868;
	b=4iHl5U4yjBoT+piS1Fdsj7fylN13Djx1ezUc5jETNXXEx9syodOqKwi51900/gajDgMc
	 0042WtBkqexVLS3tg5bO1jafpAyPmQ+4htkXuCvRIb2ghXQdQpOxdffa2bHRNAFQMXKsQ
	 DIpQ8csByOnvyt71pkD3zsB0bpwFjhte+BSGO6zeaHuSqX8Rc8PAlBnjGAqGL4MQti8v6
	 48BHIV/TagW4/LLxH5nnTJ41Ya2pI4p0+WZOEHrthmoSbDvHIfeqXiPzVFMDsXqnw7tVD
	 EXTdpPYO+zvX85yzrFtal8X30vZmhBlVQEjABBr/OxE0HacNvteu4VZY+sEPewA/wqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tn5nF+0tzekU5KozbCzCJIbOGDSWDchusKxKW4KzvCk=;
	b=PQojloIHS3ELCNchPyGS6TZpSPwE3FqviBlvi3uvhux03fLYtNW6FITv0aHfiuSfUBgR
	 vHATNrLsQsn2niUz7MXWnK29YmfrtW0ZtXOtW0asfbor4x6s6cB9fXEqpYYMZF8tEzDbn
	 BbCq0tsUzczeBjz9bk1q/ExgEt55eHSIc5M4qz7YmoW2j6SBeCzmCNCfKX6tfcSBtFE/3
	 xMgIwjaZYzSU/hbH+KMW+xyu8LU2h1LIwqswkSrO80/8A9b5XcAgF7c/ekK8Pt+mpZZuh
	 YrJso39xBvBGQKfhOmaFhb2EwWw2pUJcRxz7Xb3pNUYNitVrNV7zMurkPivu8y2zQbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Pg7pbI/O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A79E606D4A5;
	Fri, 13 Nov 2026 17:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pg7pbI/O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14911F000C4;
	Fri, 13 Nov 2026 17:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590867;
	bh=tn5nF+0tzekU5KozbCzCJIbOGDSWDchusKxKW4KzvCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pg7pbI/OPdoNFfZbRrRxsDFxH8+AJbbpj28vjUETYQRKzNC4HVAjK2D5l+g3r04PT
	 elVCTUAY/+sYvcyeR2iVwqNuyjuy1d/4yf+1bpSNRe2nLCDFIFSyftkNqyegWSuZH2
	 drO4NRkdqPRTWwqeLqJH8Jb9sRzXbRFteWTDi3xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Liz Fong-Jones <lizf@honeycomb.io>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/670] writeback: keep cleanup_offline_cgwb()s scan out of syncs
Date: Fri, 13 Nov 2026 10:43:50 -0500
Message-ID: <20261113153813.748860144@linuxfoundation.org>
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

From: Liz Fong-Jones <lizf@honeycomb.io>

[ Upstream commit 90c96612460e6accddbda5a195e6ddaa391ecde0 ]

On a filesystem mounted with lazytime, sync() and syncfs() can return
without persisting timestamp updates of inodes attached to a dying
cgroup wb, so a crash after the sync loses them. File data and sizes are
not affected.

Since commit f6988c90671e ("writeback: bound cleanup_offline_cgwb()
rescans by rotating scanned inodes"), isw_prepare_wbs_switch() moves the
inodes it walks to the newest end of the list. When a pass fills its isw
before reaching an inode that got its lazytime update after a sync's
cutoff, the walked inodes land past it on b_dirty_time, and the sync's
queue_io(), which stops at the first inode dirtied after the cutoff,
misses them. The late inode has to be one without a pending lazytime
update; one already on b_dirty_time keeps its position.

The window is narrow. cleanup_offline_cgwbs_workfn() skips wbs with
anything on b_dirty, b_io or b_more_io, so the scan has to land between
wb_writeback() fixing dirtied_before and taking list_lock for its first
queue_io(), unless a multi-pass drain started before the wb got dirty
IO.

Take wb_switch_rwsem for read across the scan, as
process_inode_switch_wbs() does for the switches.

Fixes: f6988c90671e ("writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes")
Cc: stable@vger.kernel.org
Suggested-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/all/0bc5d58533f10b4841807be3025daa11@kernel.org/
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
Link: https://patch.msgid.link/20261017040710.1174009-1-lizf@honeycomb.io
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ Take wb_switch_rwsem before this branch's rcu_read_lock(), as
  down_read() can sleep. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 435f14b7e2cca..3b67018191df1 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -757,6 +757,13 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 		new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
 
 	nr = 0;
+	/*
+	 * The scan moves walked inodes to the newest end of b_dirty_time,
+	 * past ones it didn't reach. If one of those was dirtied after a
+	 * sync's cutoff, the sync's queue_io() stops there and misses the
+	 * moved ones. Exclude syncs as process_inode_switch_wbs() does.
+	 */
+	down_read(&wb->bdi->wb_switch_rwsem);
 	/*
 	 * Paired with synchronize_rcu() in cgroup_writeback_umount().
 	 * Holding rcu_read_lock across the SB_ACTIVE check, the inode grab
@@ -779,6 +786,7 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 		restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time,
 						 &nr);
 	spin_unlock(&wb->list_lock);
+	up_read(&wb->bdi->wb_switch_rwsem);
 
 	/* no attached inodes? bail out */
 	if (nr == 0) {
-- 
2.53.0



