Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68262D63E8;
	Tue, 31 Mar 2026 17:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976709; cv=none; b=Fc6HJF/MpAydquGJEsE/ncIeWBo0gqHHqHZCO/ep4D3Bzz/PP1+Co8K0nnp2sqrQrPYxsAZf6bd7ln7bwXqgRP+EfkNTikZWdw6LGYygy82E1blwMYj2yH1xBFaMGeEJCVAsG2CYNel4RWUFywwHPUifl8GMev9BOsDeEEPses8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976709; c=relaxed/simple;
	bh=pD78Wk7TFgwwJHCJP1yDY0jt2F6dRBFRWCmUjlg9zbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YfPeau1Lhxgtx5g5MGD83bX7RHqbAyna9efJtaFnHTMc9S7WEYgu75SWzRGRWT8Yu5R9XkKKkpbEYDF9VQGxJ1F6EwFzrkgNH3tSsTfQ/+3zFPIvNbTDzrI4BXW2nnliMeX/Vre3REPlnJsoU/+Z3XGMFgnJqA1f+8+rSX57N8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jriLP7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jriLP7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA68C19423;
	Tue, 31 Mar 2026 17:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976708;
	bh=pD78Wk7TFgwwJHCJP1yDY0jt2F6dRBFRWCmUjlg9zbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jriLP7wp9yN5Nd/Jdk/Tp789M987bNUx8GGeagPdrOU4qdx9ykr2B9jSCOp++YkR
	 UOkv8o7Zlfp3s1CmRrsJ7avJwq4443qeGvU8xYSsk6Ndna43wFW7UoPJUvi20aMj9+
	 GtXx3ibeMuuQWRlW7+27O22JjVXu/ZlW5hlSmXYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.18 196/309] RDMA/ionic: Preserve and set Ethernet source MAC after ib_ud_header_init()
Date: Tue, 31 Mar 2026 18:21:39 +0200
Message-ID: <20260331161800.671068720@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhijit Gangurde <abhijit.gangurde@amd.com>

commit a08aaf3968aec5d05cd32c801b8cc0c61da69c41 upstream.

ionic_build_hdr() populated the Ethernet source MAC (hdr->eth.smac_h) by
passing the header’s storage directly to rdma_read_gid_l2_fields().
However, ib_ud_header_init() is called after that and re-initializes the
UD header, which wipes the previously written smac_h. As a result, packets
are emitted with an zero source MAC address on the wire.

Correct the source MAC by reading the GID-derived smac into a temporary
buffer and copy it after ib_ud_header_init() completes.

Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
Cc: stable@vger.kernel.org # 6.18
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
Link: https://patch.msgid.link/20260227061809.2979990-1-abhijit.gangurde@amd.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/ionic/ionic_controlpath.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 4842931f5316..a5671da3db64 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -508,6 +508,7 @@ static int ionic_build_hdr(struct ionic_ibdev *dev,
 {
 	const struct ib_global_route *grh;
 	enum rdma_network_type net;
+	u8 smac[ETH_ALEN];
 	u16 vlan;
 	int rc;
 
@@ -518,7 +519,7 @@ static int ionic_build_hdr(struct ionic_ibdev *dev,
 
 	grh = rdma_ah_read_grh(attr);
 
-	rc = rdma_read_gid_l2_fields(grh->sgid_attr, &vlan, &hdr->eth.smac_h[0]);
+	rc = rdma_read_gid_l2_fields(grh->sgid_attr, &vlan, smac);
 	if (rc)
 		return rc;
 
@@ -536,6 +537,7 @@ static int ionic_build_hdr(struct ionic_ibdev *dev,
 	if (rc)
 		return rc;
 
+	ether_addr_copy(hdr->eth.smac_h, smac);
 	ether_addr_copy(hdr->eth.dmac_h, attr->roce.dmac);
 
 	if (net == RDMA_NETWORK_IPV4) {
-- 
2.53.0



