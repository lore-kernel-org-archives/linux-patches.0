Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145DD468C2C;
	Wed,  9 Sep 2026 14:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963766; cv=none; b=nR/oA7cA55PYgBmxaZG/XXhHbDzgfdR59eKf8pZwW0CyQmETRwZDxghZyvqUgwruBelZboJFxUMte+WO0DKVt6nAYE8cWqB+zhyLk1oR3iZuPgusSdCglTHzJvzXT0hD5iG2dgNWZ/WGOyfCy9nHs2jotTsLmcdtp59kD4/PcCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963766; c=relaxed/simple;
	bh=eqHR95bvFjMqx+zQnuS3/xvxnAE/gu+ot2wPceImcyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A83jfDjidOpoCDJbPAJg0miVPIKq026pLKEnqqNXGjQYn1tOvFF2zZyXWEN4cowjliNhCAxWnspmPYAeWvf5eCkHJfyyPXtkqOgPzu/rzidNDXESoapmLDIPuUmJE/KpCMjLEO+Nge+u0OAACxhmrbrFbLKvTYwIcl4XuJGV3nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJwiDkIF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJwiDkIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AF21F00A3A;
	Wed,  9 Sep 2026 14:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963764;
	bh=4Xla2fYlS78N4V/potW/HKuhyyBtRcWa0fdwJWLHqVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJwiDkIF5zhss9E/ZeMMpsJw7zU/JrWcNY5P8s9whSV19bEags+VdKjFDmQYWtvBw
	 AI8pHi4wrY9Qexe36ZIqC3OTXZKFpZT6xpf9xtdF7n3LjHDpQbR/rqE7I54gIX/i4R
	 04iB9TDCJcc8YU4rQryhoWX902mcTJiaCSi9cR8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 191/583] ASoC: sti-sas: sort the register default table
Date: Wed,  9 Sep 2026 15:37:56 +0200
Message-ID: <20260909134244.787985353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


