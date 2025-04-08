Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE471265630;
	Tue,  8 Apr 2025 11:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111013; cv=none; b=igT0RWo81wvTPVcDQ9cdfgTipobJrII8F2jaXLGPQuNIFiC2rR/xsy3mt+b89T+0n93TDESP/9AATsPon8ACEgcQn2ZjGyQRJcDSvb9B0llG/ikzqD94jlgwuN8ud1C2IgwelwjhNmuxYJGTfDjALbynziC4DDlQIpDzMCPkBnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111013; c=relaxed/simple;
	bh=7NC/R7FaZWmeVU0o7qG+4EMupcaT/IR/xghbPaddQHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHQdR6UGVA04OSG6eYfFh6Ru58wvRMYhUHiQ2EKlqSV3xEqGoDP3H76tqxBZGPQ0WnIVZjcran/sxLrOc8N3+ndOqSTssAaLIF1irOGkvZtMw7pHEPmVYTPXAndLyBJUXlCFKF8QcO+yWop0yY7Pa0Av+2JAGZnUuUB0B8FEqWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0s0g2uE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0s0g2uE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FEDC4CEE5;
	Tue,  8 Apr 2025 11:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111012;
	bh=7NC/R7FaZWmeVU0o7qG+4EMupcaT/IR/xghbPaddQHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0s0g2uE5WJZDeRUWH5yr0W6fPcW5tkDcauc6aUfiDv+tFY62o5sIni+tecvduWoff
	 bZyjg+h4yXoah439E3HKRmmY6r6vMxM8pjwSLAhyQI0tBAck2Vq/UOwj9dY578mqz8
	 ZCLvzRfYrfzaTdflEcnvyeOjVM+BWB65Ihk5CrHw=
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
Subject: [PATCH 6.14 277/731] drm: zynqmp_dp: Fix a deadlock in zynqmp_dp_ignore_hpd_set()
Date: Tue,  8 Apr 2025 12:42:54 +0200
Message-ID: <20250408104920.721537492@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 979f6d3239ba6..189a08cdc73c0 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dp.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dp.c
@@ -2295,7 +2295,7 @@ static int zynqmp_dp_ignore_hpd_set(void *data, u64 val)
 
 	mutex_lock(&dp->lock);
 	dp->ignore_hpd = val;
-	mutex_lock(&dp->lock);
+	mutex_unlock(&dp->lock);
 	return 0;
 }
 
-- 
2.39.5



