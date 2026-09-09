Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3AE550DC3;
	Wed,  9 Sep 2026 14:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963735; cv=none; b=B4PGcwl7YJXOCbzxKWRKItiv9gbujUVLFQkarCENZIhbvIbXRR6ejQSSm1riqBdoxVvt95zgLUzoD+I3R6YcdZHDWDqz3E9KhBep5YbEkw5Wf0LgVjjcQZV+iVntg/083N5EFXidYtFcN5x+TMcs26w+cFikoox17rSCfs2cNQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963735; c=relaxed/simple;
	bh=8hIWBEtRMRJ7Zl/NTJRtnkboxXUfIaZqrqY5Xfveok0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPK6z9TgIyPa/NPYyy+4kY8yQF7BSE7ibXXAAohDdZMj1ZmfpT9mfMHYGbD5s7H4tJP0HMTXxtjNj8L7evqqSY8fMOasY5M7FxZtycUlraqiRcZG/4oXM1VrGbLdREi8FGeNEeBNaE8p5cwSer37akG5WA/5M3x9cVITpLRvHN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzTeEBaD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzTeEBaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987BC1F00A3A;
	Wed,  9 Sep 2026 14:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963734;
	bh=nvOVzyaDq2jjlK48NTLiU3MzOqHkbYPs4aIqlEdK/Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzTeEBaDHP9HL5aSvuPrJQJ7Vy+ZaMDdxetKhrkKQzYjPm6jvB0NuyjlSatKu7PAf
	 ce5TuKgP2W5PhPugFmfFAZiqflUsWAl6jk8nfv89P6oVxR66OlWd4VSANDatLFLMxU
	 6XRx/h0af57HDXWHu6aGHEd8RBS0dV5FUe0MUEdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 182/583] ASoC: rt711: sort the register default table
Date: Wed,  9 Sep 2026 15:37:47 +0200
Message-ID: <20260909134244.487398516@linuxfoundation.org>
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

commit 55fe63530772fe95a99abe9497872975f3161a56 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

At the end of rt711_reg_defaults[] the 0x83xx entries are interleaved with
the 0x73xx entries they belong to, which leaves 5 of the 269 entries
unreachable for the binary search.  regcache_reg_needs_sync() then cannot
compare them against their default and reports that a sync is needed, so
they are written to the device on every regcache_sync() even when they were
never touched.

Sort the table by register address.

Fixes: 320b8b0d13b8 ("ASoC: rt711: add rt711 codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-7-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt711-sdw.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/soc/codecs/rt711-sdw.h
+++ b/sound/soc/codecs/rt711-sdw.h
@@ -256,16 +256,16 @@ static const struct reg_default rt711_re
 	{ 0x3122, 0x00 },
 	{ 0x3123, 0x00 },
 	{ 0x7303, 0x57 },
-	{ 0x8383, 0x57 },
 	{ 0x7308, 0x97 },
-	{ 0x8388, 0x97 },
 	{ 0x7309, 0x97 },
-	{ 0x8389, 0x97 },
 	{ 0x7312, 0x00 },
-	{ 0x8392, 0x00 },
 	{ 0x7313, 0x00 },
-	{ 0x8393, 0x00 },
 	{ 0x7319, 0x00 },
+	{ 0x8383, 0x57 },
+	{ 0x8388, 0x97 },
+	{ 0x8389, 0x97 },
+	{ 0x8392, 0x00 },
+	{ 0x8393, 0x00 },
 	{ 0x8399, 0x00 },
 	{ 0x752008, 0xa807 },
 	{ 0x752009, 0x1029 },


