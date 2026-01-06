Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3888C34CFDC;
	Tue,  6 Jan 2026 17:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720037; cv=none; b=npNWHvuVMKSbT/jwZQpblatpSWJNyy6gUFTec1B8SUZ1WSQsD9BZYP8lBKvR5itf4BMgA6cHQeqhcoR5Joxivv5Q9fL2MVWn6XKPZozox/AWcmQPfflwpDd8JuADyrNag2WVuo0E7XcR62R8PlWU9NPkHbFdvtezQ6eYIywlSb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720037; c=relaxed/simple;
	bh=9przQN2pB0TrG1X00+a89i66AnNtUwscAIcF2jifNLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvzFa2E09soaeUB1jl5WSvC4CpQxUPqlZfBFmvRrTpucFZBmsF5kvToZinkCDN4MI8f3jTZH5jSyESgb5hZ9Syrpn+oQzd0wHmQre30ZIHSjXUk3xuwf7Dl3Uz/bO1zT5eyu/kBlS57ikIxitDDi1GflU4NXpNeV5NlrKf74jWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+/E3SJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+/E3SJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C79C116C6;
	Tue,  6 Jan 2026 17:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720037;
	bh=9przQN2pB0TrG1X00+a89i66AnNtUwscAIcF2jifNLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w+/E3SJI4wyevOFrmpIMCOnzpt8pZ+fK0bX7X/tDW0QuGJgXdLBAWbEn8u1bn/QeL
	 dA7HG7dLmEyTjHSV7OKnkI0Mn3UjiUaDrTzcLonf9vAwFH4mGjWwflCCDgEcs0ey0s
	 dWQwClBJfm94C0+Rv2TqE/g1ZbgNMGOTBsjeR/Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/567] nfsd: update percpu_ref to manage references on nfsd_net
Date: Tue,  6 Jan 2026 17:58:18 +0100
Message-ID: <20260106170455.622302218@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 39972494e318a21b3059287909fc090186dbe60a ]

Holding a reference on nfsd_net is what is required, it was never
actually about ensuring nn->nfsd_serv available.

Move waiting for outstanding percpu references from
nfsd_destroy_serv() to nfsd_shutdown_net().

By moving it later it will be possible to invalidate localio clients
during nfsd_file_cache_shutdown_net() via __nfsd_file_cache_purge().

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: df8d829bba3a ("nfsd: fix memory leak in nfsd_create_serv error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 45f1bb2c6f13..f9bb408478dc 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -436,6 +436,10 @@ static void nfsd_shutdown_net(struct net *net)
 
 	if (!nn->nfsd_net_up)
 		return;
+
+	percpu_ref_kill_and_confirm(&nn->nfsd_serv_ref, nfsd_serv_done);
+	wait_for_completion(&nn->nfsd_serv_confirm_done);
+
 	nfsd_export_flush(net);
 	nfs4_state_shutdown_net(net);
 	nfsd_reply_cache_shutdown(nn);
@@ -444,7 +448,10 @@ static void nfsd_shutdown_net(struct net *net)
 		lockd_down(net);
 		nn->lockd_up = false;
 	}
+
+	wait_for_completion(&nn->nfsd_serv_free_done);
 	percpu_ref_exit(&nn->nfsd_serv_ref);
+
 	nn->nfsd_net_up = false;
 	nfsd_shutdown_generic();
 }
@@ -526,11 +533,6 @@ void nfsd_destroy_serv(struct net *net)
 
 	lockdep_assert_held(&nfsd_mutex);
 
-	percpu_ref_kill_and_confirm(&nn->nfsd_serv_ref, nfsd_serv_done);
-	wait_for_completion(&nn->nfsd_serv_confirm_done);
-	wait_for_completion(&nn->nfsd_serv_free_done);
-	/* percpu_ref_exit is called in nfsd_shutdown_net */
-
 	spin_lock(&nfsd_notifier_lock);
 	nn->nfsd_serv = NULL;
 	spin_unlock(&nfsd_notifier_lock);
-- 
2.51.0



