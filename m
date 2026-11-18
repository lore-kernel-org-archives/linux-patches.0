Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046139;
	b=nAWGMFTmbAOBTZF+54k9SGvWlJFOkLyMh6Hcs9D2b/4dzGaPXKmwYec11l4i4zxtKXpu
	 UPTQGUZ+O5emjD7G3Itz/KV4WHmYQBJVCXJq+ju673JTR2dR0q2f882GSbhUuFACVMDdV
	 d9rTAubTFseQhXY0By2dRq0lk7VU+jsp8IYpFL8KezICa4Px72kiyF/HmCi8rTZq2Wqny
	 CUX9moSd7HZ+h842QHbjaEDmSb4Auu4UAk94oOodDH0+SkIeiMtH/bLuuCvzGaewXz4QZ
	 eIdASBrUB4ZaDlRk6pf8UkRvJAqYOwOmM8c1jscP3Pxo0vsokHH9cs1afqHZvnvgpvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NdYaQm4r7+m1/NeCf4ueNkyIeMqRxWF6zWGYg9+LSiA=;
	b=VDUTm/5nDGwHCUb92MzOsK7dB3NyMXW/C/DyjyFzz51OC+PGIX7oMpxvKHXSChGPPxVe
	 syjT//0eKaAcD2DnodsTHO/EHxx2ZMpwoYg2O3zXPDLKrCVi/xvDN/BmTaI4Bqycsj6Bt
	 AH8f0GFx4CsYtP4tS1Eci/SPJ9itpOzk11Ed95HfDq2ZO3mTFjzyNI9D2wwIBByulHdx7
	 jVzneOZy9L8QOUHdbNhw9OJUzt1FbSQDidDrWOLjrmNZ14/B5bIsaJ2s6osW9WYkAdLze
	 wbFbiKNVovlNFuJ+1ZJGOVzQXWwnWb7HVewWOetubFuzy7AZ0aztszorZsVxacdQ3Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mqm+E4lm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8997E606A31C;
	Wed, 18 Nov 2026 23:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mqm+E4lm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB07F1F000C4;
	Wed, 18 Nov 2026 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046139;
	bh=NdYaQm4r7+m1/NeCf4ueNkyIeMqRxWF6zWGYg9+LSiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqm+E4lmkz6u5TQPpNQ9HumonahTd5b1otYHHehqZCjqI9j6x6JchRmDTmMS4xDQZ
	 PsSWvgS6Arif0HWT/HitZ7iWwB6n1+BwRQeWW+APZgzovd7gZI06nXjGHoUle4f+c9
	 dClXGeih6Qd1ua0rseRdg+1v/j4XZelEFThVOReE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1175/2857] media: adv748x: Fix endpoint reference leaks on probe failure
Date: Wed, 18 Nov 2026 15:36:49 +0100
Message-ID: <20261118150243.909028100@linuxfoundation.org>
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
index 4498d78a23570..54bc23cff4bb8 100644
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



