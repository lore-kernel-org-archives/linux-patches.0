Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537961586CB;
	Tue, 18 Jun 2024 13:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716103; cv=none; b=VqIFGJ6xRg2u1Gmzz2gLw3oeXWMzFQ2/5HzubsYbPobyy2lCiBLJzd7GHfsZTioBezr/78voyOJMIbEObu8yAkPcJXhHvzGInGSzkXmrRPBygkskPE6KIwxacxZsB1gZpn0Nau6WNzohUEcBxqLFBA8B9pkO4uOKAqq3cnPU9og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716103; c=relaxed/simple;
	bh=lcOJ4lEJ3U9SuYsG3JUk6EOd4Rlniue+qcPJKjaxpx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IaBd84rTBlO7LOyEInY853cNvPrQPLBDITmlu8Q0S3tUrxPgUVHxbTFnomgERHm8zgSBalKB2NqbW+cza875tL7xFJCPS6jU7cWdl0Eayqax69qaiJcIq3qwjJpHdUryths2LSlFeOzUKBakrzgdsWoL1y7eO62VmMcBFOMfea4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o3kr+0ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o3kr+0ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD98C3277B;
	Tue, 18 Jun 2024 13:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716103;
	bh=lcOJ4lEJ3U9SuYsG3JUk6EOd4Rlniue+qcPJKjaxpx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3kr+0ws/u+wMSITGO2XW1OqiPOVnW6B+lGpO+srwdIC9qpeMFoBhVL8dc/uzOQfc
	 Rji05h6uZa7slvyuU//i0g99Libmsa0zmGG34zWXr8v6T448hyMFm/Akal7L6HEPq+
	 yS4GTd8Skpok/gaKDqWQAsunKhgxGzYf03CNNU6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Schroeder <jumaco@amazon.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 533/770] nfsd: destroy percpu stats counters after reply cache shutdown
Date: Tue, 18 Jun 2024 14:36:26 +0200
Message-ID: <20240618123427.884708147@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Schroeder <jumaco@amazon.com>

[ Upstream commit fd5e363eac77ef81542db77ddad0559fa0f9204e ]

Upon nfsd shutdown any pending DRC cache is freed. DRC cache use is
tracked via a percpu counter. In the current code the percpu counter
is destroyed before. If any pending cache is still present,
percpu_counter_add is called with a percpu counter==NULL. This causes
a kernel crash.
The solution is to destroy the percpu counter after the cache is freed.

Fixes: e567b98ce9a4b (“nfsd: protect concurrent access to nfsd stats counters”)
Signed-off-by: Julian Schroeder <jumaco@amazon.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfscache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 0b3f12aa37ff5..7da88bdc0d6c3 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -206,7 +206,6 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
 	struct svc_cacherep	*rp;
 	unsigned int i;
 
-	nfsd_reply_cache_stats_destroy(nn);
 	unregister_shrinker(&nn->nfsd_reply_cache_shrinker);
 
 	for (i = 0; i < nn->drc_hashsize; i++) {
@@ -217,6 +216,7 @@ void nfsd_reply_cache_shutdown(struct nfsd_net *nn)
 									rp, nn);
 		}
 	}
+	nfsd_reply_cache_stats_destroy(nn);
 
 	kvfree(nn->drc_hashtbl);
 	nn->drc_hashtbl = NULL;
-- 
2.43.0



