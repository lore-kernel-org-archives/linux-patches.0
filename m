Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF31B51EDE7;
	Thu, 17 Sep 2026 17:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665261; cv=none; b=SK+uItihc5+HP2pyzgTXuoHWXeuLWLoALQlA/Fgmu+v9u66koHP7svkbDu+OJNKt4Ge+kcYM6t5e5zKBpF8JbHe6UMkYeMQ9q8p6QOuva962yOH7Uw0/P6MEIxW94iRXXQmC4mqUJJBLodY1YM+bCYGDWh9EPp1rnGeyZ9an0s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665261; c=relaxed/simple;
	bh=qT7PS//0JnIlHMSSbnNaL5465W56pC9K0NbDMriVqKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LADtt6r6/JD6rxtx0CKVIDi9JV88BVzetCqb5lTwPt4RQJXrQKIGMy4tJvBwiRJqtIE8HQLXIbHqH9NmQKJwFe+TDQ8w41xghOs2MkQZRYK/E+agzMsFhOqHDzUluHZg2/Ei9X5s9uKSsnbfGcS6LCk38wCCNERkbBXcZbi6AXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlkjMqtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlkjMqtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD191F00893;
	Thu, 17 Sep 2026 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665260;
	bh=mirbgqFlG8MEYJW3231eNCSzGv4JndrcQSabWtJ7X5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlkjMqttBC3zbFRVyKqlxC1bAuRNDci6GpJcM0KEl+oaw8GZvFN4LA1qv1Lo6GIx4
	 m5j0AMfWqpHgLtJ7T2L3A/l+3kAkbWBDzcu8WHzBDOSirYdNL99ri3Rtdd3jTCJCe4
	 oGjGRtV1h4w8IHXutfGGIqmtL1cpED0mfm+bptl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0644/1250] netfs: Fix i_size update for partial transfer
Date: Thu, 17 Sep 2026 16:07:19 +0100
Message-ID: <20260917151609.352600347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 741416a8003b77e636dafade408f808d96ac3f47 ]

Fix netfs_unbuffered_write_done() to pass the amount written to
netfs_update_i_size() in the event of a partial transfer that ends in an
error.

That said, it might be better for the filesystem to mark the inode data as
invalid and recheck it in case something like a network error occurred that
prevented the reply from the server from being received.

Fixes: a0b4c7a49137e ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Link: https://sashiko.dev/#/patchset/20260824120224.504575-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260827134304.2075713-5-dhowells@redhat.com
Acked-by: Paulo Alcantara <pc@manguebit.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/direct_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index 4b81e8a6fb438..6cba5bd60361d 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -21,7 +21,7 @@ static void netfs_unbuffered_write_done(struct netfs_io_request *wreq)
 	/* Okay, declare that all I/O is complete. */
 	trace_netfs_rreq(wreq, netfs_rreq_trace_write_done);
 
-	if (!wreq->error)
+	if (wreq->transferred)
 		netfs_update_i_size(ictx, &ictx->inode, wreq->start, wreq->transferred);
 
 	if (wreq->origin == NETFS_DIO_WRITE &&
-- 
2.53.0



