Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F41327ECC
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjLVf1X/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EE6C433C8;
	Mon, 16 Oct 2023 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467600;
	bh=K1xT30bZruYqm9gVfjdyXtS/Ruu1BO+UU88zYu5kduA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjLVf1X/NeIVk+4bJWtwoEo6T/I0T/NN5pjrmpsnmieC2NktXXCUf/sH9Cx2POarj
	 WiJDrMk4gLP9go8gnVC3wcMIYX0zoHD4MmkofWVfmkV6P3BSmn2dv1mCio161QncwW
	 CmL5+EPFpXRnn0Y6rCE3sabeLf7leCUVXZu3PICM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 053/191] net: dsa: qca8k: fix regmap bulk read/write methods on big endian systems
Date: Mon, 16 Oct 2023 10:40:38 +0200
Message-ID: <20231016084016.644027477@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 5652d1741574eb89cc02576e50ee3e348bd6dd77 ]

Commit c766e077d927 ("net: dsa: qca8k: convert to regmap read/write
API") introduced bulk read/write methods to qca8k's regmap.

The regmap bulk read/write methods get the register address in a buffer
passed as a void pointer parameter (the same buffer contains also the
read/written values). The register address occupies only as many bytes
as it requires at the beginning of this buffer. For example if the
.reg_bits member in regmap_config is 16 (as is the case for this
driver), the register address occupies only the first 2 bytes in this
buffer, so it can be cast to u16.

But the original commit implementing these bulk read/write methods cast
the buffer to u32:
  u32 reg = *(u32 *)reg_buf & U16_MAX;
taking the first 4 bytes. This works on little endian systems where the
first 2 bytes of the buffer correspond to the low 16-bits, but it
obviously cannot work on big endian systems.

Fix this by casting the beginning of the buffer to u16 as
   u32 reg = *(u16 *)reg_buf;

Fixes: c766e077d927 ("net: dsa: qca8k: convert to regmap read/write API")
Signed-off-by: Marek Behún <kabel@kernel.org>
Tested-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index efe9380d4a15d..8e1574c63954e 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -505,8 +505,8 @@ qca8k_bulk_read(void *ctx, const void *reg_buf, size_t reg_len,
 		void *val_buf, size_t val_len)
 {
 	int i, count = val_len / sizeof(u32), ret;
-	u32 reg = *(u32 *)reg_buf & U16_MAX;
 	struct qca8k_priv *priv = ctx;
+	u32 reg = *(u16 *)reg_buf;
 
 	if (priv->mgmt_master &&
 	    !qca8k_read_eth(priv, reg, val_buf, val_len))
@@ -527,8 +527,8 @@ qca8k_bulk_gather_write(void *ctx, const void *reg_buf, size_t reg_len,
 			const void *val_buf, size_t val_len)
 {
 	int i, count = val_len / sizeof(u32), ret;
-	u32 reg = *(u32 *)reg_buf & U16_MAX;
 	struct qca8k_priv *priv = ctx;
+	u32 reg = *(u16 *)reg_buf;
 	u32 *val = (u32 *)val_buf;
 
 	if (priv->mgmt_master &&
-- 
2.40.1



