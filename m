Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3970A307AD6;
	Wed, 25 Feb 2026 06:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002657; cv=none; b=ECiw6PlXiXSuSBRklAghsoBcaoaRT5JcabkCd6TnHanFLIzEpflpKOdE+xN7lIucBNwe7VAn9SZO6/ArejNFGep2lcyUG/BlTphZO6xePIbP9RJWJJ++hTS0oQveNudrpTc/BPsZ596YoZEnA/NoRg3HxxUFyrWTJ9O6DgeFeLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002657; c=relaxed/simple;
	bh=F8TMf2RyHPoIa6wZqoFPswzejvnes7zcKu88Uqh2kqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWkJukZr1EaaJK6s7y0c/lv00jn2JginYnlAEn3jThC8iXOKtqbFhkYJzqhclbDZfNhRSb6d58ueUnEryDDHsnoM5FhaGN2bYosW2oOzfRs/O2mPM6JFdsvEq4gKzeD4+DZE9Dm1Xsdo8mM8zKwtCYklDPNCdUKbJMz4MiJWfqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3fm7ERK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3fm7ERK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086BAC116D0;
	Wed, 25 Feb 2026 06:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002657;
	bh=F8TMf2RyHPoIa6wZqoFPswzejvnes7zcKu88Uqh2kqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3fm7ERKiPrfWZLd+A+B3eqbgEjBcyAdPyS3EIC1wplNn5RuMNhQR/KJjtW7RUVRs
	 jKBIwxTig99BLPZIxkKlx+pZYnbdUT+WvNmt24W4OQYenX8hiDPAtTPZpv4dKsKzVr
	 oj1B5VwhMJJG1VmY+aUEHIs/Sma/iTYyfkOKIhQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keguang Zhang <keguang.zhang@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 434/641] clk: loongson1: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:22:40 -0800
Message-ID: <20260225012359.053659303@linuxfoundation.org>
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

[ Upstream commit 11d3c676e7e0f00e3398199f85e47a0e22369866 ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: bb40a2ef4fc9 ("clk: loongson1: convert from round_rate() to determine_rate()")
Reviewed-by: Keguang Zhang <keguang.zhang@gmail.com>
Tested-by: Keguang Zhang <keguang.zhang@gmail.com> # on LS1B & LS1C
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-loongson1.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/clk/clk-loongson1.c b/drivers/clk/clk-loongson1.c
index f9f060d08a5fa..1674181a1107d 100644
--- a/drivers/clk/clk-loongson1.c
+++ b/drivers/clk/clk-loongson1.c
@@ -99,10 +99,7 @@ static int ls1x_divider_determine_rate(struct clk_hw *hw,
 	struct ls1x_clk *ls1x_clk = to_ls1x_clk(hw);
 	const struct ls1x_clk_div_data *d = ls1x_clk->data;
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate,
-				       d->table, d->width, d->flags);
-
-	return 0;
+	return divider_determine_rate(hw, req, d->table, d->width, d->flags);
 }
 
 static int ls1x_divider_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.51.0



