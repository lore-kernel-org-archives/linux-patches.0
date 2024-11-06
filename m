Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDEF1F428D;
	Wed,  6 Nov 2024 13:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898585; cv=none; b=cNsnV3snPQWu3BktYVts7AdN/ejT0d1Bre92nA2EfgACp4YEWjVbd6I0Vxr94NlrDbbziXYiuNcHMhMpizzGKM7Bty5ETYcQmJL/JJY6KOlvlpe6Np8UwxHQ0PP0KxthZFoeqWIQ5D+fuDpSdoci+IKiELsUvfV0jLwgT4SwR8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898585; c=relaxed/simple;
	bh=+FI9Ya/V7I3dbZgtAJgj0GFp/VdrA88nNPNdX4COb8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZbWTtQEKocc5ivf37chIFmWHuI/C4QfmJW9GqW8K6hTo2CQt0ZdmtTeJBRVzflLslFgY5XobAkQzQTyt0wqt28WoTCpMX01HJex1HKxjYtn5PYY/wcSKoLHCWUkbNbg5J0jzWnOju5Zax5bLyMvq8Al1v0VzpWArK2o7V6cceA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Xh56yU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Xh56yU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD25DC4CECD;
	Wed,  6 Nov 2024 13:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898585;
	bh=+FI9Ya/V7I3dbZgtAJgj0GFp/VdrA88nNPNdX4COb8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Xh56yU3DQv65qBaNbYbpeoHMRSGydebRWEcmkcf1q49lNhjEnOTH203g+g7xiPkd
	 K4tnnurW464aKbNj+ZvFmzvc0rSDYKkmKZTWF3mz2XP+G7V0O+rFw6Tz+g0fFRQKo8
	 An0XRwDkUVuHQnoACIP9zeT97rUzc94w4NVBa7fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 287/462] nfsd: use ktime_get_seconds() for timestamps
Date: Wed,  6 Nov 2024 13:03:00 +0100
Message-ID: <20241106120338.612988781@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a0aa7e63739df..336342b414627 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -832,7 +832,7 @@ static void nfs4_free_deleg(struct nfs4_stid *stid)
 static DEFINE_SPINLOCK(blocked_delegations_lock);
 static struct bloom_pair {
 	int	entries, old_entries;
-	time_t	swap_time;
+	time64_t swap_time;
 	int	new; /* index into 'set' */
 	DECLARE_BITMAP(set[2], 256);
 } blocked_delegations;
@@ -844,15 +844,15 @@ static int delegation_blocked(struct knfsd_fh *fh)
 
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
@@ -882,7 +882,7 @@ static void block_delegations(struct knfsd_fh *fh)
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



