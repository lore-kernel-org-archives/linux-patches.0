Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919EC19AD59;
	Tue, 16 Jul 2024 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145443; cv=none; b=SCW8kyt67QxdSBs+7QIeQBcmVxfe2ECHoiQ0uRdVO4bBjUp7/DWKj54UuHCCvfhH1FLSekUnuHLzpYubPIaNp4IDkgeLcXtSg7nQTJn0jd8huhq5STAk3baB3aaqvD5Rnk9MYXP6tA7GOID460KoqMIMwklAwi2tUec9FFHjLkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145443; c=relaxed/simple;
	bh=BH7o3pCorBeF61N8QPkys9VHOMBHL8wS3fjVp6Y29oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCW8ejzN9yw0C4Q9Ur6AMi3BUSch/HROLABYzp67xKlFWSB55+4/V5PbGjJ9nmAYE9gB4Tu3JXV+KRXwnvZ8TEi1K50hM4zftYc97CtNkytuzZsmflvhIc7+35AHrv7gM8rjPREPDy6LIXloCnB+HF6no2Cy/hyf3/GuQHuzHI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ek6nt4sm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ek6nt4sm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A10DC116B1;
	Tue, 16 Jul 2024 15:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145443;
	bh=BH7o3pCorBeF61N8QPkys9VHOMBHL8wS3fjVp6Y29oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ek6nt4smAjFrLRnjqAEhlaxzUHSp6ZrFHruhijRJsntIvn+NakdowTF+x8wT2MLrJ
	 HYXurON9xTp+yR+NFu9UB+O1OIk++Tx6kBNoIx3k/qTBSAWIWv7y2tdEifSEuLAxji
	 zIADxz3JQUcTs9/I4O8vcS/1R6uESdza9cMegrG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 35/96] firmware: cs_dsp: Use strnlen() on name fields in V1 wmfw files
Date: Tue, 16 Jul 2024 17:31:46 +0200
Message-ID: <20240716152747.863005446@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 680e126ec0400f6daecf0510c5bb97a55779ff03 ]

Use strnlen() instead of strlen() on the algorithm and coefficient name
string arrays in V1 wmfw files.

In V1 wmfw files the name is a NUL-terminated string in a fixed-size
array. cs_dsp should protect against overrunning the array if the NUL
terminator is missing.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: f6bc909e7673 ("firmware: cs_dsp: add driver to support firmware loading on Cirrus Logic DSPs")
Link: https://patch.msgid.link/20240708144855.385332-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index eb6caeba6cdc3..ee4c32669607f 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1089,7 +1089,7 @@ static int cs_dsp_coeff_parse_alg(struct cs_dsp *dsp,
 
 		blk->id = le32_to_cpu(raw->id);
 		blk->name = raw->name;
-		blk->name_len = strlen(raw->name);
+		blk->name_len = strnlen(raw->name, ARRAY_SIZE(raw->name));
 		blk->ncoeff = le32_to_cpu(raw->ncoeff);
 
 		pos = sizeof(*raw);
@@ -1165,7 +1165,7 @@ static int cs_dsp_coeff_parse_coeff(struct cs_dsp *dsp,
 			return -EOVERFLOW;
 
 		blk->name = raw->name;
-		blk->name_len = strlen(raw->name);
+		blk->name_len = strnlen(raw->name, ARRAY_SIZE(raw->name));
 		blk->ctl_type = le16_to_cpu(raw->ctl_type);
 		blk->flags = le16_to_cpu(raw->flags);
 		blk->len = le32_to_cpu(raw->len);
-- 
2.43.0



