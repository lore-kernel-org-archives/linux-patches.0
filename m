Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1158B196D87;
	Thu,  6 Jun 2024 14:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683010; cv=none; b=AyMMeOIWoyMHF5uVzb4pwxBQ4bYjGz0sFi2rSPo7HtOdGsgWuREE6Ijn5Rt0lrDYrhir+9XnMKbaSuljHcT4PbKpTBcQAXYYnvl2pic81ZOfFlAPPXg8A2CK3inO/kQqM613b0g2uWH3BuCarlWUwcMrwlfkBBtGCqi01ES6mEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683010; c=relaxed/simple;
	bh=xT5qo6Gikfjr+4NThpYg1qpioAewX+HWPhiGYO12slc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYDdy165r4RVydvJNk7z2wVx1eh+bgBu94i37EsnwKNS10219GeedHoD234iDUZdXMtqBWUE7TSECWOMYJYBB8T9Iiv6iVKm4KsvNypwzqJntNGzcLjrUvy/mdaoUh+DBEtLGbgo6d4tTZvXvGAstpD/TQL8MB8uvAKF54LBIiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aC+Xqpxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aC+Xqpxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4773C4AF1D;
	Thu,  6 Jun 2024 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683010;
	bh=xT5qo6Gikfjr+4NThpYg1qpioAewX+HWPhiGYO12slc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aC+XqpxgZTsmyQ4Qj6hoPbIT0dcXOJkSuUVfo0ANgQ5q87K7UDtHxwuLcW9rwIMiD
	 IboV87U35McxX0Vv/lS2eoKPeHtP3Sq1GkT5WJ6c8DwjB5Wql/5SXg1fNUfa93FVUU
	 M+UP5CbMvEQflTNVm0Jw0knjZXnfPQ5BiXfvMdN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 220/374] ASoC: rt715-sdca-sdw: Fix wrong complete waiting in rt715_dev_resume()
Date: Thu,  6 Jun 2024 16:03:19 +0200
Message-ID: <20240606131659.163262523@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit c8bdf9e727acb6e1b37febf422ef1751e5a2c7d1 ]

enumeration_complete will be completed when a peripheral is attached.
And initialization_complete will be completed when a peripheral is
initialized. rt715_dev_resume() should wait for initialization_complete
instead of enumeration_complete.

the issue exists since commit 20d17057f0a8 ("ASoC: rt715-sdca: Add RT715
sdca vendor-specific driver"), but the commit can only apply to
commit f892e66fcabc ("ASoC: rt-sdw*: add __func__ to all error logs").

Fixes: f892e66fcabc ("ASoC: rt-sdw*: add __func__ to all error logs")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20240509163658.68062-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt715-sdca-sdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt715-sdca-sdw.c b/sound/soc/codecs/rt715-sdca-sdw.c
index ee450126106f9..9a55e77af02fe 100644
--- a/sound/soc/codecs/rt715-sdca-sdw.c
+++ b/sound/soc/codecs/rt715-sdca-sdw.c
@@ -234,10 +234,10 @@ static int __maybe_unused rt715_dev_resume(struct device *dev)
 	if (!slave->unattach_request)
 		goto regmap_sync;
 
-	time = wait_for_completion_timeout(&slave->enumeration_complete,
+	time = wait_for_completion_timeout(&slave->initialization_complete,
 					   msecs_to_jiffies(RT715_PROBE_TIMEOUT));
 	if (!time) {
-		dev_err(&slave->dev, "%s: Enumeration not complete, timed out\n", __func__);
+		dev_err(&slave->dev, "%s: Initialization not complete, timed out\n", __func__);
 		sdw_show_ping_status(slave->bus, true);
 
 		return -ETIMEDOUT;
-- 
2.43.0



