Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B47F7868F;
	Mon,  4 Mar 2024 21:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588816; cv=none; b=K2arnGXD2ngA65ZFVR+pc1VNNdSyi5Xbk7JOqXUxGwa+mYBJku3ZZl1HnJg5/fBB7KAVte404ejzhR2tgp25dRcY8l4Mz7KNnYnoPbXArrBPyj7al3+RvdkVCVyjnQr+HphVZgjcfyk9fdeaRP9CcQYR/3MR3ip7hzDIMS4EZ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588816; c=relaxed/simple;
	bh=tBWkG0JQKtQfWflhFj2hWKMPGBdX1q6PdN3gciVCuP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdKYf+gAyc5r8TeYNW8uQcgMhyqWRrkO7PB8BGGrYp6wLNnXx5Z8oX3cGixdBAEM6QQmP8MKqmDJgGpSMblJYjcQo9Uebi4s7ywGAXbGpCQBbcaO7cSNzGrNOH9nPhbm62pifDq5PbkfW/mXSILHLD9NHwaS04YF+swrCXlrCkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKCQPEAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKCQPEAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1415C433F1;
	Mon,  4 Mar 2024 21:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588816;
	bh=tBWkG0JQKtQfWflhFj2hWKMPGBdX1q6PdN3gciVCuP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKCQPEASnRz6F1AMrTkA4Q3atI44ihoD7KcO5+5fdSJMDs5S7qXcqlhnVCpLtB8o6
	 vlcvovwe/XxFk22fTOfDbDEOkCPeq8N/reCAacAmFo2ph3Ydq3L3DPcxMra+Jug45U
	 O1lcTAJfyVFcKNq+cRgjCscVb2Lp3m/8CVbEdJQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.1 108/215] RDMA/core: Update CMA destination address on rdma_resolve_addr
Date: Mon,  4 Mar 2024 21:22:51 +0000
Message-ID: <20240304211600.462822769@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Shiraz Saleem <shiraz.saleem@intel.com>

commit 0e15863015d97c1ee2cc29d599abcc7fa2dc3e95 upstream.

8d037973d48c ("RDMA/core: Refactor rdma_bind_addr") intoduces as regression
on irdma devices on certain tests which uses rdma CM, such as cmtime.

No connections can be established with the MAD QP experiences a fatal
error on the active side.

The cma destination address is not updated with the dst_addr when ULP
on active side calls rdma_bind_addr followed by rdma_resolve_addr.
The id_priv state is 'bound' in resolve_prepare_src and update is skipped.

This leaves the dgid passed into irdma driver to create an Address Handle
(AH) for the MAD QP at 0. The create AH descriptor as well as the ARP cache
entry is invalid and HW throws an asynchronous events as result.

[ 1207.656888] resolve_prepare_src caller: ucma_resolve_addr+0xff/0x170 [rdma_ucm] daddr=200.0.4.28 id_priv->state=7
[....]
[ 1207.680362] ice 0000:07:00.1 rocep7s0f1: caller: irdma_create_ah+0x3e/0x70 [irdma] ah_id=0 arp_idx=0 dest_ip=0.0.0.0
destMAC=00:00:64:ca:b7:52 ipvalid=1 raw=0000:0000:0000:0000:0000:ffff:0000:0000
[ 1207.682077] ice 0000:07:00.1 rocep7s0f1: abnormal ae_id = 0x401 bool qp=1 qp_id = 1, ae_src=5
[ 1207.691657] infiniband rocep7s0f1: Fatal error (1) on MAD QP (1)

Fix this by updating the CMA destination address when the ULP calls
a resolve address with the CM state already bound.

Fixes: 8d037973d48c ("RDMA/core: Refactor rdma_bind_addr")
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20230712234133.1343-1-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/cma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4060,6 +4060,8 @@ static int resolve_prepare_src(struct rd
 					   RDMA_CM_ADDR_QUERY)))
 			return -EINVAL;
 
+	} else {
+		memcpy(cma_dst_addr(id_priv), dst_addr, rdma_addr_size(dst_addr));
 	}
 
 	if (cma_family(id_priv) != dst_addr->sa_family) {


