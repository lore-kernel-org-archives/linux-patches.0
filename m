Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBF914A4E2;
	Tue, 20 Feb 2024 20:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462762; cv=none; b=cjVtbuAew/Oj3/kOremlNq7iM9VLsvQVslCc3WY0V7F6QDsweZ2iChi2HeZugHpQWB2FqPb3k2EY15fvCokw3wriylgK+YdQI6WB1pySatZ5KQYm9X9b8QYabi/FJpXJwbO1n25yQ8ausiL5Pp/OVSDGcLGKZfwnSMT+ii6V/4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462762; c=relaxed/simple;
	bh=EzKkFOhg5dKYZ04xYpJQuUHwAfGNFDcUEf7EimSALO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJAy8YaCAJwpdsToG7Bl6O/VPlfNm/2tv3IEldzuZkQbtDJDxZTLL315DdiMIccd339Wg7lKvv/a2Ztys71G4BDI8le870dB+lYoclZuxl12K1MknR8UKOotz9Kf9/hdTyjTQeZNd/+TzwJ9YgAR/UeO+loTRF7UOpGilHn/IxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sf8sL/7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sf8sL/7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7EBC433F1;
	Tue, 20 Feb 2024 20:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462762;
	bh=EzKkFOhg5dKYZ04xYpJQuUHwAfGNFDcUEf7EimSALO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sf8sL/7BITnsyg3LLOScz0I0w4VlEaGDIZy9tXys6kTRA1ndqSHx4jW1Xw2gX3d2A
	 W1NyroqrQY49DKDUBLI3lx0j4DhFdVMUjUqvGIa3dXpAVvV3qjqHtezdtyThQqrqcj
	 nDkP77vmfacdh1SyUahrVRT1Q8Uel8cxUiOvhmHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/197] ASoC: rt5645: Fix deadlock in rt5645_jack_detect_work()
Date: Tue, 20 Feb 2024 21:49:47 +0100
Message-ID: <20240220204841.923378903@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit 6ef5d5b92f7117b324efaac72b3db27ae8bb3082 ]

There is a path in rt5645_jack_detect_work(), where rt5645->jd_mutex
is left locked forever. That may lead to deadlock
when rt5645_jack_detect_work() is called for the second time.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: cdba4301adda ("ASoC: rt5650: add mutex to avoid the jack detection failure")
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Link: https://lore.kernel.org/r/1707645514-21196-1-git-send-email-khoroshilov@ispras.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index fd3dca08460b..844d14d4c9a5 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3288,6 +3288,7 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 				    report, SND_JACK_HEADPHONE);
 		snd_soc_jack_report(rt5645->mic_jack,
 				    report, SND_JACK_MICROPHONE);
+		mutex_unlock(&rt5645->jd_mutex);
 		return;
 	case 4:
 		val = snd_soc_component_read(rt5645->component, RT5645_A_JD_CTRL1) & 0x0020;
-- 
2.43.0



