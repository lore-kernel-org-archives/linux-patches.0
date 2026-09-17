Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF28369D5E;
	Thu, 17 Sep 2026 16:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660898; cv=none; b=gX0/UnMjPjL3LNvpAx5NbXch4xb7smEWoysmOLqNuZl6DcPq9epNIPVDb2skPG1k5YODSkNauszqQV0+O5C48C4EmQ2CjXt9HBiMfpTR2OE4A5maE81wiFQ8XmSH+JOQ3y/KP+KZ74UluTJe1x8KkobR9CCQkRTlnqawBjrYlys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660898; c=relaxed/simple;
	bh=Yt5ZQMoHs8yC8Ja/WHTi4rfsasLvne0L4BV/DU6QgPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRkdG37uBJhTBc5Jq1kkeI5pCn+xLxno2Zc3arHv6JyD3aqKFUMO2pZeOZLjKZ88xmUg4XesRvAiK8RZ+e8feyduZdxifWHZm3Ofu4H4ef1IRLnNsbu35JPbYSA2L6Bbdou3ccGQYk4yQIsxfR4CK34kxBHQ6nYOgbtIUxZwkcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7cQwaHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7cQwaHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015531F000FF;
	Thu, 17 Sep 2026 16:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660897;
	bh=og2T5n0RrJmMgJaP57fRJ1MFGooe+e7SF+l/tlyz/Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7cQwaHfkEsqIf1dziZFZZr4lW2xWgxxc7xn+778po6fy/vHTeuHTsDrY3xwHaZUh
	 EPHMZIZgNfkaO6hi8m7sO/Wwox2JWqGa92QmSp2QOcepHZepb6VhNBAhRGMpW0SGxx
	 F4fPMlCp7vhsKfQD0ipAIepMShFo5Leu32dk0pRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <jie.wang@intel.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0015/1250] gfs2: move quota_init qc iterator increment
Date: Thu, 17 Sep 2026 15:56:50 +0100
Message-ID: <20260917151552.339148894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Wang <jie.wang@intel.com>

[ Upstream commit 942202677f8f2ee448a6a2feb06aeeaf520342e3 ]

Move qc++ from the loop body into the for-loop increment
expression in gfs2_quota_init().

This keeps iterator progression explicit and avoids mixing pointer
advance with duplicate-slot handling in the loop body.

Signed-off-by: Jie Wang <jie.wang@intel.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/quota.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 7a36a3fe5e6e6..4620f586411a6 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1447,7 +1447,7 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 
 		qc = (struct gfs2_quota_change *)(bh->b_data + sizeof(struct gfs2_meta_header));
 		for (y = 0; y < sdp->sd_qc_per_block && slot < sdp->sd_quota_slots;
-		     y++, slot++) {
+		     y++, slot++, qc++) {
 			struct gfs2_quota_data *old_qd, *qd;
 			s64 qc_change = be64_to_cpu(qc->qc_change);
 			u32 qc_flags = be32_to_cpu(qc->qc_flags);
@@ -1455,7 +1455,6 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 						USRQUOTA : GRPQUOTA;
 			struct kqid qc_id = make_kqid(&init_user_ns, qtype,
 						      be32_to_cpu(qc->qc_id));
-			qc++;
 			if (!qc_change)
 				continue;
 
-- 
2.53.0



