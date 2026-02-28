Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4A9301F0D;
	Sat, 28 Feb 2026 17:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301430; cv=none; b=GCBdiykEXRH7aOLO9lKn7YHvAQs2CnCBtEXPr5pfiYU++eJrcjYOKWl6FzIhWfAW6omQTNvNbSWLI2TdiLpGkqyKKXzspZ9EFxNt7HLuxEfLY5u8m1sy7nksUJicczC902I3DI0NxXO3q1EyR0a83ayWcoITOvPJanZrppfU5eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301430; c=relaxed/simple;
	bh=iQnX+4o+AUZBwJkC+zOGV7Sf4aoS/SXbeAAQ5OCyguU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRkny/imQ9fdBiCY9CGBazYqwmzfO2tnPY1wKDRiLJ48b9TrOqJ+e2micrUa4t9sBpOSOB0w9IJ7pMTDp1W0exm+RV+u8JXLvFuNHoZCdRKyC3WE+0/z8tBFCu7vGZY92GbiHrH8fSFYVGS+HL7BXugjSlxLmD/tr6lbJ3XdIlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kSgr2liE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kSgr2liE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F926C116D0;
	Sat, 28 Feb 2026 17:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301429;
	bh=iQnX+4o+AUZBwJkC+zOGV7Sf4aoS/SXbeAAQ5OCyguU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSgr2liE/9qWaTMRR8Yp0mDbeEunteM35wDKNn16ZZlonjowLu8L6xtv6X35k6ieS
	 CZMYeGnQurD2lEyw2KRsgoYwEVN86DGSrjtgVA4Tqx+FCdqiSE+Fg3Q+20tPX0CqS7
	 ewQ2go42eTI2B9aYKubFkP+GIFGP+uH0h/RjqIxqQ4X6MH3lGjf3wh7VxG9H7taGKK
	 JjwGw6Mec5aIZ/PggEbRoxpwKomRprpgAiWTb0BUX5xKYmfoiX7+Dzhd1nup4O08FM
	 x29Xo10ZZYUUyAsC4/iyJoPkkUidxQEH6xsgdHii1w9iSroNAT+lxXTZ2uIjSKs0UC
	 eDjX51d3Bwkzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Olga Kornievskaia <okorniev@redhat.com>,
	stable@vger.kernel.org,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 620/752] NFSD: fix setting FMODE_NOCMTIME in nfs4_open_delegation
Date: Sat, 28 Feb 2026 12:45:31 -0500
Message-ID: <20260228174750.1542406-620-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit 41b0a87bc60d5ccfa8575481ddb4d4d8758507fa ]

fstests generic/215 and generic/407 were failing because the server
wasn't updating mtime properly. When deleg attribute support is not
compiled in and thus no attribute delegation was given, the server
was skipping updating mtime and ctime because FMODE_NOCMTIME was
uncoditionally set for the write delegation.

Fixes: e5e9b24ab8fa ("nfsd: freeze c/mtime updates with outstanding WRITE_ATTRS delegation")
Cc: stable@vger.kernel.org
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 740c40eb5b366..c5dba49c90356 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6356,7 +6356,8 @@ nfs4_open_delegation(struct svc_rqst *rqstp, struct nfsd4_open *open,
 		dp->dl_ctime = stat.ctime;
 		dp->dl_mtime = stat.mtime;
 		spin_lock(&f->f_lock);
-		f->f_mode |= FMODE_NOCMTIME;
+		if (deleg_ts)
+			f->f_mode |= FMODE_NOCMTIME;
 		spin_unlock(&f->f_lock);
 		trace_nfsd_deleg_write(&dp->dl_stid.sc_stateid);
 	} else {
-- 
2.51.0

