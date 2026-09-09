Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFC5572699;
	Wed,  9 Sep 2026 14:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963855; cv=none; b=lFEEwJ4y8rzNn8cX0DikTMO2vQoWjLVrd19PJVeDdVm556rf1t06Vui5y2xQ7xufxqW04pnL9ApyLMAViUOM3dt+diMXo3ccH8f6jieNtJ/zvpGOBSUAMaP9RMBQHKCMAfQG8EbGR8DuAi+fmGQY2I98XoLe41JCStzbpyCuvhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963855; c=relaxed/simple;
	bh=3qpgulQtCaR6fi/+ms1mnwmL6a3gb45ci7l1YdghEXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNY/haRvAeSydI7MkUzgyU/4pyd5DBhlNjUK/8OPnoNLj/20wroRzp1NZ1feGhtQPj5u2jSI/n/gAs2cZnbYFdnMV54UxK4yXsigM/Edwhm08h77QU2DP+RxkqKcoTIXfuPPP6zqzl3GHXQPG4NY+RQrc2Rk1oPydYErm4zZjwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sdCJLgO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sdCJLgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213EC1F00A3A;
	Wed,  9 Sep 2026 14:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963854;
	bh=xqAQKLmOqoa76NzGrfHwVi+pSYKcnwjuOZ2+1eB3xyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1sdCJLgOk5y8gWW8508tUhYNI3pHcpCxTlSoNCrURzaH5+R/7wJ2GXn+PT0vLsZYQ
	 jux5PIS6pi8mcf4CmLNnYqekToCKkj/GkOucnZQpvCcm5K42QlthBQbcgLfcld2dg3
	 s8A9/YHA4R58DRewY6VJ6IisNqjjQuCc+2YTJHtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 175/583] ASoC: rt1318: sort the register default table
Date: Wed,  9 Sep 2026 15:37:40 +0200
Message-ID: <20260909134244.255980324@linuxfoundation.org>
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

commit 2a8e4b7114f6493314348bda7e3d2141d218ef61 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

The 0xdd93 and 0xdd94 entries are listed after 0xddc8 in rt1318_reg[],
which leaves them unreachable for the binary search.
regcache_reg_needs_sync() then cannot compare them against their default
and reports that a sync is needed, so they are written to the device on
every regcache_sync() even when they were never touched.

Sort the table by register address.

Fixes: fe1ff61487ac ("ASoC: rt1318: Add RT1318 audio amplifier driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-17-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt1318.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/rt1318.c
+++ b/sound/soc/codecs/rt1318.c
@@ -338,6 +338,8 @@ static const struct reg_default rt1318_r
 	{ 0xdd08, 0x40 },
 	{ 0xdd12, 0x00 },
 	{ 0xdd35, 0x00 },
+	{ 0xdd93, 0x00 },
+	{ 0xdd94, 0x64 },
 	{ 0xddb5, 0x00 },
 	{ 0xddb6, 0x40 },
 	{ 0xddb7, 0x00 },
@@ -346,8 +348,6 @@ static const struct reg_default rt1318_r
 	{ 0xddc6, 0x00 },
 	{ 0xddc7, 0x00 },
 	{ 0xddc8, 0x00 },
-	{ 0xdd93, 0x00 },
-	{ 0xdd94, 0x64 },
 	{ 0xdf00, 0x00 },
 	{ 0xdf5f, 0x00 },
 	{ 0xdf60, 0x00 },


