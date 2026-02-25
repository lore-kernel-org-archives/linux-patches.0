Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F0D303A0A;
	Wed, 25 Feb 2026 06:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002657; cv=none; b=OmGx7DJ7WUY8tpAvTkYAKlFa+8Jje7OuPi5b9FfHWC/lsHpiBOVSE1kG6VYGCG4AJvmakc4fjVzIEuXJJdL5Cp1ejaLqH4CXKLbhkR9c8Ypewbql1QyEgAvHFSu7OT52Zo2lHosa9oXBmGmw+kEAsV21XOARyullMy+eStsYqFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002657; c=relaxed/simple;
	bh=A3YR2WaEOpSsI1Fz46WRs7QLgvZh2/vix46nuu4bfTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chlPbMsesgetALBKEjnrNPvoLagnqQ76D9G5ELuUyMiSG8xjtyxczYeBL43xNwkMu0QQ3UwqtofZRMmWYWKFOHuIq1URp2x365hoHbJi9k7iDRod3WL521vWk7YBe1UJNirF8n/zLY1MZO5mbp47FZobv2MpospOkqwICgBDAis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzfOtCzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzfOtCzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A51C116D0;
	Wed, 25 Feb 2026 06:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002657;
	bh=A3YR2WaEOpSsI1Fz46WRs7QLgvZh2/vix46nuu4bfTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzfOtCzoeQ15NvLQk9NiAbNE7oRcQwPOivbsh9+4C7+COVOt0f5h8G0BBNzPLwSx1
	 DVNs8jAR5CNweAocaiSvBoXVqJTkC+G8jijR1OjvzfQS9GnJw766xIgMZZxppNmR6L
	 s4ghtDFZnARwucAuv+Ju7fOG+5yBU30fpcae5U9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 435/641] clk: milbeaut: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:22:41 -0800
Message-ID: <20260225012359.077221324@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 865e63b038c446d38593ddbcc362ebb62e6ff007 ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: 7b45988fcf78 ("clk: milbeaut: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-milbeaut.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/clk/clk-milbeaut.c b/drivers/clk/clk-milbeaut.c
index b4f9b7143eaa6..bb94d02a76cf1 100644
--- a/drivers/clk/clk-milbeaut.c
+++ b/drivers/clk/clk-milbeaut.c
@@ -407,10 +407,7 @@ static int m10v_clk_divider_determine_rate(struct clk_hw *hw,
 		return 0;
 	}
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate,
-				       divider->table, divider->width, divider->flags);
-
-	return 0;
+	return divider_determine_rate(hw, req, divider->table, divider->width, divider->flags);
 }
 
 static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.51.0



