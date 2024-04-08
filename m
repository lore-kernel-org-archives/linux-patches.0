Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A826F08B;
	Mon,  8 Apr 2024 13:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581349; cv=none; b=CQ9UK1Zws7DmxIcUEUv54WbQ8+ZaVKRS8I5w3lw2cD+6ab97XZpUmrT97dSrjTX3BAH2bRpTLvOpq4/4OAd4axCC61kRS51+BcwkCO4xFmVWbQlBE3RhsgdkykuNcpi5nQtU+eBrKpf/F28nbPXXlk0jRi90bISpCJtGpo7MjA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581349; c=relaxed/simple;
	bh=3LiNNVZcyDaKQqpM4bKfBctEBlW985j/OtCmY/IX6aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpsuPPQo2WIFSy9Alr5DlD5prew6UJlSBG/LLygRtPv7i8KRvko42NCDpN+nmhIyFLvLKAshtBNrkKpYQVa2c0rV8BmnYPVC4bZ30McMbYYJKNHhEUM5iH93RTcs3pHLAqqw4E/brKA7NLU+16K/jzyURwaAAKjYEI+N6BqXL54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYQ/Hicz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYQ/Hicz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8A0C433F1;
	Mon,  8 Apr 2024 13:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581349;
	bh=3LiNNVZcyDaKQqpM4bKfBctEBlW985j/OtCmY/IX6aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYQ/HiczMugNwJZjgRaqH51wb2eUruTRNtqf823pRo3GqTfvSLIIeDEDdGf8dQfSG
	 pR7y3w1Y1vDQc5c/p4gCcRWnSAtmsBusabiCO6QB2Zp6vs/doqPk0SCBqri2c3GA8i
	 wPrgp4WiltumJuGmLNxN7lqTyu8/1/ZV9CdhLQbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.1 006/138] ixgbe: avoid sleeping allocation in ixgbe_ipsec_vf_add_sa()
Date: Mon,  8 Apr 2024 14:57:00 +0200
Message-ID: <20240408125256.423082655@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit aec806fb4afba5fe80b09e29351379a4292baa43 ]

Change kzalloc() flags used in ixgbe_ipsec_vf_add_sa() to GFP_ATOMIC, to
avoid sleeping in IRQ context.

Dan Carpenter, with the help of Smatch, has found following issue:
The patch eda0333ac293: "ixgbe: add VF IPsec management" from Aug 13,
2018 (linux-next), leads to the following Smatch static checker
warning: drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c:917 ixgbe_ipsec_vf_add_sa()
	warn: sleeping in IRQ context

The call tree that Smatch is worried about is:
ixgbe_msix_other() <- IRQ handler
-> ixgbe_msg_task()
   -> ixgbe_rcv_msg_from_vf()
      -> ixgbe_ipsec_vf_add_sa()

Fixes: eda0333ac293 ("ixgbe: add VF IPsec management")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/intel-wired-lan/db31a0b0-4d9f-4e6b-aed8-88266eb5665c@moroto.mountain
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index 774de63dd93a6..15fc2acffb871 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -908,7 +908,13 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 		goto err_out;
 	}
 
-	xs = kzalloc(sizeof(*xs), GFP_KERNEL);
+	algo = xfrm_aead_get_byname(aes_gcm_name, IXGBE_IPSEC_AUTH_BITS, 1);
+	if (unlikely(!algo)) {
+		err = -ENOENT;
+		goto err_out;
+	}
+
+	xs = kzalloc(sizeof(*xs), GFP_ATOMIC);
 	if (unlikely(!xs)) {
 		err = -ENOMEM;
 		goto err_out;
@@ -924,14 +930,8 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 		memcpy(&xs->id.daddr.a4, sam->addr, sizeof(xs->id.daddr.a4));
 	xs->xso.dev = adapter->netdev;
 
-	algo = xfrm_aead_get_byname(aes_gcm_name, IXGBE_IPSEC_AUTH_BITS, 1);
-	if (unlikely(!algo)) {
-		err = -ENOENT;
-		goto err_xs;
-	}
-
 	aead_len = sizeof(*xs->aead) + IXGBE_IPSEC_KEY_BITS / 8;
-	xs->aead = kzalloc(aead_len, GFP_KERNEL);
+	xs->aead = kzalloc(aead_len, GFP_ATOMIC);
 	if (unlikely(!xs->aead)) {
 		err = -ENOMEM;
 		goto err_xs;
-- 
2.43.0



