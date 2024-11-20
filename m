Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A4F1BCA0F;
	Wed, 20 Nov 2024 13:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107677; cv=none; b=fmts93q/vurVco0KJbXj17ABSuMJx92VqI7lDbSYsLr2fkU64fdJR32A6fFDxYXiZxkzuV0jtR+5uUH1lXwGBbV4MtVc+64xFpvAoEBku384WzND1fArCiIgV0MAzW/oV+kv+2R4kItTXQ+hcccqx7D3zVnzJQlFN/rzHQfFlAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107677; c=relaxed/simple;
	bh=8GsigZQa7R1dyHKo24yLx89woSfto8+2u/DINpspP8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtgjU8s7MhEwAut2WQfoiLXMkayV1osQF3lO0ITLTqT2XHUAtQxAs4BWiV6KNE8WCutpFJ9a1ISb3bUodlZDmliFelWCqZ+mIeEwIXC5RI9q3J4CsvoJCBnJHbApRkPyWLRzDJdd1BjshD/PMTGBJMC+z6I0T+dZeOJP9qv2y5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEQk3fpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEQk3fpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01F6C4CED1;
	Wed, 20 Nov 2024 13:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107677;
	bh=8GsigZQa7R1dyHKo24yLx89woSfto8+2u/DINpspP8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEQk3fprRPDYLZV7sWkVNPz3WNhqSeCyWQ9q0PX+6vytCbmmIXvkVZSmi3Ra65tT4
	 mutU8QrrjT1eeMIT8tGo0Vw6VsI6I9LRKg1aokkhyE9mMULOHAAM0quRIiIfcGYGcx
	 2Bl8QuaWt+8pXFWLh8deKPe4pSRouXNAWTmI408g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 34/73] staging: vchiq_arm: Get the rid off struct vchiq_2835_state
Date: Wed, 20 Nov 2024 13:58:20 +0100
Message-ID: <20241120125810.429825644@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 4e2766102da632f26341d5539519b0abf73df887 ]

The whole benefit of this encapsulating struct is questionable.
It just stores a flag to signalize the init state of vchiq_arm_state.
Beside the fact this flag is set too soon, the access to uninitialized
members should be avoided. So initialize vchiq_arm_state properly before
assign it directly to vchiq_state.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20240621131958.98208-6-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 404b739e8955 ("staging: vchiq_arm: Use devm_kzalloc() for vchiq_arm_state allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../interface/vchiq_arm/vchiq_arm.c           | 25 +++++--------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 705c5e283c27b..bb1342223ad0d 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -115,11 +115,6 @@ struct vchiq_arm_state {
 	int first_connect;
 };
 
-struct vchiq_2835_state {
-	int inited;
-	struct vchiq_arm_state arm_state;
-};
-
 struct vchiq_pagelist_info {
 	struct pagelist *pagelist;
 	size_t pagelist_buffer_size;
@@ -574,29 +569,21 @@ vchiq_arm_init_state(struct vchiq_state *state,
 int
 vchiq_platform_init_state(struct vchiq_state *state)
 {
-	struct vchiq_2835_state *platform_state;
+	struct vchiq_arm_state *platform_state;
 
-	state->platform_state = kzalloc(sizeof(*platform_state), GFP_KERNEL);
-	if (!state->platform_state)
+	platform_state = kzalloc(sizeof(*platform_state), GFP_KERNEL);
+	if (!platform_state)
 		return -ENOMEM;
 
-	platform_state = (struct vchiq_2835_state *)state->platform_state;
-
-	platform_state->inited = 1;
-	vchiq_arm_init_state(state, &platform_state->arm_state);
+	vchiq_arm_init_state(state, platform_state);
+	state->platform_state = (struct opaque_platform_state *)platform_state;
 
 	return 0;
 }
 
 static struct vchiq_arm_state *vchiq_platform_get_arm_state(struct vchiq_state *state)
 {
-	struct vchiq_2835_state *platform_state;
-
-	platform_state   = (struct vchiq_2835_state *)state->platform_state;
-
-	WARN_ON_ONCE(!platform_state->inited);
-
-	return &platform_state->arm_state;
+	return (struct vchiq_arm_state *)state->platform_state;
 }
 
 void
-- 
2.43.0



