Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8F33D5642;
	Wed, 20 May 2026 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297253; cv=none; b=av9HWm+aKeqEB7k1PkePli2gRJyzLjMp7KOGYJ6Ozj68NDY2XGAINDTi97lFW12fQhrFP2C973a9OjOUsfn6Ix9AISo3u0dSg33t3qgey543/8e8rPF1jJutCRclCZkec5b4WsxgghttpoGpErwttxwbwcxlTGsmAXnH9nLQvXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297253; c=relaxed/simple;
	bh=OZ8EJhXynZFduoznESVaUdm9XTIOYtzcDT5gFeqsZ4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxsppTN6R2xb5dNFa14OoWrjqJnMEH7k3/Sk2ilLYaPgOWOqQY7w5kkwj/2T+TuWC/tcGJ+4puPTunAJiyqxTuJEEFMJ5+XSmdH3OfqXeROBzkzfzR7GkbL/hYNV9FbHWuWsNCeo4GiFPRgVpS3vvdBIezEq0ca0mni/ubFWRJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUeU6+nh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUeU6+nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8D21F000E9;
	Wed, 20 May 2026 17:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297251;
	bh=67vgx+gec97GFNHwjVog4DRw+DCGUZNJaXpFXn4sMFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUeU6+nhPIHDscNHYVyMioTJ5BRZWRtkYlKQdg8QZH6BsvyZI220gLLBtYgUTE+lJ
	 3WOs7EpkUJxzUq7BKvZ0kwvIObyeSiczXVjWkevcUexaDFbEWNor+7ej+Q3VKEyBYL
	 C3tp/19fsOIvnsnblCgbvebjc4e++JWZc6c2P0BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.0 1108/1146] nfsd: update mtime/ctime on COPY in presence of delegated attributes
Date: Wed, 20 May 2026 18:22:38 +0200
Message-ID: <20260520162213.320869970@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Olga Kornievskaia <okorniev@redhat.com>

commit 4183cf383b6faec17a0882b84cd2d901dba62b16 upstream.

When delegated attributes are given on open, the file is opened with
NOCMTIME and modifying operations do not update mtime/ctime as to not get
out-of-sync with the client's delegated view. However, for COPY operation,
the server should update its view of mtime/ctime and reflect that in any
GETATTR queries.

Fixes: e5e9b24ab8fa ("nfsd: freeze c/mtime updates with outstanding WRITE_ATTRS delegation")
Cc: stable@vger.kernel.org
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |   11 ++++++++++-
 fs/nfsd/xdr4.h     |    1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2121,8 +2121,10 @@ do_callback:
 
 	set_bit(NFSD4_COPY_F_COMPLETED, &copy->cp_flags);
 	trace_nfsd_copy_async_done(copy);
-	nfsd4_send_cb_offload(copy);
 	atomic_dec(&copy->cp_nn->pending_async_copies);
+	if (copy->cp_res.wr_bytes_written > 0 && copy->attr_update)
+		nfsd_update_cmtime_attr(copy->nf_dst->nf_file, 0);
+	nfsd4_send_cb_offload(copy);
 	return 0;
 }
 
@@ -2182,6 +2184,9 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 		memcpy(&result->cb_stateid, &copy->cp_stateid.cs_stid,
 			sizeof(result->cb_stateid));
 		dup_copy_fields(copy, async_copy);
+		if ((READ_ONCE(copy->nf_dst->nf_file->f_mode) &
+			       FMODE_NOCMTIME) != 0)
+			async_copy->attr_update = true;
 		memcpy(async_copy->cp_cb_offload.co_referring_sessionid.data,
 		       cstate->session->se_sessionid.data,
 		       NFS4_MAX_SESSIONID_LEN);
@@ -2200,6 +2205,10 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 	} else {
 		status = nfsd4_do_copy(copy, copy->nf_src->nf_file,
 				       copy->nf_dst->nf_file, true);
+		if ((READ_ONCE(copy->nf_dst->nf_file->f_mode) &
+			       FMODE_NOCMTIME) != 0 &&
+				copy->cp_res.wr_bytes_written > 0)
+			nfsd_update_cmtime_attr(copy->nf_dst->nf_file, 0);
 	}
 out:
 	trace_nfsd_copy_done(copy, status);
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -752,6 +752,7 @@ struct nfsd4_copy {
 
 	struct nfsd_file        *nf_src;
 	struct nfsd_file        *nf_dst;
+	bool			attr_update;
 
 	copy_stateid_t		cp_stateid;
 


