Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2986F14884C;
	Wed,  5 Mar 2025 18:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198631; cv=none; b=kxZv6+VtGLjGZOJjL9N2jeqi4xYfgBWDrwvZn8ZUYj6iddF7UOT5t5FQMbEIGk4yTbdrHI2UEWsYmVp9LGne00jskS16U06+GV3Ccr9LpNQMRkNoJEWNGo2E2xH1gO4SKAzp85Bs9TMcetRzTxn8agdo4UUAsRh0UojUcfuPzng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198631; c=relaxed/simple;
	bh=pXm+nQQnA0qjaIlxxAGV4oFXpao3IkyyeA0GgLOH+Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltUyiYSdUj2Vgkxdmsv4t6pnDZM43jhUn9nVq+8yyfvtWmhf9xwvtNHwCG8iUY2MYTKAOmrA18uzwHcXTk/wNuYvc0nOc6gtQFmRWFzbuI7JripffIdtxAKES9mAql5M0n8cKEDETcvAzhOnnPG3Fv/KWWzeQ0QdxZYRNNVm9LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TE7D8GKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TE7D8GKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D897C4CED1;
	Wed,  5 Mar 2025 18:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198630;
	bh=pXm+nQQnA0qjaIlxxAGV4oFXpao3IkyyeA0GgLOH+Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TE7D8GKOMb1xnr4IYK00HI71v0pg9eXy75I11v4wWhWUarpceK6a25VCGxqO1opNv
	 D8PQnfme4OsmXWsfhUExNfwSxnVF3zn936tYgcSXzcHmaEW9qWGlYmgohQ2IMl+pEq
	 lWCuFD97U9nohwhZanb2F3G4qzBV8wWF7axt2H/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Che Cheng <giver@chromium.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 063/157] thermal: gov_power_allocator: Fix incorrect calculation in divvy_up_power()
Date: Wed,  5 Mar 2025 18:48:19 +0100
Message-ID: <20250305174507.837093446@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Che Cheng <giver@chromium.org>

[ Upstream commit 4ecaa75771a75f2b78a431bf67dea165d19d72a6 ]

divvy_up_power() should use weighted_req_power instead of req_power to
calculate granted_power. Otherwise, granted_power may be unexpected as
the denominator total_req_power is a weighted sum.

This is a mistake made during the previous refactor.

Replace req_power with weighted_req_power in divvy_up_power()
calculation.

Fixes: 912e97c67cc3 ("thermal: gov_power_allocator: Move memory allocation out of throttle()")
Signed-off-by: Yu-Che Cheng <giver@chromium.org>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20250219-fix-power-allocator-calc-v1-1-48b860291919@chromium.org
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_power_allocator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/gov_power_allocator.c b/drivers/thermal/gov_power_allocator.c
index 3b644de3292e2..3b626db55b2b9 100644
--- a/drivers/thermal/gov_power_allocator.c
+++ b/drivers/thermal/gov_power_allocator.c
@@ -370,7 +370,7 @@ static void divvy_up_power(struct power_actor *power, int num_actors,
 
 	for (i = 0; i < num_actors; i++) {
 		struct power_actor *pa = &power[i];
-		u64 req_range = (u64)pa->req_power * power_range;
+		u64 req_range = (u64)pa->weighted_req_power * power_range;
 
 		pa->granted_power = DIV_ROUND_CLOSEST_ULL(req_range,
 							  total_req_power);
-- 
2.39.5



