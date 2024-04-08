Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3007F49C;
	Mon,  8 Apr 2024 14:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585113; cv=none; b=PvEaGTz+E2NFelrXWxZL5D7+EIZ2XUpuwgApGt6J6wnb8XX0XFnskukFsOYYuS4vqMw80hpudMsiJMrTUJQ48MMyym3+/+rPjlrlG2A/w9G4eRgBtK/VgWnqSBSEqtAiBAxMbsNkfF/epwtSmgy9BHaT8jGp6+sYc/Nzq68xWI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585113; c=relaxed/simple;
	bh=A6jvupesE99zNSHgNvonodd+hkdwjjva58FrrPYhL0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeRcsDD5j5CMA3b9m42tEwdONYvoVJrQrg/MpUmvor/h9xRTcCbTYUmGuNANRBSR0IEbMM+VXuFWzP9noHQ1Gm+09hssJ6Exd+oYgzHt2R0ezwfBXhMtp0XLaTx/WZjihyy7A8ZnnltsgUMe+aL6hq1bhA64eYSVxVLHSmT3avE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXhM5URe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXhM5URe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F7EC433F1;
	Mon,  8 Apr 2024 14:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585113;
	bh=A6jvupesE99zNSHgNvonodd+hkdwjjva58FrrPYhL0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXhM5UReCNfvQykJpzyJnbDYuawn+OBkMg5hh6Zq3AH5JQoMfKpsC+u0Bp5Dvqekh
	 ocJqZyFhy13nSEEEeKZ/K/Q15SvVKnq7bMQvbeSMsjEJuPKvaot2sZUfrVwRtP/tzU
	 YGN6rdBSkH+wGPZIf1FiVsNdRVeubOU+0surTjLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 667/690] ASoC: rt5682-sdw: fix locking sequence
Date: Mon,  8 Apr 2024 14:58:53 +0200
Message-ID: <20240408125423.848530963@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 310a5caa4e861616a27a83c3e8bda17d65026fa8 ]

The disable_irq_lock protects the 'disable_irq' value, we need to lock
before testing it.

Fixes: 02fb23d72720 ("ASoC: rt5682-sdw: fix for JD event handling in ClockStop Mode0")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Chao Song <chao.song@linux.intel.com>
Link: https://msgid.link/r/20240325221817.206465-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-sdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index 9fdd9afe00da4..f452245b210f6 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -787,12 +787,12 @@ static int __maybe_unused rt5682_dev_resume(struct device *dev)
 		return 0;
 
 	if (!slave->unattach_request) {
+		mutex_lock(&rt5682->disable_irq_lock);
 		if (rt5682->disable_irq == true) {
-			mutex_lock(&rt5682->disable_irq_lock);
 			sdw_write_no_pm(slave, SDW_SCP_INTMASK1, SDW_SCP_INT1_IMPL_DEF);
 			rt5682->disable_irq = false;
-			mutex_unlock(&rt5682->disable_irq_lock);
 		}
+		mutex_unlock(&rt5682->disable_irq_lock);
 		goto regmap_sync;
 	}
 
-- 
2.43.0



