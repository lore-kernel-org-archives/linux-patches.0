Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DCECA6F;
	Sat, 12 Sep 2026 11:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211542; cv=none; b=hHgLrTlLNupm0TEUxhcR05lrrDHqEY+msbz3qfh2NxorWI8PSsUlPVwELW/yFK9zoWsFbJFA2tVjd43bE75aWj0xBOWq5r4kfvRTAQcg/G91owcO7QJoXDbs5vViTD6I3oKNwPJ9+lVgva3kPP8605IrKtd1TKDlS3foAUmPPNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211542; c=relaxed/simple;
	bh=ZnHO68nG9zvh1kbYPs5z41BQ1WQ5V7Y8EsWZakCFJB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LX4TTCOVFgl/cPhFKrySEUtAE7UY0l9BCt8Mv46uqV8fUHwSGLxKOHQ76jSyU599HX7Ur/qUtdL2Fz9cHnV/YUu3CSofmXR8sQLpiWVhbGbqY1fpiLg3akZx/992rKzlb6OhOCz+j7t7ee3zkLGFI4gok7AmfQ9Zjd9UpCC/RN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7x4Anpt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7x4Anpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3571F000FF;
	Sat, 12 Sep 2026 11:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211541;
	bh=QViN8MlSKIfrOHDyuoJxahwr2/gQqxg1FBizDJDd4xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r7x4AnptwSgtN+MVInPkqTMn9+g+e3Ci58Xy4XkbgGDZjS5dU677mDdxjHB10FJ4f
	 XjOPH8zgVz/8xI9O2R5O23MjYpZFeGcdpFXFYw2WVN+lGuoOCBq6BxTBNWv5yIX5OO
	 vTkkB9Dr+Z6dp6m6Go4vv3vik20ERBFD2sMvJzgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1253/1518] clk: devres: fix cleanup in devm_clk_get_optional_enabled_with_rate()
Date: Sat, 12 Sep 2026 08:57:02 +0200
Message-ID: <20260912065651.855544414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5368d92d9b399..09fd5e8fb72c4 100644
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



