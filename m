Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D6E1BD002;
	Tue,  2 Jul 2024 17:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940259; cv=none; b=PgP13M+17GWI5qFm1FUoLaltV65zOQ3Rijxm/l1ERPfs3j9g7k6OniZLtM/7jC5RevBo6MqbLs0oIQthqDe1UPZ+4FIMc8Xt5wtuaMf0eqr5MQK5d7z0rs4gZxO1qlY1QgXBEH20hElFpIjO44EK5g2QOm4rZLyX6XbP3ugudNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940259; c=relaxed/simple;
	bh=6KW1WDhY7shtYeTTgQc+ea8DaNau6F2mFesg0VRkO40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4SwTxRC2t9cWW8IHbJFuO262EMxDqqJc2CtgkE7+PZq7zgUq2gtTa3E7t3v2Tq1cr0oy0sMpd0lw+vIYPoiw28iV4S1hzwBuf3nP34OoOtIprYo7zrGGy1NdZ5W+6xXNCfyEknctnwBEEJALF01LlnfYMhh8ubmcKrdlC40MRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IoYeQNGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IoYeQNGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD11C116B1;
	Tue,  2 Jul 2024 17:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940259;
	bh=6KW1WDhY7shtYeTTgQc+ea8DaNau6F2mFesg0VRkO40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IoYeQNGhkn6uo8Z47to08CrGzCWccJJjKnhMfCApp2UiygnSzhv5IfDAmwPHGA65i
	 v14Kx6MRIPqmdHYjCPU1lJHkaYI1ofdYOa3OO//bg7R+v1ukR2t+x789vv1/H4LMpb
	 xd8ahFFsA8/6O1LBJ7sY/npC+NY3xdD8QWKAt++k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 100/222] nfsd: initialise nfsd_info.mutex early.
Date: Tue,  2 Jul 2024 19:02:18 +0200
Message-ID: <20240702170247.791872173@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit e0011bca603c101f2a3c007bdb77f7006fa78fb1 ]

nfsd_info.mutex can be dereferenced by svc_pool_stats_start()
immediately after the new netns is created.  Currently this can
trigger an oops.

Move the initialisation earlier before it can possibly be dereferenced.

Fixes: 7b207ccd9833 ("svc: don't hold reference for poolstats, only mutex.")
Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Closes: https://lore.kernel.org/all/c2e9f6de-1ec4-4d3a-b18d-d5a6ec0814a0@linux.ibm.com/
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 2 ++
 fs/nfsd/nfssvc.c | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 4d23bb1d08c0a..332847daa1b41 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1679,6 +1679,8 @@ static __net_init int nfsd_net_init(struct net *net)
 	nn->nfsd_svcstats.program = &nfsd_program;
 	nn->nfsd_versions = NULL;
 	nn->nfsd4_minorversions = NULL;
+	nn->nfsd_info.mutex = &nfsd_mutex;
+	nn->nfsd_serv = NULL;
 	nfsd4_init_leases_net(nn);
 	get_random_bytes(&nn->siphash_key, sizeof(nn->siphash_key));
 	seqlock_init(&nn->writeverf_lock);
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index c0d17b92b249f..f23b00cb9f631 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -673,7 +673,6 @@ int nfsd_create_serv(struct net *net)
 		return error;
 	}
 	spin_lock(&nfsd_notifier_lock);
-	nn->nfsd_info.mutex = &nfsd_mutex;
 	nn->nfsd_serv = serv;
 	spin_unlock(&nfsd_notifier_lock);
 
-- 
2.43.0



