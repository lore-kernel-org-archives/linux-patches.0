Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238763EDE5B;
	Tue, 12 May 2026 18:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608951; cv=none; b=oKfE/Cy2ptuSaIjSnilodRRw4Mg+mtilLyK7ShLWQEfcAMHhAlDMwePSsAvEKKtZfq09VST7CrlephdGVG4S8kEj3LquDzFgxDSuRbASISUQblkTch6WJggvgMzc7cK2KOventzyCu5L72hzdohGMJCfyx1OzrpSiOn0+Tejto8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608951; c=relaxed/simple;
	bh=vNAE4b7rdRfv3cl4W4Lcl7gBOg94/RlVSDMp93oBTFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1bij+XJtEUGusnTPBaaifsBPyxBnR8DmQP2X+PhM3W90bu2vvCvO2FStv4chjyStzd+jFU8/sgjH5kE7Lk6E2O/ZCtdcPXGvHg/+wHsjWPQDyOnrJ07PPtwK0PakO2V5YTK6EidB2q4YRgPiHO/3Jh2ihz3KLXDcn/EsesONF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDUMaBpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDUMaBpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA6BC2BCF6;
	Tue, 12 May 2026 18:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608951;
	bh=vNAE4b7rdRfv3cl4W4Lcl7gBOg94/RlVSDMp93oBTFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDUMaBpHIMQMz0DIyErdUP2VYR+A1rpW6eHtXZgUMEUg0CfyhWxseoue6KSKR6hIg
	 BShgrWFkzMUJZoAo0Wa0/GuhH1eziIt0C+vyCmqkqzGfu324aRZ/xixs5HyO0i6Lyb
	 uFDuh7O+Dj9kvaqTmURspQL3sk9RV/JRc5avWdL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 254/270] mmc: core: Adjust MDT beyond 2025
Date: Tue, 12 May 2026 19:40:55 +0200
Message-ID: <20260512173943.791246311@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avri Altman <avri.altman@sandisk.com>

[ Upstream commit 3e487a634bc019166e452ea276f7522710eda9f4 ]

JEDEC JESD84-B51B which was released in September 2025, increases the
manufacturing year limit for eMMC devices. The eMMC manufacturing year
is stored in a 4-bit field in the CID register. Originally, it covered
1997–2012. Later, with EXT_CSD_REV=8, it was extended up to 2025. Now,
with EXT_CSD_REV=9, the range is rolled over by another 16 years, up to
2038.

The mapping is as follows:
cid[8..11] | rev ≤ 4 | 8 ≥ rev > 4 | rev > 8
---------------------------------------------
0          | 1997    | 2013        | 2029
1          | 1998    | 2014        | 2030
2          | 1999    | 2015        | 2031
3          | 2000    | 2016        | 2032
4          | 2001    | 2017        | 2033
5          | 2002    | 2018        | 2034
6          | 2003    | 2019        | 2035
7          | 2004    | 2020        | 2036
8          | 2005    | 2021        | 2037
9          | 2006    | 2022        | 2038
10         | 2007    | 2023        |
11         | 2008    | 2024        |
12         | 2009    | 2025        |
13         | 2010    |             | 2026
14         | 2011    |             | 2027
15         | 2012    |             | 2028

Signed-off-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: d6bf2e64dec8 ("mmc: core: Optimize time for secure erase/trim for some Kingston eMMCs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/mmc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -671,7 +671,14 @@ static int mmc_decode_ext_csd(struct mmc
 		card->ext_csd.enhanced_rpmb_supported =
 					(card->ext_csd.rel_param &
 					 EXT_CSD_WR_REL_PARAM_EN_RPMB_REL_WR);
+
+		if (card->ext_csd.rev >= 9) {
+			/* Adjust production date as per JEDEC JESD84-B51B September 2025 */
+			if (card->cid.year < 2023)
+				card->cid.year += 16;
+		}
 	}
+
 out:
 	return err;
 }


