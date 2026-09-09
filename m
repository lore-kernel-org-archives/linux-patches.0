Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7EF4C6803;
	Wed,  9 Sep 2026 13:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962276; cv=none; b=LZAcNLWEVZopCirCL1qZR6/IipJLxojYpWi93AjHayVT2Z+An00RYc5shSa/6FcKBWcQEKnQpD8QFyDsIeG24luUPw//3O5yJ5lqmj8XLeUVrOJH+cFWGy898keUf+AOPLJARJ+9HrTa306lTbC7MT6S4vrGd9PxVkZhNSbR49o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962276; c=relaxed/simple;
	bh=bblBuxREtF0r/LoSxoEU1EnIku4dR+NfNU5DzZ48mXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAkV2YM/h4VG0waQpjma9nKUai8SAB8CX11rVXPtMI3Cec95+85rV6kmTAyE0BBuR+xgBXZi1aVzxmo3aMKrxf6VGo6qcheQVne5oyA+tj8sd5jyBeESC0UI0Co78Yr61BByBAnVdp2bJHGlgj/NVXkoQggiQEiOJAOz2NgDn7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYp3AjO2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYp3AjO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289491F00A3A;
	Wed,  9 Sep 2026 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962274;
	bh=m2JKjh/nPcwF/2M7Y0tuSn9FUpHYh2HVidzmLBE7FcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CYp3AjO2ORGCbH38gucMegLAmtgK6m4aMg9h2XXSJZ1OpUvo9s5D/D38/eWv8CVIb
	 0SjiGwjqw6LbStn6YXzQZGQya0Z+7SJTWRh4C3Ieqgf3X/91AFmYcLhoMsYIjhbXP6
	 GMFQXyLh4aRixoJuDD4FxOxetWqI/BBk0oeCc0E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 234/556] ASoC: rt1017-sdca-sdw: sort the register default table
Date: Wed,  9 Sep 2026 15:38:34 +0200
Message-ID: <20260909134238.642767400@linuxfoundation.org>
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

commit 5b48ce0356b134155722a61f7196516a7c2e66c5 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

rt1017_sdca_reg_defaults[] places the SDCA controls before the lower
vendor registers instead, so the binary search does not find 4 of its
entries.  regcache_reg_needs_sync() then cannot compare those against
their default and reports that a sync is needed, so they are written to
the device on every regcache_sync() even when they were never touched.

Sort the table by register address.

Fixes: 2b7aecd58528 ("ASoC: rt1017: Add RT1017 SDCA amplifier driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-15-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt1017-sdca-sdw.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/soc/codecs/rt1017-sdca-sdw.h
+++ b/sound/soc/codecs/rt1017-sdca-sdw.h
@@ -165,19 +165,19 @@ static const struct reg_default rt1017_s
 	{ 0xdb09, 0x0f },
 	{ 0xdb0a, 0xff },
 	{ 0xdb14, 0x00 },
-
-	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1017_SDCA_ENT_UDMPU21,
-			RT1017_SDCA_CTL_UDMPU_CLUSTER, 0), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1017_SDCA_ENT_FU,
 			RT1017_SDCA_CTL_FU_MUTE, 0x01), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1017_SDCA_ENT_XU22,
 			RT1017_SDCA_CTL_BYPASS, 0), 0x01 },
-	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1017_SDCA_ENT_CS21,
-			RT1017_SDCA_CTL_FS_INDEX, 0), 0x09 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1017_SDCA_ENT_PDE23,
 			RT1017_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1017_SDCA_ENT_PDE22,
 			RT1017_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
+
+	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1017_SDCA_ENT_UDMPU21,
+			RT1017_SDCA_CTL_UDMPU_CLUSTER, 0), 0x00 },
+	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1017_SDCA_ENT_CS21,
+			RT1017_SDCA_CTL_FS_INDEX, 0), 0x09 },
 };
 
 #endif /* __RT1017_SDW_H__ */


