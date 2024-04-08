Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B317C08D;
	Mon,  8 Apr 2024 13:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583212; cv=none; b=JbVb9lw9+fvCe9125ZoazLiDViorPAFZ5o2YTOD7YGPN0wyo7IW47LO92J3bMInBshn8c9i9A2i/efqKk/jJQaw8+Exyz6+U9sbbY/Xw5y6qpeHf6Q6rNUD5zWeYHaGtGVHpoaeLHFJPTB2aSwsiRLVp3GJ/5/rCLEg6J1VH11I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583212; c=relaxed/simple;
	bh=qwyqwOSB0b0aCf5EGCCkx+KTGNyyyooey5jngDl/oIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGZlLITbEuMfwzmW66DN1SaH49Iateg4Vvxp7JE3MVP0rCvyLd9SSi81t9Fe+YwrTPjd+EQINPjLVhm7TgLk5wkc5PlfE1AczW69x6lhLKfyFOtmWiknvIJrKbD3u1BSsJ6IapwmuloOwqU4gw1bspZqgAFtQwouKBD+3Wp0se0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQOrwkDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQOrwkDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EF6C433F1;
	Mon,  8 Apr 2024 13:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583212;
	bh=qwyqwOSB0b0aCf5EGCCkx+KTGNyyyooey5jngDl/oIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQOrwkDZFdeterOOBLLfSSBeh0lEX40/aHunHcPYxvbS/gH74daGyqks4NOOqTruO
	 56cSV4TTYM0TkvT8jj1HY6PLkMjQp/vMyRp6f/jx86M/5+bgCZTJKrd58TUSablWng
	 dxT3JtNYOP7LUuDzCzQ+PrkAVbHnkP+WbSfPltyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/252] ASoC: rt711-sdw: fix locking sequence
Date: Mon,  8 Apr 2024 14:57:49 +0200
Message-ID: <20240408125311.937519679@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit aae86cfd8790bcc7693a5a0894df58de5cb5128c ]

The disable_irq_lock protects the 'disable_irq' value, we need to lock
before testing it.

Fixes: b69de265bd0e ("ASoC: rt711: fix for JD event handling in ClockStop Mode0")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Chao Song <chao.song@linux.intel.com>
Link: https://msgid.link/r/20240325221817.206465-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt711-sdw.c b/sound/soc/codecs/rt711-sdw.c
index 3f5773310ae8c..988451f24a756 100644
--- a/sound/soc/codecs/rt711-sdw.c
+++ b/sound/soc/codecs/rt711-sdw.c
@@ -536,12 +536,12 @@ static int __maybe_unused rt711_dev_resume(struct device *dev)
 		return 0;
 
 	if (!slave->unattach_request) {
+		mutex_lock(&rt711->disable_irq_lock);
 		if (rt711->disable_irq == true) {
-			mutex_lock(&rt711->disable_irq_lock);
 			sdw_write_no_pm(slave, SDW_SCP_INTMASK1, SDW_SCP_INT1_IMPL_DEF);
 			rt711->disable_irq = false;
-			mutex_unlock(&rt711->disable_irq_lock);
 		}
+		mutex_unlock(&rt711->disable_irq_lock);
 		goto regmap_sync;
 	}
 
-- 
2.43.0



