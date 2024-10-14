Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583D01AB507;
	Mon, 14 Oct 2024 14:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916697; cv=none; b=uTt+NU33ByNJpH70JIBbRmMKdqdBd42qLGuerLkUDiVG+HREVX/z5zU97234lbyfSw/mMvQRcoflcqwjrSVAWWYVV18qYWu0i8alZ1OBXGexAaPBE7wlwZ8FeKiDaZB2ZTQrMv085dEXG6Tur+hXFq54k+7QJXKUh15kysYieOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916697; c=relaxed/simple;
	bh=zRCi4Je6rXnMOwP/mK0yvxVkEif9uhFeyAK9oUsCDtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1ur2EIyyDx0B67h6xVl0fogS1UV9MhQAbmzQkcqRE1cvFxc8mSBX/MPWreQ/V003slS0woQFVYmIHvEXD0SIHFxVV1Rt/v3e5hW2OCkSYikPJmZlVrzHMqR8AeHalnSaTy/WCcBMbeIT9Cx9tlnMz5875FYVbxRf/ija/3IJvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/xOlRL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/xOlRL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFA3C4CEC3;
	Mon, 14 Oct 2024 14:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916697;
	bh=zRCi4Je6rXnMOwP/mK0yvxVkEif9uhFeyAK9oUsCDtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/xOlRL7AWY9vvLZF1gHhSVYJDR64gk58n7yGq6NRvdgIvB8wnf/k6a0n2UahKAGl
	 /NL3xvL7ZRHnes2BujSZQ/DYM9HuMQEnyntruk4PNi7/WIZki5f34DMkIxU74E3I9J
	 3oNkLO/nRwxHEOd9AeKRNu7z/Lj0VWwqOJIo+yJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/213] gfs2: Revert "ignore negated quota changes"
Date: Mon, 14 Oct 2024 16:18:35 +0200
Message-ID: <20241014141043.343934553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 4b4b6374dc6134849f2bdca81fa2945b6ed6d9fc ]

Commit 4c6a08125f22 ("gfs2: ignore negated quota changes") skips quota
changes with qd_change == 0 instead of writing them back, which leaves
behind non-zero qd_change values in the affected slots.  The kernel then
assumes that those slots are unused, while the qd_change values on disk
indicate that they are indeed still in use.  The next time the
filesystem is mounted, those invalid slots are read in from disk, which
will cause inconsistencies.

Revert that commit to avoid filesystem corruption.

This reverts commit 4c6a08125f2249531ec01783a5f4317d7342add5.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/quota.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index ed602352fe1d3..c537e1d02cf3a 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -454,17 +454,6 @@ static bool qd_grab_sync(struct gfs2_sbd *sdp, struct gfs2_quota_data *qd,
 	    qd->qd_sync_gen >= sync_gen)
 		return false;
 
-	/*
-	 * If qd_change is 0 it means a pending quota change was negated.
-	 * We should not sync it, but we still have a qd reference and slot
-	 * reference taken by gfs2_quota_change -> do_qc that need to be put.
-	 */
-	if (!qd->qd_change && test_and_clear_bit(QDF_CHANGE, &qd->qd_flags)) {
-		slot_put(qd);
-		qd_put(qd);
-		return false;
-	}
-
 	if (!lockref_get_not_dead(&qd->qd_lockref))
 		return false;
 
-- 
2.43.0



