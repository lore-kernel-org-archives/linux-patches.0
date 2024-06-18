Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B85713F431;
	Tue, 18 Jun 2024 12:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714746; cv=none; b=GhW6jBAo19R+HcrwaNpazx5BbSMEfhy1LQYjGtbdALqge617/rNLG0NMC2Up0suI3bQGlOLFw3kiImfcoxTmtALYj1AztUG12/PyEaGhI9hFguGWs+PsAeCsbQN5yIuu3GWL2AGMthSydSnwK78zxA/y8SJqXfwrOh87b82P8AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714746; c=relaxed/simple;
	bh=6nTG0YgfQln9tpNEOMfCAazZ41iQfCbwbAWi1vCV3qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jp8byea3CnTc2rA0AdZ9pu1siG1nYmds4tTfOrfxX7KnqWYo3dD31oV9af+O50dkcYGrRViK3QE76KxyStmuUbX4o6AOvFZ/ACikjDOgg7o0QemOmzCjWJRQR99YktvbS0OR7qdqOkwqkSO/T4S52IKnEBqLcC/enXuiy4znWFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s673PynM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s673PynM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D28C3277B;
	Tue, 18 Jun 2024 12:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714746;
	bh=6nTG0YgfQln9tpNEOMfCAazZ41iQfCbwbAWi1vCV3qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s673PynMKiXTeXj1u7VPxdWItfjslOLLkJwV5he6r+Qpy5jxN+C9TDe0bqFLgjT66
	 FGaaRhxzGucXYVwVb/ENEWMNkc7/pM+f/95WEylnCK5Kl/NLjghwjm7/A+Bg1gWNlZ
	 esoinTSBraQlFR49IcnXC8XTiUcs3FCIj0aIEj2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/770] NFSD: Replace READ* macros in nfsd4_decode_share_deny()
Date: Tue, 18 Jun 2024 14:28:16 +0200
Message-ID: <20240618123408.957275632@linuxfoundation.org>
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

[ Upstream commit b07bebd9eb9842e2d0dea87efeb92884556e55b0 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index a43b39940ab25..a9257ec9d151d 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1063,16 +1063,13 @@ static __be32 nfsd4_decode_share_access(struct nfsd4_compoundargs *argp, u32 *sh
 
 static __be32 nfsd4_decode_share_deny(struct nfsd4_compoundargs *argp, u32 *x)
 {
-	__be32 *p;
-
-	READ_BUF(4);
-	*x = be32_to_cpup(p++);
-	/* Note: unlinke access bits, deny bits may be zero. */
+	if (xdr_stream_decode_u32(argp->xdr, x) < 0)
+		return nfserr_bad_xdr;
+	/* Note: unlike access bits, deny bits may be zero. */
 	if (*x & ~NFS4_SHARE_DENY_BOTH)
 		return nfserr_bad_xdr;
+
 	return nfs_ok;
-xdr_error:
-	return nfserr_bad_xdr;
 }
 
 static __be32
-- 
2.43.0



