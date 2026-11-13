Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590048;
	b=gJPlPakR3+H/N0SZP/HBGytcQss9uo0X0djwehyaw6vVcw7Vxs5FzHlc/zpW9/E71pte
	 8xaJCQnV+1aETfZbh6en1aepzVztGvUu6fD5DwUGhqmud/qBhuf0Iy5uCcLpcqyKDcgtA
	 lJsiPJWNyZJoKcPkeZB+YQuPKt4vRiSnyOJFWx3ocu5v8FzcTZ1EU8Lx/YcfaHJSEtYom
	 IWVu1J/16TBftDf8mc5dKP3zmdOToBJlB8F4xh/aNsQy4YRSzz2+Qb3SjndYFFzhTLEEE
	 j5Ben82rKykHP6msojySPCDebcSyEo8xkHn1CqeFbix+CPdgNxgNbqq22e5+KLfTq1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BS3NN0rAFgSYM+lR1NQkKkl5aufaybtsOWUcUgNjGNk=;
	b=ppHkh+tHPvDXrIX6wc9KNw66gYoqxSWltv8NtMkXUHWZ1eJXpTKTqB0kNCh2G9cuYKRK
	 /JxyTAcdWJqm0L9opK83mH02F9pkFFzf9npfSwBTOoQYad9knwPqlTIPUfRHi0WfIje9N
	 EfZT1in4PHQVHlhZJ2cKoOWIFmBuTOThezp1gwct5XSYCIZI7gUm4m7ZUcYVKdXa2bra2
	 3vO3pZ9djQCqebU62kVSqTM7a4OQ+Sr+1kUuW+9Uibqf11bMGdLSho0k6U3CsMJ/dgnBy
	 vfu2+MAs2dTDajaqKmSx1jrCtZdeMVKcTsELN65u/+MEIPyLE2BQBp2GnCwAIefEqxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C43e/MV6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CDE606A336;
	Fri, 13 Nov 2026 17:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C43e/MV6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FE41F000C5;
	Fri, 13 Nov 2026 17:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590048;
	bh=BS3NN0rAFgSYM+lR1NQkKkl5aufaybtsOWUcUgNjGNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C43e/MV64XLI7FUkoF2fyU+Aix5OeO5wBqmRKLgMQRCkyRG6XVGztWMhZLf8oxgQg
	 XBAvD/zrUh0PlSVgN4Rkn1LGkjrAMVng4/z2FpqKyTWHwGgkcJs+++IIWd3MFb84x0
	 m+O/AiGPHZzXdAXjkh1x273ghHmsM6YPKB9h0mW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Liz Fong-Jones <lizf@honeycomb.io>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/686] writeback: keep cleanup_offline_cgwb()s scan out of syncs
Date: Fri, 13 Nov 2026 10:43:35 -0500
Message-ID: <20261113153823.664349917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3025fc7ddfe84..85f21ecc59958 100644
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



