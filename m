Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19B935A95B;
	Fri,  9 Jan 2026 12:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961877; cv=none; b=IBp4/sox3k0mCK9IoP2TY88h/sN12VJBICAnkozvp4FQpfjba+Us199ug2z+ihxeB2+EO80PHyXCNpAlJ+KDTrMi62wjatNRi/R7KMhsby4e5AXQ3z7LHrpcTul2hDB67UX/m4MwtK850s92kMbJUjDp2vfGqxxBeS1Y7k69G20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961877; c=relaxed/simple;
	bh=rutcdPqCiej+RJmBFXTHcdial/nK99mt74UhwSgWoQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeTMmvAwtl9kdMaNNkuOGneUlNMcUvtJY6mg4llkv9gLKKNcXwrJPcdZO2XEIKa/tRLxCV/cbX+iRlA38tAj/3XZpdZdv3qQy+uFaJgajGPNfk2A7/zzq5+nm0IPYs/FUreU7sxo/kQd0RV2iHdBLaiFKvi6OHiLkMQdrgNHZsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uT0UeH+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uT0UeH+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C346C4CEF1;
	Fri,  9 Jan 2026 12:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961876;
	bh=rutcdPqCiej+RJmBFXTHcdial/nK99mt74UhwSgWoQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uT0UeH+Huh2C4rh0NEcJhh+IROHPuJd+aljw1FsN9vbJMq9Zp6g8PcJkyxyGAHp5v
	 LBwKIrSE7N0d6yiKgLYLbZ48D7LK8zQl1i/0JNRsj1HEw0MIqGficToMyZjIOzBnb+
	 JRQPYyhSV+OIcu5XCj9dA9qxiGna2jq+KZ4uqEb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/634] ASoC: Intel: catpt: Fix error path in hw_params()
Date: Fri,  9 Jan 2026 12:37:24 +0100
Message-ID: <20260109112123.694660321@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 86a5b621be658fc8fe594ca6db317d64de30cce1 ]

Do not leave any resources hanging on the DSP side if
applying user settings fails.

Fixes: 768a3a3b327d ("ASoC: Intel: catpt: Optimize applying user settings")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20251126095523.3925364-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/catpt/pcm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/catpt/pcm.c b/sound/soc/intel/catpt/pcm.c
index 30ca5416c9a3f..a30cdc94871d1 100644
--- a/sound/soc/intel/catpt/pcm.c
+++ b/sound/soc/intel/catpt/pcm.c
@@ -417,8 +417,10 @@ static int catpt_dai_hw_params(struct snd_pcm_substream *substream,
 		return CATPT_IPC_ERROR(ret);
 
 	ret = catpt_dai_apply_usettings(dai, stream);
-	if (ret)
+	if (ret) {
+		catpt_ipc_free_stream(cdev, stream->info.stream_hw_id);
 		return ret;
+	}
 
 	stream->allocated = true;
 	return 0;
-- 
2.51.0



