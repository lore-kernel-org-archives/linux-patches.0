Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39228F58;
	Mon,  4 Mar 2024 21:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588356; cv=none; b=LC6QCm74cQtXYjF0Ad0TCVhcAmi9edQv7Kpmjlw8MG682zZZkBqhVTlCjqwGr9rwNXzFVdTjUkjiMriQ7v8OWHLmYlgWtcDUD2zWrDIIVE13867zDL7PCyBuiRf51oS6jugVcPGGoEeBk9DV97SmQwRbI2xSSvhPxfVKFb/Se00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588356; c=relaxed/simple;
	bh=3fXWEsksbaaSGt6s/yFqUsXkU4YVbnp3naDSpLdPu7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6qy3ayVDM+D1cDYEoraDvZpMF69cmpg4xwxIlJNF4wcse1O80R0O4QC5SZVVmas42gAG5J4EsUVidnJUhLFAblGSQXlP3VRhsI8TCuz33ASILqHaILyLgp3RlhFof6mzIsLmEXqjCIRbx+wz8J00yVL6hAVBL+rizU9mWWbG+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfPBbu8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfPBbu8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76121C433C7;
	Mon,  4 Mar 2024 21:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588355;
	bh=3fXWEsksbaaSGt6s/yFqUsXkU4YVbnp3naDSpLdPu7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BfPBbu8PyYse/6FRVrKmFdm6BdJvTlpLFlTM0Yowe+mfitST7WbX8QY1GYmmcfkJj
	 Ouwx/MCFZOCIHrR33Q6QN1n8m/9+LYMKUx/qK8A4kXxZSZxiDuZmkM77MZOfxx+5Do
	 VqtmM01dBkPmotB8JdYqmS11QKV4uHNonJ9UtD+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/143] ASoC: cs35l56: cs35l56_component_remove() must clean up wm_adsp
Date: Mon,  4 Mar 2024 21:22:51 +0000
Message-ID: <20240304211551.562481391@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit cd38ccbecdace1469b4e0cfb3ddeec72a3fad226 ]

cs35l56_component_remove() must call wm_adsp_power_down() and
wm_adsp2_component_remove().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: e49611252900 ("ASoC: cs35l56: Add driver for Cirrus Logic CS35L56")
Link: https://msgid.link/r/20240129162737.497-5-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index e850f906f1079..1d0a2948f533b 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -810,6 +810,11 @@ static void cs35l56_component_remove(struct snd_soc_component *component)
 
 	cancel_work_sync(&cs35l56->dsp_work);
 
+	if (cs35l56->dsp.cs_dsp.booted)
+		wm_adsp_power_down(&cs35l56->dsp);
+
+	wm_adsp2_component_remove(&cs35l56->dsp, component);
+
 	cs35l56->component = NULL;
 }
 
-- 
2.43.0



