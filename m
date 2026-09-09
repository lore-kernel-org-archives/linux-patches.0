Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC90566C6B;
	Wed,  9 Sep 2026 13:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962379; cv=none; b=vA+XNtkO/rlKTUDI514dFNIknvwgJqsp6ATBlZnY0zIvtlOvRKzyv2rtSzdB5ZOYADgPESMS/zQjER+2mE15ARHPYntjZjZA0ZwfXku0jwXH3Tj/KgScSV0MfMzz2RmPWCZcUcxN+E037uhj+6ruEKXdZUj4xHCOMRatlwWFvf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962379; c=relaxed/simple;
	bh=0tzJxRID5WWufbQikmuRY8JlcId3i74NPtKpb5zgGec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxiMW4muO+40aiuW+PM/+3smvGTq/K83RvAm+0egaw2dqR/KDLBLgD9nVHr/K7xK/bQy5i5J1J3NHyBVgxKE9Al9IFeJii22t3qlXUrgWO7wEoIGLlZRjmze24tEBoSV67DrgyFXil442Ku1imuSAQdAjrpGJ6HdQ8fKh8k8Alc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEu7rotA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEu7rotA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88761F00A3A;
	Wed,  9 Sep 2026 13:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962378;
	bh=0pyV1WfSEMIlr9kkb9t9GIUxnqUHFuYxSOeHtioZjEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEu7rotAgv/Dd0QHbjjzLLLisi7jX4LyI8uhEZj+O2yWnTvikNJKoQpQffxuwOSp/
	 Mm/K6YKr3c41m/AxmebxIEV9zLy58OTXLJ7FxikY0OOEejtPQ6aN7Q8Ipnfsz8krZS
	 8WfGWXWpVS50H08ABT980LSE7/u3MaRVcSiD3+6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 253/556] ASoC: sti-sas: sort the register default table
Date: Wed,  9 Sep 2026 15:38:53 +0200
Message-ID: <20260909134239.395881279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit bbd73fb224caa1badfe2aa338fe9c9dcf40a6e96 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

STIH407_AUDIO_DAC_CTRL (0xa8) is listed before
STIH407_AUDIO_GLUE_CTRL (0xa4), which makes the latter unreachable.
regcache_reg_needs_sync() then cannot compare it against its default and
reports that a sync is needed, so it is written to the device on every
regcache_sync() even when it was never touched.

Sort the table by register address.

Fixes: 165a57a3df02 ("ASoC: sti-sas: clean legacy in sti-sas")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805122811.13713-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/sti-sas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/sti-sas.c
+++ b/sound/soc/codecs/sti-sas.c
@@ -44,8 +44,8 @@ enum {
 };
 
 static const struct reg_default stih407_sas_reg_defaults[] = {
-	{ STIH407_AUDIO_DAC_CTRL, 0x000000000 },
 	{ STIH407_AUDIO_GLUE_CTRL, 0x00000040 },
+	{ STIH407_AUDIO_DAC_CTRL, 0x000000000 },
 };
 
 struct sti_dac_audio {


