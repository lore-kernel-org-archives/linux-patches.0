Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479467868F;
	Mon,  4 Mar 2024 21:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587693; cv=none; b=KpEcLl82YI4FtYMN9HGLXlJgBjqYQqklfw4Ma2CgnzUKUUkaXVM7Levtt1rxdOcTZfGCaRTVJvB6Fem+igo8PcOdYWEaMpRfHeEqRAbReUOrmURUrtLoL9uIXzrWfY4bQM3ZRHPhp3s7HVU0xUqddkzRBUPsZvH2v5fnvCc/4s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587693; c=relaxed/simple;
	bh=AUWTc7BI5lXOb7jv1k8ukISmwwG+l+xAssiC1fpoblw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkWbM4CIIPvYd5jtMXibAqoSTv1wrOJQRG6EaaZTX3CJeIGLkhcS95KQl/VgTQQjGxIKNgAf+MAfe1rBuaLHf6PdFjgrPo8z/5s5rcQ1sw6iSbf4J1y4Td1l13X2eabo2epWIvONkNJV2K0qobU1ce5xlN5c/Dk/qBdK2r5w0Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3t/aufc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3t/aufc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAE3C433F1;
	Mon,  4 Mar 2024 21:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587693;
	bh=AUWTc7BI5lXOb7jv1k8ukISmwwG+l+xAssiC1fpoblw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3t/aufc0kjoeGnfvmvJ621eP4FAiHmxOJSQVYPY47kHBUIO1anRYpu6rfbdLsMPn
	 i+QVtBqePrDePl9OmTgArUo1hQY3OTExFpOOABZc8e2xjFxFZ3/ohUeK8X5QVmTmLK
	 5wRoJi/tq7u7jJw6q5O9WnbczzmhmFbH9wNJKEA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 054/162] ASoC: cs35l56: cs35l56_component_remove() must clean up wm_adsp
Date: Mon,  4 Mar 2024 21:21:59 +0000
Message-ID: <20240304211553.584061918@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit cd38ccbecdace1469b4e0cfb3ddeec72a3fad226 ]

cs35l56_component_remove() must call wm_adsp_power_down() and
wm_adsp2_component_remove().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: e49611252900 ("ASoC: cs35l56: Add driver for Cirrus Logic CS35L56")
Link: https://msgid.link/r/20240129162737.497-5-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: eba2eb2495f4 ("ASoC: soc-card: Fix missing locking in snd_soc_card_get_kcontrol()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 09944db4db30d..491da77112c34 100644
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



