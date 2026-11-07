Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063250;
	b=30GAuXJFNK3SHq/I1Whqv6mjjyeXlsV7FDA53bvV4+a0wRdOSLMN4WiM89Uw4F6DcDn5
	 ijcHE/NxknJGqpcEqigKNTnxz3Uu5+T67zX0dPSzkPd3T/T13dXExoIOY+EksRpk4RU2G
	 M6C7Lhtq3a7Vav0CFAwXJw3PwzC0suHlOIhAEJuHOzP/Ay78unW4f1YEzf1cEfzyqrLni
	 heAxhtNFV9BwoNRUMePMjXER/xW2/Gzh6dGSaqqENR6IQm+762DQHzxCC8QuaD5vH7SSp
	 UWWtQduCyiOvQMVIHQmuwMs4xT3WU6KGNA8h+XjmpC79m0p3dyEbJGgG67Nu7iC4QMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W7u/oSSIQu0WO+TyR36bsPnKuKvoQBRxae9kGHmCaak=;
	b=h9mSt8sxylyYE/a92jc0ZacAZZj+wydSP7vdjk6AliWco2ZRoWgyaLT+LJCqZsD8kj7d
	 0reAYvF99bV34wyINkNQ/7iFmopCSsgsTouZbS90W1+txoTHyLsaDJSUnq46kFk/EYEy/
	 nN2l4aS3rkfNFkJXP0TO+azlq6c5x7VjUIwMrupWy40rexyXBaYoDLkvOsuxfpgtrDE+J
	 WS3TjA6ROGByhw+qky75D1eBL8I/ScxthnjW28W5efjZZdCqvl1P2kleFA6m7r3YoBGh1
	 NmTT6VP3YIenebJcIhk0SjEn8SUXnq/vUqsOWC+YkW7ZDtRQgjTvipkxWqM6Hq0DEEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KRzhDUK2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5E1606A336;
	Sat,  7 Nov 2026 14:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KRzhDUK2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A95D1F0089F;
	Sat,  7 Nov 2026 14:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063249;
	bh=W7u/oSSIQu0WO+TyR36bsPnKuKvoQBRxae9kGHmCaak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KRzhDUK2VYsK8np7LaB1383iZ8ZPmFW/5TtFGT2wRLRqrKSL5QixHlE14D651ZOU5
	 sxOAnnJMagAaSpraiis2hqzC3eRFVBRLaHonV/QZHRjb/KAi5I+IhnfierXbfDf6vr
	 OhWNWdlqnudKX20w1RN454FXtDoqQucNrxLJ4LM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Herve Codina <herve.codina@bootlin.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 435/869] soc: fsl: cpm1: tsa: Fix clock leak in tsa_of_parse_tdms()
Date: Sat,  7 Nov 2026 08:51:57 -0500
Message-ID: <20261107134908.538954813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 46201d760c48e771fa2febfcb0787f22c3b71387 ]

The error cleanup loop puts l1rsync_clk and l1rclk_clk a second time
and never puts l1tsync_clk or l1tclk_clk, because the branches that
guard the transmit clocks use the receive clock field names.

Use the matching field in each branch so every clock acquired by
tsa_of_parse_tdms() is released exactly once.

Fixes: 1d4ba0b81c1c ("soc: fsl: cpm1: Add support for TSA")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20260917152719.2160395-1-vulab@iscas.ac.cn
[chleroy: Fixed the same in tsa_remove()]
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/tsa.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/fsl/qe/tsa.c b/drivers/soc/fsl/qe/tsa.c
index 4a88e54d25b94..502e2ffe86898 100644
--- a/drivers/soc/fsl/qe/tsa.c
+++ b/drivers/soc/fsl/qe/tsa.c
@@ -865,12 +865,12 @@ static int tsa_of_parse_tdms(struct tsa *tsa, struct device_node *np)
 			clk_put(tsa->tdm[i].l1rclk_clk);
 		}
 		if (tsa->tdm[i].l1tsync_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rsync_clk);
-			clk_put(tsa->tdm[i].l1rsync_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tsync_clk);
+			clk_put(tsa->tdm[i].l1tsync_clk);
 		}
 		if (tsa->tdm[i].l1tclk_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rclk_clk);
-			clk_put(tsa->tdm[i].l1rclk_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tclk_clk);
+			clk_put(tsa->tdm[i].l1tclk_clk);
 		}
 	}
 	return ret;
@@ -1039,12 +1039,12 @@ static void tsa_remove(struct platform_device *pdev)
 			clk_put(tsa->tdm[i].l1rclk_clk);
 		}
 		if (tsa->tdm[i].l1tsync_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rsync_clk);
-			clk_put(tsa->tdm[i].l1rsync_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tsync_clk);
+			clk_put(tsa->tdm[i].l1tsync_clk);
 		}
 		if (tsa->tdm[i].l1tclk_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rclk_clk);
-			clk_put(tsa->tdm[i].l1rclk_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tclk_clk);
+			clk_put(tsa->tdm[i].l1tclk_clk);
 		}
 	}
 }
-- 
2.53.0



