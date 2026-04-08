Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6751331A44;
	Wed,  8 Apr 2026 18:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673696; cv=none; b=a0DrOg7Nr/Qo9kDkyuSO2s98tFPBeCMwSElm//r2zk8k8f9e3NhF3ts6Trb75v6u8AK1UZlcS5I0FB7i3pY/fuVReF+D0NjOBFkxUtkettaUW+OxM5Jf8qAcm2D1L6iOa69G6rcOvYgg/rVciOy91S4Gg/60mu1UZPIHCjRoX8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673696; c=relaxed/simple;
	bh=cuIxTCmC9vrHdgOpyNm3K7g+1PDnUrMbQgpJ/Rnwujg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDqfYjeYGg6oN61rEV4NqPZY8DRQSl9hNNpeJU6UxD7rH0yPR15uGxgir47S4EcaaRqDUhaSfkg5VN3nY4TRfY1ADVrBg2ndJw+acFSGcd1kW7f1yVUm3q567Rxq9e3eRTkJfgSfQm+PpyjUB4Iz+L8+F1/4V07ZjYZ5muNTs6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqYSJSPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqYSJSPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9E1C2BCB3;
	Wed,  8 Apr 2026 18:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673696;
	bh=cuIxTCmC9vrHdgOpyNm3K7g+1PDnUrMbQgpJ/Rnwujg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqYSJSPoV5WyYGJ97/IFaDWC7lMymdg066gS1TBj7mYaUeOD6zVbLF/L7Ljk4ik0l
	 akD0kjKkxyegjKQzjWHbi83chnItxFqrVEsifxaL6PLMRUOhYNoe97KSdH3fWnORMW
	 MynSb//so5l+FGGXkYFzUU93Wv41bD8O/M7LvX7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/242] net/sched: sch_hfsc: fix divide-by-zero in rtsc_min()
Date: Wed,  8 Apr 2026 20:01:34 +0200
Message-ID: <20260408175929.098795279@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 4576100b8cd03118267513cafacde164b498b322 ]

m2sm() converts a u32 slope to a u64 scaled value.  For large inputs
(e.g. m1=4000000000), the result can reach 2^32.  rtsc_min() stores
the difference of two such u64 values in a u32 variable `dsm` and
uses it as a divisor.  When the difference is exactly 2^32 the
truncation yields zero, causing a divide-by-zero oops in the
concave-curve intersection path:

  Oops: divide error: 0000
  RIP: 0010:rtsc_min (net/sched/sch_hfsc.c:601)
  Call Trace:
   init_ed (net/sched/sch_hfsc.c:629)
   hfsc_enqueue (net/sched/sch_hfsc.c:1569)
   [...]

Widen `dsm` to u64 and replace do_div() with div64_u64() so the full
difference is preserved.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260326204310.1549327-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hfsc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index d8fd35da32a7c..57221522fe56d 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -555,7 +555,7 @@ static void
 rtsc_min(struct runtime_sc *rtsc, struct internal_sc *isc, u64 x, u64 y)
 {
 	u64 y1, y2, dx, dy;
-	u32 dsm;
+	u64 dsm;
 
 	if (isc->sm1 <= isc->sm2) {
 		/* service curve is convex */
@@ -598,7 +598,7 @@ rtsc_min(struct runtime_sc *rtsc, struct internal_sc *isc, u64 x, u64 y)
 	 */
 	dx = (y1 - y) << SM_SHIFT;
 	dsm = isc->sm1 - isc->sm2;
-	do_div(dx, dsm);
+	dx = div64_u64(dx, dsm);
 	/*
 	 * check if (x, y1) belongs to the 1st segment of rtsc.
 	 * if so, add the offset.
-- 
2.53.0



