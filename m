Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB9735BDAA;
	Thu, 30 Jul 2026 15:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426726; cv=none; b=qaAIq2o2imxcjPxGL/M90EIe2+K7y1YLHKVidWOuOfLnZeDbD2iBqovV+LWlKlAFgObzL9rFtGX2XHsWcNrKUhgCSNMEoN6cWos064IbUQpY5ogPVsFgvkhtH8HM2hfCIqVXTXKtjS8mpbVLLYH6/2PNzCALAeCCs04xK755qU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426726; c=relaxed/simple;
	bh=o6lcuGuicZkfaZgQKhjzkj6YoLTi8uJe1c0r0T7s+es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxqb4//9iDJVy5sBSpOYvQLvLpMfBqgP8ZAcb2erBsjQW5ZoFd0+ynae5HlqEVDWvN/xWokmaflF62JLkNfeWwle5XvCgOHBIib9mAGoovaNSm8XfXkgL2DcqucMTuKI4XJXMVDoHfQQN7qFYWxHms6dsktSeFDC07VOhoswoRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYTSnkS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYTSnkS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9D21F00A3A;
	Thu, 30 Jul 2026 15:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426724;
	bh=KT9U5ajps3AknO8VhiqAQCMiwmJKyoxrcIbN6HihhvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iYTSnkS1jCLOX+wRWmNUzrS24Ozgj/DmF0FCYLAJ8U8nwJ07SMz6mYe/zk6CeWCQx
	 mvNexSIqUfKD/n444i2AJ2dkUCDQOuGoM/8pnphXrhZBgCuMpc9MOf7y1mbRt7glGY
	 VtaL6UEIGLSfv++AFxDl17YpOnjFBwRJnvKMMw64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 476/602] ALSA: hda: Fix cached processing coefficient verbs
Date: Thu, 30 Jul 2026 16:14:28 +0200
Message-ID: <20260730141445.966313376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -214,7 +214,7 @@ static int hda_reg_read_coef(struct hdac
 	err = snd_hdac_exec_verb(codec, verb, 0, NULL);
 	if (err < 0)
 		return err;
-	verb = (reg & ~0xfffff) | (AC_VERB_GET_COEF_INDEX << 8);
+	verb = (reg & ~0xfffff) | (AC_VERB_GET_PROC_COEF << 8);
 	return snd_hdac_exec_verb(codec, verb, 0, val);
 }
 
@@ -232,7 +232,7 @@ static int hda_reg_write_coef(struct hda
 	err = snd_hdac_exec_verb(codec, verb, 0, NULL);
 	if (err < 0)
 		return err;
-	verb = (reg & ~0xfffff) | (AC_VERB_GET_COEF_INDEX << 8) |
+	verb = (reg & ~0xfffff) | (AC_VERB_SET_PROC_COEF << 8) |
 		(val & 0xffff);
 	return snd_hdac_exec_verb(codec, verb, 0, NULL);
 }


