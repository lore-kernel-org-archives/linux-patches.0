Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0D536122;
	Sat,  3 Feb 2024 04:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933600; cv=none; b=rO6LQhlhfFQ0hHm6N6pTJlwsDSM5TULmay5RB2mTuGBfuTZ8AzP0d/CM/0HEGGP/OBmRHGTUvkH8NLAjZ+XDlSJxSQZ14ZNmxJYbMf6jeqyAG2W2M8YYKO1u9J3rVR16Xdf/V9JrFR8axEXmHnp4fmv9dn/5VClbXIUB9GdSOtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933600; c=relaxed/simple;
	bh=ZilyjS7LYK1jQSgzdeTgT+eJpBeXOz2TzM8jF/UfqRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrZq1v7zJu9WRhG6FiHnmsjYnxKRJ4RNKtXm0kQ4yHXE9KOdw6eo8a+YKO+2PboP4F/VgH89L7C7ght1KhmH34+iSHM+v7j+7MM8r+ZNWnV9C1+khuytzNt6RNn87O93WLvWhdOEp4SX8dZuwXy7IlwnbfSYMEWp+c6qVvCorUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2jsJrWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2jsJrWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115EDC433F1;
	Sat,  3 Feb 2024 04:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933600;
	bh=ZilyjS7LYK1jQSgzdeTgT+eJpBeXOz2TzM8jF/UfqRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2jsJrWgYURt6wXO/JGJqdtxeDxk9dZbSy7fjF53C9k7IrBPGNEVoYHATTyT133Sn
	 RLIJThIheseDNTXzgnwTb+GBjC/BikScit9kqLyCfSCR+K1o7ynZYI5X1W1WK/QBzE
	 mAVOKvJtiwT6y0K9P1Iy/w3wKQyaoBnkzNw2VCJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Ilya Bakoulin <ilya.bakoulin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/322] drm/amd/display: Fix MST PBN/X.Y value calculations
Date: Fri,  2 Feb 2024 20:04:25 -0800
Message-ID: <20240203035404.663969146@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Bakoulin <ilya.bakoulin@amd.com>

[ Upstream commit 94bbf802efd0a8f13147d6664af6e653637340a8 ]

Changing PBN calculation to be more in line with spec. We don't need to
inflate PBN_NATIVE value by the 1.006 margin, since that is already
taken care of in the get_pbn_per_slot function.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Ilya Bakoulin <ilya.bakoulin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
index a96f0747628c..b9768cd9b8a0 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -1059,18 +1059,21 @@ static struct fixed31_32 get_pbn_from_bw_in_kbps(uint64_t kbps)
 	uint32_t denominator = 1;
 
 	/*
-	 * margin 5300ppm + 300ppm ~ 0.6% as per spec, factor is 1.006
+	 * The 1.006 factor (margin 5300ppm + 300ppm ~ 0.6% as per spec) is not
+	 * required when determining PBN/time slot utilization on the link between
+	 * us and the branch, since that overhead is already accounted for in
+	 * the get_pbn_per_slot function.
+	 *
 	 * The unit of 54/64Mbytes/sec is an arbitrary unit chosen based on
 	 * common multiplier to render an integer PBN for all link rate/lane
 	 * counts combinations
 	 * calculate
-	 * peak_kbps *= (1006/1000)
 	 * peak_kbps *= (64/54)
-	 * peak_kbps *= 8    convert to bytes
+	 * peak_kbps /= (8 * 1000) convert to bytes
 	 */
 
-	numerator = 64 * PEAK_FACTOR_X1000;
-	denominator = 54 * 8 * 1000 * 1000;
+	numerator = 64;
+	denominator = 54 * 8 * 1000;
 	kbps *= numerator;
 	peak_kbps = dc_fixpt_from_fraction(kbps, denominator);
 
-- 
2.43.0



