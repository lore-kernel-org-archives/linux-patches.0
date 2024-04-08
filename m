Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA47F492;
	Mon,  8 Apr 2024 13:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582285; cv=none; b=Msr/o+qGD+yxGC+mhpWksQEVYcUXjqSsNvKXFcP8maAWtkixwVZkRqjBo/w/3m0AaxeFZNklnZjJArDcbnsmpYL3OhrLsjCJh1NKIOAIn5fK3xMl++mQnqQ/3tllLFzICtc086Sh/EjWekkulQRYrjH2IoZu3c2NOguUTGAP5ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582285; c=relaxed/simple;
	bh=O5NMlOOZWCFh4y9VqLppuSlFjBPef1rXyJzXe6MsEZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnytDITRe05z9CsdCaYJ29hXMbJRe5OSf43A0FNAZ08MzI3AUX8pbvKIbRIFz8d6I4Hs4qRhmVIA+6sTb4DcpdX4pW89fU3lOy/4UB6UyNgkp9SBLF5qTbjok8J/5aZooi4HN0pMewPEpIPEiLEnBsqYepALP5QNZvGkUEmCNXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XTIQB7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XTIQB7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68231C433C7;
	Mon,  8 Apr 2024 13:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582284;
	bh=O5NMlOOZWCFh4y9VqLppuSlFjBPef1rXyJzXe6MsEZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XTIQB7IChlZ0euJKQCdpS6u+NFb55yMPDdn5G0GToRgwhBYLteFjvwZpGeqKvNE1
	 YOkDP9fF6qXpijLwh5L40Z6MT9EnF6w4jJCu0mbirbxxqgEHZqUOG7l2e7iEG3nhPb
	 JROxGL7VKN7MwGbXkqDb2buY67FUmRmYfnV1V6rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/138] ASoC: rt5682-sdw: fix locking sequence
Date: Mon,  8 Apr 2024 14:58:27 +0200
Message-ID: <20240408125259.123797275@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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
index 868a61c8b0608..7685011a09354 100644
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



