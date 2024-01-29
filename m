Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD76157031;
	Mon, 29 Jan 2024 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548164; cv=none; b=rEL2St6ptR4/LPTmc/WR1vtUl9W2cXcEnpkWqh54bt9cD+A6Y6xUwLWMg9hHTQoEleEKsRSsJJqA9ChkxrQxcIrZjx1nZRUMY/5e5D0PoPZ4YB+2gRYa6f4RkTVnQuxHoVtOXnJEizumiumJbKDwvtsuGa563amGurw/HjEAuek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548164; c=relaxed/simple;
	bh=VIzH6X+C0jx5piuMgkuYhLB/A1kDDhKfNTYq8x+/B2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqKCfhka4Kq3wp45KwLs4YmvSQXtBeMpoD/fI08tM0Fav0du5zOv8A+Qr+heVXEPagklT5DsqROX8dNWUApZeiGkVn7E/PmiomEclEf2kpbQWMFL9yzJeFyUlmdIMoYF8KUh2Ux/KG1OXrsGQcY0mR8FM7uKKkakgD3RKOgo/Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0aBzFUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0aBzFUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FC4C43394;
	Mon, 29 Jan 2024 17:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548163;
	bh=VIzH6X+C0jx5piuMgkuYhLB/A1kDDhKfNTYq8x+/B2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0aBzFUZt64NpTfk2POqFx2v7olqaxeto32mRuv9VRW+2KmY2kkHvqCW66zcoC3kX
	 /F6Ufk7MFVqvC75UcmGhKNdeRIDCh1mTllYkDAPWluruYdCFrZx41/CD3KuTK/crPC
	 zojfjSf//JriV9WqdEZ5RFWdaqvKCAwBNebobMiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Altman <jaltman@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 179/346] afs: Fix error handling with lookup via FS.InlineBulkStatus
Date: Mon, 29 Jan 2024 09:03:30 -0800
Message-ID: <20240129170021.658741926@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 17ba6f0bd14fe3ac606aac6bebe5e69bdaad8ba1 ]

When afs does a lookup, it tries to use FS.InlineBulkStatus to preemptively
look up a bunch of files in the parent directory and cache this locally, on
the basis that we might want to look at them too (for example if someone
does an ls on a directory, they may want want to then stat every file
listed).

FS.InlineBulkStatus can be considered a compound op with the normal abort
code applying to the compound as a whole.  Each status fetch within the
compound is then given its own individual abort code - but assuming no
error that prevents the bulk fetch from returning the compound result will
be 0, even if all the constituent status fetches failed.

At the conclusion of afs_do_lookup(), we should use the abort code from the
appropriate status to determine the error to return, if any - but instead
it is assumed that we were successful if the op as a whole succeeded and we
return an incompletely initialised inode, resulting in ENOENT, no matter
the actual reason.  In the particular instance reported, a vnode with no
permission granted to be accessed is being given a UAEACCES abort code
which should be reported as EACCES, but is instead being reported as
ENOENT.

Fix this by abandoning the inode (which will be cleaned up with the op) if
file[1] has an abort code indicated and turn that abort code into an error
instead.

Whilst we're at it, add a tracepoint so that the abort codes of the
individual subrequests of FS.InlineBulkStatus can be logged.  At the moment
only the container abort code can be 0.

Fixes: e49c7b2f6de7 ("afs: Build an abstraction around an "operation" concept")
Reported-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c               | 12 +++++++++---
 include/trace/events/afs.h | 25 +++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 75896a677b96..9140780be5a4 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -716,6 +716,8 @@ static void afs_do_lookup_success(struct afs_operation *op)
 			break;
 		}
 
+		if (vp->scb.status.abort_code)
+			trace_afs_bulkstat_error(op, &vp->fid, i, vp->scb.status.abort_code);
 		if (!vp->scb.have_status && !vp->scb.have_error)
 			continue;
 
@@ -905,12 +907,16 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry,
 		afs_begin_vnode_operation(op);
 		afs_wait_for_operation(op);
 	}
-	inode = ERR_PTR(afs_op_error(op));
 
 out_op:
 	if (!afs_op_error(op)) {
-		inode = &op->file[1].vnode->netfs.inode;
-		op->file[1].vnode = NULL;
+		if (op->file[1].scb.status.abort_code) {
+			afs_op_accumulate_error(op, -ECONNABORTED,
+						op->file[1].scb.status.abort_code);
+		} else {
+			inode = &op->file[1].vnode->netfs.inode;
+			op->file[1].vnode = NULL;
+		}
 	}
 
 	if (op->file[0].scb.have_status)
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index e9d412d19dbb..caec276515dc 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -1216,6 +1216,31 @@ TRACE_EVENT(afs_file_error,
 		      __print_symbolic(__entry->where, afs_file_errors))
 	    );
 
+TRACE_EVENT(afs_bulkstat_error,
+	    TP_PROTO(struct afs_operation *op, struct afs_fid *fid, unsigned int index, s32 abort),
+
+	    TP_ARGS(op, fid, index, abort),
+
+	    TP_STRUCT__entry(
+		    __field_struct(struct afs_fid,	fid)
+		    __field(unsigned int,		op)
+		    __field(unsigned int,		index)
+		    __field(s32,			abort)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->op = op->debug_id;
+		    __entry->fid = *fid;
+		    __entry->index = index;
+		    __entry->abort = abort;
+			   ),
+
+	    TP_printk("OP=%08x[%02x] %llx:%llx:%x a=%d",
+		      __entry->op, __entry->index,
+		      __entry->fid.vid, __entry->fid.vnode, __entry->fid.unique,
+		      __entry->abort)
+	    );
+
 TRACE_EVENT(afs_cm_no_server,
 	    TP_PROTO(struct afs_call *call, struct sockaddr_rxrpc *srx),
 
-- 
2.43.0



