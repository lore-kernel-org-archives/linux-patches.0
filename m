Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A35E1C68A6;
	Wed, 19 Feb 2025 08:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953841; cv=none; b=SjGXtwk3st5cA5ibYgmINl1JqMht0ijPfwX61jtGd6VCN2P3Ka6hnZIPb5IQIfIXMZU3+YhOQ0Wk2ccbxEuFuHA9ewXrCKKxPbqzziR5pDz2MfEFmz7VVxAE3nkpsN/pKbLQCJG7j7Xg7oly4ongfY2929TEQQQj9uRKhudti+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953841; c=relaxed/simple;
	bh=K2ow86c4wK/mLhslQtP5Z9jwt4Ma9q/A6IjHPSXvztM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6LSBZV04AHMXKc2uIMnLYiVi0RJTtuqWIJ5y2tCo3UpQIa7bKUpPNfON4GdPvI3bobNnF6bcuk+UnEq10ubnbqRvS7wfCD3ONUEAOFy7grWhu1Xzy1irIOT1J2l37DCpE3McnvFsW6ShTkDJQh/yPGZN1WI4tvfC8aDTzMxrdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zobt2QOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zobt2QOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5583DC4CED1;
	Wed, 19 Feb 2025 08:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953840;
	bh=K2ow86c4wK/mLhslQtP5Z9jwt4Ma9q/A6IjHPSXvztM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zobt2QOmkbjp7f/xc8IDhnexHzmPq0JOjlUuNp9Me3k1AfTPHfv+MU0evpr7147PB
	 QgfPqjaNyZujyPA5dOmB6/NgXcD7/6EtzjM87MNf6wshV/Mjam1z9v/fNXlkqiK7nu
	 6EdQ9wgqfMrZwAZg+qCk6FFuhglgWymRqzs4LJhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 015/274] pinctrl: pinconf-generic: Print unsigned value if a format is registered
Date: Wed, 19 Feb 2025 09:24:29 +0100
Message-ID: <20250219082610.136470681@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 0af4c120f5e7a1ea70aff7da2dfb65b6148a3e84 ]

Commit 3ba11e684d16 ("pinctrl: pinconf-generic: print hex value")
unconditionally switched to printing hex values in
pinconf_generic_dump_one(). However, if a dump format is registered for the
dumped pin, the hex value is printed as well. This hex value does not
necessarily correspond 1:1 with the hardware register value (as noted by
commit 3ba11e684d16 ("pinctrl: pinconf-generic: print hex value")). As a
result, user-facing output may include information like:
output drive strength (0x100 uA).

To address this, check if a dump format is registered for the dumped
property, and print the unsigned value instead when applicable.

Fixes: 3ba11e684d16 ("pinctrl: pinconf-generic: print hex value")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/20250205101058.2034860-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinconf-generic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 0b13d7f17b325..42547f64453e8 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -89,12 +89,12 @@ static void pinconf_generic_dump_one(struct pinctrl_dev *pctldev,
 		seq_puts(s, items[i].display);
 		/* Print unit if available */
 		if (items[i].has_arg) {
-			seq_printf(s, " (0x%x",
-				   pinconf_to_config_argument(config));
+			u32 val = pinconf_to_config_argument(config);
+
 			if (items[i].format)
-				seq_printf(s, " %s)", items[i].format);
+				seq_printf(s, " (%u %s)", val, items[i].format);
 			else
-				seq_puts(s, ")");
+				seq_printf(s, " (0x%x)", val);
 		}
 	}
 }
-- 
2.39.5



