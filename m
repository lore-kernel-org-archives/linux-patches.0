Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F002DF73;
	Mon,  8 Apr 2024 13:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581747; cv=none; b=UfKGJtWYTZ+5SBd1nSctWYV50kp7eb12npp/X0FKstf/FVT1eEhP1xphtkhFmGRxNvmH5bL01ogrpBi54pVB/irMoFN4QLKaYxv6rmZ0o96EL5/5C7TUfRGcknyomow0pI/QVg2AZvOiExwziaqjZ/55Kfn9FDO5r+n+MbPZKBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581747; c=relaxed/simple;
	bh=3IKvIMv6e7cdIr67xFQxLqNsLTbCR0bLP7AzPs+byXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VR0UOljyItYJU3TtA5W87pD+5j70wJTPd5q4XBeRpiBNdYoRqHluC/NP7YtKxNZGAAOOONNcXHbGPqNNyCnYLywaTWhDfy02LOd7rPkIOLqQXkfKZVacPaJYGyx7Yb32uqmHMwC7re9jO2KX3C15AFnSEfDVzyh9WBOONHg+Vw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPCqZK6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPCqZK6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CBAC433F1;
	Mon,  8 Apr 2024 13:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581747;
	bh=3IKvIMv6e7cdIr67xFQxLqNsLTbCR0bLP7AzPs+byXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPCqZK6XgoUTWrIdIEjqlZNU+qofWJKioTSvPXcCJPRyk3Xap1Ic4A/l6dFUQ14Mh
	 MW1zh+jK94p2/RFWFFBesssfqmV/kLdKWKRDndRHPx0GzkluGE9ScfkgcYxJQYOPS1
	 voVUZ6E4JHKpGIo+VEe7cg9j3Blz0mwIgg7Q7iGk=
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
Subject: [PATCH 6.8 017/273] ixgbe: avoid sleeping allocation in ixgbe_ipsec_vf_add_sa()
Date: Mon,  8 Apr 2024 14:54:52 +0200
Message-ID: <20240408125309.830348877@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 13a6fca31004a..866024f2b9eeb 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -914,7 +914,13 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
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
@@ -930,14 +936,8 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
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



