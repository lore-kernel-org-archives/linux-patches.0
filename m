Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BD519F40B;
	Sat,  6 Dec 2025 14:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765029807; cv=none; b=iBTMJRCfXwQDD69ClhRtTSf7tLtFUa7IaNLQA/eBvZnYMydGdx99ptqAC1Q8xm9hLxNnf90rfjTJorugQ0PK5kbEzek2byTOHApYz5ylZOS79BRC7Mx+xbsJUmvfRMtudeZqqbxx8v+hPcA7vvfUP3ZGNX5uKQgDpzljKhaKlhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765029807; c=relaxed/simple;
	bh=dzxMO+uhYKst8Ap1tY4HgkuvJlbrMeUHwC9kHnv3zYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aifJG4/G1wsMw7PxK5ISKjPbVqU77gDt00adwHT/z5l7QiPnXqSovnU5c+a6Su/2V3qdm8L9rmgI9LD2yx6kfO5A3n/2HCfuaCvxQUJJ0T2lp6PjOQErdnTaxbOH8C/X7dexaV7tRjZ/pspUTX31rTCL3MXTekDkFAZ5hA0HNrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=At7j4YHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="At7j4YHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D799EC116D0;
	Sat,  6 Dec 2025 14:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765029806;
	bh=dzxMO+uhYKst8Ap1tY4HgkuvJlbrMeUHwC9kHnv3zYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=At7j4YHiXPf9E+Dt4vd9qgKmHNWq0lsaO11MhFvg7cvF065pwOc8vLuByH5hpAu9Z
	 xCcQeK/wCdRjTMKipclhm4EorB5WHtRfHQSGCrGAq/FlCKdXHIkH8Qu6JVLordyO/V
	 vmI/X6AW4WAOJjg4Qw7q68R8cT2STC5ImIUOwMEZZkJRiEbnTaiKf7AZiq349b+mFL
	 riCHRwNucjXZ278+blsMSy/POuOUeIFukAOtD8Ag4EcK0+V3eK2zOD7ISNweQ/VE42
	 rLSbLamPuQEDLppSONKrfilSPxzv0cQ2+ARNWhg3Mib/zUj9UD4Lor9xlIT+F9myBV
	 +SVRv99YsrVKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.6] gfs2: fix remote evict for read-only filesystems
Date: Sat,  6 Dec 2025 09:02:20 -0500
Message-ID: <20251206140252.645973-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251206140252.645973-1-sashal@kernel.org>
References: <20251206140252.645973-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 64c10ed9274bc46416f502afea48b4ae11279669 ]

When a node tries to delete an inode, it first requests exclusive access
to the iopen glock.  This triggers demote requests on all remote nodes
currently holding the iopen glock.  To satisfy those requests, the
remote nodes evict the inode in question, or they poke the corresponding
inode glock to signal that the inode is still in active use.

This behavior doesn't depend on whether or not a filesystem is
read-only, so remove the incorrect read-only check.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:



 fs/gfs2/glops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 0c0a80b3bacab..0c68ab4432b08 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -630,8 +630,7 @@ static void iopen_go_callback(struct gfs2_glock *gl, bool remote)
 	struct gfs2_inode *ip = gl->gl_object;
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 
-	if (!remote || sb_rdonly(sdp->sd_vfs) ||
-	    test_bit(SDF_KILL, &sdp->sd_flags))
+	if (!remote || test_bit(SDF_KILL, &sdp->sd_flags))
 		return;
 
 	if (gl->gl_demote_state == LM_ST_UNLOCKED &&
-- 
2.51.0

