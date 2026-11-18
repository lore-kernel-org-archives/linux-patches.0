Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037502;
	b=khNSSttkPjzS+BjAdE/WBok+1w1lA4uXvknj6tgIyGsT4LQoznfg9XYstce9pRZegjjF
	 T1+3ZhwaLPq+Vocs7QlkiPEa+OdrqtBlbOZGzv+AT95LPB085diW+f1byVyQ3d+PYm2EH
	 h2w/zvNcoB1r7AM5Z45MMF7659hqjct9fSVq3Tx2+lidhExdcFe5jjtummm8g14+UjXYH
	 8kQH4zb3VMMtWSfu4NkOvAv5RDngrFsjbzF7lUjdA65+V/ashRVXOBGIbzjpgWG0l71ix
	 /lkgIDshLershOf3hUC5puOUx2THrTG4VH+VtTXrc6sMiPrzhPn++KUZlWqC7IjZi3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=15GSoaJBhea6/KV8w+GUGJb1Ybmg/RNawX7ab40hiSA=;
	b=qXYSKeaHTZO3G7qxhr/OF5Si3n32i+0Q3B4P1TQmMgoSSgpuXb6tN4Mb4uVxgfGoXEwA
	 zNZQrKLf2yhsOJ12jErDshj6nnuMjNQEi7DGasPwQek2D2xe6qeZ9rfsv2kFE7sCc4NpY
	 qCrW6A7RLZZOCkDb42FI82e2vzCmDAQQd1TNv7w/TpgvIZodZ9Qlpd3hzslq2sWPS84Ir
	 s4DPUAJQuECBChi58g/wy6+sKk0IncO9Puzi4qEKvO2HphU5IK1VF7I4UUIYShCZXeNS/
	 L0v2jzTqW8Xm8IHwPKIAinyDF6WkWJNsQl74IRGb2y4q2gpWQhryicmi/vOkc123+Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ef95ueMA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2488E606A331;
	Wed, 18 Nov 2026 21:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ef95ueMA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7997B1F000CA;
	Wed, 18 Nov 2026 21:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037502;
	bh=15GSoaJBhea6/KV8w+GUGJb1Ybmg/RNawX7ab40hiSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ef95ueMAn6a0ItEqDWtA3Mtg/RPdSL8TZWubB3kAeQNVn5FQrjftTs08g4qvjeUzA
	 z1mReikvJnMD3qo2e/cM4D+zln9ZxyFGKAHnGB0LU/5/4hZPu4DLcLIs4bSCKthrIj
	 UrP36uVguSN8O2J+d2AaMluGa2UHd2OjY/gJd2Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1382/3318] media: adv748x: Fix endpoint reference leaks on probe failure
Date: Wed, 18 Nov 2026 15:33:24 +0100
Message-ID: <20261118150402.002159539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 359db09cf055497075a668b192f4578a0ed00955 ]

adv748x_parse_dt() takes an extra reference for every endpoint saved in
state->endpoints. If parsing later fails, adv748x_probe() skips
adv748x_dt_cleanup(), so the saved references remain held. A CSI-2 lane
parsing error also returns from for_each_endpoint_of_node() without
dropping the iterator's reference.

Save the endpoint reference only after lane parsing succeeds. Drop the
iterator reference before returning a lane parsing error and route all
parse failures through the endpoint cleanup path to release any saved
references. This retains the endpoints only for a successful probe.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 6a18865da8e3 ("media: i2c: adv748x: store number of CSI-2 lanes described in device tree")
Fixes: eccf442ce156 ("media: i2c: adv748x: Support probing a single output")
Cc: stable@vger.kernel.org
Suggested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 3eb6d5e8f0826..70594d0018048 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -675,9 +675,6 @@ static int adv748x_parse_dt(struct adv748x_state *state)
 			continue;
 		}
 
-		of_node_get(ep_np);
-		state->endpoints[ep.port] = ep_np;
-
 		/*
 		 * At least one input endpoint and one output endpoint shall
 		 * be defined.
@@ -689,8 +686,13 @@ static int adv748x_parse_dt(struct adv748x_state *state)
 
 		/* Store number of CSI-2 lanes used for TXA and TXB. */
 		ret = adv748x_parse_csi2_lanes(state, ep.port, ep_np);
-		if (ret)
+		if (ret) {
+			of_node_put(ep_np);
 			return ret;
+		}
+
+		of_node_get(ep_np);
+		state->endpoints[ep.port] = ep_np;
 	}
 
 	return in_found && out_found ? 0 : -ENODEV;
@@ -739,7 +741,7 @@ static int adv748x_probe(struct i2c_client *client)
 	ret = adv748x_parse_dt(state);
 	if (ret) {
 		adv_err(state, "Failed to parse device tree");
-		goto err_free_mutex;
+		goto err_cleanup_dt;
 	}
 
 	/* Configure IO Regmap region */
@@ -809,7 +811,6 @@ static int adv748x_probe(struct i2c_client *client)
 	adv748x_unregister_clients(state);
 err_cleanup_dt:
 	adv748x_dt_cleanup(state);
-err_free_mutex:
 	mutex_destroy(&state->mutex);
 
 	return ret;
-- 
2.53.0



