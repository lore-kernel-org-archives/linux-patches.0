Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEEE1BBBC0;
	Tue, 18 Jun 2024 12:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714593; cv=none; b=juSpVn7CIq3Gx8lChfxeZeBWqwHjmjyAYE8OwCmKHDsuIautg4Bw2GrBwbcDjR7W/u6FAQZqlc4AzwZQerjjDZmWrAi10pz45RPTDgeptSgdgF6p2GOwU1nXBgX+EQfBvM93BIQw+ihu6cBNTO/BmKs1mtjNRl7Pb5LpiBHt1Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714593; c=relaxed/simple;
	bh=uFxYQ/AX6sP8pXyt/SZ3u96peAIgym0RNZVX7WsCtu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUgGHqWZaBLOU9aIVSzHzWe6SIgqtS6jHQHByo1Fs02N2l2Ye0wfv0+TTTVjANWLQu/T7MMZVNz2a4YfGPwxjQBJHfu5MjHWD2QwWh/3pYSARhG+txeigbSbswLgkET9rq2qoozrpAOhJqYLwfnQC2gUwrAbwZCHqg5Ikn+nS4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZiTygZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZiTygZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E7FC4AF1D;
	Tue, 18 Jun 2024 12:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714592;
	bh=uFxYQ/AX6sP8pXyt/SZ3u96peAIgym0RNZVX7WsCtu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZiTygZ+yKkhIUN15kW9h0UyJZJurt7m9IKI0oNywFnS7TtYWea8rLJSWjh3b98rK
	 YIgcpSsyJK8xwdIYJblodaWPJCkrMbyKj+A6TBV53yi7dwV4Q4QC0fh+vxExI+9QQI
	 j3WtxCtsmiNLwsn/3ZpRNSPc+dL1hrOhWvKprG1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/770] NFSD: Replace READ* macros that decode the fattr4 owner attribute
Date: Tue, 18 Jun 2024 14:27:55 +0200
Message-ID: <20240618123408.153263703@linuxfoundation.org>
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

[ Upstream commit 9853a5ac9be381917e9be0b4133cd4ac5a7ad875 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 9dc73ab95eac9..7dc6b79e51fd0 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -360,11 +360,16 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		iattr->ia_valid |= ATTR_MODE;
 	}
 	if (bmval[1] & FATTR4_WORD1_OWNER) {
-		READ_BUF(4);
-		dummy32 = be32_to_cpup(p++);
-		READ_BUF(dummy32);
-		READMEM(buf, dummy32);
-		if ((status = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
+		u32 length;
+
+		if (xdr_stream_decode_u32(argp->xdr, &length) < 0)
+			return nfserr_bad_xdr;
+		p = xdr_inline_decode(argp->xdr, length);
+		if (!p)
+			return nfserr_bad_xdr;
+		status = nfsd_map_name_to_uid(argp->rqstp, (char *)p, length,
+					      &iattr->ia_uid);
+		if (status)
 			return status;
 		iattr->ia_valid |= ATTR_UID;
 	}
-- 
2.43.0



