Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065230;
	b=yfIzaGB6Pgjh90hGmoEAIl/QOUl/mGwQK5tXl+lXdUIECQ2iQECwlgzkE1jLs4uY1F4m
	 2wpD2bU6OkkvEiYdjFbWzgc68F3JSsty0PdMTIrcX2Q/6uEDXI/pZFiRt6uRUMscmjsPo
	 LTF6cnqiMtjQWntB/zuBykr93SBPsMidjxUQwNiJFxMILNMxxFFN4IP43IsdEwHl+/3js
	 KmdGvnjXhLq9xlK6YUHUR/kgOxH7nhaIXz0sbNJbupN7i1F9WOr9L3ABzMpXkWo4Uxd8y
	 C0ilmuIcsn3lx/5CSr/blo177eTfr17wodutkSsA26mgSlX6TvkNat/nyIjB8EQ7PXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q7Tinl6drNhMG2M65t40Cv1bjCLHRPLOBaESPkLZZfM=;
	b=tuKFkUFzX1QS7T8zyQF7GSpnvsDYkSpW1Dr5VpPPFC6zIPdCJTUGDU7zOJTzei4knWtk
	 qUh37nN2u6i0ZI5bSBfAcDlSdFfRtmkkZD1/ua/J0dCzCdREaKq2yTv1mJ2uL1t3GfDFs
	 uLkU0UctiwoJF/TXrfn7m63TP8yMfx1MEXLN9myIRhYK74u5U+DjbI6ntXVoLUFsVaXHj
	 ZjbyxXRv8CPDRPq+TbFIl645PXD9/5z8odLc+mub+0ttuCciaQRDjuJLzj1imp3rydGhx
	 wocWWRlcjFj3QqKc21r4vlBj3B76zebJqiggrx2WlIZ706Q/IDgO0b8fhQu+MK0Y6mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g9Tb2ax1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FABE606A32E;
	Sat,  7 Nov 2026 15:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g9Tb2ax1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672AF1F008A1;
	Sat,  7 Nov 2026 15:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065230;
	bh=q7Tinl6drNhMG2M65t40Cv1bjCLHRPLOBaESPkLZZfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9Tb2ax1D4WDwIU7P6Gfk1VHcNcfl8ILmKheTYswtj58kSz4TQNsJI03l+88yJdul
	 qPYshb2ZKmXY9mr2K9WQ4t3Ga+foJpKKJyzZH3M+jMzU8Gl2OPMjhPM3EsKRu0hAmt
	 QcKNih+VZm3i+H54xlZ3oEq+zP4PbIOImJZl8R7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Liz Fong-Jones <lizf@honeycomb.io>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1018/1257] writeback: keep cleanup_offline_cgwb()s scan out of syncs
Date: Sat,  7 Nov 2026 08:55:14 -0500
Message-ID: <20261107135007.451423170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1b5b4e9ff5a52..e2ee11119518c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -790,6 +790,13 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 		new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
 
 	nr = 0;
+	/*
+	 * The scan moves walked inodes to the newest end of b_dirty_time,
+	 * past ones it didn't reach. If one of those was dirtied after a
+	 * sync's cutoff, the sync's queue_io() stops there and misses the
+	 * moved ones. Exclude syncs as process_inode_switch_wbs() does.
+	 */
+	down_read(&wb->bdi->wb_switch_rwsem);
 	spin_lock(&wb->list_lock);
 	/*
 	 * In addition to the inodes that have completed writeback, also switch
@@ -804,6 +811,7 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 		restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time,
 						 &nr);
 	spin_unlock(&wb->list_lock);
+	up_read(&wb->bdi->wb_switch_rwsem);
 
 	/* no attached inodes? bail out */
 	if (nr == 0) {
-- 
2.53.0



