Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DB614658D;
	Thu, 13 Feb 2025 15:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460438; cv=none; b=GM2J91o0IU30mlJWYCfvVtT4MoArxD9wsg+AX2JhOz7xbnWg/IW4dXVUJbBRmoEHKrR/J9eWolFoXPkj5HeAcukFFsVe9AeCsXQUFNMKwVeILVoU9quEyMATk2cVNkq7/tahuNVO+f3OpaPWGu+NL+hj0AetQVk/1m0C3MgVezw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460438; c=relaxed/simple;
	bh=2qn67VbYVKmoUeTGV/rKob5YNLB4BQqou6CE4fWacZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xk5w4FybAzVErJcKIOFdgzElwhIlQAlZdo0yjAlTzFGKmStIE3NmqykhyF/+zjGAUtqkFhv4U2neroIZOo8miEAW6t4QEfrI9/BOnDfa8wChPdph0D7wSdrC+OvQ5FqRGIujlzcj1miClb3x5gHIGYm4ucoO9GiZDw0smjiLYP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGQL5NVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGQL5NVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F5AC4CED1;
	Thu, 13 Feb 2025 15:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460438;
	bh=2qn67VbYVKmoUeTGV/rKob5YNLB4BQqou6CE4fWacZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGQL5NVkL5zT8Iz+H0xy/pyTeebpujGJhxgSZDo4KLE7S22jwy2oG7lcEx4ocdryv
	 sayTSZlDRhlt++/hdsdnmO9jr3d7Lnov8i3J9zgzNJ6JX9PCuaHaF6p/G2jWwqMCe1
	 5rrWWigewLzFVvK2Jj6bSq/NKTvJ1fZOMQ2KrhpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 113/273] clk: qcom: clk-rpmh: prevent integer overflow in recalc_rate
Date: Thu, 13 Feb 2025 15:28:05 +0100
Message-ID: <20250213142411.809017932@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


