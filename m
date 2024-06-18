Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC78013D291;
	Tue, 18 Jun 2024 13:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716525; cv=none; b=KbDaw5QJj+Hb0ApdymmkVlgk930EzAGWqZxEfr6HRWhU37bcjRlBNSvNMyH6pZmCFfdO/kH4znEc9xg+hKUpl90hzxnAdyz3z9xnt2zdOihYP81emw82P+6cFAAFYAkdmW9ODpFo0m8fYJ/SgHUlGnucQgMq/B0bbiv/LtGZh54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716525; c=relaxed/simple;
	bh=FNj7Ud7XVhZBIM/kfbBsWxKY/bydelYh+kWRoth5WOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyKakJg1lyZ6dkXXsqi+4tDlRXvwYOzZ4GgwnNAphLkPrpfiEp1kj8/esHlH6aQpOMuJpR83r7VQB29psH6Zlae8K1vbTt8ciTX5B3cf3bptG3LKRlsf+2/bosxS8uVxAvBdJy69KyoE8gEMmZjwSoQ9LkayKRI3x+8AjbNrQKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVq2Tg2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVq2Tg2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519F0C3277B;
	Tue, 18 Jun 2024 13:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716525;
	bh=FNj7Ud7XVhZBIM/kfbBsWxKY/bydelYh+kWRoth5WOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVq2Tg2m33FU+wN0TAo/2KlJhyk/Uk7kIfHtcwABRBaT1noAM4wDza1tAJfoJ9fLy
	 VLZICxyg+zIhm/lQP4NmYycwW5EeLtEJGDX+hcd3yHPTVdWfuMymoAJ9BIx3sUfi1b
	 QvNu/TSPAuNz5HPMFtv1tejtteWwy2cYTUKLGnXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+ff796f04613b4c84ad89@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 674/770] NFSD: unregister shrinker when nfsd_init_net() fails
Date: Tue, 18 Jun 2024 14:38:47 +0200
Message-ID: <20240618123433.296730829@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



