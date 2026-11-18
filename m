Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037274;
	b=W4gRoAZyTg8nDY8M+UMSdZxeeJOng6mpGV2KWNqWZNVBMHN8Up+BlQAoKq/HEUgm2bYe
	 WjJx3s7Pg88B8ZvlEEAntUWI2A0sfsTcTkiw3SVoV9DInB16FAa78oipWmZOPZEd34ilu
	 HstZ5nKpHFLyPZLZdw7cnQbzYbJLXUKg9bxovqBDR3gVZ5jV0vzF0X9KFg/yO9481z05h
	 OB3M4pZZGvXEHoHw2xc5CF3V0L8g59qWCr7VkPoIcwHrkbmO2jS/Wuv4ALAEcKy+c6iHP
	 6K9E+4di4VUQDHGQoEpJ8AmvGu5OYCCM+n+LCzrjqOanIFdCztPtJUk0GWkYp0xBpMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rxAdqzZ1OuxD087ij2PoFZcrdBryYLhRqdTJWolO/EI=;
	b=e4daRNBDUO6QfUDTW2DuquiOW/u6GFsdKTQ5qX0+jrp7TY8MlsfgvicgaGJDCK0H8JIg
	 lToVU4J1N88MWI7JuN96390xgcXz5H+dCY3WKuvRrciig07MlkTPW7+bYBX/kWz8KMbY9
	 EU7kW6vbd1Yr/gdIqUka5HafsptY2Fy2wRMGGaeYIYERPqHlNIvNntgM6XDtj52W6g8RQ
	 pQtZ5r90Rg3WbuU9Ibx6+MF7iGYAyv53YELhEQ8u0McG9Ns2ofh4WegXOtuKpcDg7H0QF
	 wxYT/7277MamSvEQ2ajhsfiS5rbdTWnotK2o4VMtzKTZFUoSvMdYwLxdm//YiC3Z/kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O772AOds;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3BE606A325;
	Wed, 18 Nov 2026 21:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O772AOds
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999641F000C4;
	Wed, 18 Nov 2026 21:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037274;
	bh=rxAdqzZ1OuxD087ij2PoFZcrdBryYLhRqdTJWolO/EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O772AOdsOF5z9hLlF4yWWa0oatbUFr1WHFY30/uXJOjuXlGW9tsxVNj/JkbmFHzQY
	 gNvC+rVjlxT3L7DtWrmlWN5P2yAlm/0afnPGXjmWUf/edV3Sd3iiZnS74MLpDenzrW
	 GbKr5hbwqzIcslZXf/wRdY6GjNRKjPWVlgvTF7OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Liz Fong-Jones <lizf@honeycomb.io>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1351/3318] writeback: keep cleanup_offline_cgwb()s scan out of syncs
Date: Wed, 18 Nov 2026 15:32:53 +0100
Message-ID: <20261118150400.940310895@linuxfoundation.org>
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
index c9fe6a5974713..85d9d97e486eb 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -733,6 +733,13 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
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
@@ -755,6 +762,7 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 		restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time,
 						 &nr);
 	spin_unlock(&wb->list_lock);
+	up_read(&wb->bdi->wb_switch_rwsem);
 
 	/* no attached inodes? bail out */
 	if (nr == 0) {
-- 
2.53.0



