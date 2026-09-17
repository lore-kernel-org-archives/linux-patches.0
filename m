Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B57A50257B;
	Thu, 17 Sep 2026 17:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667303; cv=none; b=Z+CuYjk3HDSy/tNjAyaAIwjM2N96uNFAs2W5CAfXJ/QHLPExsq2VXFwXLnOYLxeX8RGWLEP0/VTmwJp/J9jyY6aD5DdhkJyjOWfWuhV/72/zcaBw1B//s9ZOOz90uOwTk3zbHh+x7hAqiimn4Aj2Uhfjo+f/1QqmlTQRSbNWsR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667303; c=relaxed/simple;
	bh=dac2EC1LM5iKhzvlt9izoc5q4/yuLDYbNAPstzPawIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koyegorNBn7tv4eoTLh3kBLgBOvkmx6FDzhqCqGFNw9ABb3kMdND7HUytGkLKMa5nTvz679TUpmD8U0pJHvqv5mPEgyT3lXPrz7/NgbGQWyxfDOeOgTj5RI2tDl2Mtmqmaslem4A9S4HC/UDIXeqK+xAB1SemTp3HaUopyHnGIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7daBnyV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7daBnyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40DB1F000FF;
	Thu, 17 Sep 2026 17:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667301;
	bh=kYxMY/q1fo059B7SIizzN21cz4znSv0NMBIOGb87MQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7daBnyVJkfBlvLcoVgfqGZXvT3TqeWcm1CEjWHWICZodedZf5bF+2f/Sd5Rdl2Gw
	 iH/q4nPZ7HL6vxyM2jZ+Cw63ho6HoS2Ku8gCKgjjqJvrDGjQyygjibp+Tl1Pu1KAFi
	 mFv7wqRYy+R4Hx5xanYVO8AtsRNl+sVqdjAcalE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <jie.wang@intel.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0009/1102] gfs2: move quota_init qc iterator increment
Date: Thu, 17 Sep 2026 15:59:12 +0100
Message-ID: <20260917151539.656116194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index da62e0c5ee388..def166bff5289 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1449,7 +1449,7 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 
 		qc = (struct gfs2_quota_change *)(bh->b_data + sizeof(struct gfs2_meta_header));
 		for (y = 0; y < sdp->sd_qc_per_block && slot < sdp->sd_quota_slots;
-		     y++, slot++) {
+		     y++, slot++, qc++) {
 			struct gfs2_quota_data *old_qd, *qd;
 			s64 qc_change = be64_to_cpu(qc->qc_change);
 			u32 qc_flags = be32_to_cpu(qc->qc_flags);
@@ -1457,7 +1457,6 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 						USRQUOTA : GRPQUOTA;
 			struct kqid qc_id = make_kqid(&init_user_ns, qtype,
 						      be32_to_cpu(qc->qc_id));
-			qc++;
 			if (!qc_change)
 				continue;
 
-- 
2.53.0



