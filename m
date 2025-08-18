Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115E7335BA3;
	Mon, 18 Aug 2025 13:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525203; cv=none; b=V860rmJF0g6bequEQ3V5XtedbMdcZNqaMzweyqwsZMsm8Cgq6xDwyS+k1kvIHLuSefXb86Z/leidk7RiWYaEmEam8tElqutuvjYN57WaROeTLzwJ4MmymS4rACV/xrY/PmdhclPDQwW791ogSDgRHip+4LOzoz7h0IALB7uOMRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525203; c=relaxed/simple;
	bh=1xZeW5PyTSZZKrwS4zg3sRccepyV+7udO3vWkNDHXJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zf1zcAxbwIyyCpm27kLaij7HWjnvZnKB8y8zqmXu8RlW3TS1e4Ri0AzdGXmBhG35VFgd1LkUv/kDO2doM15TzCTIlbDKJDioeukGAF6qaHoaetZHhDVsIBG33rcCIm99pDq2UumikExdMVla42UdnpwunYZUD0ksKL1K59+9Xlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oq2YAscX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oq2YAscX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9104CC4CEEB;
	Mon, 18 Aug 2025 13:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525202;
	bh=1xZeW5PyTSZZKrwS4zg3sRccepyV+7udO3vWkNDHXJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oq2YAscXzjhWHxSZjE0+H418tfaUnKxQ5cSj569SOMTu18TaBgrpFAhnbxv9lFBWM
	 ZHM7S/8/4dyGiZCh3MwnpBBJqoTegY+Twj4NZQPSlswpdiVb7Tzazm9rNwSWO4QCXe
	 ehkwCKazINrMCnk0i3S2jua7cDBXes2PJwgGaYbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 190/570] ASoC: core: Check for rtd == NULL in snd_soc_remove_pcm_runtime()
Date: Mon, 18 Aug 2025 14:42:57 +0200
Message-ID: <20250818124513.125369376@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 2d91cb261cac6d885954b8f5da28b5c176c18131 ]

snd_soc_remove_pcm_runtime() might be called with rtd == NULL which will
leads to null pointer dereference.
This was reproduced with topology loading and marking a link as ignore
due to missing hardware component on the system.
On module removal the soc_tplg_remove_link() would call
snd_soc_remove_pcm_runtime() with rtd == NULL since the link was ignored,
no runtime was created.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20250619084222.559-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 67bebc339148..16bbc074dc5f 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1139,6 +1139,9 @@ static int snd_soc_compensate_channel_connection_map(struct snd_soc_card *card,
 void snd_soc_remove_pcm_runtime(struct snd_soc_card *card,
 				struct snd_soc_pcm_runtime *rtd)
 {
+	if (!rtd)
+		return;
+
 	lockdep_assert_held(&client_mutex);
 
 	/*
-- 
2.39.5



