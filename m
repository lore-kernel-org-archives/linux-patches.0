Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3FE1448D2;
	Thu, 13 Jun 2024 12:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281692; cv=none; b=qR4T1GZxOwKNZ7gnQ0Jda0B9mteMcGGzZFYri65gqE2DbymDRsol51a7fQivsykvhqt79idBYX4l17ixpz4Vb7BtlORCWgo+6FTtU15Np6Kbc4h5QW5j8J17LmiLFTqIofKQZH0We4zTNipYj3GwZ4neobF6pPZlXwKVCox5KPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281692; c=relaxed/simple;
	bh=5Q/ctb280NdUqKhlKkVatuHfYVHEN7jVFdxyodjZuN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPRi8yS/J9CQUdGUzfeTRpsUdP/jTbSVcFlQOlIdR7DXm/qCzsfrHk5QHKT5wQq3eF++OmnJsfHTGuSl0x+sALIYY6EvcyM3WrhyGn/6Mp7n02tqNN/3adB4IpWbXCom4ZKwavmWl6z7e81AxA3obxvTkRwn9lcM9NfR95Zprfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwOdsgu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwOdsgu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83A0C32786;
	Thu, 13 Jun 2024 12:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281692;
	bh=5Q/ctb280NdUqKhlKkVatuHfYVHEN7jVFdxyodjZuN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwOdsgu+rqVrs2VZwkRKlG4t/geuhw3utVuEhUtqHoM9WC9Ui/khzv6zjpexnvAZn
	 Vyyfv05Two2Y9Jyb6RsQ/U0eC4PX/yI5D6Oc/CLEWc6SbzH/soqOHfgcATeMPfTVqY
	 dkkEN8esVeUjxfXsL2lIEHeG+f/FyMTWRMfl37mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/402] regulator: irq_helpers: duplicate IRQ name
Date: Thu, 13 Jun 2024 13:29:41 +0200
Message-ID: <20240613113303.084685422@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 7ab681ddedd4b6dd2b047c74af95221c5f827e1d ]

The regulator IRQ helper requires caller to provide pointer to IRQ name
which is kept in memory by caller. All other data passed to the helper
in the regulator_irq_desc structure is copied. This can cause some
confusion and unnecessary complexity.

Make the regulator_irq_helper() to copy also the provided IRQ name
information so caller can discard the name after the call to
regulator_irq_helper() completes.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://msgid.link/r/ZhJMuUYwaZbBXFGP@drtxq0yyyyyyyyyyyyydy-3.rev.dnainternet.fi
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/irq_helpers.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/irq_helpers.c b/drivers/regulator/irq_helpers.c
index 5227644355750..a44a0b30a6516 100644
--- a/drivers/regulator/irq_helpers.c
+++ b/drivers/regulator/irq_helpers.c
@@ -350,6 +350,9 @@ void *regulator_irq_helper(struct device *dev,
 
 	h->irq = irq;
 	h->desc = *d;
+	h->desc.name = devm_kstrdup(dev, d->name, GFP_KERNEL);
+	if (!h->desc.name)
+		return ERR_PTR(-ENOMEM);
 
 	ret = init_rdev_state(dev, h, rdev, common_errs, per_rdev_errs,
 			      rdev_amount);
-- 
2.43.0



