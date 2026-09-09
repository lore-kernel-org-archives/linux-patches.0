Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABB8549364;
	Wed,  9 Sep 2026 13:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962264; cv=none; b=tAMqH5Q8iajDYeGkbTbvbUYEURgNjbdEO7C0BhG6/PBUFWkMcPRyw6YWahPavBpLzDjEf/LonrECxb51tRE6nGRfgHq8ebfyJ/nPt2n21t3+UvRTMWacz71ab6lntC4FV9o+PlHiKp1lpU8dX+sxAxKtGJCe8RNZ9bgYYu27Awg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962264; c=relaxed/simple;
	bh=Ua4i/MA1E9wJNVQEUY+3QXq1HdIGMpgxc2cnWe6Oaoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoS87oxruedegejMk5B/GGZKcVt3cdEKrpkVthHuGwPkkWkyi00WMzF+k8HGjg0V/gncVmkeyoEuVgA+miUsRfuOB3iE74ICOYYarCR0My91vF26obCGNs/U7ahah7f0Yjx3fNp2pwe6Gh9EC1X693uaR8aCi/1oemGPTSH6HpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iD9KkYWd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iD9KkYWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76F71F00A3A;
	Wed,  9 Sep 2026 13:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962263;
	bh=kqdw2fJFbVrSTVXKKvRfBvK6ncT7fg6/kgku3fuNDeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iD9KkYWdtzzogwdGhgkdS34oq65lC4m7ru4wt0ofI2Jgo/kXNBsfQ8MGwTuRYnPFr
	 tWLThyT1CpSuq6FMmfGDawMQuAScCDAXPi0uZPsp7k8w6Vzn4ys+8bCx1YN52kKj1w
	 pH4ohv37wfVclcttRQNvUSKOWhFrJzO6/W8t8u1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 230/556] ASoC: max9860: sort the register default table
Date: Wed,  9 Sep 2026 15:38:30 +0200
Message-ID: <20260909134238.506655115@linuxfoundation.org>
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

commit 5c4cf173b7eba9bd1e8824b75380412cae2e026b upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

MAX9860_PWRMAN (0x10) is listed as the first entry, before
MAX9860_INTEN (0x02), which makes MAX9860_INTEN unreachable.
regcache_reg_needs_sync() then cannot compare it against its default and
reports that a sync is needed, so it is written to the device on every
regcache_sync() even when it was never touched.

Sort the table by register address.

Fixes: 3b2af7f79968 ("ASoC: max9860: new driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805122811.13713-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/max9860.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/max9860.c
+++ b/sound/soc/codecs/max9860.c
@@ -48,7 +48,6 @@ static int max9860_dvddio_event(struct n
 }
 
 static const struct reg_default max9860_reg_defaults[] = {
-	{ MAX9860_PWRMAN,       0x00 },
 	{ MAX9860_INTEN,        0x00 },
 	{ MAX9860_SYSCLK,       0x00 },
 	{ MAX9860_AUDIOCLKHIGH, 0x00 },
@@ -62,6 +61,7 @@ static const struct reg_default max9860_
 	{ MAX9860_MICGAIN,      0x00 },
 	{ MAX9860_MICADC,       0x00 },
 	{ MAX9860_NOISEGATE,    0x00 },
+	{ MAX9860_PWRMAN,       0x00 },
 };
 
 static bool max9860_readable(struct device *dev, unsigned int reg)


