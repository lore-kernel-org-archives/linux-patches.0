Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB2122257E;
	Tue,  8 Apr 2025 11:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113012; cv=none; b=BW7h4v4eszStuSCwxT9lWN+9NImQoM66xf6JW735HznxqrZL5ZXnf0aF/4QmD0FYXoGcPvdnBbJO6jSkjmhDUUQxAkc74B7vaeimMwhqetRIfJKYYDc/HdzDbLT+qZ8nDQ/pBnU87GLs9fBi/leHMt1okAtNIHyFyKO29ZNu0IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113012; c=relaxed/simple;
	bh=o0wPio6sIWQqyjrfyhd3Jb2wDTWLIXIMsXq6VBnQTZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hh016JxM9GH57QnAtlu7gvIsfp7udCeh6qN9SQ7S6b76E31mDoergVMLWV9OYFCdAGD9wPt3GC3Iill1ALPZRQTRFBQ/K19nT7J7ZxxFcEA8EBbiufAYlRSk0gvCdJy7AoLrT5JZyUV/Z7q/OxaDGqHiDG/WFtTp2696izMVT0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfj4/BDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfj4/BDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F50C4CEE5;
	Tue,  8 Apr 2025 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113011;
	bh=o0wPio6sIWQqyjrfyhd3Jb2wDTWLIXIMsXq6VBnQTZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfj4/BDZFmfXBp46BHueSbEbT57DfF0cHJSuTRyu9XhSXFuD4xCVIUQiCWM1WWHTq
	 kcW6Tuxm6jQODT3Cor9DaZh0Nw4B1MbKXqHoznoOSwwpGpX5i7pETKaFlAgAwq4uzS
	 pdIL8Iudp4rH73f1K8uOu+hHXEgU0O6AB66shwWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <frank.li@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 252/279] can: flexcan: disable transceiver during system PM
Date: Tue,  8 Apr 2025 12:50:35 +0200
Message-ID: <20250408104833.182927932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 5a19143124be42900b3fbc9ada3c919632eb45eb ]

During system PM, if no wakeup requirement, disable transceiver to
save power.

Fixes: 4de349e786a3 ("can: flexcan: fix resume function")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <frank.li@nxp.com>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20250314110145.899179-2-haibo.chen@nxp.com
[mkl: add newlines]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index fc9cfe434ce4f..6f4e3e0330a45 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -2337,6 +2337,10 @@ static int __maybe_unused flexcan_suspend(struct device *device)
 
 			flexcan_chip_interrupts_disable(dev);
 
+			err = flexcan_transceiver_disable(priv);
+			if (err)
+				return err;
+
 			err = pinctrl_pm_select_sleep_state(device);
 			if (err)
 				return err;
@@ -2369,10 +2373,16 @@ static int __maybe_unused flexcan_resume(struct device *device)
 			if (err)
 				return err;
 
-			err = flexcan_chip_start(dev);
+			err = flexcan_transceiver_enable(priv);
 			if (err)
 				return err;
 
+			err = flexcan_chip_start(dev);
+			if (err) {
+				flexcan_transceiver_disable(priv);
+				return err;
+			}
+
 			flexcan_chip_interrupts_enable(dev);
 		}
 
-- 
2.39.5



