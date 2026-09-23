Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED72338D6A2;
	Wed, 23 Sep 2026 14:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173507; cv=none; b=bVXIKlXebxjcOQruuhHjrTRA+L+iUMFjvu+7+qerhvOzxM/QpvQAMPiCPh8pcf65jIwyiHLn1DeNLgTBl3sqj3l2xhpcgFNlix1TN5IDL4wOtT4GuQWjSE65r3uoXiuiqjFJTKVQNTPGk7Neiguw9DVyS864P851LCRQOs996Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173507; c=relaxed/simple;
	bh=9CA+5qT4YPvyi2D2g4vXAO/ErrZ0ey+8vTNKB09VjDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EavJuFasxtV+B0/Mf66JBOiLWsErM0wLcIsnYvIOGVsVvLo3WAcAdgbpafGQnMOgeq0rryP75o5qEjkz6E6qClAnyUgUA2SWFSnHK53zMKaRYKiibHgWHGDRPYzIjoY1jUI0m7Fc5TapQgjItB/dh5oIHdeoNou+iRuZcPaPnmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRviTy1Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRviTy1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FF51F000FF;
	Wed, 23 Sep 2026 14:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173505;
	bh=ohR5rfflaPvsbYZhZX1qpgvHoxKzQR3gz2NOIS0m/34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aRviTy1YqT7x3DToIGj7eons1VWzkmCJQOvtd4dKZcICFvTDPjkKxodcSyrkqpoZ8
	 F2kXjqJFxGKqcfo9Mo1TKmtO5kZC6aLC8YvVvvOpakDP1PyK2ugAm9NK2q8Oec3VnN
	 o5BRAAcqzI7zpf7bMAkdCrQylb7Y74wJ1wLQNyTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 268/438] nfsd: fix handling of NFSEXP_PNFS in the netlink codepath
Date: Wed, 23 Sep 2026 16:04:49 +0200
Message-ID: <20260923140651.712482932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit f76017a7663c4ce5e379f8a8d39f032bdb1fd865 upstream.

The rework of how block layouts were checked moved the check for
NFSEXP_PNFS out of nfsd4_setup_layout_type() and into the callers. That
patch didn't account for the new call in nfsd4_setup_layout_type().

Cc: Christoph Hellwig <hch@lst.de>
Fixes: da9baa5470dc ("exportfs,nfsd: rework checking for layout-based block device access support")
Cc: stable@vger.kernel.org
Reported-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260414-pnfs-exp-fix-v1-1-9face14c16c2@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/export.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index a47c90f40422..1f678583f612 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1006,7 +1006,8 @@ static int nfsd_nl_parse_one_export(struct cache_detail *cd,
 			goto out_uuid;
 		err = 0;
 
-		nfsd4_setup_layout_type(&exp);
+		if (exp.ex_flags & NFSEXP_PNFS)
+			nfsd4_setup_layout_type(&exp);
 	}
 
 	expp = svc_export_lookup(&exp);
-- 
2.55.0



