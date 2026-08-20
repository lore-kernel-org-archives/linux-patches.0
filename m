Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EEA485502;
	Thu, 20 Aug 2026 17:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247350; cv=none; b=JGVRZlxPOCsUFUM2N00bHMmrYrlWqZhY4p5+RzqdnIx78t64yP3OjmNAfAE5jMkkwbJ7z/79o4PQ+TTncnwy3NDCt7oJHHB7CjEgW9SsVj9SYpxq6Sh5Wdb5Mjv2TFtBHutjvzZH1795Jmhvuv+sj0EcXfDRdNvt+A989jx9+2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247350; c=relaxed/simple;
	bh=fw+OHCGiT3CPESzY9xoROAi0SvkkteIAPIp8I7quoXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aID4z1ZtKc6yCZ62/LMAlv0ER4ibOJR2yhLojHoopplQgjyalkXB3AXNRK3R+H7GwbHdLiGeSZ4fadldLikfxkbmII0gypkM9E5esaNGcyV0L1MnRTOqFjqgOlY7D6wrG9BBF0Lp3d9ncOmAc71WmJXNOzJHxbHrgJKZHWZJs1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gi2TrKUa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gi2TrKUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD741F000E9;
	Thu, 20 Aug 2026 17:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247349;
	bh=MLRXi0N0hGX4fpPVSh/CgB6BpZKSbOGuRxzk/jn8L5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gi2TrKUaWCI+A/lrtW0jb8kyaZ/oVwHrXEcsc00b4a6cItUtRyOg69+oXZARddOVd
	 WZn+A3V3NRzE3H8CBdKQJf/KLn7dz1z6LeV7eWmrZEFUz+a/BeKt9wknU06/RdLRCE
	 JOEQpp+kIyFC5hbB+Eq66Mj3mqYoUqvIOS8IQuZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 016/166] ASoC: cs35l45: sort the register default table
Date: Thu, 20 Aug 2026 16:54:35 +0200
Message-ID: <20260820145211.678506920@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit f39a68ed08bb6eef0ae711b41d645ee5e9448c09 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

cs35l45_defaults[] lists the DSP1_RX*_RATE and DSP1_TX*_RATE registers
(0x02b80080 - 0x02b802b8) in the middle of the table, ahead of entries with
much lower addresses, so the binary search does not find 36 of its 73
entries.  regcache_reg_needs_sync() then cannot compare those against their
default and reports that a sync is needed, so they are written to the
device on every regcache_sync() even when they were never touched.

Sort the table by register address.

Fixes: 74b14e2850a3 ("ASoC: cs35l45: DSP Support")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260805082413.26174-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs35l45-tables.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/sound/soc/codecs/cs35l45-tables.c
+++ b/sound/soc/codecs/cs35l45-tables.c
@@ -66,22 +66,6 @@ static const struct reg_default cs35l45_
 	{ CS35L45_ASPTX3_INPUT,			0x00000020 },
 	{ CS35L45_ASPTX4_INPUT,			0x00000028 },
 	{ CS35L45_ASPTX5_INPUT,			0x00000048 },
-	{ CS35L45_DSP1_RX1_RATE,		0x00000001 },
-	{ CS35L45_DSP1_RX2_RATE,		0x00000001 },
-	{ CS35L45_DSP1_RX3_RATE,		0x00000001 },
-	{ CS35L45_DSP1_RX4_RATE,		0x00000001 },
-	{ CS35L45_DSP1_RX5_RATE,		0x00000001 },
-	{ CS35L45_DSP1_RX6_RATE,		0x00000001 },
-	{ CS35L45_DSP1_RX7_RATE,		0x00000001 },
-	{ CS35L45_DSP1_RX8_RATE,		0x00000001 },
-	{ CS35L45_DSP1_TX1_RATE,		0x00000001 },
-	{ CS35L45_DSP1_TX2_RATE,		0x00000001 },
-	{ CS35L45_DSP1_TX3_RATE,		0x00000001 },
-	{ CS35L45_DSP1_TX4_RATE,		0x00000001 },
-	{ CS35L45_DSP1_TX5_RATE,		0x00000001 },
-	{ CS35L45_DSP1_TX6_RATE,		0x00000001 },
-	{ CS35L45_DSP1_TX7_RATE,		0x00000001 },
-	{ CS35L45_DSP1_TX8_RATE,		0x00000001 },
 	{ CS35L45_DSP1RX1_INPUT,		0x00000008 },
 	{ CS35L45_DSP1RX2_INPUT,		0x00000009 },
 	{ CS35L45_DSP1RX3_INPUT,		0x00000018 },
@@ -113,6 +97,22 @@ static const struct reg_default cs35l45_
 	{ CS35L45_GPIO1_CTRL1,			0x81000001 },
 	{ CS35L45_GPIO2_CTRL1,			0x81000001 },
 	{ CS35L45_GPIO3_CTRL1,			0x81000001 },
+	{ CS35L45_DSP1_RX1_RATE,		0x00000001 },
+	{ CS35L45_DSP1_RX2_RATE,		0x00000001 },
+	{ CS35L45_DSP1_RX3_RATE,		0x00000001 },
+	{ CS35L45_DSP1_RX4_RATE,		0x00000001 },
+	{ CS35L45_DSP1_RX5_RATE,		0x00000001 },
+	{ CS35L45_DSP1_RX6_RATE,		0x00000001 },
+	{ CS35L45_DSP1_RX7_RATE,		0x00000001 },
+	{ CS35L45_DSP1_RX8_RATE,		0x00000001 },
+	{ CS35L45_DSP1_TX1_RATE,		0x00000001 },
+	{ CS35L45_DSP1_TX2_RATE,		0x00000001 },
+	{ CS35L45_DSP1_TX3_RATE,		0x00000001 },
+	{ CS35L45_DSP1_TX4_RATE,		0x00000001 },
+	{ CS35L45_DSP1_TX5_RATE,		0x00000001 },
+	{ CS35L45_DSP1_TX6_RATE,		0x00000001 },
+	{ CS35L45_DSP1_TX7_RATE,		0x00000001 },
+	{ CS35L45_DSP1_TX8_RATE,		0x00000001 },
 };
 
 static bool cs35l45_readable_reg(struct device *dev, unsigned int reg)


