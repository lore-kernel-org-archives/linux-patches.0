Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E621F2D023;
	Mon, 10 Mar 2025 17:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629369; cv=none; b=aCu2hrn43qiEWeBGDe+8P5m3C5L43aIDUMyIWA5TkHTsLC1pA8TRStMOjp65DiQrO8EljdEzTiLv2bPGJY9P7QCYB3Cpo8U+YMi9WkUcaOH0vkCqGfBSqpzJYqhmgJmgmMxXDDMdwrtGzp40ohTehutl4hWeSgE0PMBt2kR2AQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629369; c=relaxed/simple;
	bh=wwn5oHQXTMkg+Ctaabaay6Id9L4hCiiLAS3BwjzFi5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRDFgb5UzS/f9ktiLH21HowDR1Yd9H4+3KlcWG45i7IRIvsYO5Td4beIPmcrBp4kbmkbKvNAdLM1Md3DgCbBTdQPadTTea/z2W6FHHwogCCj+TZNy0yI1385xbMxmyiNT3EvPikvW+hU5v2EOd/yS6F6p9Q8t+KFNtFmU0ZL4Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZLAquVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZLAquVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8D4C4CEE5;
	Mon, 10 Mar 2025 17:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629368;
	bh=wwn5oHQXTMkg+Ctaabaay6Id9L4hCiiLAS3BwjzFi5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZLAquVNDQ900mtkfyEhfcdPyZkmgPG9PyDHIZ+WQ8BwxkgU2s15YXBUfIEbYbJkb
	 ShATHxNJ2Jzics0ZATEFApHo+DSvXoXtCVuHtq2qsCS1zLeY09ru/w3eGEfpqHCQsX
	 I5VdfvbTVna3tjVpZknGK7ngTctBkFa2K/8z9Fsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 270/620] clk: qcom: clk-rpmh: prevent integer overflow in recalc_rate
Date: Mon, 10 Mar 2025 18:01:56 +0100
Message-ID: <20250310170556.277895741@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anastasia Belova <abelova@astralinux.ru>

commit 89aa5925d201b90a48416784831916ca203658f9 upstream.

aggr_state and unit fields are u32. The result of their
multiplication may not fit in this type.

Add explicit casting to prevent overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 04053f4d23a4 ("clk: qcom: clk-rpmh: Add IPA clock support")
Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Link: https://lore.kernel.org/r/20241203084231.6001-1-abelova@astralinux.ru
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-rpmh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -331,7 +331,7 @@ static unsigned long clk_rpmh_bcm_recalc
 {
 	struct clk_rpmh *c = to_clk_rpmh(hw);
 
-	return c->aggr_state * c->unit;
+	return (unsigned long)c->aggr_state * c->unit;
 }
 
 static const struct clk_ops clk_rpmh_bcm_ops = {


