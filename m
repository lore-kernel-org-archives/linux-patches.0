Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A0B324B0A;
	Fri,  7 Aug 2026 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116741; cv=none; b=PTEG+y4/7zzA5wXTcvYIB92i7iOvo1vWwBS4WQNOpOzYmDLZlDuPM6rusjwfXjq+93W5y0zGJVQgHdEIxhYncoxBAxTFEOqQQUXSW9UAe47xXxCDDYYEJL5bKzNSeafUC4NdvdBje7anKJ3/7MPfxMMOojAnaKQ8xawM8aWV1FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116741; c=relaxed/simple;
	bh=Gg0YMt2KJMrbwXwuRgnRzujhjSYBKWdxHn8XYgkOMUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bT7DkXVcVdOlt3WDiVC3dh4Rbc9fA8ww3Bx2V3wSX4TSpqK/8U30KDOFz779NSv1d08CmSuZ2q4y6a1lSFl3RBAKXCCTbXSDF2WKH9uaxTCMMCiu4pHpao+xMt1DJRXPGAqe1v+juJZCcjF8FvnLjP1vW3OJY5Lp69OcHhyKGr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/2+HbT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/2+HbT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E44C1F000E9;
	Fri,  7 Aug 2026 15:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116740;
	bh=5GgYfhpwMGR2sXC1WNcGSNM61CVLbyQmv7wYTvTABAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/2+HbT4igcZyKgl2JwN3XkhkEAONKlX1U7Y8DQfj/d80f4xV8N3xKzqK+8Ht5t9f
	 DTqnfvyajdLwGIcZEzxcLrXV5XqoohZXsgxQeVzynP/wYlz0AcBapT34AknsqP4SED
	 YvAGoBnOZ/gO4ZjZqm3qd++lwSpr3ol4R9LWIBQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 067/438] ASoC: SDCA: Ensure that Control Range is large enough for header
Date: Fri,  7 Aug 2026 16:34:23 +0200
Message-ID: <20260807143429.417264724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 951e921b039b793bef7050eaf5c5fb1a4a5341d1 ]

When reading the Ranges structure from an SDCA Control, ensure that the
read data is large enough to encompass the required header before
accessing it.

Fixes: 64fb5af1d1bb ("ASoC: SDCA: Add parsing for Control range structures")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260722103500.872714-5-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_functions.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sdca/sdca_functions.c b/sound/soc/sdca/sdca_functions.c
index 196bade11ab5d..ecc372a397573 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -847,6 +847,8 @@ static int find_sdca_control_range(struct device *dev,
 		return 0;
 	else if (num_range < 0)
 		return num_range;
+	else if (num_range < 2 * sizeof(*limits))
+		return -EINVAL;
 
 	range_list = devm_kcalloc(dev, num_range, sizeof(*range_list), GFP_KERNEL);
 	if (!range_list)
-- 
2.53.0



