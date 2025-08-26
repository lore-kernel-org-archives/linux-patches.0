Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6874134A33C;
	Tue, 26 Aug 2025 13:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216215; cv=none; b=SHo8DyTop+qOXsA+qV2lo2wxaSrO62Bik6Hcdcl63Uq0DtB6v+QHs10gklufewOA7BB4FdAO1RgakIqXW05vHpUMIionOvGv+rzPGa7aEBaNdVNLfcPrpPFx3RBUR0vZaCtxLKFfXaSWAo4BpydBO6zyBQ2m9tEVlC7Z1oQEyQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216215; c=relaxed/simple;
	bh=0ewIVQW4q+NZ26MWbCFEjfxY40gQMUtwVXYdB3SoNqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BURwo15Gyc+YOdA4QREzSzfnheMF8ySGv6lleRDHPpSwRXpyjh87ROzFZCARvKJXLuFxtwqUetJpwpUVgj0tMQ1P3YDppu8J2rukVxd3Rb9Vazrp06vNJuzFqv0PbJ+0sXnc6JH4BPyYv9+ReZIH3k1V/BMEFFIOfdQfbOQ5UE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpyGDekh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpyGDekh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FFDC113D0;
	Tue, 26 Aug 2025 13:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216215;
	bh=0ewIVQW4q+NZ26MWbCFEjfxY40gQMUtwVXYdB3SoNqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpyGDekh+hGN5WnU3sGlOlSzOhvhIK/1ZlL7UQktUTCmxZAiF2caQIysJGq377lSB
	 5nRQXv3ui+LXb6zWA1gnrER+fWj17Y8l13T1YnlOok4ucsVo6BT1BBSTAXBfrqyA4c
	 /lylCA5Asjud9ggwVp614vTbpdDgB5Bce+ttseG0=
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
Subject: [PATCH 5.15 326/644] ASoC: core: Check for rtd == NULL in snd_soc_remove_pcm_runtime()
Date: Tue, 26 Aug 2025 13:06:57 +0200
Message-ID: <20250826110954.465534327@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1c4d8b96f77b..d28261ef1d4c 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -959,6 +959,9 @@ static int soc_dai_link_sanity_check(struct snd_soc_card *card,
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



