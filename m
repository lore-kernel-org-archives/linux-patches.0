Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C861F892A;
	Tue,  3 Dec 2024 15:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240609; cv=none; b=kCQpp3FDavscaCEwPfeK6eGSudCjN5GaTvzGZYPjpKAlFIEHzsTDaVChWbnJwbgmfgViMH1UlojjCQzoXMCszLmxD/TtEfhno7aZQWK2LMIRsxI8lwo4rIKNGtHn5n6wTL/F1iovBAUbvkodtxFpPFFSLKufZZhGKgNXTxG/C5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240609; c=relaxed/simple;
	bh=UrxytSLNhqVNTI+EOWjpBW+X1Z8m4C8CGoMBPdgIKrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEDo5WCwX5NJMIrRXVhNjNkV2vlk0/niJGiPEGXPCI5SxRnOGVjG3ybRql0gFE6T6/PIwVeQRwv0GERZSX1e5ztJjOS3WebvcO8kKDmowPvuJHrz+nXDMA0HNaXxZWZUmh3fpHGHjRHcJ402gbWqW4iOUHQeJnT1GZvHVFzechw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWZr/cpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWZr/cpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EA4C4CECF;
	Tue,  3 Dec 2024 15:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240608;
	bh=UrxytSLNhqVNTI+EOWjpBW+X1Z8m4C8CGoMBPdgIKrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWZr/cpf2BhyQTlodtCmIibIADtUs1xQ5et047XmIhP4pi+qEXhtjPUbAR+4ZRxyT
	 +/50qXXYqNz43zgs0YsIZoBrd4M5tR/yAj6W/AgRB/xpy8c1DkSz0AAHvgyO5jCgDM
	 ocggyxnFGPNQUNnj5RZRQWmHJ6zkhtCO7fpoV7u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/826] drm/vc4: hvs: Fix dlist debug not resetting the next entry pointer
Date: Tue,  3 Dec 2024 15:38:33 +0100
Message-ID: <20241203144750.997533097@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 6d5f76e0544b04ec5bdd2a09c19d90aeeb2cd479 ]

The debug function to display the dlists didn't reset next_entry_start
when starting each display, so resulting in not stopping the
list at the correct place.

Fixes: c6dac00340fc ("drm/vc4: hvs: Add debugfs node that dumps the current display lists")
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621152055.4180873-18-dave.stevenson@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index ac112dc3d592d..2cd9ad9c031c1 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -110,7 +110,7 @@ static int vc4_hvs_debugfs_dlist(struct seq_file *m, void *data)
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
 	struct vc4_hvs *hvs = vc4->hvs;
 	struct drm_printer p = drm_seq_file_printer(m);
-	unsigned int next_entry_start = 0;
+	unsigned int next_entry_start;
 	unsigned int i, j;
 	u32 dlist_word, dispstat;
 
@@ -124,6 +124,7 @@ static int vc4_hvs_debugfs_dlist(struct seq_file *m, void *data)
 		}
 
 		drm_printf(&p, "HVS chan %u:\n", i);
+		next_entry_start = 0;
 
 		for (j = HVS_READ(SCALER_DISPLISTX(i)); j < 256; j++) {
 			dlist_word = readl((u32 __iomem *)vc4->hvs->dlist + j);
-- 
2.43.0



