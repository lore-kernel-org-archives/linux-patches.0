Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CB541B8C6;
	Sat, 12 Sep 2026 13:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218646; cv=none; b=d++feLSdgXKz1HlLrf8PWJfFl36V/lqdy/bhMU7mmm/6RPZuqPTskyDD5lUp0Ui0iwoKIm7vVW6EXFLf0fNCIVKLQUDl+33hXKLB/aO+ZT3VO+xts+aJmYIiRi0oCzav9pbH5yEz7e/jplRHiPkH7VHA7bhCsGuEeKnW1YL/Fto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218646; c=relaxed/simple;
	bh=WOoY9PKxt1p8VG7UZqTWH/0OQEedzyTzLDEeRQKoGe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ENmtDgN++83X0LDrLf3p3MwJjlIs5AWybZpuS75pT1GlMD1jYEUtm5PCMjI3gaKy+b8JjtUETfjbAIZInHTztRXqqLsUkUVUQDVqdsufFHYL0DugkL2PlS9CmGx2SCZJe+fuBU8FdWWZUyB2Htzbwn6v+crCqlWDHV5qIngovrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYmd1+/9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYmd1+/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4029E1F000FF;
	Sat, 12 Sep 2026 13:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218645;
	bh=5po2t4GFRuSZRwxzlWVJqX2T+8pzV62hnAehuDcdbNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eYmd1+/98TJ5PuhyU09KBec5+u27pcNyNKgwvHIREsYpY4XPfFWb5bsM1GXO5q4gq
	 tL2cG41Uzs+1KI5PBAHHq3aEnLVjFx/C2ROqu9uIXAZ2WVxw2jjkcyvg8vgYymtqCZ
	 z+QKf+POgG6vpIp7sHS4fA2qFT9emN1wA2uVej78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1186/1376] clk: devres: fix cleanup in devm_clk_get_optional_enabled_with_rate()
Date: Sat, 12 Sep 2026 09:00:12 +0200
Message-ID: <20260912065633.983953598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Onur Özkan <work@onurozkan.dev>

[ Upstream commit 0d4d262c1664365e17e0a5ba2ab79f4db484b44e ]

devm_clk_get_optional_enabled_with_rate() registers its cleanup action
before setting the clock rate. If setting the rate fails, it attempts to
disable and unprepare a clock that was never enabled. This issue was
spotted while reviewing "rust: clk: add devres-managed clks" [1].

Register the cleanup action only after successfully preparing and enabling
the clock.

[1]: https://lore.kernel.org/rust-for-linux/20260706-clk-type-state-v5-3-67c5f326a16c@collabora.com

Fixes: 9934a1bd45b2 ("clk: provide devm_clk_get_optional_enabled_with_rate()")
Signed-off-by: Onur Özkan <work@onurozkan.dev>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-devres.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index 82ae1f26e6345..a9ceb84a45f80 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -99,6 +99,11 @@ struct clk *devm_clk_get_optional_enabled(struct device *dev, const char *id)
 }
 EXPORT_SYMBOL_GPL(devm_clk_get_optional_enabled);
 
+static void devm_clk_disable_unprepare(void *data)
+{
+	clk_disable_unprepare(data);
+}
+
 struct clk *devm_clk_get_optional_enabled_with_rate(struct device *dev,
 						    const char *id,
 						    unsigned long rate)
@@ -106,8 +111,7 @@ struct clk *devm_clk_get_optional_enabled_with_rate(struct device *dev,
 	struct clk *clk;
 	int ret;
 
-	clk = __devm_clk_get(dev, id, clk_get_optional, NULL,
-			     clk_disable_unprepare);
+	clk = devm_clk_get_optional(dev, id);
 	if (IS_ERR(clk))
 		return ERR_CAST(clk);
 
@@ -119,6 +123,10 @@ struct clk *devm_clk_get_optional_enabled_with_rate(struct device *dev,
 	if (ret)
 		goto out_put_clk;
 
+	ret = devm_add_action_or_reset(dev, devm_clk_disable_unprepare, clk);
+	if (ret)
+		goto out_put_clk;
+
 	return clk;
 
 out_put_clk:
-- 
2.53.0



