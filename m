Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EAD321448;
	Mon, 18 Aug 2025 13:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523450; cv=none; b=WBu+VOxLEvP/PZyR0Zi1PWtWXx9v4Tos5+OcJKOAHKY3Nt9wrCXuBKKVm9/LMb9xv0i1qug+ZoSlfC53KeoYXnzRgnZYKuHgKNzL91RJ2177UAS+zdNf+wuqthPCxsU7SWQ+0qXKV0sM0oYljiv1flLNpQ2bQ/b1V84FooMZBjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523450; c=relaxed/simple;
	bh=X+Qu72bvhMfAG6+88mF72Lew9XpuNeZhY07NgBa5SIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pb+q7onXPmwyzg3wsEsoDQRlYqytq5htigSxMZs030h5A2vZB7YCt7XFhVO04vmDhZPpB4KDxFTSvokcqwU7XeWAGRIr97uwrNAV3IV2don0yHb1m+We999L9A1VjYM12jkwzUxiq+9FsM9rFrqmwIOLVTOVU25/a+ZSmXAAK4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvtEsiK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvtEsiK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398BEC4CEEB;
	Mon, 18 Aug 2025 13:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523449;
	bh=X+Qu72bvhMfAG6+88mF72Lew9XpuNeZhY07NgBa5SIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvtEsiK7n2Aidte9XQz9n4o763ooEVIIWZKYxCYC9mRPBfme2FTOtVu9u4VkYlhPL
	 eU7/vjdGZYjCpSssOO36iMauiuJRQGHtc/dEj9jPGSU4SRL6L31h+bVkemlYRnZRpX
	 EBgndM8H7atRB9ksXWC11/I/aKrtaHLdjuQ5OSnc=
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
Subject: [PATCH 6.15 174/515] ASoC: core: Check for rtd == NULL in snd_soc_remove_pcm_runtime()
Date: Mon, 18 Aug 2025 14:42:40 +0200
Message-ID: <20250818124505.061534456@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3f97d1f132c6..0db6db16f28b 100644
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



