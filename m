Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774E12C1B4;
	Sun,  1 Sep 2024 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207724; cv=none; b=LJSZ0xyUQIk6BJbtZ6Ve3f4GNcyTwz8VytytX/dRaP168E3YBwBhP4kB7xe2eRu5cG7f31c4ic/rwwpWjdXYBlStXCg9ARSs3xos6mkivI3z4iYENCtmCULWAV3Pzfn9h5iwLDnEK1oLRYxaJIFgVpM/13IxbkspIhg1Ud4lEAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207724; c=relaxed/simple;
	bh=f8NVK4ypHpdf9Nk32NHxg+bwiGzG7Ed6+/QS5xBRmks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJvwhCZ8qaMJ3J5Ho0cLJEffxdsa2o2a8eh99syuHW7gdvaLWyPQmUniSXxKjXkDo6C6EOZiEZyVt3twdVTg3HTQKr+7gzqunsPIlDYjHp4cFZSjfcm6Q9g5laUFURTARIwJyB2Z2dCk3SSpfuGdebgdMKBWKhjP3plLD/TrRqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKyviHHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKyviHHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3A8C4CEC3;
	Sun,  1 Sep 2024 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207724;
	bh=f8NVK4ypHpdf9Nk32NHxg+bwiGzG7Ed6+/QS5xBRmks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKyviHHtnFA85REYTOLqnk1FsDQCBSvv4pLnt3Zf+G5AdEp2dk7ojBdMohUvDafst
	 n9ODsSfmCmzQCGkj8wyUWeST8IYqf3ohPS208YjR3/boheCWsrSWvew+x3k7p56OGs
	 uOFOfvpJTFiKJfOLDXFMaA1lEQ3hLOJSuGQacQIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/98] quota: Remove BUG_ON from dqget()
Date: Sun,  1 Sep 2024 18:15:57 +0200
Message-ID: <20240901160804.716098942@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 249f374eb9b6b969c64212dd860cc1439674c4a8 ]

dqget() checks whether dquot->dq_sb is set when returning it using
BUG_ON. Firstly this doesn't work as an invalidation check for quite
some time (we release dquot with dq_sb set these days), secondly using
BUG_ON is quite harsh. Use WARN_ON_ONCE and check whether dquot is still
hashed instead.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 6bdb44fb07a7f..a470bb4e00f18 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -985,9 +985,8 @@ struct dquot *dqget(struct super_block *sb, struct kqid qid)
 	 * smp_mb__before_atomic() in dquot_acquire().
 	 */
 	smp_rmb();
-#ifdef CONFIG_QUOTA_DEBUG
-	BUG_ON(!dquot->dq_sb);	/* Has somebody invalidated entry under us? */
-#endif
+	/* Has somebody invalidated entry under us? */
+	WARN_ON_ONCE(hlist_unhashed(&dquot->dq_hash));
 out:
 	if (empty)
 		do_destroy_dquot(empty);
-- 
2.43.0



