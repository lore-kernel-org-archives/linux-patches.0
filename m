Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5FD81AA1;
	Mon,  8 Apr 2024 13:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583195; cv=none; b=McB34cF9I7I5GbFKXwY947OKijQhKgR+ks1YQbaiFwYIOXMJE9GSMjTAMKZ8iO6JVLxMwMtHoFBMdPg1Ln2IYFy0Q498iLeTRMKSW6SQdx3IBDJSRaietDUr0AAXi2Sw/B4eMUlI1Udbi5bJ+tVxAdxgwdQGgHnhIaOo1h5OSoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583195; c=relaxed/simple;
	bh=qAqqE7Mv8VWcDOlk/dTmzTo6GT3BVHoEPYHQyIBgQKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkIEGOKxvpGDH07WifW24zBYR8dJ8imecXStRyfxz3NnJVI3dTur1xijHA+RYImg2DS5FEWkwMbID9PYjd9YzqvzIILM4DwyPtfqw7gp3xE3KAiqD9pT5J6so+mQQoekAWJkCj8cd1CdaN1HaBbapCEfkBwd3W+rCi38hVtEUqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJhBQueo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJhBQueo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F8BC43390;
	Mon,  8 Apr 2024 13:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583195;
	bh=qAqqE7Mv8VWcDOlk/dTmzTo6GT3BVHoEPYHQyIBgQKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJhBQueosbNopKCBJLOW7IGwoZNfTI1zlvV5t8Ie1k1xjyuMC0oBKBRPhIz5o1rvU
	 vrYCGFruEjtbtb/nRYBYWCTLxh1f5KS8iNM2S+Yb/bk4EDxoO44//RMqHFtA8nKO5C
	 +5uqb/lWt959gLIRlSxCr9dN8BOwURaWK7sHFpf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/252] ASoC: rt5682-sdw: fix locking sequence
Date: Mon,  8 Apr 2024 14:57:47 +0200
Message-ID: <20240408125311.876601769@linuxfoundation.org>
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
index e67c2e19cb1a7..1fdbef5fd6cba 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -763,12 +763,12 @@ static int __maybe_unused rt5682_dev_resume(struct device *dev)
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



