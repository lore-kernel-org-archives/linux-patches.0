Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDE01B9AD7;
	Tue, 18 Jun 2024 12:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714586; cv=none; b=PC7M6wRkOa1TnC6Z/EHGlexy4CvGQ78JEj7cqCeWhAmfmKt4ztlkkgSr2+rBAHeBhqetYoBOZtLVnL/0p3f3I+jj5P5Vub5eIj7qdtsG1KQiEvwhe0gU4cDSWHXaOwJNEYd/5GKt2kWiNInp8FC6/OpWTjORjT9LLs0LTrUUCrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714586; c=relaxed/simple;
	bh=yZCUcqplMnfdcv1GEMLlCh+mQ2UEQojXd+DPV0pmGg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNbXuR17UQsQGQfPv6RXapIU/yQLxrG03FbuzlgrfRMZ+EgaRYip9Uwvjrwfm1dnzaYG05FH4M7Fu7aEz5jrSKk8KNHAc76PlQruigrm0vnnDYO9gird/TiwX1kRGPOdc1b2r3l00Q6R9qgHuQLvi9W68IRYntpxsePPAClavv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4YLtqvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4YLtqvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22452C32786;
	Tue, 18 Jun 2024 12:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714586;
	bh=yZCUcqplMnfdcv1GEMLlCh+mQ2UEQojXd+DPV0pmGg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4YLtqvpYOg/3vMmorlANxYEJj5STXJT7MAM+xSuLUb4hqnoFHvUbUBkmRJ2ebSNX
	 FFRLFOhkhWnE1tZOCjNayinEm+8Flwwu46NoRtlg1fkNKH41wcOq1Xnyu30H/bbLZf
	 JjG5qFsfTMxJ4idlF5pvKhesdJYKQqUf6ekMGeoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/770] NFSD: Replace READ* macros that decode the fattr4 mode attribute
Date: Tue, 18 Jun 2024 14:27:54 +0200
Message-ID: <20240618123408.115494416@linuxfoundation.org>
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

[ Upstream commit 1c8f0ad7dd35fd12307904036c7c839f77b6e3f9 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 0fe57ca0f31ac..9dc73ab95eac9 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -351,8 +351,11 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 	} else
 		*acl = NULL;
 	if (bmval[1] & FATTR4_WORD1_MODE) {
-		READ_BUF(4);
-		iattr->ia_mode = be32_to_cpup(p++);
+		u32 mode;
+
+		if (xdr_stream_decode_u32(argp->xdr, &mode) < 0)
+			return nfserr_bad_xdr;
+		iattr->ia_mode = mode;
 		iattr->ia_mode &= (S_IFMT | S_IALLUGO);
 		iattr->ia_valid |= ATTR_MODE;
 	}
-- 
2.43.0



