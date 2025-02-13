Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CF5139566;
	Thu, 13 Feb 2025 14:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457684; cv=none; b=p+4wVfBsIypdF2+JQ+NNRH9EuIrQgfgeMDuDprUexR2nbUNZGWUuZ0KTpBXXhvWmn5z53UZuRgzC0vbm+hqvpmkPHDSjG+q5QwycR+U/Qw99sqpfYuuzyK56ZwsJeq89MXWjkQb40qCpm+EWFe92O9aHTMOFnBVfc+OpylqQO2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457684; c=relaxed/simple;
	bh=QSPFqRnoXFCjypEKaVmAYk3eexkiJ54mXszmePG1bco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPAkcEAEljRRv97iqdtWgkEwg5OAKld4ws/qjjOksJBO3hrmDoflQvoG4FZqPCjGtfZhf5qKfxQzDpoykot5E66oUovIyCnBCWr865ypecHNRs3n4KyzuVz+hncj3I42xdFgSOk1NCvqPKZfWS6Epf1254/QJWtuCnbZJcict+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMeizPOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMeizPOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DBAC4CED1;
	Thu, 13 Feb 2025 14:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457684;
	bh=QSPFqRnoXFCjypEKaVmAYk3eexkiJ54mXszmePG1bco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMeizPOY7vJHtN1zlMTkv0vNLgCLiN5dLU9MUPvGGLPw5bR77IKxMORit4I7bK5/x
	 egBQITmMCShJVvkFvfV9mgM7Cy5eYqigBqzADgTJ3qEOEUanDPEd7Ak201+PRCJoSn
	 4whiHAMhKm4kEIRElO0D0mMLHZwzcLgEO7ZTCqy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 183/422] clk: qcom: clk-rpmh: prevent integer overflow in recalc_rate
Date: Thu, 13 Feb 2025 15:25:32 +0100
Message-ID: <20250213142443.608671682@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -329,7 +329,7 @@ static unsigned long clk_rpmh_bcm_recalc
 {
 	struct clk_rpmh *c = to_clk_rpmh(hw);
 
-	return c->aggr_state * c->unit;
+	return (unsigned long)c->aggr_state * c->unit;
 }
 
 static const struct clk_ops clk_rpmh_bcm_ops = {


