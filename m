Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDE121D3DD;
	Mon, 23 Jun 2025 21:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714669; cv=none; b=OzaE+V1b2FRbfkSDCB7JiHamY4gTxMx3HBiEJtMA5rF5tq8egzodM3nKrQuCkeua1ABeJ4N0s12XqmOcDiqGgogVCqXqOA9z3hI7VCqYNsBBqyjVJDM0zHSk3NeHtlCquHmy3DCMb/rf6CJYva7jQAsQLZG3FkefG9YvpKqx4us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714669; c=relaxed/simple;
	bh=a7L6bt9ftjssXri9RKysWKYG+OsPjocuTP3kvmRTw7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LFOIty7sBU9n2GYk7zaTcmiAU20JlVxIHZljAl7hn9NbER2WVYIgMLdByX5mRM5q4qLLg7u1VUp51KkLyjPgIjbQFdlNbzGFuqMXYV5hMYqfSzRMcAJkHo3lMmEB5iMepQOzCr1kLED8QrRkecKkbP06jIiHVmYsUcjegLuCvhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjTNh5ac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjTNh5ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3862BC4CEEA;
	Mon, 23 Jun 2025 21:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714669;
	bh=a7L6bt9ftjssXri9RKysWKYG+OsPjocuTP3kvmRTw7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjTNh5ace6m/EtVdsI7Kr/NU/zBpo49e53cRHKRkx7gHOttZygmhE5Og4b2XEJbdR
	 ctVbP26uS7koTDJDvXLHwi9bKSJSgC4f+Zy3dLSKmFaYFulEhHH3SCVI9lGqCiiVVa
	 2lv9XuBxqV6sE0a3K/BzoUc5/ooxofjrGbWpigb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/508] ASoC: Intel: avs: Fix deadlock when the failing IPC is SET_D0IX
Date: Mon, 23 Jun 2025 15:03:53 +0200
Message-ID: <20250623130649.897567974@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 306f0dc4eaf58..2e76aba7338e8 100644
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



