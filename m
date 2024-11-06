Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AC51DED62;
	Wed,  6 Nov 2024 12:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895445; cv=none; b=QPzYibF532aBvTLpp1fTCkSWqOSqpRdCsnvbVh804pxtm/WTvDTPfSQPXYJeZD+EWuyjKgl5hJ1OnWKNTCObPdLZNAmI6TM+9IP3djdnrIIS69rPadnS1DkpQQ+KqsjmO2tWzxekwxY/R8f0ixXNVS05xSKF2Ze46x3D1er8Hrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895445; c=relaxed/simple;
	bh=CU60l7mRF1Le6PnSAYrNAC9pKrTVpWAah5vj83pAaTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkcAP6ghMx4zG1Ubs9+RCl6bcG7cm9IWGyqC2qGkDKbev/sumW+bKpoGK6or2Z4TxqJURwlVrAAOtYUYe0z9xTQOzVhfoCJ5kHQL0hx08tH7wmTofIADxrgExYaebFwv90a6EoSIP/BzWlryaayC8YxabTvVtytyPJccuo2v3Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyPW8YJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyPW8YJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0088C4CECD;
	Wed,  6 Nov 2024 12:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895445;
	bh=CU60l7mRF1Le6PnSAYrNAC9pKrTVpWAah5vj83pAaTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyPW8YJGLTynWBouPbv1jpD56Aik25Qr4D1WrOWbqp6or+zYOoUNg4AafwUOcqOk8
	 /Gzy92WMe9Mlz0bDavSeGswpwlOA7saDD8a5oEK1fb+NQJgfENOfydjJ71sZWH2tf/
	 O1I3wzZmvS6n0WEu5f5yZYRKU27szacpsW82tewg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 221/350] nfsd: use ktime_get_seconds() for timestamps
Date: Wed,  6 Nov 2024 13:02:29 +0100
Message-ID: <20241106120326.457310449@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b3f255ef6bffc18a28c3b6295357f2a3380c033f ]

The delegation logic in nfsd uses the somewhat inefficient
seconds_since_boot() function to record time intervals.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Stable-dep-of: 45bb63ed20e0 ("nfsd: fix delegation_blocked() to block correctly for at least 30 seconds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 7ac644d64ab1d..acb43210d2dc5 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -755,7 +755,7 @@ static void nfs4_free_deleg(struct nfs4_stid *stid)
 static DEFINE_SPINLOCK(blocked_delegations_lock);
 static struct bloom_pair {
 	int	entries, old_entries;
-	time_t	swap_time;
+	time64_t swap_time;
 	int	new; /* index into 'set' */
 	DECLARE_BITMAP(set[2], 256);
 } blocked_delegations;
@@ -767,15 +767,15 @@ static int delegation_blocked(struct knfsd_fh *fh)
 
 	if (bd->entries == 0)
 		return 0;
-	if (seconds_since_boot() - bd->swap_time > 30) {
+	if (ktime_get_seconds() - bd->swap_time > 30) {
 		spin_lock(&blocked_delegations_lock);
-		if (seconds_since_boot() - bd->swap_time > 30) {
+		if (ktime_get_seconds() - bd->swap_time > 30) {
 			bd->entries -= bd->old_entries;
 			bd->old_entries = bd->entries;
 			memset(bd->set[bd->new], 0,
 			       sizeof(bd->set[0]));
 			bd->new = 1-bd->new;
-			bd->swap_time = seconds_since_boot();
+			bd->swap_time = ktime_get_seconds();
 		}
 		spin_unlock(&blocked_delegations_lock);
 	}
@@ -805,7 +805,7 @@ static void block_delegations(struct knfsd_fh *fh)
 	__set_bit((hash>>8)&255, bd->set[bd->new]);
 	__set_bit((hash>>16)&255, bd->set[bd->new]);
 	if (bd->entries == 0)
-		bd->swap_time = seconds_since_boot();
+		bd->swap_time = ktime_get_seconds();
 	bd->entries += 1;
 	spin_unlock(&blocked_delegations_lock);
 }
-- 
2.43.0



