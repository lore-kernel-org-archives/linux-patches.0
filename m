Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8323DBAD
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MX/+zqaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B97C433C9;
	Wed, 15 Nov 2023 20:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078640;
	bh=Mt3cC4JmVhZUJjXasJfDfkLU2uf7pla9zRk5ZHLT3Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MX/+zqaE3eLqpdqGfBKsOpKyEpFDeGmaJ20SuL2njajD+dTlOhlpY8TCtcNyl9Rq6
	 iBXe5hTriezlE9jS1qxqXbUuFWNhpxfEeEsb161jtml4RZNjlLlKHxg4GkcAxcL0KX
	 DjxzhRr9EHFappSOEiS3CahCJ2bIFCsaBfFrAauQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Timur I. Davletshin" <timur.davletshin@gmail.com>,
	Jo-Philipp Wich <jo@mein.io>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/45] hwrng: geode - fix accessing registers
Date: Wed, 15 Nov 2023 14:32:55 -0500
Message-ID: <20231115191420.718704093@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191419.641552204@linuxfoundation.org>
References: <20231115191419.641552204@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 464bd8ec2f06707f3773676a1bd2c64832a3c805 ]

When the membase and pci_dev pointer were moved to a new struct in priv,
the actual membase users were left untouched, and they started reading
out arbitrary memory behind the struct instead of registers. This
unfortunately turned the RNG into a constant number generator, depending
on the content of what was at that offset.

To fix this, update geode_rng_data_{read,present}() to also get the
membase via amd_geode_priv, and properly read from the right addresses
again.

Fixes: 9f6ec8dc574e ("hwrng: geode - Fix PCI device refcount leak")
Reported-by: Timur I. Davletshin <timur.davletshin@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217882
Tested-by: Timur I. Davletshin <timur.davletshin@gmail.com>
Suggested-by: Jo-Philipp Wich <jo@mein.io>
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/geode-rng.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index 207272979f233..2f8289865ec81 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -58,7 +58,8 @@ struct amd_geode_priv {
 
 static int geode_rng_data_read(struct hwrng *rng, u32 *data)
 {
-	void __iomem *mem = (void __iomem *)rng->priv;
+	struct amd_geode_priv *priv = (struct amd_geode_priv *)rng->priv;
+	void __iomem *mem = priv->membase;
 
 	*data = readl(mem + GEODE_RNG_DATA_REG);
 
@@ -67,7 +68,8 @@ static int geode_rng_data_read(struct hwrng *rng, u32 *data)
 
 static int geode_rng_data_present(struct hwrng *rng, int wait)
 {
-	void __iomem *mem = (void __iomem *)rng->priv;
+	struct amd_geode_priv *priv = (struct amd_geode_priv *)rng->priv;
+	void __iomem *mem = priv->membase;
 	int data, i;
 
 	for (i = 0; i < 20; i++) {
-- 
2.42.0



