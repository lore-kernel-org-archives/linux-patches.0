Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40941198A31;
	Thu,  6 Jun 2024 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683062; cv=none; b=CjetR1SPGvrGDf9oyD+Y1472/A2eyTl8k4Dmhd8avx4cdoxwysYICF72kjqzDzj09JCSC+ilB5VNkdtUebvAbkkAI9LRaDRzj5benVTFD8M5SB1+UIlYo2F+B3DudqpLb/Afgqcz5VLn98lUlWOZ/utnECJAXNByhQARiL4U1F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683062; c=relaxed/simple;
	bh=KMLEbonCSLnKphYAz4JNRtjeRwf0BGrUJ8xrZ05rXfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvUf/M4aotYtSx16Y+X0RNaMrAPiPbemQkkrcCfkgvFlohDSGj/Yx0y85OCcJl1JIc5oFHACg8GmCaHGVzMM9805EOTPAcmqUEVbdrxOZa7xJD44YoHLGtnguJIv0kxAGuYxoAoEvqSKxBF1dV+rqzaTz5VQHCTq+koYhWaorpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o3gRkvgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o3gRkvgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDBDC2BD10;
	Thu,  6 Jun 2024 14:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683062;
	bh=KMLEbonCSLnKphYAz4JNRtjeRwf0BGrUJ8xrZ05rXfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3gRkvgS7wcQv0fVZblWxbVQuaKm2E2TVF0VSHoKDS1/l1eI5FpeuGCyyFgD8GALL
	 4bvCizPY9SRgSgP344EIBpFuWXk/DmsXozm/W+lu7eQSzR90Yb+jFgcdsF7hgkW0wU
	 76NTJY5J1XQOjgK7W0vtRHZ+f7l+iokpvAybDamE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 312/374] Octeontx2-pf: Free send queue buffers incase of leaf to inner
Date: Thu,  6 Jun 2024 16:04:51 +0200
Message-ID: <20240606131702.294169020@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 1684842147677a1279bcff95f8adb6de9a656e30 ]

There are two type of classes. "Leaf classes" that are  the
bottom of the class hierarchy. "Inner classes" that are neither
the root class nor leaf classes. QoS rules can only specify leaf
classes as targets for traffic.

			 Root
		        /  \
		       /    \
                      1      2
                             /\
                            /  \
                           4    5
               classes 1,4 and 5 are leaf classes.
               class 2 is a inner class.

When a leaf class made as inner, or vice versa, resources associated
with send queue (send queue buffers and transmit schedulers) are not
getting freed.

Fixes: 5e6808b4c68d ("octeontx2-pf: Add support for HTB offload")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://lore.kernel.org/r/20240523073626.4114-1-hkelam@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
index 1723e9912ae07..6cddb4da85b71 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
@@ -1407,7 +1407,10 @@ static int otx2_qos_leaf_to_inner(struct otx2_nic *pfvf, u16 classid,
 	otx2_qos_read_txschq_cfg(pfvf, node, old_cfg);
 
 	/* delete the txschq nodes allocated for this node */
+	otx2_qos_disable_sq(pfvf, qid);
+	otx2_qos_free_hw_node_schq(pfvf, node);
 	otx2_qos_free_sw_node_schq(pfvf, node);
+	pfvf->qos.qid_to_sqmap[qid] = OTX2_QOS_INVALID_SQ;
 
 	/* mark this node as htb inner node */
 	WRITE_ONCE(node->qid, OTX2_QOS_QID_INNER);
@@ -1554,6 +1557,7 @@ static int otx2_qos_leaf_del_last(struct otx2_nic *pfvf, u16 classid, bool force
 		dwrr_del_node = true;
 
 	/* destroy the leaf node */
+	otx2_qos_disable_sq(pfvf, qid);
 	otx2_qos_destroy_node(pfvf, node);
 	pfvf->qos.qid_to_sqmap[qid] = OTX2_QOS_INVALID_SQ;
 
-- 
2.43.0



