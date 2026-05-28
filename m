Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98041413D8E;
	Thu, 28 May 2026 20:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998702; cv=none; b=H2Avvlzzm4J+Scxx5QdiGfThwV4CcGdFyU0cWxEM2MFpPNA12dUCcM5edsHsCUY242o0PqmG/Fz6xJD2f9oOBNgsH9RbDW1h9vRM34R1PRmcqz2NB7fNNoa/8Oeu66KviIP/ncUPB/AX42iTZYNlG7EMVfEn16Fq2zWyvkMeXYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998702; c=relaxed/simple;
	bh=H65xPM3+itimHWW6W/s9dBynZu10LWgKV4mp5j6Mdp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpoL/LC6qUTulNpsOQmBIkCZwV9PIgeSsiFLERQg08s72ONiZnU8vqq/M0CLjk9YEc54xXfCd5VqVbsxdN2RWzyF3AWUfQZHVO2MWJUXiRLkTKy/GozB7N/Eqqqy9QE0LbswQmFcTTbSQjWWz6oEInVp83K+4rVVxuWrhJDFvgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iADPqcT5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iADPqcT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A9B1F000E9;
	Thu, 28 May 2026 20:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998701;
	bh=oOauYayf3SuJzh9wziOySAiZg54G3Ibtp02jYXklF7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iADPqcT5J28OPsV0dG5lmiOKovnzeZ18VDQf7bQ0mhDPMbOAChKBdRgqh3smRgGsC
	 k8nB6/hZRD8W8dheewjrHLKychFtMXlFW/e0j+S0QbAH+VYDzz2ajLb4X13lBFYOLW
	 QIp/EIQk+jr0KnPn6mq+IFNp5OQlfbSnv/QgjsxA=
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
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 266/461] netfs: Fix potential UAF in netfs_unlock_abandoned_read_pages()
Date: Thu, 28 May 2026 21:46:35 +0200
Message-ID: <20260528194654.866476259@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit dbe556972100fabb8e5a1b3d2163831ff07b1e8e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 4 ++--
 fs/netfs/read_collect.c  | 2 +-
 fs/netfs/read_retry.c    | 2 +-
 include/linux/netfs.h    | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 004d426c02b41..83d0b8153e96e 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -670,7 +670,7 @@ int netfs_write_begin(struct netfs_inode *ctx,
 		ret = PTR_ERR(rreq);
 		goto error;
 	}
-	rreq->no_unlock_folio	= folio->index;
+	rreq->no_unlock_folio	= folio;
 	__set_bit(NETFS_RREQ_NO_UNLOCK_FOLIO, &rreq->flags);
 
 	ret = netfs_begin_cache_read(rreq, ctx);
@@ -736,7 +736,7 @@ int netfs_prefetch_for_write(struct file *file, struct folio *folio,
 		goto error;
 	}
 
-	rreq->no_unlock_folio = folio->index;
+	rreq->no_unlock_folio = folio;
 	__set_bit(NETFS_RREQ_NO_UNLOCK_FOLIO, &rreq->flags);
 	ret = netfs_begin_cache_read(rreq, ctx);
 	if (ret == -ENOMEM || ret == -EINTR || ret == -ERESTARTSYS)
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 3c9b847885c2a..23660a5901246 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -83,7 +83,7 @@ static void netfs_unlock_read_folio(struct netfs_io_request *rreq,
 	}
 
 just_unlock:
-	if (folio->index == rreq->no_unlock_folio &&
+	if (folio == rreq->no_unlock_folio &&
 	    test_bit(NETFS_RREQ_NO_UNLOCK_FOLIO, &rreq->flags)) {
 		_debug("no unlock");
 	} else {
diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index e10eb5a073326..f59a70f3a086b 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -292,7 +292,7 @@ void netfs_unlock_abandoned_read_pages(struct netfs_io_request *rreq)
 			struct folio *folio = folioq_folio(p, slot);
 
 			if (folio && !folioq_is_marked2(p, slot)) {
-				if (folio->index == rreq->no_unlock_folio &&
+				if (folio == rreq->no_unlock_folio &&
 				    test_bit(NETFS_RREQ_NO_UNLOCK_FOLIO,
 					     &rreq->flags)) {
 					_debug("no unlock");
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 4fd1d796ad73b..243c0f7379388 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -252,7 +252,7 @@ struct netfs_io_request {
 	unsigned long long	collected_to;	/* Point we've collected to */
 	unsigned long long	cleaned_to;	/* Position we've cleaned folios to */
 	unsigned long long	abandon_to;	/* Position to abandon folios to */
-	pgoff_t			no_unlock_folio; /* Don't unlock this folio after read */
+	const struct folio	*no_unlock_folio; /* Don't unlock this folio after read */
 	unsigned int		direct_bv_count; /* Number of elements in direct_bv[] */
 	unsigned int		debug_id;
 	unsigned int		rsize;		/* Maximum read size (0 for none) */
-- 
2.53.0



