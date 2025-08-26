Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF871A00F0;
	Tue, 26 Aug 2025 12:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212928; cv=none; b=XxKwpDgT5h3pcUDMJ35qnmgHJ+3sJBHxwvya2TvRr9qygNsc1QFUR2tee3eVOasA2giQYrnUn7U0AHtw0PGEjQYKN89hcsjDWLBZabVE4PdnxEslfCrcsjdl0kGbb17cbD1N/YdbeiAuyhVnb4bWXkjWk3xvJG/gvpab67DbQMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212928; c=relaxed/simple;
	bh=kS+pKd4+tD9opOmQggITggADeqUtgGzq1FalZbnN9zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyRLGJ0sVbu+XBHlCcCbLJnitUfi5qmlRZZMw7/TZiJ33REAbw1qscwCq+VBe/3BXqEMw1AO7f4MB3Qv1CvK0PTUoVXgIdaaGcPX4S9Lz1Eo5W5k0fj8J8x1aGL7xUSI9Cr8NSyXLRL9BqbuDTFcOWvhMl2QCLZyLbNl8BLlSDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRD7PQD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRD7PQD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D71C4CEF1;
	Tue, 26 Aug 2025 12:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212927;
	bh=kS+pKd4+tD9opOmQggITggADeqUtgGzq1FalZbnN9zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BRD7PQD4KvLzqLSK68kUjhSjQdxzpaZG+DjiOS5ceXJ+b/CWsWrOAW/GEf8cNci7O
	 oQhacJhABy1UEaoKViTIsJzv2Txl3deQWyiaq6OHpY/JzOORbT/C8eFyEx1D2Nx9Qs
	 /NjaftMd6u748gzb/me7sI7mAOtoBUgFzpMecI7Y=
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
Subject: [PATCH 6.6 125/587] ASoC: core: Check for rtd == NULL in snd_soc_remove_pcm_runtime()
Date: Tue, 26 Aug 2025 13:04:34 +0200
Message-ID: <20250826110956.134924685@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7eea70eea68b..dc95b6f41555 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1025,6 +1025,9 @@ static int soc_dai_link_sanity_check(struct snd_soc_card *card,
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



