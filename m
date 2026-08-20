Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A55485502;
	Thu, 20 Aug 2026 17:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247347; cv=none; b=aJDHZQG2owrKfvXNNv1rOALypRcP+JtLYqJIlzgt9bJgceWl74M5T4IPI+W93zJflnJh3zZiBLL6+W5k2d/sP8STl/B/aZtCACVQ8Cs8bNXsjU99DH2i3wXyeAPB96LpvxbLhm8gwa+OZLKuiEpAJNW2S7vVPwTFFmw+KGtp+bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247347; c=relaxed/simple;
	bh=J2itlDXkcEKl/g5Q26L/mu/RJ12EyDqVjupen1dTAW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2kYGcTAuYQznywiGm24ZIZWvdionsNkNaO2l1M5qdVAlgIZCcBMfhaKnjsLJqlrmMFO7TxCbrzOEx8u9MDrkyxN+YsiazjJmLSYrEwt5YO+fMDx7dbS35NxtbVq+eHlC15cJQj2Gn7QHzVYtZUIEiQ9U+irRTrE4LtqQwR3qe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TI44Htc7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TI44Htc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25031F000E9;
	Thu, 20 Aug 2026 17:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247346;
	bh=5oBF4zNvkKtE9BvpiBKqSEKyho0o8T7uGcXDN2pgXkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TI44Htc7O6RPU09Ey+PgiVXFvcebya2g9A2B5l0u3KA8LSrpDLAvp0++j/QZlcYr8
	 rDMcravXmW9D+lCMpfXt8XXoi9I9PaESx2tFSaOkCzFHW6R3gnbxggODNs9w5ZpN7N
	 kbxjf9HTQpJ9DI2nFrJOKrg+mmDauZaUHwZ9CMl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 015/166] ASoC: cs4265: sort the register default table
Date: Thu, 20 Aug 2026 16:54:34 +0200
Message-ID: <20260820145211.648836383@linuxfoundation.org>
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

commit e4fe3e046524e5de3c04c6eef3743780cbdc231c upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

cs4265_reg_defaults[] lists CS4265_INT_MASK (0x0e),
CS4265_STATUS_MODE_MSB (0x0f) and CS4265_STATUS_MODE_LSB (0x10) after
CS4265_SPDIF_CTL1 (0x11) and CS4265_SPDIF_CTL2 (0x12), so the binary search
does not find those three entries.  regcache_reg_needs_sync() then cannot
compare them against their default and reports that a sync is needed, so
they are written to the device on every regcache_sync() even when they were
never touched.

Sort the table by register address.

Fixes: fb6f806967f6 ("ASoC: Add support for the CS4265 CODEC")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260805082413.26174-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs4265.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/cs4265.c
+++ b/sound/soc/codecs/cs4265.c
@@ -46,11 +46,11 @@ static const struct reg_default cs4265_r
 	{ CS4265_DAC_CHA_VOL, 0x00 },
 	{ CS4265_DAC_CHB_VOL, 0x00 },
 	{ CS4265_DAC_CTL2, 0xC0 },
-	{ CS4265_SPDIF_CTL1, 0x00 },
-	{ CS4265_SPDIF_CTL2, 0x00 },
 	{ CS4265_INT_MASK, 0x00 },
 	{ CS4265_STATUS_MODE_MSB, 0x00 },
 	{ CS4265_STATUS_MODE_LSB, 0x00 },
+	{ CS4265_SPDIF_CTL1, 0x00 },
+	{ CS4265_SPDIF_CTL2, 0x00 },
 };
 
 static bool cs4265_readable_register(struct device *dev, unsigned int reg)


