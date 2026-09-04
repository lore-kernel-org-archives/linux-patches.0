Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94A1412294;
	Fri,  4 Sep 2026 05:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500655; cv=none; b=BEJcPwb44+LbaB8y+E/O3dmhi8ofcF3jrzK7/XblJIge0iOmrqETHgIGclHxMJq237vzsHzJ1lIJjFsaKVgtIAQ91a6f+m1fl/G7f+TpyImCBilrzZUm+mYmfcKmgBTvC2YW/eAMfGwEICuCHb07z6T1mTeie5RiUifuwXtqyMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500655; c=relaxed/simple;
	bh=clnRxxc/xEY/ZLtnVIDCHYikF3uecO62QWZVJb8We4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1izmHudHot//T90yr7FAaIp/k/PRh6UjVVddB6ZodaCG5EhGNww+Jy4yLhtgpBGmpH7NDtBG23epKtCpNjAZUP07obFUga19htON2k3bO5k9+O3DfctFeqG/0SJzlDh6RJVOY7MjTOiph1KB9uxb5LQR3wMCxP0G6NkW2Wyn4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNLUH1D+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNLUH1D+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89F81F00A3D;
	Fri,  4 Sep 2026 05:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500654;
	bh=B07egZvqBrH3SiCiZuyo1wJ8a6u0VKcG+5saqCLNit8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNLUH1D+y22jtb8VIPxBur1UESRaEQYCk6mLgMlZ0DHluR9BCOKsxOWFhjp/kv6Dy
	 jH9zTVMDLUiJ9Rzi0txwgF42f4ujakQhE5DjvVKff0NrXsVGgmrvX0y2LcYI2MSqKd
	 8PxR0OUlIH8yLIOb2ghGv0fR113/7E9kZdLA81NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikol Kuklev <nikolk202@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 134/552] nfsd: fix null dereference in nfsd4_setattr for deleg timestamp attrs
Date: Fri,  4 Sep 2026 06:54:51 +0200
Message-ID: <20260904045751.423713839@linuxfoundation.org>
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
@@ -1196,7 +1196,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 
 	if (deleg_attrs) {
 		status = nfserr_bad_stateid;
-		if (st->sc_type & SC_TYPE_DELEG) {
+		if (st && (st->sc_type & SC_TYPE_DELEG)) {
 			struct nfs4_delegation *dp = delegstateid(st);
 
 			/* Only for *_ATTRS_DELEG flavors */


