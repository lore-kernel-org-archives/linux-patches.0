Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2BC4ABBB6;
	Thu, 17 Sep 2026 15:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659038; cv=none; b=ZiojJdBXUp3PztLZwYN+dmuZANQHRLdO67/kk7plPoQEBboDf1cg5RhhqgYCC5/gxhnvQ6yw0LyPI9QMm+BQUZ7ehMzrt4VBSlkp7mDBTcfrQWs+HxNhjw2Zd0IC8PkLkOl6lf5EywPsQTfmrnGJx8KxRgAGI3TG5UufqHxko08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659038; c=relaxed/simple;
	bh=LiaYuZtQ8JlwfyZgu0VQ4Amp+bN0rcOCdBGqhDtSxic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+F/uKCjvnlBxblSes7eZDSgraAr4iwgPy9ozsved+a1KW9Y4Up3y0mh7lyqNxI9hOHg/8ydHrBGN/GzrT1oELMCVMxeckisIjKha4/T/H4ja4q9fxSvUVikON5jUmdGeJRkoiHJQdlJ5a9kEHPpW312ebnwyQlASNWmLOhUIhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0bxrrZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0bxrrZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC78C1F0089A;
	Thu, 17 Sep 2026 15:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659025;
	bh=1CGdzmeuX7AFdXlYom1MFtyS8yCoB9ZxxD07T8x1drw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0bxrrZhZN1sNSE03tXNm9InUTvaz51FDTlXTnIz6O3dmcNn63DNbhnn70ou39elQ
	 S6f7ibFAg2CVVPxap/mJJ+2QklwUzF9a2Y+GRvDfi2Eo9K4E+p8pfSpEOgUHvYED4O
	 TXo7Q3uePMRcW14/ZfTVbypccRmucQd0S0Rd4H98=
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
Subject: [PATCH 7.2 081/733] netfs: Fix error vs transferred passed to ->ki_complete()
Date: Thu, 17 Sep 2026 16:06:29 +0100
Message-ID: <20260917151352.915438841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

[ Upstream commit 0bfe2571a6af653611860d0e24c4e4c83bae7a54 ]

Fix netfs_unbuffered_write_done() to pass the amount written to
->ki_complete() rather than the error in the event of a partially complete
transfer.

Fixes: a0b4c7a49137e ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Link: https://sashiko.dev/#/patchset/20260824120224.504575-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260827134304.2075713-4-dhowells@redhat.com
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
index d53b42ceadd23..e563532c2e598 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -51,7 +51,7 @@ static void netfs_unbuffered_write_done(struct netfs_io_request *wreq)
 		wreq->iocb->ki_pos += written;
 		if (wreq->iocb->ki_complete) {
 			trace_netfs_rreq(wreq, netfs_rreq_trace_ki_complete);
-			wreq->iocb->ki_complete(wreq->iocb, wreq->error ?: written);
+			wreq->iocb->ki_complete(wreq->iocb, written ?: wreq->error);
 		}
 		wreq->iocb = VFS_PTR_POISON;
 	}
-- 
2.53.0



