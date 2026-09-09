Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C33756510E;
	Wed,  9 Sep 2026 13:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962250; cv=none; b=U0J3UITV73defjOiLJ4uTJjgANFVYZxRFNdIhvf4FqO9/E2peDn92NFRErU5aL+AqXmY/Z3udpU/ilkqsDMPhUfB0KbtVuqkTfDYPHXHMwD2PBsW5tU+zO2S3eGwO1Fl07Ac/3tCh6Z2RI9u5c+d9l7eBhDbVjOM3BpzwZ1Y7nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962250; c=relaxed/simple;
	bh=tToeqD5FXB5J0dCfYhwjvoeP8IOrZEnTcbi37qdyPdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+ZK4CgTZaxVgKY2yYR5f86mMOG9vJy8eF0QXJ4E53rhk7Vo+hqpI37Ge2T5UotTlJ9GZEU3f0VT4FXF8K+DVzqjO9goN7uUFvALpqai2LrQWcYxCXe1TpQHe4ScWU26e29No/IqBOjQk81A4a4JGiEhdi05R9IE5R7aitDNPjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7Xv1rt+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7Xv1rt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6484D1F00A3A;
	Wed,  9 Sep 2026 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962248;
	bh=fReWxWf6slKcJ4bu1bvbYtL+wTjxVWsSFrV19xns9dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7Xv1rt+ZNOI6LnWgKgCINpwYO/fZc9zg4giNAZLmn9eiLXJYZNRQsIyVkCGjyLU2
	 VsHeA3ynsRD7ulC0pY+TT92Bhe4uZwlcIeV74bLvidUmiHjq2T0l/L9cQv/3r7JNHd
	 JIX+NKYk7LRaQCv5cYwrzIui1UWNy+bg9r5l3iUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 226/556] ASoC: fsl_easrc: sort the register default table
Date: Wed,  9 Sep 2026 15:38:26 +0200
Message-ID: <20260909134238.358941704@linuxfoundation.org>
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

commit 84c5d79aebe6c45e12e3112d14e68972f33c210a upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

The four REG_EASRC_RRL() entries are listed as a block before the four
REG_EASRC_RRH() ones, but the two registers of a context alternate in
the address map (RRL(n) at 0x110 + 8 * n, RRH(n) at 0x114 + 8 * n).
This leaves REG_EASRC_RRL(1), REG_EASRC_RRL(2) and REG_EASRC_RRL(3)
unreachable.  regcache_reg_needs_sync() then cannot compare them against
their default and reports that a sync is needed, so they are written to
the device on every regcache_sync() even when they were never touched.

Sort the table by register address.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805122728.12362-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_easrc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -1711,12 +1711,12 @@ static const struct reg_default fsl_easr
 	{REG_EASRC_SFS(2),	0x00000000},
 	{REG_EASRC_SFS(3),	0x00000000},
 	{REG_EASRC_RRL(0),	0x00000000},
-	{REG_EASRC_RRL(1),	0x00000000},
-	{REG_EASRC_RRL(2),	0x00000000},
-	{REG_EASRC_RRL(3),	0x00000000},
 	{REG_EASRC_RRH(0),	0x00000000},
+	{REG_EASRC_RRL(1),	0x00000000},
 	{REG_EASRC_RRH(1),	0x00000000},
+	{REG_EASRC_RRL(2),	0x00000000},
 	{REG_EASRC_RRH(2),	0x00000000},
+	{REG_EASRC_RRL(3),	0x00000000},
 	{REG_EASRC_RRH(3),	0x00000000},
 	{REG_EASRC_RUC(0),	0x00000000},
 	{REG_EASRC_RUC(1),	0x00000000},


