Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590131;
	b=bvpB0IccHEgHqjw7UE2MCcGdH5ik0Q1VZIEi5x7/j98oZOeyTYvDQEMhOyijKMsl1EfM
	 zpfBnJth8yiTRUA2QMTx2ltkn4R/2FIKXM+fbc34WtNnAto3GCTzzFL5tZmTb+kdsb1cA
	 WFb9s21kdV4Ek2qDuEf/CgUIFZs+0446scFQpIz4WxncaAjUUkK0krf1cTY0XQ3bOhi4Y
	 zoIE/bzSoWD81Xc8nyr95rGzwnz+2mv9meaaiCuqgYlMxCn+M7q4A7ANHj/DPhmMzk2jk
	 DIDutSnu8rf5c76+3ujE48j27RjlHlR8CxJ6mRx7PXqPjQaXH9mGc9BbjVksz+Zs7HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=76oxpdTph8asvsgzvAwTWVsfNs2wIDExwrWKp9PMIhc=;
	b=0Rd7c9ZygSJmRApsKATl3sPfBDlzNg/oW6UOOfhnU9uTn9H8eanRuOKx455XCHspzbSq
	 rOSklRPK4ZO9oz7Z35br+QZaz9bkOCal+7V3nlH9DNS21D9glMunGB8ws6ujVI0Qthexa
	 jKUotnUQ/UPqDiZSlbuFvMO1bc9q/epktolbJRowemOBtehiwzEw7mklyjbCS/gUIOjNb
	 /o7tekwsOQwPov+jfZWOA2u9V2IybQgPcW7DzgOo92H97OTAcxh7UquuMWuHm/To7vOno
	 p5MJs06AajkVlS7lZ6kALtB32PPV/v9+TnenGoW4KVS+RUQuP2aQPaJB/SITV4qwvYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aLZ2T/ZB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88C160A5BC8;
	Fri, 13 Nov 2026 17:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLZ2T/ZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5566F1F000D0;
	Fri, 13 Nov 2026 17:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590131;
	bh=76oxpdTph8asvsgzvAwTWVsfNs2wIDExwrWKp9PMIhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLZ2T/ZBLkjsmLmeHHpAnRWgW1UU9rkXjehp+fObM/LR102LHCT1tQuQG5ENjv88x
	 GQSGqHVTtViHHLVtjF8yEUr1eSDQyZc3HB81f40/61mZntJ5QcO5LQclV+aqq0hTT3
	 O9jpTS6i7cdQiTkneSYpTQloEa6c03UWlkulgfP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/686] media: adv748x: Fix endpoint reference leaks on probe failure
Date: Fri, 13 Nov 2026 10:44:44 -0500
Message-ID: <20261113153825.912441477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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



