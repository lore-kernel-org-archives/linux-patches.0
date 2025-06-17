Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31D62EE600;
	Tue, 17 Jun 2025 16:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176374; cv=none; b=HoDeHNojC6LfZ/yvBqNB1ktpqAZ5XZP4HYov9WGe+HqJpNfPtNJeEFnVIfH0dzTnL+d4PmR6E/BSWpG9HEak2rdKSB4ultncld8ClTmIuGY+CMV5b2Cn0FRD0C+KjoRNSXRpfIwIW+Y3UASg+P8TAFVdrnICPMSWbncDeI43v/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176374; c=relaxed/simple;
	bh=Q5vw4N9x1d1vRDiwDg7Yh9rCmnG7B/2hTdYW9KqmKGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rl4tSSN4vbMD5Gt+/cyPlDm31yAxKSX/cvU0n0Tr6fafH8GhajcllhfLgu0X9t89dbi5K78IOcCvo0PyGDVH2ETEwxKxE33OUsi+/n5uIDA/wL4o86dtCON4RBQzHhAUqB/QudVhY6L/6EIPgCXYTVnaQBpGX2FowARf0C87bDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U27vnrYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U27vnrYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71ACEC4CEE3;
	Tue, 17 Jun 2025 16:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176373;
	bh=Q5vw4N9x1d1vRDiwDg7Yh9rCmnG7B/2hTdYW9KqmKGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U27vnrYZP64lwkqXyhQcExzuHdkCbRsDhibXtZkHrUeGIKJtwpSGeNqEm0nrnOY62
	 9b9is3wkDkqnzGh9kqhp2dQZmOckbPIFHnaNZJkqB3lCB6ROp2c7Nd1bLdgXp8MZNa
	 6KftkjAC1LfgRAm7pTLGXN4v2tWzL2NSPzhwGRv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 271/356] ASoC: Intel: avs: Fix deadlock when the failing IPC is SET_D0IX
Date: Tue, 17 Jun 2025 17:26:26 +0200
Message-ID: <20250617152349.107682714@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 74f676fdfba29..afd472906ede4 100644
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



