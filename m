Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2338D277CA8;
	Wed, 30 Jul 2025 09:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868522; cv=none; b=GipZmQF6udwWJR54Ty5dLEVG9g+bWRZtd/DlbFGdwcIXJxRkJ/JFyIRAHYJZ/QWvNTf7yYJstgEsx7D5+WG1+6cEbzh//8nQpatQc29Ww1fZ1wWxPvd4j35+F9DkP0zDQi6spCS9Jnr+Ofg1dkHSvT6aJvv1tGCtlZdy5HtLD1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868522; c=relaxed/simple;
	bh=jUak4c/8qy0OK1IVw9BjPrQbuOmckLM9SAsBT5izXgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9XTGwDjXv3uwezP5kYVkPIZPmRbKEVWJySaTHEZHHdfbpi4Ou02c1UUzBnWyXunytZ6xiMAxACBDnoJQel4dLEDR+5A1QXBww9hsPGELNJ1KGyQ0xpnJ9q5V7X4TKLYKN5xQnwDHqoubbBQfsQKGMkyTE9rTOIn3ghJyq5RuUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZecNJ1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZecNJ1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF79C4CEE7;
	Wed, 30 Jul 2025 09:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868521;
	bh=jUak4c/8qy0OK1IVw9BjPrQbuOmckLM9SAsBT5izXgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZecNJ1vhnAc5lpqiZrDX3Wn6XmWJsvQvy+o9ffvAqH6BFuafGm5LD0jmoLHkdCOW
	 Lygz2LTdNC6YmW+r3I/Tgf/FZFxslvlSxlZt1gGga1I6aXA+R6gMPO5tC7S/9/AB/N
	 Bz+SqaVXzshUByTK/Z+9tKbMqMDkg+baW3TmMrNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/117] regmap: fix potential memory leak of regmap_bus
Date: Wed, 30 Jul 2025 11:34:39 +0200
Message-ID: <20250730093233.991160026@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit c871c199accb39d0f4cb941ad0dccabfc21e9214 ]

When __regmap_init() is called from __regmap_init_i2c() and
__regmap_init_spi() (and their devm versions), the bus argument
obtained from regmap_get_i2c_bus() and regmap_get_spi_bus(), may be
allocated using kmemdup() to support quirks. In those cases, the
bus->free_on_exit field is set to true.

However, inside __regmap_init(), buf is not freed on any error path.
This could lead to a memory leak of regmap_bus when __regmap_init()
fails. Fix that by freeing bus on error path when free_on_exit is set.

Fixes: ea030ca68819 ("regmap-i2c: Set regmap max raw r/w from quirks")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Link: https://patch.msgid.link/20250626172823.18725-1-abdun.nihaal@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 5962ea1230a17..de4e2f3db942a 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1174,6 +1174,8 @@ struct regmap *__regmap_init(struct device *dev,
 err_map:
 	kfree(map);
 err:
+	if (bus && bus->free_on_exit)
+		kfree(bus);
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(__regmap_init);
-- 
2.39.5



