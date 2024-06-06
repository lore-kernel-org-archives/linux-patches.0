Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515FD1A255D;
	Thu,  6 Jun 2024 14:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683749; cv=none; b=i62ZyYn6A3k9YIU+puST/lg1diHPRaoIZKj4VwrUJQ3Nd07QwZm19rJHt/LAfwf3eP8ACyYFQse4YAeed/+MCnOCkdI0IwBjEhordxGnfIg/S9l4Rg1RXiAZja8TYRKl/ZBsqcNr6ykbbiMS3pMXSHiF6666NPmlMIQsAdhsODk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683749; c=relaxed/simple;
	bh=CJcEr8fiR++Vdmou8s2N3gcNsRFdYp3GVxoMMawYRRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnLtrhckjI6WRaTGWlnkdwpA/pOLJc0s7ZStpH7ON+9Cru0AH0LL6iUjJO4Ek25i5x+07/6LR4EnViIrXHIwZKuv4UaECaKl6WzbqCxH4kIeN5n3BNvDx439nzwywTU6EXSplOeZ1ZEDw46VBNQQgKXT8l338Em25BoLwqy119A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2ozHs/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2ozHs/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F306C2BD10;
	Thu,  6 Jun 2024 14:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683749;
	bh=CJcEr8fiR++Vdmou8s2N3gcNsRFdYp3GVxoMMawYRRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2ozHs/sxSE7rN+swqI2T+MNBmTZ6Djpva5WXKUw2TJJArW7+p4ngjmjRQVVktGTn
	 TjUFHam29V9WELGn7oyZIs2NNblHGuYm+t88z5agBkgdRIgqGmP/wFWkFM456kSGuV
	 Yug1CVhKRqoYbu8M4QfVK9fKYdn0JDLmhQsbjvC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 699/744] Octeontx2-pf: Free send queue buffers incase of leaf to inner
Date: Thu,  6 Jun 2024 16:06:11 +0200
Message-ID: <20240606131754.899038610@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



