Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A86158853;
	Tue, 18 Jun 2024 13:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716112; cv=none; b=Yg5RWVMH4cE3IyMQlXHJifyLZJeKDxdOrxekJ8Sq89hjVJTyzM69tie6F4pAHyCm1J0pCFtpXfFNkPON4nm59g8g3TppJR1FMRPKtKQYtOsX17+N3f1i191tk9ehsa/cpQX5Mk4EM8NBmj1vRg15dtThRRwjd3bgiXcEpZBPAlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716112; c=relaxed/simple;
	bh=r4FM46IiBlu5a4WzszKE4QgTU91hH53TNCZoA6eC71w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOK9JWeNdyOmKDuoO3gnWk/Zxe+bjiA5urrHbvDzCbFk18nbVmEYaiScROTos/geJR55LRKz0x/KwKRfkIKl1rDJjPIZMaQmsliQ0YgWlE47eFHjGbZ1Hy1WERGuMwCVeCPIHGTUlc99HgR2nICS9vkiAkKGpLl/tByHKzxuqhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjXhtGWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjXhtGWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B429C3277B;
	Tue, 18 Jun 2024 13:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716112;
	bh=r4FM46IiBlu5a4WzszKE4QgTU91hH53TNCZoA6eC71w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjXhtGWGMKrU26s/mL7DU1HIqKQpx/DqiAaFEHfZ4h/PWJS4gNA8WDlkKzWxBXoj5
	 BTjCgVAPKBapm7t5HONJ6m9sWZBE09R9+QvKuenHgb4lcTXvBgrgFGrqFkAI2XUfxV
	 YoIrYLFvJIERj0+sBWDMizOOvsH0Kt+PBmfjjFE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 536/770] NFSD: nfsd_file_put() can sleep
Date: Tue, 18 Jun 2024 14:36:29 +0200
Message-ID: <20240618123427.999162961@linuxfoundation.org>
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

[ Upstream commit 08af54b3e5729bc1d56ad3190af811301bdc37a1 ]

Now that there are no more callers of nfsd_file_put() that might
hold a spin lock, ensure the lockdep infrastructure can catch
newly introduced calls to nfsd_file_put() made while a spinlock
is held.

Link: https://lore.kernel.org/linux-nfs/ece7fd1d-5fb3-5155-54ba-347cfc19bd9a@oracle.com/T/#mf1855552570cf9a9c80d1e49d91438cd9085aada
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index bdb5de8c08036..11c096b447401 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -302,6 +302,8 @@ nfsd_file_put_noref(struct nfsd_file *nf)
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



