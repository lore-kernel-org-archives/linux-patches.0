Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1377148094F;
	Tue, 25 Aug 2026 13:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665412; cv=none; b=jttrgasRDDoY/xA/TeIbOZElOLeiolcwv7Owut6kbV98AjDpEuC/ekwv3D+5QkXF6S/g03z5N5dk/IhTq2pLQl3yUgqvX77Z95QskA09GoM0+sGHmKujs/9OiSQeBgp1qWBN3ni2u8iD4jPC4glLlPwl5h/lHaPiJ8c3piaLVfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665412; c=relaxed/simple;
	bh=U5Yi9mjH/C5027DAriD3cS4tVRGGXDxJQw5fYNEo0ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIOALbUCGngE3gz0M++ioNEKXaiYpOD/fQLq4P3K9l4MZxxJxI4JZHz7R2EgIXHpX+nZ+XmtzypVvIebgEvKQCIJOjYOkF3MjlizJgZW28ufzwGVOZ+dqaQeUgeYgwQwYfTPfTqafp8UKcRVTHcDBrRAEuVYkMdO+19Kk9CrNhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2A/wCbuZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2A/wCbuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736321F000E9;
	Tue, 25 Aug 2026 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665411;
	bh=rmJtCMVBjay2n/U0dxbsYTKZJ0f4XUSNvJQ5PRNR1XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2A/wCbuZgyhu833XfxLJKVD2y30NKHcg5Ox0fFnE+UmVez0uZp+xjWi9ZfGsgKIHP
	 36lSt/UV73XpCAcbc6AeIn+YvioTFbusftWkwAOP7uEm9HPbwbFhhuNDx7JzGghX3G
	 kTIcRgLuIUhpAo4TxvjMve34N85eXKfnOqvuGCss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Shishkin Aleksey <demonaxsh@gmail.com>
Subject: [PATCH 6.12 08/77] netfs: Fix potential UAF in netfs_unlock_abandoned_read_pages()
Date: Tue, 25 Aug 2026 15:25:30 +0200
Message-ID: <20260825132541.880648723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit dbe556972100fabb8e5a1b3d2163831ff07b1e8e upstream.

netfs_unlock_abandoned_read_pages(rreq) accesses the index of the folios it
is wanting to unlock and compares that to rreq->no_unlock_folio so that it
doesn't unlock a folio being read for netfs_perform_write() or
netfs_write_begin().

However, given that netfs_unlock_abandoned_read_pages() is called _after_
NETFS_RREQ_IN_PROGRESS is cleared, the one folio that it's not allowed to
dereference is the one specified by ->no_unlock_folio as ownership
immediately reverts to the caller.

Fix this by storing the folio pointer instead and using that rather than
the index.  Also fix netfs_unlock_read_folio() where the same applies.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-20-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Shishkin Aleksey <demonaxsh@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/buffered_read.c |    4 ++--
 fs/netfs/read_collect.c  |    2 +-
 fs/netfs/read_retry.c    |    2 +-
 include/linux/netfs.h    |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -734,7 +734,7 @@ retry:
 		ret = PTR_ERR(rreq);
 		goto error;
 	}
-	rreq->no_unlock_folio	= folio->index;
+	rreq->no_unlock_folio	= folio;
 	__set_bit(NETFS_RREQ_NO_UNLOCK_FOLIO, &rreq->flags);
 
 	ret = netfs_begin_cache_read(rreq, ctx);
@@ -800,7 +800,7 @@ int netfs_prefetch_for_write(struct file
 		goto error;
 	}
 
-	rreq->no_unlock_folio = folio->index;
+	rreq->no_unlock_folio = folio;
 	__set_bit(NETFS_RREQ_NO_UNLOCK_FOLIO, &rreq->flags);
 	ret = netfs_begin_cache_read(rreq, ctx);
 	if (ret == -ENOMEM || ret == -EINTR || ret == -ERESTARTSYS)
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -73,7 +73,7 @@ static void netfs_unlock_read_folio(stru
 	}
 
 	if (!test_bit(NETFS_RREQ_DONT_UNLOCK_FOLIOS, &rreq->flags)) {
-		if (folio->index == rreq->no_unlock_folio &&
+		if (folio == rreq->no_unlock_folio &&
 		    test_bit(NETFS_RREQ_NO_UNLOCK_FOLIO, &rreq->flags)) {
 			_debug("no unlock");
 		} else {
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -249,7 +249,7 @@ void netfs_unlock_abandoned_read_pages(s
 			struct folio *folio = folioq_folio(p, slot);
 
 			if (folio && !folioq_is_marked2(p, slot)) {
-				if (folio->index == rreq->no_unlock_folio &&
+				if (folio == rreq->no_unlock_folio &&
 				    test_bit(NETFS_RREQ_NO_UNLOCK_FOLIO,
 					     &rreq->flags)) {
 					_debug("no unlock");
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -266,7 +266,7 @@ struct netfs_io_request {
 	atomic64_t		issued_to;	/* Write issuer folio cursor */
 	unsigned long long	collected_to;	/* Point we've collected to */
 	unsigned long long	cleaned_to;	/* Position we've cleaned folios to */
-	pgoff_t			no_unlock_folio; /* Don't unlock this folio after read */
+	const struct folio	*no_unlock_folio; /* Don't unlock this folio after read */
 	size_t			prev_donated;	/* Fallback for subreq->prev_donated */
 	refcount_t		ref;
 	unsigned long		flags;


