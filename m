Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C56191F72;
	Tue, 10 Sep 2024 10:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963799; cv=none; b=lJ0LBO2Y7GR2g5A1lI0C2V40IWgQZoQ/WFAl3foZM2v1tO99Z9rHELfYxkX94+9KOj2PNP8X1hIk+AXH6x/bErZGlCAv+zs5mG3CCzUEwUeczW5Eh1cHTDTd+M/QbkmjU3mGgwXowb9jKXtYjKh+XZv2Me1vjVhbE/ma/VmSscU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963799; c=relaxed/simple;
	bh=8wQxykYQ19is8JR7BljfQNPayLQ8XHTgNFs2mo+Xl0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mArFSqSytxpKF5+sUn2bvVsFEZ2Ee7TMU/w5HKB9MLDHQ2gYNBLjk483x//xg8tr2LJasVuPtd4ezPKjmCbZU9d7yM9irvktlte037PP05XWke0I9MS/Pf8SnkUiCj1RaX9ASrlIC14d7KVLJ0u1z7+K+sIShwa9pRkXpYkdKWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TfNf93lh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TfNf93lh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2648C4CEC3;
	Tue, 10 Sep 2024 10:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963799;
	bh=8wQxykYQ19is8JR7BljfQNPayLQ8XHTgNFs2mo+Xl0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfNf93lhbpZlCZLTpGoxucY4MC9+rIQNiGU+blamgnd731GpOmZ/Pehh0ACW/a4Tw
	 W8oLWv2BI4P2eJr34kuml6q8v9YMj53T87Ji5poWXltoIlVwzjWYGxngsZzV4Nq0iV
	 iM0ZeBoRWCTBXZii32/BZeOHf7mNgRgLSJ3S08PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Bharath SM <bharathsm@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 5.15 173/214] cifs: Check the lease context if we actually got a lease
Date: Tue, 10 Sep 2024 11:33:15 +0200
Message-ID: <20240910092605.755228910@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 66d45ca1350a3bb8d5f4db8879ccad3ed492337a upstream.

Some servers may return that we got a lease in rsp->OplockLevel
but then in the lease context contradict this and say we got no lease
at all.  Thus we need to check the context if we have a lease.
Additionally, If we do not get a lease we need to make sure we close
the handle before we return an error to the caller.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -886,8 +886,6 @@ int open_cached_dir(unsigned int xid, st
 		goto oshr_exit;
 	}
 
-	atomic_inc(&tcon->num_remote_opens);
-
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
 	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
@@ -897,8 +895,6 @@ int open_cached_dir(unsigned int xid, st
 
 	tcon->crfid.tcon = tcon;
 	tcon->crfid.is_valid = true;
-	tcon->crfid.dentry = dentry;
-	dget(dentry);
 	kref_init(&tcon->crfid.refcount);
 
 	/* BB TBD check to see if oplock level check can be removed below */
@@ -907,14 +903,16 @@ int open_cached_dir(unsigned int xid, st
 		 * See commit 2f94a3125b87. Increment the refcount when we
 		 * get a lease for root, release it if lease break occurs
 		 */
-		kref_get(&tcon->crfid.refcount);
-		tcon->crfid.has_lease = true;
 		rc = smb2_parse_contexts(server, rsp_iov,
 				&oparms.fid->epoch,
 				    oparms.fid->lease_key, &oplock,
 				    NULL, NULL);
 		if (rc)
 			goto oshr_exit;
+
+		if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
+			goto oshr_exit;
+
 	} else
 		goto oshr_exit;
 
@@ -928,7 +926,10 @@ int open_cached_dir(unsigned int xid, st
 				(char *)&tcon->crfid.file_all_info))
 		tcon->crfid.file_all_info_is_valid = true;
 	tcon->crfid.time = jiffies;
-
+	tcon->crfid.dentry = dentry;
+	dget(dentry);
+	kref_get(&tcon->crfid.refcount);
+	tcon->crfid.has_lease = true;
 
 oshr_exit:
 	mutex_unlock(&tcon->crfid.fid_mutex);
@@ -937,8 +938,15 @@ oshr_free:
 	SMB2_query_info_free(&rqst[1]);
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
-	if (rc == 0)
+	if (rc) {
+		if (tcon->crfid.is_valid)
+			SMB2_close(0, tcon, oparms.fid->persistent_fid,
+				   oparms.fid->volatile_fid);
+	}
+	if (rc == 0) {
 		*cfid = &tcon->crfid;
+		atomic_inc(&tcon->num_remote_opens);
+	}
 	return rc;
 }
 


