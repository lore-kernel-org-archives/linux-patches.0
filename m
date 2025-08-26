Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B7C343D83;
	Tue, 26 Aug 2025 13:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214342; cv=none; b=MjZvlG0MlU49oDEuFVNRn28+1ORTDCbiLnhDZN/ttszwaJiUC8kuzAUf4BtPdKbyDpAWaLvfK3EP20UMmaG2jFxX697LcjVmpce1rVW7kIbi5X9/+afB8Db2ZaaxsT41H8pgsmBDFGYX3yNJ7iNJhScsnCJvNjLtB72R0QbfAsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214342; c=relaxed/simple;
	bh=Xg0j9SSpv/Dh6PfgpTaLUk/va4Bat8wCK96fW4sfzsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/K1Yzm0X8dURsCgC6whp1eedByiISbxFMjrYckq9nLLDb3g8L1lfbEh8iBHbUATBNhTbCuGI5Wne5zn56hGLYE8ZqA4dSIu4Gx7KKGpL4h6jlyeeDDNJpDhbSlYdhTIzR0BkXFQHtDx69dHABTQnNUnEMVujUJLakr6QpxvsEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdrIF7y9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdrIF7y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42BDC4CEF1;
	Tue, 26 Aug 2025 13:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214342;
	bh=Xg0j9SSpv/Dh6PfgpTaLUk/va4Bat8wCK96fW4sfzsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdrIF7y9STniEvWzcjvotuHvliMHZXmWQjXTviIXKte3ta7Jdv1rsQVXjE7+qlCLt
	 kHrWFQkAn7dVo8q0fMYQpNbacmUEd1mpu5EkQIN7DlhIcpED/sV51aApiP2pFqAU6C
	 4YcLK11qwoUNJBQ8j9fsXg76A3Ee/AEA4RuMgUZc=
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
Subject: [PATCH 6.1 102/482] ASoC: core: Check for rtd == NULL in snd_soc_remove_pcm_runtime()
Date: Tue, 26 Aug 2025 13:05:55 +0200
Message-ID: <20250826110933.349669582@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b13370d2ec1d..1ff7a0b0a236 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -937,6 +937,9 @@ static int soc_dai_link_sanity_check(struct snd_soc_card *card,
 void snd_soc_remove_pcm_runtime(struct snd_soc_card *card,
 				struct snd_soc_pcm_runtime *rtd)
 {
+	if (!rtd)
+		return;
+
 	lockdep_assert_held(&client_mutex);
 
 	/* release machine specific resources */
-- 
2.39.5



