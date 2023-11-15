Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1619143AD7
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fk8nUDj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93644C4E777;
	Wed, 15 Nov 2023 20:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081727;
	bh=M+m0y3u8LsKdWmy/ezv+66nZsEK/Lmip6masDyH5MY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fk8nUDj+UOk0cGjQN63DwnT9z3nhONLceUsgk4yExpd6zrBazErkRv/03WJ/qZZ42
	 O0gTczzg63yb0rNa6s4JPa2k5S7a8tqZaAT/G19YAq6H2J7wIb/uqC+cv60M60oj71
	 /XKblBh07rv1wpQ3weLuK0uhlpFdz3u+w/cgv7jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Timur I. Davletshin" <timur.davletshin@gmail.com>,
	Jo-Philipp Wich <jo@mein.io>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/191] hwrng: geode - fix accessing registers
Date: Wed, 15 Nov 2023 15:46:04 -0500
Message-ID: <20231115204649.919798834@linuxfoundation.org>
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



