Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA505678C1;
	Wed,  9 Sep 2026 13:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962284; cv=none; b=WTavI+Hll76e/S5iBeF0uOESfECRJqrGOFv0rIJ6CU9sCqSmNkyKyTINnAmrhwi4vBs3Q+Ig8VH4d19pWTP+IK6aygsP3rpcCczKlwVdFSLk6rIZ1pfXqNsQnQcNxLSKOsAxGnLvnMYJFMuc/xldNsYqplVSuSupFBlWjvNYOh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962284; c=relaxed/simple;
	bh=DniDYX2Ni4n5OMBH+TyMhV6XvY/J4IdJvbh0jryM0bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ntfj/0TuKubT5J5s3Jjo1vbigjjQ4nfsZhx0Owe4jTjjnjPAQ3j0U9sU5edDQRciYlnvZRtILsdvdfcfplWAauF28FuH79wvfrcdMZKSg/TR89WLpn/GhJxxDVHQMFlJ7LtfchD+qSK/IwUTmYa9/ThypzDv6uFlseteivYhd6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pe9WFp0D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pe9WFp0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62091F00A3A;
	Wed,  9 Sep 2026 13:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962283;
	bh=SOockEfIaDANHadKm5rnhP4NWkP+LV2jNz1KtuHuR30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pe9WFp0DrIJLt7Ilx7sveP55Psa887nmLSSh4JvSSgF1rmpVgTKqEkvle50/Tvj2l
	 2uFYuEdymsVvtjOfHLen+qHIh643Wzgyyrh0QlYemyJMc+Qch7/Z28oQUiE0c2wAl+
	 ZfMjxJRfvSi0aJkjNiRVfI8V6hA8HKpJd0bG83MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 237/556] ASoC: rt1318: sort the register default table
Date: Wed,  9 Sep 2026 15:38:37 +0200
Message-ID: <20260909134238.749034478@linuxfoundation.org>
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
@@ -337,6 +337,8 @@ static const struct reg_default rt1318_r
 	{ 0xdd08, 0x40 },
 	{ 0xdd12, 0x00 },
 	{ 0xdd35, 0x00 },
+	{ 0xdd93, 0x00 },
+	{ 0xdd94, 0x64 },
 	{ 0xddb5, 0x00 },
 	{ 0xddb6, 0x40 },
 	{ 0xddb7, 0x00 },
@@ -345,8 +347,6 @@ static const struct reg_default rt1318_r
 	{ 0xddc6, 0x00 },
 	{ 0xddc7, 0x00 },
 	{ 0xddc8, 0x00 },
-	{ 0xdd93, 0x00 },
-	{ 0xdd94, 0x64 },
 	{ 0xdf00, 0x00 },
 	{ 0xdf5f, 0x00 },
 	{ 0xdf60, 0x00 },


