Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE85F3446C7;
	Tue, 12 May 2026 18:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609728; cv=none; b=DmwD1LdoF7xZ8XHcDd7iPAZ2W4F0HyfoYB+gwrrqKhNMN0kvxkCSJS+xjEOQlAPdTlvKTvI3vu1tTSneJEY1FUxO4N6ndHyjX5R/F7bKZqpByxGNYfUnDVT6Jvqi8Nl/LV2blDv8rm+XMJBVhHPPPC9m3oZmqt4jGiJXwmbP2vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609728; c=relaxed/simple;
	bh=yLbNwzRMSFp8+j4jxqj8mw8NJT0TeaRPnOVc195xb00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ob+/Bxbu50itMPO3vB8ydGpNKtT+adKOSvYzNGJ3wwGMtR0k/PNaODq2ydTcLKXyKdBRLcnf27hlheJ03u5GtrwcVPG23JHY2YS++JuDD9xK3x0v7f2vGQXhZb61epxYCTorG5k1TMMU+XTmWXp7TTmoVOo3LP+chZ49ay31bu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9sF9o/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9sF9o/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CB1C2BCF5;
	Tue, 12 May 2026 18:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609728;
	bh=yLbNwzRMSFp8+j4jxqj8mw8NJT0TeaRPnOVc195xb00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9sF9o/fLA4Sv/0oii08hVAYuu/K69bZUHmiWdFZTPI0pZZwls9h7yu8835AXTKXj
	 1tNSet0VWjtB4CxxBzEhTzBUh8OE7S2KmPoLwPJZO1Ay/9cesqQ8NoANWGjd9UWTLt
	 VqGBxNOx507wBw+9lBQoV6K99bVsX3cyMmdusSgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 293/307] mmc: core: Adjust MDT beyond 2025
Date: Tue, 12 May 2026 19:41:28 +0200
Message-ID: <20260512173946.309995645@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


