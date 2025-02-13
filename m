Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E036726B089;
	Thu, 13 Feb 2025 15:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459370; cv=none; b=p6WrWDn7VVZzpSSaQ9mG0pjQJ2RaDJ9fHVxxVOmLMf1N463m22mbUCa0Ue3q62OCJQNXHdbEEN9mTiLRUs977YVLjHfPeKys890YdJQpP0cm+nxw6QehTtgG+pWUkIPy/gdc6DfxoYkfDd+26GE50GVGTmB14lZ0y+/PaPAT4iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459370; c=relaxed/simple;
	bh=9bWCdEFVR0qzKSUSBK3au+nmaPghvsEXKmLTz1MLiNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXgw7ch7ZuO5wQPOlgQqreuSKVEe2yOWo06spqYjJFAmUAiPPd2Vt8RZ1g3vYGUcZh1MtXfLMoTS3DjBSR0kEP0adSA/FlWsh3mSvmM1knm+IqrbzITXeokjhPRZTsSj3Csmfpq1p9/aWjnhS1bcS9PJdIk54E1NsVoi3OrA8eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANJqGw0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANJqGw0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4B9C4CED1;
	Thu, 13 Feb 2025 15:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459369;
	bh=9bWCdEFVR0qzKSUSBK3au+nmaPghvsEXKmLTz1MLiNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANJqGw0GvjCIPl4X3CCE4gqGjir5Hahx7MeVpH9BTfUxOiZ7IjvGumw46FCHwBeyW
	 AZbpGI6kpYqG+98ST6wWW2/cd3DwTKRSem4ktinc5RbKEIw4SArt0dkHaJLt2UY94x
	 h8beMFbBWU1fYWHK+A4wr/V4+PlaSI0S6RcEmJ90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 203/443] clk: qcom: clk-rpmh: prevent integer overflow in recalc_rate
Date: Thu, 13 Feb 2025 15:26:08 +0100
Message-ID: <20250213142448.445308416@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


