Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049205;
	b=jlKctrzuCHTJ586LYSTPYjdkUC0Ta/vor2jsNxUk321xTROTNyA1ZPoQJacG7JjoNIbW
	 ldNuyu/2vadBc79XDIQNc+BD70hJSOaiLc+wKmQ5d6mPEdcxalPVQzkXqCOrI3G2c+CLA
	 b7/sUylBA9HYa4i/Rzhg3DI2hbxQCkkuDBi/7wT1oVMc6smG3tJaKSBVKCxTkQltMZcx7
	 Ll6+29chQk6Gpq8DkSZqXZDrje/TeZo/R/vMtBfg12J8T80Kz5TZ7FQ3LIKhh7/gvjBBE
	 uXqwE+43U5ck7itWL++g2tlvxhjR4w97cOT2VZh5IhlKab1SktNilMV95GzYRvuZeuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TDEZ763VVl48buJffTSfj569kWnXA9jEZcoDaOm5Twc=;
	b=2H4st+4fdUP12uevPI0pEyuyTXcDQ6rdga7SsBE+O5rR5ItzdCfS5Fm4QB7PUYvf7gi2
	 G2OIEFD3yZr9e09fmTeX2lq9RgtwJPOUPA69uG5MvVQ8POTfYy26ePoCI6ZWESMMXj8Ja
	 LjF8SfrRNrvdxogLG/4h2yjV4N78hSl/8GcjDzdqfuF2CZpbjVdVmhAfhIYIajuLUhKCz
	 0Y0utoBw0qrHgxEYQEou7faFrvUrITpQP2edTkRR+dYqeUdsKgWNKUgcvkACOamgEYLYo
	 sAxf7Oo741Fj4jhBG0AR1OSShEMjfBaBRwQprWl8rPVc7aKWGg+U+sDYXt/XiTzndxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RQunCzm/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601A9606A31C;
	Thu, 19 Nov 2026 00:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQunCzm/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E0F1F000C4;
	Thu, 19 Nov 2026 00:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049205;
	bh=TDEZ763VVl48buJffTSfj569kWnXA9jEZcoDaOm5Twc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQunCzm/yGrk6PDcVwQOu1Zk8K5If9sJmfyYgAH7QDeg4iWLPJYVoUdQMv8BjCJXV
	 O76qVt+ZceAhzp8uZBJJ+er+wFm6CDIkqjzp8LOnqFM8PkGONsUKa3GiU6wWBX97Rz
	 5SfyX460DSdsXMMqytxJ9e/InRjKtXz7wH2TrYT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2267/2857] dmaengine: ste_dma40: Fix logical channel bounds check
Date: Wed, 18 Nov 2026 15:55:01 +0100
Message-ID: <20261118150323.075907276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 57938e0c2a24f9f792fe9f611391ef6b58d1aa21 ]

d40_validate_conf() checks the raw dev_type against num_log_chans,
but d40_allocate_channel() derives the lookup_log_chans index as either
2 * dev_type or 2 * dev_type + 1.

Validate the dev_type against the derived logical channel index limit so
channel allocation cannot write past lookup_log_chans.

Fixes: 26955c07dcf3 ("dmaengine: ste_dma40: Amalgamate DMA source and destination channel numbers")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260618051539.15E201F000E9@smtp.kernel.org/
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-19-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 2749e343527f4..1b0dea372e477 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1752,15 +1752,26 @@ static int d40_validate_conf(struct d40_chan *d40c,
 {
 	int res = 0;
 	bool is_log = conf->mode == STEDMA40_MODE_LOGICAL;
+	bool invalid_dev_type = conf->dev_type < 0;
 
 	if (!conf->dir) {
 		chan_err(d40c, "Invalid direction.\n");
 		res = -EINVAL;
 	}
 
-	if ((is_log && conf->dev_type > d40c->base->num_log_chans)  ||
-	    (!is_log && conf->dev_type > d40c->base->num_phy_chans) ||
-	    (conf->dev_type < 0)) {
+	if (!invalid_dev_type && is_log) {
+		int max_dev_type;
+
+		if (conf->dir == DMA_DEV_TO_MEM)
+			max_dev_type = DIV_ROUND_UP(d40c->base->num_log_chans, 2);
+		else
+			max_dev_type = d40c->base->num_log_chans / 2;
+
+		invalid_dev_type = conf->dev_type >= max_dev_type;
+	}
+
+	if (invalid_dev_type ||
+	    (!is_log && conf->dev_type > d40c->base->num_phy_chans)) {
 		chan_err(d40c, "Invalid device type (%d)\n", conf->dev_type);
 		res = -EINVAL;
 	}
-- 
2.53.0



