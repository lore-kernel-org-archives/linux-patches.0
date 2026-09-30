Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB153749FA;
	Wed, 30 Sep 2026 16:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787090; cv=none; b=lebde1E826Sk3ptyNcd0TwHXRfo8qFj4vqM7bkrPVAK+mupr7JTCv1W5BhDHutGUdxsdZgyF4tfHH7KbQSvvjTw2zITIghVq8hXK7t2ou8TuVCduDUY+LOMbKduCIVe0/WRQRN/+kG0gopeFpsRQPNZKcU/opcZSKPhiT51WXZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787090; c=relaxed/simple;
	bh=hmWGz4Pc14itNG8+J0jdp1UJaQUlb/MBWNYY1JgND/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKYr+vePdHz36X5flVOsg5ikafX6SnYClxQd56hOmbCidAjlM50afhzF//R65a6pKJ3HfPQacfoNPa4Bq3H+WownAD0E5vDs1zVpTGznk/5G2pUtFKKwSg4WBefSbuFv6vMzEXuprSF8uomP0LBSUtEdRaCfsoIJnEvIXtFcp7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1FyBgoG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1FyBgoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59AE1F008A1;
	Wed, 30 Sep 2026 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787089;
	bh=k7Ak9q2T05PiaNVY0hA5ZNG8CRJgDMMkvH8BiyWn374=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1FyBgoGX29heVl0Cl/+tN9FqBHmvK/PdDPWYIjmbr3aByFSCSvUwyFIAX3fzuqbH
	 bCjV19IVZ5pH8e6A+NtipRBEYuomjO2je/CWvhDL8sTW0fol81O2nfGrv9ZBbv4Th8
	 BMoO3wN0/iJI7wkzt+HtUGfysM/Z562cQnor9EuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 064/457] netfs, afs: Fix symlink reading
Date: Wed, 30 Sep 2026 17:22:49 +0200
Message-ID: <20260930152347.421152614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit c51e89c5b5db3e1927738fad7cd18b66dde68aed ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/read_collect.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 5cf22087d2439..a94197ef01811 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -435,6 +435,11 @@ static void netfs_rreq_assess_single(struct netfs_io_request *rreq)
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
-- 
2.53.0



