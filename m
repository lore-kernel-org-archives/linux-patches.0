Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC44533A014
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301872; cv=none; b=h2YJgt9cN9o5iMoWyuP/7NF6WxjmsXXRAu3DbonGwX9A90bKRBwGSVijvRenBZL/wCO2O78FxJcHhD7mMnPA73gNS2Mq83D4l7SitjlMgCVUJLml4/6y7Ml7et3zNsEr1QWFSyRDWjHhPXcVermnNzJCsFLvYLlu/C6EVfLnct0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301872; c=relaxed/simple;
	bh=eK8+5NouAvn3TjRu7r+W3QUCiupbGOVDEjB65FWlPTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEvftWsKXQPDMm4IG3oLaPi0YDtq6VbkzASBklub3KZyXg7QN4FS3r83qy0BIEvk6oTjOSY/s+Kg/1g5qWhDgD6fnczExRTUpCB0HiEw6riNFdB73Dd4TgOjAims/XGRtrAnyu5Sx3wZT9QNe8CGjMvhgr5kO5QWPiwhHYgNDbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jyg56ji8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jyg56ji8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B966C116D0;
	Sat, 28 Feb 2026 18:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301872;
	bh=eK8+5NouAvn3TjRu7r+W3QUCiupbGOVDEjB65FWlPTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jyg56ji8tr1kOLSJCPuWJXcGP6NoxCPBS0Mm6v4LP/LtNwv+hTtLSNfkD5KtXpk2O
	 97oEQIw0K1VqUrY343Bw24o8ACh8p56CbtwVATsO0n1dHey5qd6SiJZD+PfERioF64
	 Tt7RE06Y1HD9LygMFMo90jvMvwV3DbqHQ//e5AcpS6HIJYj/+Qhd8E9pGirZKjwUyJ
	 KrxVU8+B0FQUHmpBz/gkoI/UcK4mrwLDV2I09tJ4R3XCIWDGpHt1CBKruLTcKcpjON
	 MSUdgg6jF11S6iWRJ0gTnwwR+QEctHwjh6pBWPoQsqTAMDi8zN23ftS59MC2/QV/Ak
	 b1KqAuzwhSehQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/385] fbdev: of_display_timing: Fix device node reference leak in of_get_display_timings()
Date: Sat, 28 Feb 2026 12:58:39 -0500
Message-ID: <20260228180011.1568201-297-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit c39ee2d264f98efa14aa46c9942114cb03c7baa6 ]

Use for_each_child_of_node_scoped instead of for_each_child_of_node
to ensure automatic of_node_put on early exit paths, preventing
device node reference leak.

Fixes: cc3f414cf2e4 ("video: add of helper for display timings/videomode")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/of_display_timing.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/of_display_timing.c b/drivers/video/of_display_timing.c
index bebd371c6b93e..a4cd446ac5a59 100644
--- a/drivers/video/of_display_timing.c
+++ b/drivers/video/of_display_timing.c
@@ -195,7 +195,7 @@ struct display_timings *of_get_display_timings(const struct device_node *np)
 	disp->num_timings = 0;
 	disp->native_mode = 0;
 
-	for_each_child_of_node(timings_np, entry) {
+	for_each_child_of_node_scoped(timings_np, child) {
 		struct display_timing *dt;
 		int r;
 
@@ -206,7 +206,7 @@ struct display_timings *of_get_display_timings(const struct device_node *np)
 			goto timingfail;
 		}
 
-		r = of_parse_display_timing(entry, dt);
+		r = of_parse_display_timing(child, dt);
 		if (r) {
 			/*
 			 * to not encourage wrong devicetrees, fail in case of
@@ -218,7 +218,7 @@ struct display_timings *of_get_display_timings(const struct device_node *np)
 			goto timingfail;
 		}
 
-		if (native_mode == entry)
+		if (native_mode == child)
 			disp->native_mode = disp->num_timings;
 
 		disp->timings[disp->num_timings] = dt;
-- 
2.51.0

