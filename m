Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F66374E5A;
	Thu, 20 Aug 2026 16:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243344; cv=none; b=nkcnzfdXYi5C2eWTpVnw1CWtP67hUAuPjwrdFBUwLJN1orkfER3BdqGeVeEUMWvLZ4//hvIWBz6AbcLvq2ZDZtKlUzeN8IW+7JtqJ7BmrvI7VDMSTo3ZGsP2MQ0kXF4EkUTsVaOgWa+WFpALof5505dTDQjV6Mqpopu+Plg/bMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243344; c=relaxed/simple;
	bh=BgEFw1xNczDPgCXiaV/2iz0bnoPrWn+X6VCQuEoTjiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoNf22we9QwxUmIqt6Z7rE6/08AAGhS1Fe8a4WQjd/gIlev6fig93byKsA7GdBDq2cn5ClSBoDPyTkFDWegwPmTyXDrcpCX+7c+vAyY/92td5BEG3T5Bg8zLNZLhkumCbvCOKQI3oM+vABDpfLrIPgOQNEq7h4bFErgHrjrpP4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ktvy4TIz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ktvy4TIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4831F000E9;
	Thu, 20 Aug 2026 16:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243343;
	bh=49SQTz+/XVZKSW31lvEiG4Iwkdbu0wW7C1uuvm6qWiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ktvy4TIzeJAIZACPv+SNwN+zJgk1tJVWfueHbNfYNWq8SXHvad1I+g3m37PBw4cWb
	 6ikx1eYPVW2czWYYPPKqfRVU8/CjRcmvEZj5SH/UOmWZKlRL/qWY27iIJWtdr346vp
	 voJJ+NwxoX8qxXMUeQ0VXu6AFvLeJglt214/VowE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/272] ALSA: hda: Fix cached processing coefficient verbs
Date: Thu, 20 Aug 2026 16:54:05 +0200
Message-ID: <20260820145233.124846696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit f67be28fdf8b5d31ac1cc1152bb17250f9f8f513 ]

Intel HD Audio defines Coefficient Index and Processing Coefficient as
separate audio widget controls in the Audio Widget Verb Definitions:
Coefficient Index selects the coefficient slot, while Processing
Coefficient accesses the value at the selected slot.

hda_reg_read_coef() selects the slot with AC_VERB_SET_COEF_INDEX, but
then uses AC_VERB_GET_COEF_INDEX for the value read.  That reads back the
selected index instead of the coefficient value.  hda_reg_write_coef()
has the same issue and builds the value write from AC_VERB_GET_COEF_INDEX
instead of AC_VERB_SET_PROC_COEF.

This only affects the regmap coefficient cache path used by codecs that
set codec->cache_coef.  Direct coefficient helpers already use the normal
SET_COEF_INDEX followed by GET_PROC_COEF or SET_PROC_COEF sequence, which
is likely why this has not been noticed widely.

Use AC_VERB_GET_PROC_COEF for cached coefficient reads and
AC_VERB_SET_PROC_COEF for cached coefficient writes.

Fixes: 40ba66a702b8 ("ALSA: hda - Add cache support for COEF read/write")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/DB9023BF2920BA99+20260707132419.1731342-1-raoxu@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/hdac_regmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/hda/hdac_regmap.c
+++ b/sound/hda/hdac_regmap.c
@@ -215,7 +215,7 @@ static int hda_reg_read_coef(struct hdac
 	err = snd_hdac_exec_verb(codec, verb, 0, NULL);
 	if (err < 0)
 		return err;
-	verb = (reg & ~0xfffff) | (AC_VERB_GET_COEF_INDEX << 8);
+	verb = (reg & ~0xfffff) | (AC_VERB_GET_PROC_COEF << 8);
 	return snd_hdac_exec_verb(codec, verb, 0, val);
 }
 
@@ -233,7 +233,7 @@ static int hda_reg_write_coef(struct hda
 	err = snd_hdac_exec_verb(codec, verb, 0, NULL);
 	if (err < 0)
 		return err;
-	verb = (reg & ~0xfffff) | (AC_VERB_GET_COEF_INDEX << 8) |
+	verb = (reg & ~0xfffff) | (AC_VERB_SET_PROC_COEF << 8) |
 		(val & 0xffff);
 	return snd_hdac_exec_verb(codec, verb, 0, NULL);
 }


