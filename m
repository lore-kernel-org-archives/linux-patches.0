Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E908051DDF4;
	Thu, 17 Sep 2026 17:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665256; cv=none; b=R/VC8gjiMVIVdGLgey7orZH1YB8KVKxAFLT3nQCL/hbEWy0cj13Xc1EsqA0JjpkMfeaJ+qErBB3YbeWv6F2NNDb8IeoJeAgdcKIvydZf8l7V+3Gp1RynaCYUOywv+21nNAJvR6jpNybCgT9J3yoTEyN9uvXyNh/VTkEZE41avTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665256; c=relaxed/simple;
	bh=1dDFeS8fndERi9K+H6Lt/lc7mch7YmQ5c6262tKjF9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWSczyHT1oAnqWqJaftW/YJqdDGTM1PNHR7GELpO2J27olNWdo8/bC/4IEUpKIOtHC2D9k6UfdVk2ZM9UCWmOZNtfZRGVXONEJbH0kwHA1ZiiwGvISpe8u+OkiAfWZz8BTVp7dx6nWLU+z7xA8tsICOAkR9AHEYhldqaKnW1iU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0ejkuEu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0ejkuEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC251F000FF;
	Thu, 17 Sep 2026 17:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665254;
	bh=+gbhY0rKx87qe0RWi7tNHlHtKwtHl+iH99LOiLIi2LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0ejkuEu7abN2sdHeOw3tn91IePT+EYXuwjrWDYuuiucdS8MEUS3uo/1Ru4BloO63
	 jLpqapBOoyCiPfAn8KsRMzkTXYkZH4lrdm0/d5sROoHmTXXxf5K+anvGediRhcxkgX
	 2LVUBdaNcxbEbvFawDgTZwAOuE60rGZq1wqMzYGs=
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
Subject: [PATCH 6.18 0642/1250] netfs: Fix unbuffered/DIO write partial transfer error return
Date: Thu, 17 Sep 2026 16:07:17 +0100
Message-ID: <20260917151609.292521686@linuxfoundation.org>
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

[ Upstream commit c753a33664e4e86246f7491a93d9a77c1a673b5d ]

Fix unbuffered/DIO write to return the amount of data transferred in
preference to an error if a partial transfer has been achieved, and to
prefer an error stashed in the request over the one returned by
netfs_unbuffered_write() (likely -EINTR or -ERESTARTSYS).

Fixes: a0b4c7a49137e ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Link: https://sashiko.dev/#/patchset/20260824120224.504575-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260827134304.2075713-3-dhowells@redhat.com
Acked-by: Paulo Alcantara <pc@manguebit.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/direct_write.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index f9ab69de3e298..cc5151ea75a11 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -139,13 +139,11 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 		if (test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags)) {
 			retry = true;
 		} else if (test_bit(NETFS_SREQ_FAILED, &subreq->flags)) {
-			ret = subreq->error;
-			wreq->error = ret;
+			wreq->error = subreq->error;
 			netfs_see_subrequest(subreq, netfs_sreq_trace_see_failed);
 			subreq = NULL;
 			break;
 		}
-		ret = 0;
 
 		if (!retry) {
 			netfs_unbuffered_write_collect(wreq, stream, subreq);
@@ -292,11 +290,11 @@ ssize_t netfs_unbuffered_write_iter_locked(struct kiocb *iocb, struct iov_iter *
 		ret = -EIOCBQUEUED;
 	} else {
 		ret = netfs_unbuffered_write(wreq);
-		if (ret < 0) {
-			_debug("begin = %zd", ret);
-		} else {
+		if (wreq->transferred) {
 			iocb->ki_pos += wreq->transferred;
-			ret = wreq->transferred ?: wreq->error;
+			ret = wreq->transferred;
+		} else if (wreq->error) {
+			ret = wreq->error;
 		}
 
 		netfs_put_request(wreq, netfs_rreq_trace_put_complete);
-- 
2.53.0



