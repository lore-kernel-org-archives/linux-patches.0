Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC5C2FFDDF;
	Tue, 12 Aug 2025 17:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020249; cv=none; b=FH3WaYGGot6x6YeQbUYpSyrbo/I9Bh++cmf4CbPhMM/bbjxrtWLmWPV82TGPjCtrbeg6A+ML1xyBT4A+LYHhJ1FokSosU9ZBQTu2R1gEsyWSil2dv2hZzQoBg8tskSRkVrqRZX0KSmY1nmCsmHlktvXfbRqUNwMXebKJ4fQ1ibc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020249; c=relaxed/simple;
	bh=W6obxWAYrzrZL/nHxACT85lM+yadUwMOha3Qw0c95H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hnct/iOOyBMJx+x5n7IZgpWnW++ImZYiKZ+xKsZhpO+j2CpIlCJ7K95tG74bKFjTcIX/bV/KoeUfzjALEuQLoAC3GEmhn8EV4/iWTmZ4+4ZT7jQbrn/tHXSeTk1+4/Oonm6XIbs4nPJpwBUrrHB5aAawEpMLGW3BCLNO1WZRK/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCZE6frZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCZE6frZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA27C4CEF6;
	Tue, 12 Aug 2025 17:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020248;
	bh=W6obxWAYrzrZL/nHxACT85lM+yadUwMOha3Qw0c95H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCZE6frZdSaiHHPCCyQovsIty/kAUjntBdTMCUt7oW/LyN9olJGOJ62ejiLcq9CQ8
	 3EUkPkUKTyxpEQ7a168qMqvFuoNylv+Gk5OVUXebRXZOXWWGN6Q0ZmsYAUOnW9kK8O
	 7IuMm4p9HRDh+e6joVt+OPDzRzJGFgdi60QWgiSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/253] regmap: fix potential memory leak of regmap_bus
Date: Tue, 12 Aug 2025 19:26:34 +0200
Message-ID: <20250812172948.956261999@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f0e314abcafc5..168532931c86d 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1266,6 +1266,8 @@ struct regmap *__regmap_init(struct device *dev,
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



