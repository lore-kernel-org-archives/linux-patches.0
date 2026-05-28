Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B0D3164B7;
	Thu, 28 May 2026 20:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998655; cv=none; b=fmt5ehbQ50mJ91UiHw6ELejbBjhchlnpVZH5D8c1fHQMJCqH4GDBPPYm5vnGJ6u86bdfFRHbyp66HbtpLQ+hGJfNeoWjJPy1vDToQ/7lVzGgvjSnL0qO6fFnVnYodr6vIMw+MvGi42J2fybSA4v32/T0nw1Ajbzs0zpXJnMMJhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998655; c=relaxed/simple;
	bh=XJSIDlwq1Qrn2KgududYJqTxTOHPrfOpd8CO7Lls4Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5J1OVmRAmA1wAjSICgBNDp4CHwiDWlQPZwB5g6wndZUiamtWw0RrfDyI/Sn5xHpgpm149yA4RZz0C9vWbBi0FsRVDtY6lYi5xSe+w1/VsciXsR+gaKFeKuwAMEtopGzMos5i3pMb57CylprQZkS5YWTsQTW79eGfyJbSIENAoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfkNri3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfkNri3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE771F000E9;
	Thu, 28 May 2026 20:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998654;
	bh=Ptg+ocnKUHL78QZ/Cl+Lkeja9skaf3MXMemV7xbXFDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rfkNri3WzthB22iZxV7bCitG+gsiHcIpsEsJcPce6w3o19xGPI9LoWtAHU123ycHZ
	 ghVj9MIkiwfPkHEmp+jEVLQFbCoM1jcaMAbsYoHqjExoLOIsnC00dpC38x5vYB6ShZ
	 YU9I7ft0LktryouYVXKNZrn3J4s97wrw+IBZDLY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 251/461] netfs: Fix missing locking around retry adding new subreqs
Date: Thu, 28 May 2026 21:46:20 +0200
Message-ID: <20260528194654.416593338@linuxfoundation.org>
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

[ Upstream commit cce18c263e9623872327ba3c956012f73c1179cc ]

Fix netfs_retry_read_subrequests() and netfs_retry_write_stream() to take
the appropriate lock when adding extra subrequests into
stream->subrequests.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Closes: https://sashiko.dev/#/patchset/20260425125426.3855807-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-3-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/read_retry.c  | 6 +++++-
 fs/netfs/write_retry.c | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index cca9ac43c0773..5ec548b996d65 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -175,7 +175,9 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 			list_for_each_entry_safe_from(subreq, tmp,
 						      &stream->subrequests, rreq_link) {
 				trace_netfs_sreq(subreq, netfs_sreq_trace_superfluous);
+				spin_lock(&rreq->lock);
 				list_del(&subreq->rreq_link);
+				spin_unlock(&rreq->lock);
 				netfs_put_subrequest(subreq, netfs_sreq_trace_put_done);
 				if (subreq == to)
 					break;
@@ -203,8 +205,10 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 					     refcount_read(&subreq->ref),
 					     netfs_sreq_trace_new);
 
+			spin_lock(&rreq->lock);
 			list_add(&subreq->rreq_link, &to->rreq_link);
-			to = list_next_entry(to, rreq_link);
+			spin_unlock(&rreq->lock);
+			to = subreq;
 			trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
 
 			stream->sreq_max_len	= umin(len, rreq->rsize);
diff --git a/fs/netfs/write_retry.c b/fs/netfs/write_retry.c
index 29489a23a2209..32735abfa03f0 100644
--- a/fs/netfs/write_retry.c
+++ b/fs/netfs/write_retry.c
@@ -130,7 +130,9 @@ static void netfs_retry_write_stream(struct netfs_io_request *wreq,
 			list_for_each_entry_safe_from(subreq, tmp,
 						      &stream->subrequests, rreq_link) {
 				trace_netfs_sreq(subreq, netfs_sreq_trace_discard);
+				spin_lock(&wreq->lock);
 				list_del(&subreq->rreq_link);
+				spin_unlock(&wreq->lock);
 				netfs_put_subrequest(subreq, netfs_sreq_trace_put_done);
 				if (subreq == to)
 					break;
@@ -153,8 +155,10 @@ static void netfs_retry_write_stream(struct netfs_io_request *wreq,
 					     netfs_sreq_trace_new);
 			trace_netfs_sreq(subreq, netfs_sreq_trace_split);
 
+			spin_lock(&wreq->lock);
 			list_add(&subreq->rreq_link, &to->rreq_link);
-			to = list_next_entry(to, rreq_link);
+			spin_unlock(&wreq->lock);
+			to = subreq;
 			trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
 
 			stream->sreq_max_len	= len;
-- 
2.53.0



