Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710394E73A6;
	Thu, 17 Sep 2026 16:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664157; cv=none; b=gCk9kmGmNfPe3kx3zqWsk3+0suvZf2FvLd1mEXCdG4D8HvL1IaaqE239DOtee6JMbdrHYjD4frLoAG6dS2JFoRVrYltTxaZWuN09eAzWKBhYdDvts8/mcB/rdnbDijsIs5uX5Mf9h6UH0LmQNU+ErGoI5DvafiD8or8+8r6Fnxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664157; c=relaxed/simple;
	bh=qxEYUbjwS94RY7BMkiH7dIPqgdatKjCeGKmv4NsanIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oa7kLtkb21NRwIazXkbmgsHz3TkcULaZjyIcyyEal0VVhcNUPBaEKm3ZXisYjE3lRHB2h0OYCzG+rxlgAd8+/R55H5VJytcajxzfnfp3rULilp5C4iETcvw/HlSnclpTAneFMHJwLpc//vcOxqRGHmytNYoF1wfow5hEDDLsyXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oax3xR8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oax3xR8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940471F000FF;
	Thu, 17 Sep 2026 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664156;
	bh=OUYpl+I0oXhIywTEr4Iy0gLNPg3/0jtg3TOaDGdze0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oax3xR8/MZ54xHQJvYdsrZVJwhhEodhLeBKAFKRflsJd+8Rcu2aQAhVA67idsjFa2
	 cl3RRsIaHbtemoQK+W0K0sCd+4ulgJbaZWD2Lqdcq5f0xZY2lzXgnuCwvGjl9T4R6/
	 j/qi+2A7Dewk5/V0kIwlLJ/mLce9lWRlN1IpPv2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0278/1250] ASoC: codecs: pcm3168a: Prevent regulator double-disable in S4
Date: Thu, 17 Sep 2026 16:01:13 +0100
Message-ID: <20260917151559.673074469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit bb3c847523f951315f212047ab26363f9928d569 ]

The SLEEP_PM_OPS are unset for the driver. Hibernation (S4) causes no
resume (skipped thanks to smart_suspend=true) yet still performs the
suspend sequence unconditionally, see device_complete() in
drivers/base/power/main.c.

If S4 runs for already suspended pcm3168a device, we end up with
"unbalanced disables" warning from the regulators. Assigning the
operations fixes the problem.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260525201801.1336936-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm3168a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/pcm3168a.c b/sound/soc/codecs/pcm3168a.c
index c8617a488b11c..7f8d64fb0e57f 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -907,6 +907,7 @@ static int pcm3168a_rt_suspend(struct device *dev)
 
 EXPORT_GPL_DEV_PM_OPS(pcm3168a_pm_ops) = {
 	RUNTIME_PM_OPS(pcm3168a_rt_suspend, pcm3168a_rt_resume, NULL)
+	SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
 };
 
 MODULE_DESCRIPTION("PCM3168A codec driver");
-- 
2.53.0



