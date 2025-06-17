Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957A82DE1E5;
	Tue, 17 Jun 2025 16:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179192; cv=none; b=Pt7253BRPVcnOlAi3xbDJkPvBZYx8dxbgZVvnlhJyOEMECt0WYRBc0GNRJYDYEg+7Z1Y5lhYolm7D8jisNTonHixFwEiyH9YXr3iElMz/nIb0Y3PM3X0nqsO7hC0V5qgm5hr4FWsTg4U5QaVLy29JZu5t/9lsOAEI2hn0K0Jpd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179192; c=relaxed/simple;
	bh=eoa/O7dZTYiV2bwc6ZzqXOym/QSWuAiXQ0qulVU3Eak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lPrfA8O5/ZBHN9Gti4czG3KDRxb0DUkFGRwiUBrnBEJPB+xhs9poU8tIvuEnc6yoA/VRUIXkDznzw7HOqai+Nds/KtPS8OOLTmPXLz+niYCz8pgDrhO7Gi8EtVvRUlxzlbolNaHi/OONmtz8tPyDerysquYQyIPsOtPdBjOK2kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=koIbH1dg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koIbH1dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FF9C4CEE3;
	Tue, 17 Jun 2025 16:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179192;
	bh=eoa/O7dZTYiV2bwc6ZzqXOym/QSWuAiXQ0qulVU3Eak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=koIbH1dgc/fKvJkhx029lqzuyhGNmMXVQigXnheK59mdeuXi9yeM3rDGerbvOUWyy
	 KSFDtBYLnd2kfyoovyZbm7jRM85XTwmctKQxWLw99GVUij9Tnrg+S4pKGgaY3x3iI3
	 bEbVrPfX0MmQEgy/zWBDe2qev0IxVOuMTOnbPxHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 636/780] ASoC: Intel: avs: Fix deadlock when the failing IPC is SET_D0IX
Date: Tue, 17 Jun 2025 17:25:44 +0200
Message-ID: <20250617152517.376675933@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 9ad1f3cd0d60444c69948854c7e50d2a61b63755 ]

The procedure handling IPC timeouts and EXCEPTION_CAUGHT notification
shall cancel any D0IX work before proceeding with DSP recovery. If
SET_D0IX called from delayed_work is the failing IPC the procedure will
deadlock. Conditionally skip cancelling the work to fix that.

Fixes: 335c4cbd201d ("ASoC: Intel: avs: D0ix power state support")
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530141025.2942936-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/ipc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/ipc.c b/sound/soc/intel/avs/ipc.c
index 08ed9d96738a0..0314f9d4ea5f4 100644
--- a/sound/soc/intel/avs/ipc.c
+++ b/sound/soc/intel/avs/ipc.c
@@ -169,7 +169,9 @@ static void avs_dsp_exception_caught(struct avs_dev *adev, union avs_notify_msg
 
 	dev_crit(adev->dev, "communication severed, rebooting dsp..\n");
 
-	cancel_delayed_work_sync(&ipc->d0ix_work);
+	/* Avoid deadlock as the exception may be the response to SET_D0IX. */
+	if (current_work() != &ipc->d0ix_work.work)
+		cancel_delayed_work_sync(&ipc->d0ix_work);
 	ipc->in_d0ix = false;
 	/* Re-enabled on recovery completion. */
 	pm_runtime_disable(adev->dev);
-- 
2.39.5



