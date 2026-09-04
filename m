Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7834415B85;
	Fri,  4 Sep 2026 05:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498779; cv=none; b=d+NzrJ+R3igdyeGgdnLZ5HNf/UH4TTq5REd0LMAdF82MuGPl4KVS9iVCuJ0rDUzsX6+vvd6GK5TBHkXTUufKTw58P+u+e4VX0Rk8sy+yI6GlCcMBrifi0qL4/JnlTn4DSczZ9BMoG9xy4iG0pyUbAQm1HwQbw6ZrT9L46MS2J/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498779; c=relaxed/simple;
	bh=qFCtqn+O3ZmZV+G3itZsfjzTrMSmmS/S9OVzhihSXhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8f81+03GzA1yGttPmib5Vm4NqXh5L5YKU5vqMjfWQAUQq0Rl8fs2KnywpByr9hsQCVtC4TQ/IHBjaLUIptZLtyhN3hx3i9k7/vvahzkMXZ6y4Mv+xUgcOQHZMJK10DJlf41Qzxho3pseXADjQkisS1M9Suwj1lJUN9DVQ5BErU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkXBcgEm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkXBcgEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2140A1F00A3D;
	Fri,  4 Sep 2026 05:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498778;
	bh=AE4fwqhBdcDC8bZGm5cL37eUnOrWAO5BCDa4zUDbr40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkXBcgEm++ApVJOQhgxvFmae5ksZysaahANxFdt3R6N3JV1qasfVplJIpIfhKWFuC
	 urYnJpaNFLyBVD+9/3vsgs0mguHiTHETxXB1ZaSHF26BIV/qMGVNZPymak8BnLbMTE
	 6J2hbOvdpL9jImmRdOq2qPmQ9WA+4esq2UUEhCAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikol Kuklev <nikolk202@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 185/713] nfsd: fix null dereference in nfsd4_setattr for deleg timestamp attrs
Date: Fri,  4 Sep 2026 06:52:33 +0200
Message-ID: <20260904045807.961805799@linuxfoundation.org>
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

From: Nikol Kuklev <nikolk202@gmail.com>

commit fe456c8c0931bb3e8a03d429920e87fd85747fba upstream.

When a SETATTR request includes FATTR4_WORD2_TIME_DELEG_ACCESS or
FATTR4_WORD2_TIME_DELEG_MODIFY in the attribute bitmap, nfsd4_setattr()
sets deleg_attrs=true and calls nfs4_preprocess_stateid_op() to validate
the stateid.

If the client supplies the NFSv4 "one stateid" (all-0xFF bytes),
check_special_stateids() returns nfs_ok without populating the output
nfs4_stid pointer, because the special-stateid path in
nfs4_preprocess_stateid_op() jumps to done: with s==NULL, and the
"if (s)" block that would set *cstid is skipped. The local variable `st`
remains NULL.

Back in nfsd4_setattr(), the if (deleg_attrs) block then unconditionally
dereferences st->sc_type (at offset 4 from NULL), causing a kernel oops.

This is remotely triggerable by any NFSv4 client: send COMPOUND [PUTROOTFH,
SETATTR(ONE_STATEID, {bmval2=FATTR4_WORD2_TIME_DELEG_ACCESS, ...})].
No authentication, delegation, or prior state is required.

Fix by adding a NULL check before the dereference. A special stateid is
not a delegation stateid, so the existing nfserr_bad_stateid return value
is already correct; we only need to guard the pointer dereference itself.

Fixes: 7e13f4f8d27d ("nfsd: handle delegated timestamps in SETATTR")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Nikol Kuklev <nikolk202@gmail.com>
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1269,7 +1269,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 
 	if (deleg_attrs) {
 		status = nfserr_bad_stateid;
-		if (st->sc_type & SC_TYPE_DELEG) {
+		if (st && (st->sc_type & SC_TYPE_DELEG)) {
 			struct nfs4_delegation *dp = delegstateid(st);
 
 			/* Only for *_ATTRS_DELEG flavors */


