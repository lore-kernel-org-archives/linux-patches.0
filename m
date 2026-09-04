Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20A83815E1;
	Fri,  4 Sep 2026 05:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500667; cv=none; b=oM+7wibpxk8h+7QmkDzH93JHkO6CkOVSIGdKfd93VaVW0+Ck9NB5ZzpcipnNtXBY6fxH/pYjjJCZPRt0PFp1Slf5WsxzsHmErFef25zXUin1rC2HygqhkNnMUixgH0i4n67fYzn7cmB3MiXKONzgItIqTXGhVFY7FANMX3frEr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500667; c=relaxed/simple;
	bh=gIpWqABGTe4IdyjHiVW96O7Lh4xTagyZlxcxuhP4q2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZq+emRJpPnUp4ygYaE3Tj13FKEchdGzTE/DC6rNK3U7kPbQYdrrgBBZkk3ubWds+n7zzlhvYE85PYD7OoyfOObdcD9qMlRxdFvqWif7e3jHUKHzWy20TzNsHS48geMr5R9f5iMbG4yRrbCnAFJ4nOC496gBlrMLOCaNMSb62pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rI4jxlv9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rI4jxlv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5011F00A3D;
	Fri,  4 Sep 2026 05:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500665;
	bh=wjyckPW+J5rp5WaZdoQhCgWhUgw0iJT6igmXLlCE1zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rI4jxlv9eNZOFJ6HHPmgeHq95gMDJW2MADyAh7jCVO3xZzQns4HYpilChw893hSeU
	 eaZZfkJgMhUyfN5J0ThiFnROqFdZsA5epj8R/TJvlE2oefaRNGpf0oZxdfolWU14Xw
	 XQTrPpRSduvYGQYSng0da5FNynr9EoxuTgPmWFM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 137/552] nfsd: fix stale s2s_cp_stateids IDR entry for async COPY
Date: Fri,  4 Sep 2026 06:54:54 +0200
Message-ID: <20260904045751.555132228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -2014,11 +2014,12 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 		async_copy->cp_src = kmalloc(sizeof(*async_copy->cp_src), GFP_KERNEL);
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


