Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3354156F9;
	Fri,  4 Sep 2026 05:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498796; cv=none; b=IVPzhjhl++BS12H9KE8cNRqy4Opux8o7m/9YLhWuKh4IBaMfWURNILImNTo1cQXN/75Y4zq5EvJO2/ott/eC3ZwdLPqIJBb/jmSN4CkgeVtZN0NY/8phILe8h27HpjfPPIxG0m55DVZk3kB4VKjhY5RvhgXS9taD1jLs7WLAM/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498796; c=relaxed/simple;
	bh=UiBY+s1kcAP22dbTqtFcws8BSwF8O1OIvrIIQN0wQ3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9u1hmLyEo3v7rut9qnvsTpT+YZqSfmgFbBsU28q27A8d4xbfcpBnZGJBv/aSGWoXMLa1q3EI2H0gdQtfRe4cTui2AlUGXK3V/z4+ITo2JdwKsSV+wNSAprG6aN0xNMUTf+NlPDjHSAK9zhwJ2iOYfKkfT9IKml3mnlfBIKPtIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X417Bvgq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X417Bvgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8E21F00A3D;
	Fri,  4 Sep 2026 05:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498795;
	bh=Z4xUSt8IMqxW+Q4msLj6sLatIo75MiW0wycQDH/dBhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X417Bvgq8Pq3swFkjSjrYHnEWYNOyC57AS49chXVtp3SsGGhQ0GZhaRoyhB/mVj2d
	 o3bzXevREjF0OOH8H+CsUwL279QZVHBsbbBgoAayvvrPTpx9DJNqyoXMKczQtn4RuU
	 cjPRU3p+97sY2NbXaVhJTb/zwv+IV0n2j2O2mH0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 190/713] nfsd: fix stale s2s_cp_stateids IDR entry for async COPY
Date: Fri,  4 Sep 2026 06:52:38 +0200
Message-ID: <20260904045808.071842304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit d0beaee498e11880e72826026db0e9c9890fc114 upstream.

For an async COPY, nfsd4_copy() called nfs4_init_copy_state() before
dup_copy_fields(), so the s2s_cp_stateids IDR was pointed at
&u->copy->cp_stateid -- memory in the per-rqstp COMPOUND buffer that is
reused by the next request. dup_copy_fields() copies only the value into
async_copy, so the IDR slot dangled at the transient buffer for the whole
background copy. Any IDR walker then dereferences reused request memory:
the laundromat reads cs_type from it and, if the bytes look like an
expired NFS4_COPYNOTIFY_STID, follows into
refcount_dec()/idr_remove()/kfree() on garbage; manage_cpntf_state() has
the same exposure via idr_find().

Duplicate the fields first, then register the stateid on the stable
async_copy. result->cb_stateid is unchanged.

Fixes: e0639dc5805a ("NFSD introduce async copy feature")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260710-nfsd-testing-v3-3-a0ff7db6aa3e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2202,11 +2202,12 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 		async_copy->cp_src = kmalloc_obj(*async_copy->cp_src);
 		if (!async_copy->cp_src)
 			goto out_dec_async_copy_err;
-		if (!nfs4_init_copy_state(nn, copy))
+		dup_copy_fields(copy, async_copy);
+
+		if (!nfs4_init_copy_state(nn, async_copy))
 			goto out_dec_async_copy_err;
-		memcpy(&result->cb_stateid, &copy->cp_stateid.cs_stid,
+		memcpy(&result->cb_stateid, &async_copy->cp_stateid.cs_stid,
 			sizeof(result->cb_stateid));
-		dup_copy_fields(copy, async_copy);
 		if ((READ_ONCE(copy->nf_dst->nf_file->f_mode) &
 			       FMODE_NOCMTIME) != 0)
 			async_copy->attr_update = true;


