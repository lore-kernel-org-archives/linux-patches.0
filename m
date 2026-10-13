Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D154EB863;
	Tue, 13 Oct 2026 12:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894578; cv=none; b=RoGJ5+IrZdpHAKYCyqev7vxNUpO65q6Cd06YyJ+F2N7wK7CQXUbDhm4YmY0xizziDqRkhalt8b/Y+oE4iIa5N+CWDWDgL7r+ZJGpnpeheq1fEVbh9WUW0gEpHd1lsadxwwqwJ1JjFSlsQvshl39pMIk5MbR8ya/zoeuMXSmGyyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894578; c=relaxed/simple;
	bh=h2tEYLJbh89N1xoKrdJelWY3joMHpBfJM6MxGPr3f+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptQ35cJDpjNY3kIH2NBaH2Ts24tA1Xk44Q5O92HI4HQuDj8c8PSiVr02RPSkPpzvMPCYTIa4/RoWgJ5bLlOBky/6Y0BeBbYei0LEbgLmAqyqgxu3N0DHZHkslBGusiOn0duq/IEpHqthbD7V2xh/sGYx1WHH7Lrx7QbTdY7KwgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RI+u6qsk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RI+u6qsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101411F000FF;
	Tue, 13 Oct 2026 12:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894576;
	bh=A82Av64ol4GW2UvW2DxkzkGYeS8kBXtm4Fd6L/Dn7Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RI+u6qskLBUIvmvhRhHhqdaxqDCNs5Nnz5Ns3kBAhfDfKin41RrSQOb47uowVj/Jw
	 bo4FQxBBCK6fyqRGukG6GW6KaXKbfMdyrLhC5odpTXVYp7mU4+jTeXjREJDVASJrzS
	 UBzeP1Bcz50l2DXVkhLvB74Qf2hdmKEmHUNlsuOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 606/621] netfs, afs: Fix symlink reading
Date: Tue, 13 Oct 2026 13:40:01 +0200
Message-ID: <20261013112935.179179942@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

commit c51e89c5b5db3e1927738fad7cd18b66dde68aed upstream.

Fix the reading of symlinks from the cache in afs by making netfslib trim
the amount read down to i_size.  The problem is that afs sets the size of
the iterator to the size of the buffer (PAGE_SIZE) so that the cache can
round the read size up to the cache's DIO size.

Note that this also impacts the reading of AFS mountpoints as they're just
stored as symlinks with an odd file mode.

Link: https://patch.msgid.link/3912795.1789489319@warthog.procyon.org.uk
Fixes: c0410adf3da6 ("afs: Fix the locking used by afs_get_link()")
Reviewed-by: Paulo Alcantara <pc@manguebit.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/read_collect.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -409,6 +409,11 @@ static void netfs_rreq_assess_single(str
 		netfs_single_mark_inode_dirty(rreq->inode);
 	}
 
+	/* To do DIO, the cache has to round the size up, so we need to undo
+	 * the rounding.
+	 */
+	rreq->transferred = min(rreq->transferred, rreq->i_size);
+
 	if (rreq->iocb) {
 		rreq->iocb->ki_pos += rreq->transferred;
 		if (rreq->iocb->ki_complete) {


