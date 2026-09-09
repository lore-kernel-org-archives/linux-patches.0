Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169445678C1;
	Wed,  9 Sep 2026 13:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962326; cv=none; b=KRRmHISiaEquSyqMLPTZfLJCAYZfGBF5C4JzK++NP3/G7IEFEDhhHYaXeyXsOmIqkcCEjiMh43V4awRNRS0hr8dd1dWSFtRqjHmp5ioA20P+CM616YQ65HiAxLwZKGOXs6KGPZNnz4/QtwupNj+6qsIaO08xffCUBHRxV8RzQWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962326; c=relaxed/simple;
	bh=/pMwdNqXHNy8yZOG9UkJWNGqNhbt7RTi5pVoK6KRGSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LecJqnntCHK9eL9PmVH0imn1A5G+Znlc20YPlXUzqR+ofPiWEZCdiQ0XHbBAJ9cQd9OCmhOGmEQj/TylfqPMklr5QPhtDvxLr2vln/L00OIEIwTM5TObdOauQsKapedWSM0BTNmcsPKgBP2BhCjN/nuoMrS5MTpIebtmiGt6/E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9regXs4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9regXs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9911F00A3A;
	Wed,  9 Sep 2026 13:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962323;
	bh=EpFc18eQNIxquHQ44+BWBtuQETVQCc5VF6vbHTxNcG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9regXs4F4Z1yL60kEaB3DT60G7akx1nG1pXx3bRcAKcphzjgh0m9WGCfoRm6buCx
	 FHAkTToXY5dovoF9vZ7vxTPfcqzSyhYWNRKg0bP1uO5W0+nZ43GAR64VepF3xKemPr
	 pY+n31Gka9oL2xMhivO/YNDUYGLYyJIhrx6XWMKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 249/556] ASoC: rt715: sort the register default table
Date: Wed,  9 Sep 2026 15:38:49 +0200
Message-ID: <20260909134239.239017332@linuxfoundation.org>
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

commit d729804a92dc4e74b8fb69da162f74660ea64385 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

At the end of rt715_reg_defaults[] the 0x82xx and 0x83xx entries are
interleaved with the 0x72xx and 0x73xx entries they belong to, and 0x385e
is listed before 0x3859.  This leaves 25 of the 323 entries unreachable for
the binary search.  regcache_reg_needs_sync() then cannot compare them
against their default and reports that a sync is needed, so they are
written to the device on every regcache_sync() even when they were never
touched.

Sort the table by register address.

Fixes: d1ede0641b05 ("ASoC: rt715: add RT715 codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-11-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt715-sdw.h |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/sound/soc/codecs/rt715-sdw.h
+++ b/sound/soc/codecs/rt715-sdw.h
@@ -281,8 +281,8 @@ static const struct reg_default rt715_re
 	{ 0x371b, 0x00 },
 	{ 0x371d, 0x00 },
 	{ 0x3729, 0x00 },
-	{ 0x385e, 0x00 },
 	{ 0x3859, 0x00 },
+	{ 0x385e, 0x00 },
 	{ 0x4c12, 0x411111f0 },
 	{ 0x4c13, 0x411111f0 },
 	{ 0x4c1d, 0x411111f0 },
@@ -300,36 +300,36 @@ static const struct reg_default rt715_re
 	{ 0x4f1d, 0x411111f0 },
 	{ 0x4f29, 0x411111f0 },
 	{ 0x7207, 0x00 },
-	{ 0x8287, 0x00 },
 	{ 0x7208, 0x00 },
-	{ 0x8288, 0x00 },
 	{ 0x7209, 0x00 },
-	{ 0x8289, 0x00 },
 	{ 0x7227, 0x00 },
-	{ 0x82a7, 0x00 },
 	{ 0x7307, 0x97 },
-	{ 0x8387, 0x97 },
 	{ 0x7308, 0x97 },
-	{ 0x8388, 0x97 },
 	{ 0x7309, 0x97 },
-	{ 0x8389, 0x97 },
 	{ 0x7312, 0x00 },
-	{ 0x8392, 0x00 },
 	{ 0x7313, 0x00 },
-	{ 0x8393, 0x00 },
 	{ 0x7318, 0x00 },
-	{ 0x8398, 0x00 },
 	{ 0x7319, 0x00 },
-	{ 0x8399, 0x00 },
 	{ 0x731a, 0x00 },
-	{ 0x839a, 0x00 },
 	{ 0x731b, 0x00 },
-	{ 0x839b, 0x00 },
 	{ 0x731d, 0x00 },
-	{ 0x839d, 0x00 },
 	{ 0x7327, 0x97 },
-	{ 0x83a7, 0x97 },
 	{ 0x7329, 0x00 },
+	{ 0x8287, 0x00 },
+	{ 0x8288, 0x00 },
+	{ 0x8289, 0x00 },
+	{ 0x82a7, 0x00 },
+	{ 0x8387, 0x97 },
+	{ 0x8388, 0x97 },
+	{ 0x8389, 0x97 },
+	{ 0x8392, 0x00 },
+	{ 0x8393, 0x00 },
+	{ 0x8398, 0x00 },
+	{ 0x8399, 0x00 },
+	{ 0x839a, 0x00 },
+	{ 0x839b, 0x00 },
+	{ 0x839d, 0x00 },
+	{ 0x83a7, 0x97 },
 	{ 0x83a9, 0x00 },
 	{ 0x752039, 0xa500 },
 };


