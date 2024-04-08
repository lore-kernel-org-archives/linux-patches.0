Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62A48287F;
	Mon,  8 Apr 2024 13:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584083; cv=none; b=tb0qPDBS3I9IHEay9FZPP5r3eAPolbQNK7nTV6IL0N2uuP9mGfk89+SbyfBAVOGlhs4LTUwxHQhF8wc77rayAQ8IBrg1hD1csNcfbD9S2Zm9DoMLkKM2amCRcmWCX3TK3GXkLF/GoQjHQJDEDoeVuNlPUYn465g3JDEjxeVgicA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584083; c=relaxed/simple;
	bh=Kbbhv0xm7Gxs5jbMbyJeJ7f+8ccB0C6K0lp/EZUGzMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUtVY7Hvt3QwUKAG67RBke1isterXNLiR2deHrwy6oIQZyOxGUUrmtVng466Q1+GmAfVAiZy+zRp3FanUX6fFO27aBfk7UjU4yfGjGnoZCKxPBSij7K4NQhhcMeElsSqhANoC+e/wZOfpJ1zvMFYE3UvFx88InTl8nt7oIXj4PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7boxs/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7boxs/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C3DC433F1;
	Mon,  8 Apr 2024 13:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584083;
	bh=Kbbhv0xm7Gxs5jbMbyJeJ7f+8ccB0C6K0lp/EZUGzMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7boxs/FxOauyUodYSRsw4ACG5e3c9s9JbPMSYmYaStr1zdb3zHHPCuVelcguV1u+
	 dDZjYKTeTNb7RoskwqByGCU/GZGLPNofJWTktwyteNqSnQSf1ixK3epwz9hgIzcDJS
	 P1AuDQItF1VvsBTpGjchLSyqcnDXIfJZE7zZhmrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 331/690] NFSD: nfsd_file_put() can sleep
Date: Mon,  8 Apr 2024 14:53:17 +0200
Message-ID: <20240408125411.592972718@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

[ Upstream commit 08af54b3e5729bc1d56ad3190af811301bdc37a1 ]

Now that there are no more callers of nfsd_file_put() that might
hold a spin lock, ensure the lockdep infrastructure can catch
newly introduced calls to nfsd_file_put() made while a spinlock
is held.

Link: https://lore.kernel.org/linux-nfs/ece7fd1d-5fb3-5155-54ba-347cfc19bd9a@oracle.com/T/#mf1855552570cf9a9c80d1e49d91438cd9085aada
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 0863bf5050935..27952e2f3aa14 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -296,6 +296,8 @@ nfsd_file_put_noref(struct nfsd_file *nf)
 void
 nfsd_file_put(struct nfsd_file *nf)
 {
+	might_sleep();
+
 	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
 	if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) == 0) {
 		nfsd_file_flush(nf);
-- 
2.43.0



