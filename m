Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051FC229690;
	Thu, 12 Dec 2024 16:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022516; cv=none; b=jEgmtZNQwUHPpUp456235wQ3ktfDjxJRf1BencDGecRcf8OIugeYJqqvgRXS+nJN68MRW3+xCbXD8GnfJIaWH0wLLWM60uGu2z4+FP3elDvSLhX3Szk1c9Gh0EdFkQz4djJw4Uk9n23QAUdBIYIJIVmSeGaF8NpJmRvKzvF86SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022516; c=relaxed/simple;
	bh=TSkBpMGCePSrP2Cuqob+rcJ0bb5BaBEstMEH80e2+sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s59K/U+8qg2NfjIsoyGxhbheux1iS15M6oUFYDyBte0VW0RJpFcIWVY8i6qs3/VLDh+tE1KVPjqOACLlduDRAKv+FOJdEERi1iIwXO86oxKoJkR57/oiJ6CCTC1tkO4bGA1YNJHwoqkW0gyyOz6MiCsgkx1tWYhbJlGEZI7K0eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YuEh5eEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YuEh5eEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C840C4CECE;
	Thu, 12 Dec 2024 16:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022515;
	bh=TSkBpMGCePSrP2Cuqob+rcJ0bb5BaBEstMEH80e2+sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YuEh5eEqCH2drrgUdBchv2vlIe7tMRgwZrxDbS8BSMclIGFz1fo9o6yxJ2Rokv1Nd
	 GjNiD5WvwFTyeALUPOxy6CrObp5bKyZkBTcQLk5cUlnNttHHgqfIy3jLZlGyuzi0io
	 V18gERf1xuQiUTgRVkgxyID6vXf2LWqeBaQMhR8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 263/565] NFSD: Prevent NULL dereference in nfsd4_process_cb_update()
Date: Thu, 12 Dec 2024 15:57:38 +0100
Message-ID: <20241212144321.863220983@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1e02c641c3a43c88cecc08402000418e15578d38 ]

@ses is initialized to NULL. If __nfsd4_find_backchannel() finds no
available backchannel session, setup_callback_client() will try to
dereference @ses and segfault.

Fixes: dcbeaa68dbbd ("nfsd4: allow backchannel recovery")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 4eae2c5af2edf..18d62d3424c1a 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1379,6 +1379,8 @@ static void nfsd4_process_cb_update(struct nfsd4_callback *cb)
 		ses = c->cn_session;
 	}
 	spin_unlock(&clp->cl_lock);
+	if (!c)
+		return;
 
 	err = setup_callback_client(clp, &conn, ses);
 	if (err) {
-- 
2.43.0



