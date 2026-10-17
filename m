Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A682248B3;
	Sat, 17 Oct 2026 16:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254163; cv=none; b=HbxBhhM7xDmQ+gm/WsEAlx0/97M6Ue7KzpJtnEfQYhqt9DypzH9A8eKgo2tzgkYBGLiOTVMFwKnAeBf+h6Km5kL9n+v2tpg/ThlAyxzlxMj000E6P+1Fp/7SX1Babqr5vRUKbtzd/rbviwz52D1sk1u5mRU5fexcwi98nCWUhQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254163; c=relaxed/simple;
	bh=573aALkI6ygS10sTpHOQ/FI7UAyi8SLfMXCCmivh82U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGaCrxN51xRq3ymQuCF4QspNIrecTPU7r8mcXDq6csIm2NDcqmDMqOieXpkv+zgjaPvYM9lim3xHJc8eLHyehaqO6ihbp4J4/MmtEuQBl/HoO9eROCwzMsX+kHU8lm3vm4up96scsJhpog5Zwl3tjVdzOwiqZp+CFsFnF2prDcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFnzQvDG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFnzQvDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA26F1F000C4;
	Sat, 17 Oct 2026 16:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254162;
	bh=B/DQCLIYadzjVrnF83FGXwttCSzoHCf8mjMIVCPtEHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFnzQvDGqoScS9SQCn6sfZQtA7PsAAixIQ1TxRoKDgQ18uCg4puoNTLAD1kmWihMV
	 Q0Xe0IK49u1XwM9/zlGiRdvB/gqfc/dpxJRT93gzTcADnaQLBW9y7eEK8dmJIXne6u
	 ZrYzgu2JjIFeag6xcR0lG7IA4umqI9QVwT6Y9aPE=
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
Subject: [PATCH 6.12 356/869] netfs: Fix missing locking around retry adding new subreqs
Date: Sat, 17 Oct 2026 17:53:17 +0200
Message-ID: <20261017160046.234460515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 fs/netfs/write_collect.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index c349867d74c34..ad2edf794f0ff 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -263,7 +263,9 @@ static void netfs_retry_write_stream(struct netfs_io_request *wreq,
 			list_for_each_entry_safe_from(subreq, tmp,
 						      &stream->subrequests, rreq_link) {
 				trace_netfs_sreq(subreq, netfs_sreq_trace_discard);
+				spin_lock_bh(&wreq->lock);
 				list_del(&subreq->rreq_link);
+				spin_unlock_bh(&wreq->lock);
 				netfs_put_subrequest(subreq, false, netfs_sreq_trace_put_done);
 				if (subreq == to)
 					break;
@@ -287,8 +289,10 @@ static void netfs_retry_write_stream(struct netfs_io_request *wreq,
 					     netfs_sreq_trace_new);
 			trace_netfs_sreq(subreq, netfs_sreq_trace_split);
 
+			spin_lock_bh(&wreq->lock);
 			list_add(&subreq->rreq_link, &to->rreq_link);
-			to = list_next_entry(to, rreq_link);
+			spin_unlock_bh(&wreq->lock);
+			to = subreq;
 			trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
 
 			stream->sreq_max_len	= len;
-- 
2.53.0



