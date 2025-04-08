Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D3C267B15;
	Tue,  8 Apr 2025 12:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114335; cv=none; b=GeKJGpRvGwatBmSK3pMkADI55KDyXPcCCvwT5COVSCjxVYPD4SNOfKr4WFaOGxw+J+p8OSlzovRdZRXhGnecHsw33fWZQvG2AEq1N10fxJVyzqCuULkc1hB/NlH0QvDvbf5S96hKQQZ+2MePtu76DW37BlfPxyVCZErnQJh71ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114335; c=relaxed/simple;
	bh=w5By8VG8A44XicVd6a04MAQU4aWIt2sc+hN/OIV4tXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqGYv0pmLR6cBs8DqIMQxh5cLpvDLR1qg0UYKzBBOiTbVcibOKV1Lw3lnmO3gHUXJrrUztxqBaQ4xLdlWGVsBC/FRzrf9Or4yTpvr/5cWOXri2YhJVehWN8j6mIMVogQpzAcCgsJP8VJhl39jSLBuISslHHAupgRtiQJFk4sg+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXdhrBVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXdhrBVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6362C4CEE5;
	Tue,  8 Apr 2025 12:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114335;
	bh=w5By8VG8A44XicVd6a04MAQU4aWIt2sc+hN/OIV4tXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXdhrBVf4uHFnZXu1xxTBsBV6KyZw9Gl/zlUYER0kjmVKflSBZmAT40/TVxi4KkyB
	 rri7BqB+VcZoF5XY2M5HiWP+wd5M7EKmI6seF0N8/SN3jN69XNszQOViNRmmesEZ1X
	 ere5TodroIMtr6e4Wi6dRDZutsdPUk32H1eXxDlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sean Anderson <sean.anderson@seco.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 068/499] drm: zynqmp_dp: Fix a deadlock in zynqmp_dp_ignore_hpd_set()
Date: Tue,  8 Apr 2025 12:44:40 +0200
Message-ID: <20250408104852.925728088@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit f887685ee0eb4ef716391355568181230338f6eb ]

Instead of attempting the same mutex twice, lock and unlock it.

This bug has been detected by the Clang thread-safety analyzer.

Cc: Sean Anderson <sean.anderson@linux.dev>
Cc: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Fixes: 28edaacb821c ("drm: zynqmp_dp: Add debugfs interface for compliance testing")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Sean Anderson <sean.anderson@seco.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250207162528.1651426-2-sean.anderson@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_dp.c b/drivers/gpu/drm/xlnx/zynqmp_dp.c
index 56a261a40ea3c..c59c4309cd497 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dp.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dp.c
@@ -2272,7 +2272,7 @@ static int zynqmp_dp_ignore_hpd_set(void *data, u64 val)
 
 	mutex_lock(&dp->lock);
 	dp->ignore_hpd = val;
-	mutex_lock(&dp->lock);
+	mutex_unlock(&dp->lock);
 	return 0;
 }
 
-- 
2.39.5



