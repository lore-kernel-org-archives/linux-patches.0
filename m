Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9A81E8347;
	Wed, 19 Feb 2025 09:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956962; cv=none; b=m7SquLW/hMzhgq6AM4SdzlIh0lgfv1z5IvTtlbdfBODine5pV3CYgPeBPKorK21UXPDk1iCVT3j9lvR9ZSqNqqz32undqDb8zW1IAez3FhP/OTDdT431NY0JGWHsMZF3cfC1votSfI/ZDvaHHviXmYachYxdcU60Qmlv/Rp8DQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956962; c=relaxed/simple;
	bh=03Oz6mn37S696V6f2zGlb/Z+Uymj/Y8CZCTlSiVAWvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfLdY7wW1+lz19uUPj1FXW6nUZdrWO6rm+EwRLHxgbuvBHJ4AVb0MLlq2+xjP/8i35YKi4VL49qSSzz/RFR8qN/kqFdHE3qrzofjbrQeUNmcSgm7EucM/5bumuHK/+4rVdkW9Sxo2HYSKVBpMut+c3j5VlJ+XTeJPvzROwsR1zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9foE1yT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9foE1yT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B625C4CED1;
	Wed, 19 Feb 2025 09:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956962;
	bh=03Oz6mn37S696V6f2zGlb/Z+Uymj/Y8CZCTlSiVAWvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9foE1yTDfkx4bBqjcyvtu+7qmdwAmKc5vmFcGQmrsQEQKXsIGQY/cQFSCIXA/4Vn
	 K9lPSnax8hGvqg5cyOMSXOdKYJsugFcaZ0XpSPej5b053cf5MyQ7pv1M7mcphomImi
	 upBBDYgqp3ooAL37hzOaYxowRobxvDv90ozmuyG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 361/578] clk: qcom: clk-rpmh: prevent integer overflow in recalc_rate
Date: Wed, 19 Feb 2025 09:26:05 +0100
Message-ID: <20250219082707.220312172@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -332,7 +332,7 @@ static unsigned long clk_rpmh_bcm_recalc
 {
 	struct clk_rpmh *c = to_clk_rpmh(hw);
 
-	return c->aggr_state * c->unit;
+	return (unsigned long)c->aggr_state * c->unit;
 }
 
 static const struct clk_ops clk_rpmh_bcm_ops = {


