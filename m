Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2DE13C675;
	Tue, 18 Jun 2024 12:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714663; cv=none; b=QAU29jQUiAmdq8n0HRe8rNCYJEeDgHfbc5HNkfBpYkhWhcyZMo1rmwFLsUpkZDZwpxw5Ta4jL4qGtKS9en23iip3HtPVp4rjcljn3r2VkOTWAqfQKw+6Fs1H48qVFrlfgB3lwO1EmqdrWVK8HkgzYSUO3ruLX072dVwyTV/A6gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714663; c=relaxed/simple;
	bh=FP84crc3bmZ1DCh9RPbYEDk8ZuaVO8O+jme0krrlpsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqADuUPZIb2NLEIEkolgUpHoo3dKBR7+UhAR7chim8nLWv2QegMDnxA0azycfoPeZYFgzLLidlFd4tqC1xuUzH8B/ZfN3CbhXYeiQhggOCa/gAdgFfSI9kKU/pVAa5sWvF4FkXPVayuHVxdpKE31t9LIU1OImo0z27AayYQ8gV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/6M6Psu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/6M6Psu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA23C32786;
	Tue, 18 Jun 2024 12:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714663;
	bh=FP84crc3bmZ1DCh9RPbYEDk8ZuaVO8O+jme0krrlpsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/6M6PsuZmbIHR3BJBiXdI6L6+ujcSDAxhCJei7vi23t5JCcqKduweYvD7j8Kqw/C
	 kXEknB1UXObd8sAdtO7VdxwdLiFykY669s2S4i5ENEMggkYtPyOkTP21V5HuBya+0P
	 n7zmE0ceXcHYHiLjizZH/QWBpxANKy3uniezNIMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/770] NFSD: Replace READ* macros in nfsd4_decode_open_downgrade()
Date: Tue, 18 Jun 2024 14:28:20 +0200
Message-ID: <20240618123409.108259112@linuxfoundation.org>
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

[ Upstream commit dca71651f097ea608945d7a66bf62761a630de9a ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 7b6fb11cdc809..95c755473899f 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1172,21 +1172,19 @@ nfsd4_decode_open_confirm(struct nfsd4_compoundargs *argp, struct nfsd4_open_con
 static __be32
 nfsd4_decode_open_downgrade(struct nfsd4_compoundargs *argp, struct nfsd4_open_downgrade *open_down)
 {
-	DECODE_HEAD;
-		    
-	status = nfsd4_decode_stateid(argp, &open_down->od_stateid);
+	__be32 status;
+
+	status = nfsd4_decode_stateid4(argp, &open_down->od_stateid);
 	if (status)
 		return status;
-	READ_BUF(4);
-	open_down->od_seqid = be32_to_cpup(p++);
+	if (xdr_stream_decode_u32(argp->xdr, &open_down->od_seqid) < 0)
+		return nfserr_bad_xdr;
+	/* deleg_want is ignored */
 	status = nfsd4_decode_share_access(argp, &open_down->od_share_access,
 					   &open_down->od_deleg_want, NULL);
 	if (status)
 		return status;
-	status = nfsd4_decode_share_deny(argp, &open_down->od_share_deny);
-	if (status)
-		return status;
-	DECODE_TAIL;
+	return nfsd4_decode_share_deny(argp, &open_down->od_share_deny);
 }
 
 static __be32
-- 
2.43.0



