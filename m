Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DFC301472;
	Thu, 28 May 2026 20:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999862; cv=none; b=aJVlAEGbryAZCIP9VKJ5Tm8OG0grOl41o58tALFAX6oekHQ4meL4mSzn64r4URTB9D330+jT8hpCRsUzacs45D4orqqGKt8S7pXbH4/FYi6c8f+xXXOcZmdpVwEK8JRv6QzGP1OqwOwof3gSk0pGMVyZcwyvKR5vidKW1+mByvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999862; c=relaxed/simple;
	bh=leTr3spSpQiZbpvcW8Mstkyz34RyvB4MJim669cenRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqpEGmPvcOQeAg0May6yXkwrVz4pUeJKFAATVCUWhfzuyF780AdRUKUCIhmwjg7KzG8GXQEPqIbtEUNeIGw4IOH0H7AkbXCG6W1rOEGKRveI+Ki6Yu0S6jZEAQUqZqjzznc33phax3PEFPxbnAlerqyGYosFH+ge2WKfPFJ39K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5BpjBr9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5BpjBr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06541F00A3E;
	Thu, 28 May 2026 20:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999861;
	bh=dzhkwgwr4TDkMrQUsC1MhIQvQq/oX6S5/wUTc4l/k6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5BpjBr9VWJbqJr04P7WUOSxFDdZlRWP0xoflyhIWGvWla5aC0zuh3LIErmIechAT
	 pb0LegM53zsmlCcvAC5U5Hoyz7Bj/GLi6vpdFfumJKFydqqIwPw8XsGXa+wcYTAVdz
	 1ycJBKd+MlEnV9+EwpxDYEUj7CWhXb7k/F3pqEEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mac Chiang <mac.chiang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 217/377] ASoC: sdw_utils: Add quirk to ignore RT712 CODEC_MIC
Date: Thu, 28 May 2026 21:47:35 +0200
Message-ID: <20260528194644.681802120@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mac Chiang <mac.chiang@intel.com>

[ Upstream commit 9c37daee7c17fa17e8d41089ee1f658b06cb672a ]

Some devices do not use CODEC_MIC but use the host PCH_DMIC
instead. Add a quirk to skip the CODEC_MIC DAI when it is not present
in disco table, ensuring the correct capture device is used.

If CODEC_MIC is present, it continues to be used as default.

Fixes: 9489db97f6f0 ("ASoC: sdw_utils: add SmartMic DAI for RT712 VB")
Signed-off-by: Mac Chiang <mac.chiang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260508093224.1246282-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 3848c7df1916f..050ca17ff105d 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -170,6 +170,8 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 				.dai_type = SOC_SDW_DAI_TYPE_MIC,
 				.dailink = {SOC_SDW_UNUSED_DAI_ID, SOC_SDW_DMIC_DAI_ID},
 				.rtd_init = asoc_sdw_rt_dmic_rtd_init,
+				.quirk = SOC_SDW_CODEC_MIC,
+				.quirk_exclude = true,
 			},
 		},
 		.dai_num = 3,
-- 
2.53.0



