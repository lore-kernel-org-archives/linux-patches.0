Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2838142046;
	Mon,  8 Apr 2024 13:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584504; cv=none; b=DeqcWV1iZprdEv6MaNC9XhaXhwHJrcOD5DlM6sQf9Lmhh0nkk4ultvq+Nq4dViVHbKpBWWPTYoJoDUAHFNbZieCGttWGoA5o8Evke8J6nv6oUZmLXIXfiG+Yi9lm63qg8DOsTxdnb91My1mUXWjnkMOG4T3uz0dhS1wz92jjXLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584504; c=relaxed/simple;
	bh=Qqkl55vnM9TkbdUdJTKpvQn1wSm11EFxSR9N4g/310E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7Qx2W6Kd7ku+x0Q4N/SMg8t0QThSVENGxT7KtpbSPfmQfZUBWPdlYabZR1JXkpzEjSB/F+njVZt4ELBTfZlgdUoZwQzakt5oDC4mnLH5U4FovbXmmCUSJg/5V/r149mM3jhsAjunMsuENrxjuO9cdp+mF+HrbQYhRfKuc4OzXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JINSaMO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JINSaMO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A457DC433C7;
	Mon,  8 Apr 2024 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584504;
	bh=Qqkl55vnM9TkbdUdJTKpvQn1wSm11EFxSR9N4g/310E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JINSaMO8lGnLzC4T+CyTx7QjYX+0sHEn5G0E7D1sP5zcR6n+AFTkVL7SzIdaPVCZ6
	 4N/DkqXoFxTwkLddiV+hzM8WDB1Ex9GPTDyzuN5N8fE8f3CKg0AIGZwZbeitGz3NFs
	 KNITb45F9hTc1aM/nv1/setJwpQ+G5Lf0KEVt9is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+ff796f04613b4c84ad89@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 461/690] NFSD: unregister shrinker when nfsd_init_net() fails
Date: Mon,  8 Apr 2024 14:55:27 +0200
Message-ID: <20240408125416.321264397@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit bd86c69dae65de30f6d47249418ba7889809e31a ]

syzbot is reporting UAF read at register_shrinker_prepared() [1], for
commit 7746b32f467b3813 ("NFSD: add shrinker to reap courtesy clients on
low memory condition") missed that nfsd4_leases_net_shutdown() from
nfsd_exit_net() is called only when nfsd_init_net() succeeded.
If nfsd_init_net() fails due to nfsd_reply_cache_init() failure,
register_shrinker() from nfsd4_init_leases_net() has to be undone
before nfsd_init_net() returns.

Link: https://syzkaller.appspot.com/bug?extid=ff796f04613b4c84ad89 [1]
Reported-by: syzbot <syzbot+ff796f04613b4c84ad89@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 7746b32f467b3813 ("NFSD: add shrinker to reap courtesy clients on low memory condition")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 6a29bcfc93909..dc74a947a440c 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1458,12 +1458,14 @@ static __net_init int nfsd_init_net(struct net *net)
 		goto out_drc_error;
 	retval = nfsd_reply_cache_init(nn);
 	if (retval)
-		goto out_drc_error;
+		goto out_cache_error;
 	get_random_bytes(&nn->siphash_key, sizeof(nn->siphash_key));
 	seqlock_init(&nn->writeverf_lock);
 
 	return 0;
 
+out_cache_error:
+	nfsd4_leases_net_shutdown(nn);
 out_drc_error:
 	nfsd_idmap_shutdown(net);
 out_idmap_error:
-- 
2.43.0



