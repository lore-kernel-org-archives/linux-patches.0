Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA381BC070;
	Tue, 18 Jun 2024 12:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714596; cv=none; b=eMHWcv0sNwBNrXcL8JLVme8Y8IweP+WRZSRiokXR+m9CuvoSG+8GpY75+jXQYeSC7saah/MAbnSeP33l9zDhspOB72Isi0Yc9ofwA8fnrUBndcT/AjoE8oe5FkkpwZWsmujBq1jFicvMQeRPaPrk6Q3P5vP8OY+Um9Ny3P8J2Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714596; c=relaxed/simple;
	bh=lroAe2NPEStvPX4I98YGV0jJQ6lQ2E8di8bhMz1eteE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlMja1KEmWiEfjeYdwXTDyQ3nqE9Kv+f8RF3KEuEgC6/Oi1Z0ob6XZgdLAocJnNTMy3KseRq8ZFk019XMbzl7XrNtBn5NLf+VWAKkWXlIMDLuDCSG2v7m0cjEh7SU9dLlTPZ3tXrzdq7ra9Q44DWIQi898uEQ378UForS5LdAco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QH7rXBxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QH7rXBxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A40AC4AF4D;
	Tue, 18 Jun 2024 12:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714595;
	bh=lroAe2NPEStvPX4I98YGV0jJQ6lQ2E8di8bhMz1eteE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QH7rXBxPuAS3YUEvrEwyLXHKtzc4Qzf4c71iPwgHuvAPUsKWyU/kMJf4dEOkURfMb
	 rRHcrgxNfrvUIdwo6oqj5Y5NdjJSA6Ow4rP6Ad3htviPjmZQnc5XU0yqJp7nHpss8a
	 KGEJcbbPNhxuBX8grpxe+WFuY4bd3gqw7NV1pa9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/770] NFSD: Replace READ* macros that decode the fattr4 owner_group attribute
Date: Tue, 18 Jun 2024 14:27:56 +0200
Message-ID: <20240618123408.190995901@linuxfoundation.org>
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

[ Upstream commit 393c31dd27f83adb06b07a1b5f0a5b8966a0f01e ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 7dc6b79e51fd0..979f1d384cd0f 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -374,11 +374,16 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		iattr->ia_valid |= ATTR_UID;
 	}
 	if (bmval[1] & FATTR4_WORD1_OWNER_GROUP) {
-		READ_BUF(4);
-		dummy32 = be32_to_cpup(p++);
-		READ_BUF(dummy32);
-		READMEM(buf, dummy32);
-		if ((status = nfsd_map_name_to_gid(argp->rqstp, buf, dummy32, &iattr->ia_gid)))
+		u32 length;
+
+		if (xdr_stream_decode_u32(argp->xdr, &length) < 0)
+			return nfserr_bad_xdr;
+		p = xdr_inline_decode(argp->xdr, length);
+		if (!p)
+			return nfserr_bad_xdr;
+		status = nfsd_map_name_to_gid(argp->rqstp, (char *)p, length,
+					      &iattr->ia_gid);
+		if (status)
 			return status;
 		iattr->ia_valid |= ATTR_GID;
 	}
-- 
2.43.0



