Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B816125E82A;
	Tue, 11 Mar 2025 15:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706866; cv=none; b=LkMPiYNRQbmDa+bPh+se+EHA0AwXFcgqQ/AYKjDzjnE63ZOchosRTJMndExHMW1JCRu2Crh47wCPte+8EipnGfW1NG44SZvR4xcQ47bbJ1hTNFdMOKQye5+mLTHF50z/8nZyBFNnX7tJ5ixAnM6k6iW3OPjltkBQaF/LXVvRZJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706866; c=relaxed/simple;
	bh=/m5TVBmgCqooMZfTvwm0j4+iCoIA33s9VvNHLyR3WyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azTCE6sxIJaXzFXQl57hyiTuEs4IoI2EAfk+LHsATM6bkCT30hu95p3v9KDmuqwISqEcfl9EqTh1XX78EBEIFSdRaT/M+O61+/hckyA0tiFZanK/g1gZi3IHpSqFOtLG5pvXCKCPpQpJ0Utq+TE2hap/VDMmY8I8KIh4GH2jfjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmiU53e3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmiU53e3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E38C4CEE9;
	Tue, 11 Mar 2025 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706866;
	bh=/m5TVBmgCqooMZfTvwm0j4+iCoIA33s9VvNHLyR3WyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmiU53e3cytkh7JD1859+U+ZSxYAamAk9Vu7ftRjvVcNri18sLS04XA3wrywsp5gR
	 l16ysMCBkWUMV/y9GH3SE3fFB0TiR+oYor35qoA1ckFNU9p14FLDt4DLxr8qUvb+HV
	 IhCtUfkCyWO5Y+OEN0WYr+I5cYuZ7Dk3RAUem2EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 177/462] clk: qcom: clk-rpmh: prevent integer overflow in recalc_rate
Date: Tue, 11 Mar 2025 15:57:23 +0100
Message-ID: <20250311145805.345214320@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


