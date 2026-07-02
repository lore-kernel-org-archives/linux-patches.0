Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9821FA859;
	Thu,  2 Jul 2026 17:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011728; cv=none; b=Z4ZdijsIJs2fm4gmkZCJov7/IfH1RleNT/nP93kzlg5skJ+NM0DuWsLMABfTdWW9CdW7s2n3UzVj2IfOIN6kHFA4TDMKPXuxiXUzxlJRfy4KTxz5ZoNR2fE/oQOAV/vsnjxO9HFRDY2Zj5xRMTfuJ6ESY6bOSHZqHiCCRzYw88w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011728; c=relaxed/simple;
	bh=UWuztENTqo0qNEAjWItcYJ7qU2MlyJBpjf4aN6Z3WHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKDUVYVPSJDdul0Dv8edDf+3XGvoKM4VZECJMSnx4gzd+SBlM6iW+EQ/KaFwVoIkdFB/D1QFWUgMNTggDpmV+ffZ94EgxJ7fngekJXiZLL/BBpKM6b3KjajCSu9pJDrBho+QV6vdkJSO1qAY1vF50DaJSBy7ox83BreijEPTjzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zid8M6/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zid8M6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1018B1F000E9;
	Thu,  2 Jul 2026 17:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011727;
	bh=TdeDthDTBwZhiE9LgAJRfu+8Dk5DO546n0eh3HAyUgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1zid8M6/VJ+8dBlS9oghP0zj4CKRcUMCycG6oLrzHyswCWIgDSctpBFu6G08YxUad
	 ag5RDgPImfMofxKq9Ih9y2cZw32UMo8J4en01T1EjSFsfi0x690spSqJThICM0Qbyv
	 hdesdyHVB2mNEHaENLKOnV38wpka3ppAjOIYNuuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.1 111/120] nfsd: fix dead ACL conflict guard in nfsd4_create
Date: Thu,  2 Jul 2026 18:21:47 +0200
Message-ID: <20260702155115.256779779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit a60f25a800846ab8e5a13f8a9d05111f2aee55a7 upstream.

nfsd4_create() steals create->cr_dpacl/cr_pacl into the local
nfsd_attrs via the designated initializer, then immediately sets the
source pointers to NULL. The subsequent conflict guard tests the
already-nilled source fields, making it permanently dead code:

    if (create->cr_acl) {
        if (create->cr_dpacl || create->cr_pacl)  /* always false */

When a client encodes both FATTR4_WORD0_ACL and
FATTR4_WORD2_POSIX_{DEFAULT,ACCESS}_ACL in the same CREATE fattr
bitmap, nfsd4_acl_to_attr() overwrites attrs.na_pacl/na_dpacl without
releasing the originals, leaking two posix_acl slab objects per
request. Repeated requests cause unbounded slab exhaustion.

Fix by checking attrs.na_dpacl/na_pacl (the stolen values) instead of
the nilled create->cr_dpacl/cr_pacl, matching the correct pattern
already used in nfsd4_setattr().

Reported-by: Chris Mason <clm@meta.com>
Assisted-by: kres:claude-opus-4-6
Fixes: d2ca50606f5f ("NFSD: Add support for POSIX draft ACLs for file creation")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -840,7 +840,7 @@ nfsd4_create(struct svc_rqst *rqstp, str
 		goto out_aftermask;
 
 	if (create->cr_acl) {
-		if (create->cr_dpacl || create->cr_pacl) {
+		if (attrs.na_dpacl || attrs.na_pacl) {
 			status = nfserr_inval;
 			goto out_aftermask;
 		}


