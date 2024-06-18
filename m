Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4311C15A84B;
	Tue, 18 Jun 2024 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716715; cv=none; b=HQM07ta0A0cIsWW0dk95fKvWtJLKZglbVIRhUFtEcqGy3ZfuqgKj7j72TlxI6RdXhKCH/9lxX2TnYqQkvLqARivHWIzFQLAWK5MyU6iwkM47RacM/mQqCclwVRFuEtGZ7xPzgdcFSOHuVMDp9tSDpxFneBaCdHV9lCxGJ54AzaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716715; c=relaxed/simple;
	bh=wRg6cuGaqEijUYbBr9nklKu/Nu9UX0OIAbL6QttLiPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WODcwoLk1pOZHSMcJ8a3Q3gNQPCAPUR+wQNfgQrxkXzeNFpqnys2gsuvsnUImy1iaecOA1Eiw7Y5SPxgTotSLr6mr3ZFacrr9JXkm7XVoQu77LFZrZYCwcWmdw1n7y0aLbNbj7Qwg6HaLNWYvq16yx//A7UibRxK31MrKOQiN+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlPZdnKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlPZdnKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87779C3277B;
	Tue, 18 Jun 2024 13:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716715;
	bh=wRg6cuGaqEijUYbBr9nklKu/Nu9UX0OIAbL6QttLiPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlPZdnKXyTo3hL0FfkQf76UgSoYvqKZjvt6mYRIyv+XVI20g8HXNuiQWCdabg34R/
	 a5SdUUF5x0PYEWNpDoSQxY5MmEL4noVqTUwO73sGOXEtXF2coaYMhcRm1dlu/QdB7D
	 jYxyaNahxsFLzm0eB/7/gE00JzgOaTqmhZlBmwjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 738/770] NFSD: copy the whole verifier in nfsd_copy_write_verifier
Date: Tue, 18 Jun 2024 14:39:51 +0200
Message-ID: <20240618123435.753518924@linuxfoundation.org>
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

[ Upstream commit 90d2175572470ba7f55da8447c72ddd4942923c4 ]

Currently, we're only memcpy'ing the first __be32. Ensure we copy into
both words.

Fixes: 91d2e9b56cf5 ("NFSD: Clean up the nfsd_net::nfssvc_boot field")
Reported-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 325d3d3f12110..a0ecec54d3d7d 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -363,7 +363,7 @@ void nfsd_copy_write_verifier(__be32 verf[2], struct nfsd_net *nn)
 
 	do {
 		read_seqbegin_or_lock(&nn->writeverf_lock, &seq);
-		memcpy(verf, nn->writeverf, sizeof(*verf));
+		memcpy(verf, nn->writeverf, sizeof(nn->writeverf));
 	} while (need_seqretry(&nn->writeverf_lock, seq));
 	done_seqretry(&nn->writeverf_lock, seq);
 }
-- 
2.43.0



