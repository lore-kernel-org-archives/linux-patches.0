Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C1314532B;
	Tue, 18 Jun 2024 12:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714834; cv=none; b=WBRQtF6fPizNX/thfpvFuCCeoyJzZQQ8UQCeD8traxMlJF+oxF5r7bKKNyDlwXFfCIJODLiHgtJEU7FvmrLJmfZnIZf/eyvPdCXl/0TmJ0HZdofGfTO7qd3P1/LuSyqPG9qZZmEWGLn0Mw7pQ8XXYozAtcKsEUEtWDfD2V650CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714834; c=relaxed/simple;
	bh=tn6SrenlK4e/NvNxmN2Bu22C4O2HQ6up9t1BF6vaYXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IA4bs/2TpEPYHuoEHrrjBE9Uin+3HL5spFJHD2k9B+oLiHiccQnLsP8Yz2AewmJUjLEw3zZJLDXEhkg5HdMh6x6pRCuO2o0W6KBryDp4Dn+A7xTZoU7Yk+QOfTTuU9qVUeD4Gng/FnKGQ9vaE9PtXImmpcjV8c+6yiBqoRJpMis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWqEJF3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWqEJF3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA05C3277B;
	Tue, 18 Jun 2024 12:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714834;
	bh=tn6SrenlK4e/NvNxmN2Bu22C4O2HQ6up9t1BF6vaYXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWqEJF3UFQQblXT7FXkUkG8qeOFPpIMG9ZYSnl9NLJv/jE45Bj1wTIvAAYzAmy3AK
	 hq2l69AhokkSqobcJPNc5qiZdkK8enA3Efatqomcf5CAMC5FFK8ANJWt73+QWojRlr
	 fbUVpgliAFAKg/ojH3+/J4vt5dfYPKSnVcv5jvlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/770] NFSD: Replace READ* macros in nfsd4_decode_getdeviceinfo()
Date: Tue, 18 Jun 2024 14:28:45 +0200
Message-ID: <20240618123410.062417627@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 044959715f370b24870c95df3940add8710c5a29 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 50 +++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 92988926d9540..11e32c244b23c 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -638,6 +638,21 @@ nfsd4_decode_state_owner4(struct nfsd4_compoundargs *argp,
 	return nfsd4_decode_opaque(argp, owner);
 }
 
+#ifdef CONFIG_NFSD_PNFS
+static __be32
+nfsd4_decode_deviceid4(struct nfsd4_compoundargs *argp,
+		       struct nfsd4_deviceid *devid)
+{
+	__be32 *p;
+
+	p = xdr_inline_decode(argp->xdr, NFS4_DEVICEID4_SIZE);
+	if (!p)
+		return nfserr_bad_xdr;
+	memcpy(devid, p, sizeof(*devid));
+	return nfs_ok;
+}
+#endif /* CONFIG_NFSD_PNFS */
+
 static __be32
 nfsd4_decode_sessionid4(struct nfsd4_compoundargs *argp,
 			struct nfs4_sessionid *sessionid)
@@ -1765,27 +1780,20 @@ static __be32
 nfsd4_decode_getdeviceinfo(struct nfsd4_compoundargs *argp,
 		struct nfsd4_getdeviceinfo *gdev)
 {
-	DECODE_HEAD;
-	u32 num, i;
-
-	READ_BUF(sizeof(struct nfsd4_deviceid) + 3 * 4);
-	COPYMEM(&gdev->gd_devid, sizeof(struct nfsd4_deviceid));
-	gdev->gd_layout_type = be32_to_cpup(p++);
-	gdev->gd_maxcount = be32_to_cpup(p++);
-	num = be32_to_cpup(p++);
-	if (num) {
-		if (num > 1000)
-			goto xdr_error;
-		READ_BUF(4 * num);
-		gdev->gd_notify_types = be32_to_cpup(p++);
-		for (i = 1; i < num; i++) {
-			if (be32_to_cpup(p++)) {
-				status = nfserr_inval;
-				goto out;
-			}
-		}
-	}
-	DECODE_TAIL;
+	__be32 status;
+
+	status = nfsd4_decode_deviceid4(argp, &gdev->gd_devid);
+	if (status)
+		return status;
+	if (xdr_stream_decode_u32(argp->xdr, &gdev->gd_layout_type) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &gdev->gd_maxcount) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_uint32_array(argp->xdr,
+					   &gdev->gd_notify_types, 1) < 0)
+		return nfserr_bad_xdr;
+
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



