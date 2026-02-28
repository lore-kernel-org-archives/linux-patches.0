Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCD9301F09;
	Sat, 28 Feb 2026 17:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301420; cv=none; b=nBSFP7tjkk1S0r9sUy80aFtc1Un7FhlbrADX5UWO7Mc/QAHlmrJjcf/vvLpghM2J0r/T1R6jL3O2k0D0mU2E20PY1cc3WAzLAjYbPRmIotqc11JlkXcyc4X0hDL3kDgCNUNP4jw5mmXQ05+dr9k/Uv4jaihWOWavAxt2DudNgGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301420; c=relaxed/simple;
	bh=lMjFxD+80hL9B3iCB39/KHPwCwDV9RytnNQRPLnUyDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZx5gK/8miDO01wk30sJfJ/bWBxgCCrgWcYH57G2ZHAuZ+cgLVbR6px5yoF22iEtwXs01+1w2y3X+kNHE29ABE588hX2TlKony01YfWpNV9lzV1ORTiB2Ncs83u5SRirRAXBOUsKCrnajQheum/VCeKoMXDu4FckAxId4mS9SV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N83dfBRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N83dfBRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF3BC19423;
	Sat, 28 Feb 2026 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301419;
	bh=lMjFxD+80hL9B3iCB39/KHPwCwDV9RytnNQRPLnUyDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N83dfBRrDfK+gNn9fu4dO3vREJUflX6bjLK8iwionVkCi0uArMl07cF8LeLVN6hUb
	 s9Dya/XuaourJEi/irtSMlZz5vfnyInwir20vRjRCFiA2aHk6zndbg4ycr3YW+gYSc
	 kiKCP7e4rsviIQBwGV6Uxz/4LigJtQHAvuRyubx7B2t7oJ5kgTtXFFeTzzSfPRzvNo
	 8K18do9iBGqHmdznbHyXH1Ov8maKDhSEJTV3RVcQQBezbqJ+R6HxxOV76/kaFSWCVY
	 4CpzBbipmeag3vtZ6MCzoLSneZt7g5mzpD+2Ig/OI0vwjmP+XycN/U30+rIsnv+y+q
	 KI4tOPAiC+Z5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	stable@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 609/752] xfs: fix remote xattr valuelblk check
Date: Sat, 28 Feb 2026 12:45:20 -0500
Message-ID: <20260228174750.1542406-609-sashal@kernel.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit bd3138e8912c9db182eac5fed1337645a98b7a4f ]

In debugging other problems with generic/753, it turns out that it's
possible for the system go to down in the middle of a remote xattr set
operation such that the leaf block entry is marked incomplete and
valueblk is set to zero.  Make this no longer a failure.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/attr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index ef299be01de5e..a0878fdbcf386 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -338,7 +338,10 @@ xchk_xattr_entry(
 		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
-		if (rentry->namelen == 0 || rentry->valueblk == 0)
+		if (rentry->namelen == 0)
+			xchk_da_set_corrupt(ds, level);
+		if (rentry->valueblk == 0 &&
+		    !(ent->flags & XFS_ATTR_INCOMPLETE))
 			xchk_da_set_corrupt(ds, level);
 	}
 	if (name_end > buf_end)
-- 
2.51.0

