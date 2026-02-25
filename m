Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AD518B0A;
	Wed, 25 Feb 2026 01:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983385; cv=none; b=sGnT+EWqFyUitzWC1Sm1hkSfvGMmAqE30qlNSMH3K9sHbAiAoxKQnXqvw9lTWhtXUVKSHeL3eL/fT+iwrDsbCaAvRgQDKaZHtE4Pnph+JztCcCRDu/fs0tcc1AjN62kDSBX+Y1Qhb3I2TdAat7Jvk04UXc56yePoCZgm8DP98L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983385; c=relaxed/simple;
	bh=d9g2M2xJ2utZco1uQBNCWfQCVqydpWzoNscIm6MMp/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0J7UhAMaM4dYMkcbrwDSMf7uA6+dlLI+aZZNrWMkhRTSk22Ed1HG79oL5Tat2WMhu71G1N92Tb6t2umDOgbXlR8J2etpaKK7AThAdJbX4tv7W2MenkGYzMWS7IgMz4I3hWYAn7HCnboOTIlgqDxI8vOw26dJPkmmg5IyfevuYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X04ujOd2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X04ujOd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CDAC116D0;
	Wed, 25 Feb 2026 01:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983385;
	bh=d9g2M2xJ2utZco1uQBNCWfQCVqydpWzoNscIm6MMp/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X04ujOd2Gf9tJDqkwLqnsyuMbL1dcnyq/yet5gidsJ2y361liiEFjJt/OQWkLm9NJ
	 qKdiUA1WD8ek7NfXCxb+KoH0Q4WQhtIIeyYasR3rrTd9xF2Q09QkYyuSitKqioQANF
	 hJ4pNjd+rReJDRTToIRW08tthHzA2OKTf6n1LKTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 509/781] fbdev: of_display_timing: Fix device node reference leak in of_get_display_timings()
Date: Tue, 24 Feb 2026 17:20:18 -0800
Message-ID: <20260225012412.288589290@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



