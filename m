Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EC81F1306;
	Wed, 30 Jul 2025 09:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868300; cv=none; b=sSqltc+a92qZMX2feORnqYFeWoWLRJoWOzb325mil+0M3tIyKZP/mj6Yx5t37juY615sk+Lh63bNwY12dD3MwQdiLbtvTYtnSmGaqXPWzLn4g91nl+AVqyavsUMPBbCPNuzAZjSF9kw7XyQpECo0aL0PIJhHjmgyKZIQnLkAQ7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868300; c=relaxed/simple;
	bh=YsJRGLY2nKpsJphJVQ8y/t1yyNuHQvpcNR9AFHirFpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKIp43SA0ChQ5qaz0XzI785CKLmgersqvIGZqSQ4zw5LJm4YwumTNEjW9DNghfzmqf3cvWRLWwD5QlU4LJY39JQlRAlleMz7A4mHss4aiij5ZKrHGPj9VPICU3CZajzD6SYGrj0K8V2CkDYVZji91g1olz3jcsl/HUZma3RyCjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NT3o53g/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NT3o53g/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD142C4CEE7;
	Wed, 30 Jul 2025 09:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868299;
	bh=YsJRGLY2nKpsJphJVQ8y/t1yyNuHQvpcNR9AFHirFpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NT3o53g/TpT7OE2VJLW583BIunrT9jRg+KXRPNH8fn5LMLhG/OqxwObP2ouz0WHbG
	 rQ4tcnRlk1bjHrsC0MXH0k9yN7lXDM33MVVIgQkZpOE+Z3ZkvhYu/Ab2nZBCSYvtA8
	 VIziwBI0g5cvzM5rHpJ3K9x2t5aESBIrSp+k3M+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 07/76] regmap: fix potential memory leak of regmap_bus
Date: Wed, 30 Jul 2025 11:35:00 +0200
Message-ID: <20250730093227.138656343@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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
index 3011f7f9381b7..1209e01f8c7f9 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1173,6 +1173,8 @@ struct regmap *__regmap_init(struct device *dev,
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



