Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F7B80022;
	Mon,  8 Apr 2024 14:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585119; cv=none; b=FcpUdWxxQNQM8/KseI5+GeJaitpVnypkwV18toFLX6iWD6lgInLnMTr2/+UuhFzBnQJlhjw4AR19xsSG8UHtFyiRoGvyqqao53tOvfWXiCCuk0lkmZtCDT20Yn5CTFtI85+MFABlRz5UiJnWlisqxRFESDcLiIP3CZGr1LBt4JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585119; c=relaxed/simple;
	bh=kis7P/ByuSSeKTITDwcABcdtmrUqyG2asU3WLfgBwfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEXxdY/8jfIodblHA58Z1BLK2sR3g/8cw/3O/2RnY5j9Fujl4PMZ57MI3u9TuyQIq0AqTRbwnLKsyh3xxyoRJZOdUsJrJZFVz9BoNVnTtHkSC2yIRZ+i4GmQtDu8jqaCtUBS4fkfS4S9B9Xoe8W/TzOC1QX8jZT02ce+EzIvGZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vt8/kJ8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vt8/kJ8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98B4C43390;
	Mon,  8 Apr 2024 14:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585119;
	bh=kis7P/ByuSSeKTITDwcABcdtmrUqyG2asU3WLfgBwfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vt8/kJ8fq12btzN658b+CmXkjlZtj4/FzAimCesGt7lXC+Pq6gERDWvOaZUcyeDUr
	 BvX5YJZU40SSrV7Umrw3iankb5YnE1G6+mGKC5RbmAsO2ieu7CroIyLAZkVXcWwJyo
	 6JCCa22M0etwYCwXvAT3S7K6rwb227va40pXMcOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Chao Song <chao.song@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 669/690] ASoC: rt711-sdw: fix locking sequence
Date: Mon,  8 Apr 2024 14:58:55 +0200
Message-ID: <20240408125423.949400494@linuxfoundation.org>
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
index 9545b8a7eb192..af7a0ab5669f4 100644
--- a/sound/soc/codecs/rt711-sdw.c
+++ b/sound/soc/codecs/rt711-sdw.c
@@ -542,12 +542,12 @@ static int __maybe_unused rt711_dev_resume(struct device *dev)
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



