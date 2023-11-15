Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCED9249E2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="voOXT/Tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C574C4E77D;
	Wed, 15 Nov 2023 20:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081707;
	bh=j6VP8YVqItD1jBtP8UZNKniuQH1tErVI9L5nKWWOTZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=voOXT/TcWjn2cg1W4ofrtNIo71wnkgLhS6tLxEorkzNc5HIS1S5it8tiJScB2YIZt
	 JJ6c/U5lsgTLwZYVGOvHHYEwJpftwNlCG6HFpcifNVNO8eQtTu3gEbKq55khnRIz2o
	 GK9dHNYcYbByv+y3cxDkbVbjRBK8JyXVUPaFMbrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/191] clk: ti: Add ti_dt_clk_name() helper to use clock-output-names
Date: Wed, 15 Nov 2023 15:45:25 -0500
Message-ID: <20231115204647.607024865@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 2c1593328d7f02fe49de5ad6b42c36296c9d6922 ]

Let's create the clock alias based on the clock-output-names property if
available. Also the component clock drivers can use ti_dt_clk_name() in
the following patches.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20220204071449.16762-7-tony@atomide.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 7af5b9eadd64 ("clk: ti: fix double free in of_ti_divider_clk_setup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk.c   | 20 +++++++++++++++++++-
 drivers/clk/ti/clock.h |  1 +
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/ti/clk.c b/drivers/clk/ti/clk.c
index 29eafab4353ef..b941ce0f3c394 100644
--- a/drivers/clk/ti/clk.c
+++ b/drivers/clk/ti/clk.c
@@ -402,6 +402,24 @@ static const struct of_device_id simple_clk_match_table[] __initconst = {
 	{ }
 };
 
+/**
+ * ti_dt_clk_name - init clock name from first output name or node name
+ * @np: device node
+ *
+ * Use the first clock-output-name for the clock name if found. Fall back
+ * to legacy naming based on node name.
+ */
+const char *ti_dt_clk_name(struct device_node *np)
+{
+	const char *name;
+
+	if (!of_property_read_string_index(np, "clock-output-names", 0,
+					   &name))
+		return name;
+
+	return np->name;
+}
+
 /**
  * ti_clk_add_aliases - setup clock aliases
  *
@@ -418,7 +436,7 @@ void __init ti_clk_add_aliases(void)
 		clkspec.np = np;
 		clk = of_clk_get_from_provider(&clkspec);
 
-		ti_clk_add_alias(NULL, clk, np->name);
+		ti_clk_add_alias(NULL, clk, ti_dt_clk_name(np));
 	}
 }
 
diff --git a/drivers/clk/ti/clock.h b/drivers/clk/ti/clock.h
index f1dd62de2bfcb..938f34e290ed2 100644
--- a/drivers/clk/ti/clock.h
+++ b/drivers/clk/ti/clock.h
@@ -214,6 +214,7 @@ struct clk *ti_clk_register(struct device *dev, struct clk_hw *hw,
 			    const char *con);
 struct clk *ti_clk_register_omap_hw(struct device *dev, struct clk_hw *hw,
 				    const char *con);
+const char *ti_dt_clk_name(struct device_node *np);
 int ti_clk_add_alias(struct device *dev, struct clk *clk, const char *con);
 void ti_clk_add_aliases(void);
 
-- 
2.42.0



