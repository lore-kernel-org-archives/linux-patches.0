Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095441C3BEB;
	Tue, 11 Mar 2025 15:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705709; cv=none; b=GBweWGtUU4A/j+jLo/x+bbUnMM35bmjVWG4FEvjK9Wxrf2c5pXVHPhJ9R+peoFk0p6GekB5iPzEMm4y5deT/EDQbISKB3JDczP8OSFLbaCa4NZshU9irlejDYgNBkL2lMaVvCB9Xt0hatuq6oB9wcF1RV5eK8OO3nidk0SfruFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705709; c=relaxed/simple;
	bh=nRuouzaw6vt0p0HwlNRV+AlYvvbvnMp0wlCI2ksfCAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOU+gNFO2Qt9k0o4xRRFVLUQ8yDQiF4qwtdXr/GT2fWkmL9jBqG3EQYFokaLXqCwMixZC8wZzGA9VVPNoFJL/gl8N8aVMbjQsQNEgCBODkB5bQSPhkoRH3rDOZ46QcfGmieOFcUZpaOooxtzM9JdY3cdY77u6jAbbZVKYGvUEAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXIyFY/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXIyFY/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAA5C4CEE9;
	Tue, 11 Mar 2025 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705708;
	bh=nRuouzaw6vt0p0HwlNRV+AlYvvbvnMp0wlCI2ksfCAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXIyFY/QT/rd246Z5rQu7VPFBFQxCP5TuhEAlf4JaZeVJk8lrd6EvA95q6s1b2Y8U
	 YuQgXN1SfO0VpsK9ptCHh0Tj+RGK3JQpksbCue7yfrZtHvyIY27W+nNOCXcFPUFj0X
	 gw/LWxtOzQEEEmdanySIYEma/olbbTIRPxbAwfkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.4 128/328] clk: qcom: clk-rpmh: prevent integer overflow in recalc_rate
Date: Tue, 11 Mar 2025 15:58:18 +0100
Message-ID: <20250311145719.991403558@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


