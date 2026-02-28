Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2012836C9CE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302206; cv=none; b=Nkg4CgRXT1UEKAUiGf/BMsUEt2cOGzdsL1nMmwvKH58fwrr7WFaI64wLZ3oCK163Y/vqLgBPlV1Fccl2IVCQMCyVCxpaw9oMWPx27YX4USPKngIPd7yVCPQIcbJonQ90TTGsxlBpzqFQFS0KF/jg1S6ww0xDfup1qggyoV8dndw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302206; c=relaxed/simple;
	bh=eK8+5NouAvn3TjRu7r+W3QUCiupbGOVDEjB65FWlPTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdchmvJYUUL6T+Jm5ZzM9ErZM5b4NB95Axtll+c6XVJPuhZAKkQzC9Mav+qibklUPtLkAh5fjkSUxYTmhyvNuPpv/28w7wBZ56koU12PLfnNhi7QUoXGG6EZyj7T8cbrrn+5pHXzb25KPfIcng46GOUNYbioH+1rIrezdQ7qAc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AS3MevCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AS3MevCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800F3C116D0;
	Sat, 28 Feb 2026 18:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302206;
	bh=eK8+5NouAvn3TjRu7r+W3QUCiupbGOVDEjB65FWlPTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AS3MevCQ0KXR0n2FuFF+/QRjg7F9uu0ODqiGJx4zubgmsGEegMYmBoX85WoZUW/J1
	 BxiQsqwIRfnNdbfhPAuh6lWckw39jCqkHuVKZLrDQiyjcQC791kwPzN7CPYG0YwZpO
	 RxVel9gbndFiM292cIyBrrTfmB1EocOBc+bCLOozU7Rdbu86zzvZDpWvfsAacqedDJ
	 U/kkOl5uZ8OiejjgPId+mTEY0C3SGgrIezYNmqRsFZZA4NJS3MczRD44BZhuBZ4oIX
	 VjsfRzpokOEh3yZjSSaLTrB4FP9YYxfBOnVfkzrxbrwNXBVXQDVg6BTKSYBhAFNjBf
	 cvlE93JwCsS7A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 211/283] fbdev: of_display_timing: Fix device node reference leak in of_get_display_timings()
Date: Sat, 28 Feb 2026 13:05:53 -0500
Message-ID: <20260228180709.1583486-211-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

