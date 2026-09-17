Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE4B50257F;
	Thu, 17 Sep 2026 17:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665069; cv=none; b=RN7HJSS8IumR1vPB4FCyT9SyOvq6ySVPdmtc6cfMyrae+NZ1D9MdMT3gDLlKfotrqymA0w+oad+Ji1oSu0YQHIeLeRXFo/BL6vJ8FuUG3ylwtNRl2pXN9tOSoi7IRmXhoUZl6gn/Y1Naiy1ZzLHGNsHIwzDBoMuVrpm/xEowCf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665069; c=relaxed/simple;
	bh=VyAisWUoynKO5KRDjhTTs2RRs7sVRYA4SDG/PTD09Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdPCfrewO6ctvkzSo6HoETI3nNZPh3E0N2IQWNjQpf8n77tYJ2ut9G+brh9hic8AySxFG8l4137dWQYDRuWdk83jxCxhkLERqy42t9UIK/lYV5N5DloHOsP5IT08SpD714TUe3O/QiBU/m7f2ZxK96nckC4XtlMQBjbHaeoBGVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4a2tN3A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4a2tN3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4131F00893;
	Thu, 17 Sep 2026 17:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665068;
	bh=FMy54a/WMjKHZwBoCfsTxjdvODGE1ijkvF8u/O14JHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4a2tN3AucZwPkIa97csmDIH5Bmq6Nx84r3oz5PSMlIKvCeb8fKVS5j8MG+XkwZ3v
	 qDWIMxffWQk3/x9MEzzpr//dh6qIv2sPGRY40fpJ+NQjneDxTHLEpL+rM/Ea+47PJz
	 I0/413t3AmXKkuX52ylx4cSOfJz9TpYo53LQdQCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0582/1250] netfs: Fix barriering when walking subrequest list
Date: Thu, 17 Sep 2026 16:06:17 +0100
Message-ID: <20260917151607.663061494@linuxfoundation.org>
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

[ Upstream commit 5c6ce05e406520290c1d89da97fb3cd70c09137d ]

Fix the barriering used when walking the subrequest list in retry as
there's a possibility of seeing a subreq that's just been added by the
application thread.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/138807.1782980582@warthog.procyon.org.uk
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/read_retry.c  | 7 ++++++-
 fs/netfs/write_retry.c | 7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index f59a70f3a086b..2b42758e01ec9 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -98,7 +98,12 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 			goto abandon;
 		}
 
-		list_for_each_continue(next, &stream->subrequests) {
+		for (;;) {
+			/* Read pointer to subreq before reading subreq state. */
+			next = smp_load_acquire(&next->next);
+			if (next == &stream->subrequests)
+				break;
+
 			subreq = list_entry(next, struct netfs_io_subrequest, rreq_link);
 			if (subreq->start + subreq->transferred != start + len ||
 			    test_bit(NETFS_SREQ_BOUNDARY, &subreq->flags) ||
diff --git a/fs/netfs/write_retry.c b/fs/netfs/write_retry.c
index 32735abfa03f0..058bc7a166a59 100644
--- a/fs/netfs/write_retry.c
+++ b/fs/netfs/write_retry.c
@@ -72,7 +72,12 @@ static void netfs_retry_write_stream(struct netfs_io_request *wreq,
 		    !test_bit(NETFS_SREQ_NEED_RETRY, &from->flags))
 			return;
 
-		list_for_each_continue(next, &stream->subrequests) {
+		for (;;) {
+			/* Read pointer to subreq before reading subreq state. */
+			next = smp_load_acquire(&next->next);
+			if (next == &stream->subrequests)
+				break;
+
 			subreq = list_entry(next, struct netfs_io_subrequest, rreq_link);
 			if (subreq->start + subreq->transferred != start + len ||
 			    test_bit(NETFS_SREQ_BOUNDARY, &subreq->flags) ||
-- 
2.53.0



