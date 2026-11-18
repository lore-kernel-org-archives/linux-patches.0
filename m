Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036811;
	b=tD7nQNQL00Ir3rq9BpeVzQHTy3OmbU6Z42PGiknn2bH9iHzy31Xag5ytsU3XTwpvk370
	 fCL6DBjpXU+yShB9y5a4mqYF/xLbwnhs5OP1n0P9RwstAuk7s7uuzuMRRTcG5As2/2eIr
	 uQoQGL7FDSy8u81vQn05b93OjcFs6g7WOa/ugUkwYUJo4A3GmU6CL7UEbb/3MQNOK00DP
	 1QMxbrdx3PgCjkdQ1MzSoCerHZtpkhkFRSPk6gj8ztuJ7eDM0PzgzK+s0GQJXRRJMROfu
	 Caca42emP+fEI9ZUAHOFNXU6Kw5duqPY0L+hQcD/3s22J6Zc95rYuiBtj4N8SR5gN5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TwoEvNwo+PeV566I27+AQKpXHYubCLeXKPi87nWd1aY=;
	b=SClazjnZ1SDMk5HBI9gvVwivKQo/3J7p6M1qBsgvpuiTsiwz+Ef6bizKysd3C1+9I4Y+
	 nwF6Pl85cLnBy9t8GWMbeKgo64HePfbBmb2dbaw+tvnrUrWrTorLqjU/gjEmhQPZ+8SW7
	 JztAYiz7yRgiAeYopMwf1wq+vWMpdPnCDguDh5hV/9BGXMvaPssMoFUhrDbAAcQFTj54E
	 UsXLdOz+CDCOdcjrp3DPuIO3MmcSJtyWPmbrmfkLpktVv76k0AKEHObcduVNs+wfJ1yhF
	 uu0z9Ggg+YUEC3YVey03prL4Rg+wxFPNbUQIAFHe/pbl1FZdiV9yisp7dmOmHope+gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F4maCrFh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9B6606A320;
	Wed, 18 Nov 2026 21:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F4maCrFh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CE21F000C4;
	Wed, 18 Nov 2026 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036811;
	bh=TwoEvNwo+PeV566I27+AQKpXHYubCLeXKPi87nWd1aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F4maCrFhm5CJUgnJCctxeLJnhx68uSg+fiyXioNMlUXGZUQ1RFF7XUPkpI+fkGUfp
	 Lpg5+dLeGYxYduZxnUIlW5vBengB5TWdDk4uvgBP43OPTwOMIT04Wu893cS1Lh+FqU
	 zGAUwjkywdcXryAMyxwyz7GvHvaPx6mn16bEtKTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1191/3318] writeback: reset dirtied_when when switching wbs
Date: Wed, 18 Nov 2026 15:30:13 +0100
Message-ID: <20261118150355.896144336@linuxfoundation.org>
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

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit 13b9a606dd0a6cf9bac12894c97b9546d22a7425 ]

When switching a dirty inode to another wb, inode_do_switch_wbs() puts
it at the newest end of the target b_dirty list instead of searching
for its sorted position. This requires updating dirtied_when, which
move_expired_inodes() uses to decide where to stop scanning.

However, the switch updates dirtied_time_when instead. This leaves
b_dirty out of order and can make the scan stop before reaching older
inodes. It also resets the lazytime expiration timestamp, potentially
delaying timestamp writeback.

Update dirtied_when instead, preserving both the constant-time insertion
and the lazytime expiration timestamp. Correct the field name in the
comment and document the distinction between the two inode timestamps.

Fixes: 9a6ebbdbd412 ("writeback: Avoid excessively long inode switching times")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Link: https://patch.msgid.link/20261016115230.3640770-2-sunjunchao@bytedance.com
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c  | 6 +++---
 include/linux/fs.h | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 58fd005d410ce..276e202f9b6f3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -431,12 +431,12 @@ static bool inode_do_switch_wbs(struct inode *inode,
 		if (inode->i_state & I_DIRTY_ALL) {
 			/*
 			 * We need to keep b_dirty list sorted by
-			 * dirtied_time_when. However properly sorting the
+			 * dirtied_when. However properly sorting the
 			 * inode in the list gets too expensive when switching
 			 * many inodes. So just attach inode at the end of the
-			 * dirty list and clobber the dirtied_time_when.
+			 * dirty list and clobber the dirtied_when.
 			 */
-			inode->dirtied_time_when = jiffies;
+			inode->dirtied_when = jiffies;
 			inode_io_list_move_locked(inode, new_wb,
 						  &new_wb->b_dirty);
 		} else {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 326d51d5262c6..9e8cc75adceef 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -691,7 +691,9 @@ struct inode {
 	unsigned long		i_state;
 	struct rw_semaphore	i_rwsem;
 
-	unsigned long		dirtied_when;	/* jiffies of first dirtying */
+	/* Timestamp for writeback list ordering and age checks (jiffies). */
+	unsigned long		dirtied_when;
+	/* Start time for deciding when lazytime updates need writeback (jiffies). */
 	unsigned long		dirtied_time_when;
 
 	struct hlist_node	i_hash;
-- 
2.53.0



