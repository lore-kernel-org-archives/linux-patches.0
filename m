Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D4C581255;
	Wed,  9 Sep 2026 14:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963873; cv=none; b=h9M4H6CLYiqfXFNavXPCqB4pIyf5ZvgWn0MLSCDd/HiJ+hahVipSXDZEkEHv7oCQohC8Smmigsz2PlCPmS6SVlbo/3TnUXhiakGVv0RGF7u6xEfyJy0EIze3YCGDHIO/G2WKPf+FyNfYhYKuOxemCSAQTUJ65GDPrcdXXvPoxCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963873; c=relaxed/simple;
	bh=lFm0gAvy5prVg7RCGJnKWEVZyovmP/WXyi7V2LiC3DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYd5dImmNnaev8EQtu3nznmi/j6NbIf9aa2jRwv/KD+iN7akOdptt9om1LLYlWiEBUYo3LEud8UEhGpNsQA+NalVd3Rx8EjPSTpNI7I94y+JpfBsyq8n9qJkz7WzWCSeLXMFA9OF+89BYkLDeipkL931ByaEcvy28uZsdsagAuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTeLUTpU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTeLUTpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C451F00A3A;
	Wed,  9 Sep 2026 14:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963871;
	bh=Js3I/HdKrquZu8TUp23WycZ55Q8J243PQ6w+eYZifW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTeLUTpUnLo7j+wNHOdFGXOvbToSV8eM+AjvVePv2fzGGSFHLbsc2gtf6A/qkH4XE
	 bp/iby3KVzH+zQC04MEMyux3qyM/G+7SlJl9RYuigIkNvSbjFfEjPmsx5oLrS/NFiL
	 kUeNMoYGLkz/IQ+I6W94y1RwP7cU51vYgd4WNQR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 178/583] ASoC: rt298: sort the register default table
Date: Wed,  9 Sep 2026 15:37:43 +0200
Message-ID: <20260909134244.354678353@linuxfoundation.org>
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

commit aa4c472b0f4a469c2e4599406fa4cff9de3e02bd upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

Four entries were appended to the end of rt298_reg[] instead of being
inserted at their sorted position and the 0x01470100 entry is listed after
0x01470c00, which leaves 7 of the 39 entries unreachable for the binary
search.  regcache_reg_needs_sync() then cannot compare them against their
default and reports that a sync is needed, so they are written to the
device on every regcache_sync() even when they were never touched.

Sort the table by register address.

Fixes: 6adcafae6ed2 ("ASoC: add rt298 codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt298.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/sound/soc/codecs/rt298.c
+++ b/sound/soc/codecs/rt298.c
@@ -78,8 +78,10 @@ static const struct reg_default rt298_re
 	{ 0x0023a000, 0x0000007f },
 	{ 0x00270500, 0x00000400 },
 	{ 0x00370500, 0x00000400 },
+	{ 0x00830000, 0x000000c3 },
 	{ 0x00870500, 0x00000400 },
 	{ 0x00920000, 0x00000031 },
+	{ 0x00930000, 0x000000c3 },
 	{ 0x00935000, 0x000000c3 },
 	{ 0x00936000, 0x000000c3 },
 	{ 0x00970500, 0x00000400 },
@@ -89,16 +91,18 @@ static const struct reg_default rt298_re
 	{ 0x00c37000, 0x00000000 },
 	{ 0x00c37100, 0x00000080 },
 	{ 0x01270500, 0x00000400 },
+	{ 0x01270700, 0x00000000 },
 	{ 0x01370500, 0x00000400 },
 	{ 0x01371f00, 0x411111f0 },
 	{ 0x01439000, 0x00000080 },
 	{ 0x0143a000, 0x00000080 },
-	{ 0x01470700, 0x00000000 },
+	{ 0x01470100, 0x00000000 },
 	{ 0x01470500, 0x00000400 },
+	{ 0x01470700, 0x00000000 },
 	{ 0x01470c00, 0x00000000 },
-	{ 0x01470100, 0x00000000 },
 	{ 0x01837000, 0x00000000 },
 	{ 0x01870500, 0x00000400 },
+	{ 0x01870700, 0x00000020 },
 	{ 0x02050000, 0x00000000 },
 	{ 0x02139000, 0x00000080 },
 	{ 0x0213a000, 0x00000080 },
@@ -107,10 +111,6 @@ static const struct reg_default rt298_re
 	{ 0x02170700, 0x00000000 },
 	{ 0x02270100, 0x00000000 },
 	{ 0x02370100, 0x00000000 },
-	{ 0x01870700, 0x00000020 },
-	{ 0x00830000, 0x000000c3 },
-	{ 0x00930000, 0x000000c3 },
-	{ 0x01270700, 0x00000000 },
 };
 
 static bool rt298_volatile_register(struct device *dev, unsigned int reg)


