Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BA5143865;
	Tue, 18 Jun 2024 12:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714820; cv=none; b=BBQAHitYelN4eWIapB534KlhfSZP4RraSra8Ddm1wLnGjEpEqoY0KwZu96gJlyhvcBY6yQobWtb9zVx9bxhH2iurEobos6WMtyZqshGy7aWwvybO/ts199xcRuw9DYjXnhVlGq+SvFeecjLj3aj2CK8qtuq9A4/JKntKQtLBi20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714820; c=relaxed/simple;
	bh=0qL89CwKx7t3FCtIkeXwIl2DpUQdP9ptAxmTtUSlZ+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdvy69PNYxdtvDvPjM8d6OjyZ8pLh7kldC0fhxcG5WZ0ftoTn3UOiPwKGhE//qKWS1WpEsorLc+klOzwtUrhKQEegE4VNcb880OTQatd85aUUSVOvSTbiFZrb0jUywDRKSgMRXDxpAjxqHhzt/5z71oNn9SfA32+TvJ4HW7BPRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6o4laum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6o4laum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEEAC3277B;
	Tue, 18 Jun 2024 12:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714819;
	bh=0qL89CwKx7t3FCtIkeXwIl2DpUQdP9ptAxmTtUSlZ+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6o4laumADkyMmQHKmMJ+WIaFe1rTxsLny0WzkuBKxKwexCgpvGifB6gaTt/RIdP1
	 hVZPITTimZ+ANI128bWNeBXMH6WrSjqrgPA3Wg4+eMjVnzR/q7lgs42Ijx1noGTYey
	 ZEKDnpMNaEMlwizBSjz6Og6DiSQP359IaAsNSX2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/770] Revert "nfsd4: support change_attr_type attribute"
Date: Tue, 18 Jun 2024 14:29:11 +0200
Message-ID: <20240618123411.054213011@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

This reverts commit a85857633b04d57f4524cca0a2bfaf87b2543f9f.

We're still factoring ctime into our change attribute even in the
IS_I_VERSION case.  If someone sets the system time backwards, a client
could see the change attribute go backwards.  Maybe we can just say
"well, don't do that", but there's some question whether that's good
enough, or whether we need a better guarantee.

Also, the client still isn't actually using the attribute.

While we're still figuring this out, let's just stop returning this
attribute.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c    | 10 ----------
 fs/nfsd/nfsd.h       |  1 -
 include/linux/nfs4.h |  8 --------
 3 files changed, 19 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 4df6c75d0eb7f..bb037e8eb8304 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3311,16 +3311,6 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 			goto out;
 	}
 
-	if (bmval2 & FATTR4_WORD2_CHANGE_ATTR_TYPE) {
-		p = xdr_reserve_space(xdr, 4);
-		if (!p)
-			goto out_resource;
-		if (IS_I_VERSION(d_inode(dentry)))
-			*p++ = cpu_to_be32(NFS4_CHANGE_TYPE_IS_MONOTONIC_INCR);
-		else
-			*p++ = cpu_to_be32(NFS4_CHANGE_TYPE_IS_TIME_METADATA);
-	}
-
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
 	if (bmval2 & FATTR4_WORD2_SECURITY_LABEL) {
 		status = nfsd4_encode_security_label(xdr, rqstp, context,
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 3eaa81e001f9c..2326428e2c5bf 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -394,7 +394,6 @@ void		nfsd_lockd_shutdown(void);
 
 #define NFSD4_2_SUPPORTED_ATTRS_WORD2 \
 	(NFSD4_1_SUPPORTED_ATTRS_WORD2 | \
-	FATTR4_WORD2_CHANGE_ATTR_TYPE | \
 	FATTR4_WORD2_MODE_UMASK | \
 	NFSD4_2_SECURITY_ATTRS | \
 	FATTR4_WORD2_XATTR_SUPPORT)
diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
index 9dc7eeac924f0..5b4c67c91f56a 100644
--- a/include/linux/nfs4.h
+++ b/include/linux/nfs4.h
@@ -385,13 +385,6 @@ enum lock_type4 {
 	NFS4_WRITEW_LT = 4
 };
 
-enum change_attr_type4 {
-	NFS4_CHANGE_TYPE_IS_MONOTONIC_INCR = 0,
-	NFS4_CHANGE_TYPE_IS_VERSION_COUNTER = 1,
-	NFS4_CHANGE_TYPE_IS_VERSION_COUNTER_NOPNFS = 2,
-	NFS4_CHANGE_TYPE_IS_TIME_METADATA = 3,
-	NFS4_CHANGE_TYPE_IS_UNDEFINED = 4
-};
 
 /* Mandatory Attributes */
 #define FATTR4_WORD0_SUPPORTED_ATTRS    (1UL << 0)
@@ -459,7 +452,6 @@ enum change_attr_type4 {
 #define FATTR4_WORD2_LAYOUT_BLKSIZE     (1UL << 1)
 #define FATTR4_WORD2_MDSTHRESHOLD       (1UL << 4)
 #define FATTR4_WORD2_CLONE_BLKSIZE	(1UL << 13)
-#define FATTR4_WORD2_CHANGE_ATTR_TYPE	(1UL << 15)
 #define FATTR4_WORD2_SECURITY_LABEL     (1UL << 16)
 #define FATTR4_WORD2_MODE_UMASK		(1UL << 17)
 #define FATTR4_WORD2_XATTR_SUPPORT	(1UL << 18)
-- 
2.43.0



