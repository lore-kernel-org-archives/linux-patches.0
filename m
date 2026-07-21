Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95D1471250;
	Tue, 21 Jul 2026 18:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658109; cv=none; b=ZBF2Y2d5QYKgy5vc7Rq61Wt2VrhtmQhZKk8onM+F1CfwKQsz9Cit94DuL32sFz7gHYuVb1rqt+kAh35KgpyvfcsbjesmnpKDa5xofzO0ENMeUqSv986ENm+6dY2iCPkABzkSIe1TyWJnN7d1HqPHMRQN07uKnip5D0C5PLZnJAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658109; c=relaxed/simple;
	bh=iFeHSlbMLqnO76RBjfCmsUznL9JX1NcVmQDX23gb7D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0P8/Lf30qok1PaFqifaEzcnf7ZpltomYxaU3mVgUDOumD3m4mavqsFm6Ww4DrTxXvVLQ1QNLpkIzISfCFMO+IGeV6cd1v14RHNBNdqi8M045iP07CCSb4mf4w6guSUOZqMvt9bghpdPPCuPnxocX52mxvqVBICuw/mNmXOqCBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iX9ZdxnA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iX9ZdxnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216F81F000E9;
	Tue, 21 Jul 2026 18:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658108;
	bh=uFX+iqHihzL1L8uocJYJqdCNslG6pVKorU6L0VAeViU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iX9ZdxnA5J+PKG6mREN4kurqbcuvni4zfI0QhfZbo37wOD+rVcz+EdnUXurGjn7rv
	 64Zrlb8vfuUPhncgkCNm3DrRMlGz7gTj8tTQOepgz0n6XGCaG7BW4jmZCBuT4JETmG
	 PGOvMiYR8yUA6qoNdAY0WCj08uUQrSI0WzjrWB8E=
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
Subject: [PATCH 6.18 1017/1611] netfs: Fix writethrough to use collection offload
Date: Tue, 21 Jul 2026 17:18:53 +0200
Message-ID: <20260721152538.268168055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit ba6a9f6533c77c628eef0c0c5c19cd316e2be1b4 ]

Fix writethrough write to set NETFS_RREQ_OFFLOAD_COLLECTION on the request
so that collection is processed asynchronously rather than only right at
the end - and also so that asynchronous O_SYNC writes get collected at all.

Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Closes: https://sashiko.dev/#/patchset/20260616100821.2062304-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-13-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/write_issue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 26289849343037..79b4085590fdb8 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -627,6 +627,7 @@ struct netfs_io_request *netfs_begin_writethrough(struct kiocb *iocb, size_t len
 	}
 
 	wreq->io_streams[0].avail = true;
+	__set_bit(NETFS_RREQ_OFFLOAD_COLLECTION, &wreq->flags);
 	trace_netfs_write(wreq, netfs_write_trace_writethrough);
 	return wreq;
 }
-- 
2.53.0



