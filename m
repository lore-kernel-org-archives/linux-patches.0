Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A093930B501;
	Wed, 25 Feb 2026 06:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002635; cv=none; b=C4kuuS9M8gnSRXhk7jSOIjf11cxV+GS3eo/kSrYb7TPI90e/ABCfbOdNkjIaU9ZXcWvE5XUyydpeMh7FlsciC8CgrIK2A4YiEPqeZ6DsBQybutTQL5yqKi7E4tVFn7tMW+lWbGxFUahTsqLMAWyzubOW7OEQUpTEMOBDHscp2ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002635; c=relaxed/simple;
	bh=WoWr2KyY3hlrygyIbGKFxYBD7TCouGt4qfqZXP4lD6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1libf1v5nXFs2YoPpyr4OftjqiEkT53htc8XcIqo7uF/xXuf364w35zCFvaOW7+DMorvlWnu3IQ3vx0B2Lx3GgOAkHDQYVZ1padrcj/xe00zHCX1NvcqL0bvvzZExv1x56Qgvo7XNumCGJRHQ6WUhHQHdHJ7WpmJjKotVZllVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDoLirNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDoLirNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CCEC116D0;
	Wed, 25 Feb 2026 06:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002635;
	bh=WoWr2KyY3hlrygyIbGKFxYBD7TCouGt4qfqZXP4lD6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDoLirNyiGr+NI6tHOiRPCKA0Q6ZcLHFD3HE6CbQXIW1IzTC8vNoymtzNHgSggqeN
	 H5Dw2E0HWXk3yv07P5JTfRyswHXEtiaJxCTw2Vokj+qW8vqF8av69ns+ZGkweXVBkV
	 0E1PXrx6AD7Cp6Y7rWPC340cXt0jOp7ppYLtngXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 400/641] fbdev: of_display_timing: Fix device node reference leak in of_get_display_timings()
Date: Tue, 24 Feb 2026 17:22:06 -0800
Message-ID: <20260225012358.261219103@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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



