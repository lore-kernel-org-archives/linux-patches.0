Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056368;
	b=Nn8x8GODBqRVIrNG3Ywz0DFZcpH0GOgQ7YHt/6oOph/3GAnLDiEHzPEzy5Au606cuo48
	 ekaGonOT7iFkuFL60nKwwS99B51orR/YHropbI9112/C16oGJ8C3hYLxtns0GgBfvKiky
	 x+ZkFIpux0fkvuOgm7716FZq95g4LshKozp2qr62sljZwm9OSk8f4iFAukbNN/56PimZf
	 DaPv/5u2pM2f5LohTfD1W633h0PVD4MXLNp6ONauiLgfMGbbK1nJdf1CxfMJXsK5inoMF
	 HRolpYeT5o1mjLsRJSF1e8lXOhp06uotol7RW4iWnP22wgbHA9MWCQN4Lm7as6BmzIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=23IFwup6Fjjjn089QkATMGTqqcgMF39W1G6nSXx9ZkY=;
	b=aMEcf/5Do6v2vuV8u77lCjTETj0hTpUXhV/I2WI6Gl0LTxWUJFq4eIoE/UKT5Om/Dwz9
	 UX7xBCvdGbuYPcbdDcNQI6oTmF/oeWNDNMpPshyy4U7KobEh4shsvKWJZ27LIPGHwebv/
	 x1v1H+NQN0bCXLv18mIbld45cAfT5sU/vSr/8JZSiysR/RQCoAJ5Clf8+2gsTX5Fy1lmz
	 643x/ILaUmWWi1xdO4NLKnPGkBHGsAddv+PDwBhNQE2gEklQnSlhIEUjvteWQv70HYCUV
	 H4w9Q5vK3Qe+tGZj1mJgzxIF7pAhwMBxvF0UWx4yDVups6mNzhk/VKwsjVKcbmWjJgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ys3w/9Xi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C73B606A31C;
	Thu, 19 Nov 2026 02:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ys3w/9Xi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16B91F000C6;
	Thu, 19 Nov 2026 02:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056368;
	bh=23IFwup6Fjjjn089QkATMGTqqcgMF39W1G6nSXx9ZkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ys3w/9XifXAWxvK/DxNYNiyOUbLsllzRmcCCWczc8t6L4H21hNrlO8dq1wBMVsxL3
	 eJILwpykiv8XGx5EHswKvdNlH3wCPYKbw5zlwb78IqV0jZY1BF8hEIvgGpjBpEM3Ep
	 3s7+4khC3bBg8QCpYktY7mn3+xpnjI+w0/z0cbXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1964/2214] RDMA/rxe: Create AH index and return to user space
Date: Wed, 18 Nov 2026 16:00:40 +0100
Message-ID: <20261118150129.505298374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 73a54932100375ba94b31710f1e3f1234f23be0b ]

Make changes to rdma_user_rxe.h to allow indexing AH objects, passing the
index in UD send WRs to the driver and returning the index to the rxe
provider.

Modify rxe_create_ah() to add an index to AH when created and if called
from a new user provider return it to user space. If called from an old
provider mark the AH as not having a useful index.  Modify rxe_destroy_ah
to drop the index before deleting the object.

Link: https://lore.kernel.org/r/20211007204051.10086-4-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 47a9c0338f2e ("RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 31 ++++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_verbs.h |  2 ++
 include/uapi/rdma/rdma_user_rxe.h     |  8 ++++++-
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index d3aef42aaa38f..fe5c890ccb8fc 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -161,9 +161,19 @@ static int rxe_create_ah(struct ib_ah *ibah,
 			 struct ib_udata *udata)
 
 {
-	int err;
 	struct rxe_dev *rxe = to_rdev(ibah->device);
 	struct rxe_ah *ah = to_rah(ibah);
+	struct rxe_create_ah_resp __user *uresp = NULL;
+	int err;
+
+	if (udata) {
+		/* test if new user provider */
+		if (udata->outlen >= sizeof(*uresp))
+			uresp = udata->outbuf;
+		ah->is_user = true;
+	} else {
+		ah->is_user = false;
+	}
 
 	err = rxe_av_chk_attr(rxe, init_attr->ah_attr);
 	if (err)
@@ -173,6 +183,24 @@ static int rxe_create_ah(struct ib_ah *ibah,
 	if (err)
 		return err;
 
+	/* create index > 0 */
+	rxe_add_index(ah);
+	ah->ah_num = ah->pelem.index;
+
+	if (uresp) {
+		/* only if new user provider */
+		err = copy_to_user(&uresp->ah_num, &ah->ah_num,
+					 sizeof(uresp->ah_num));
+		if (err) {
+			rxe_drop_index(ah);
+			rxe_drop_ref(ah);
+			return -EFAULT;
+		}
+	} else if (ah->is_user) {
+		/* only if old user provider */
+		ah->ah_num = 0;
+	}
+
 	rxe_init_av(init_attr->ah_attr, &ah->av);
 	return 0;
 }
@@ -205,6 +233,7 @@ static int rxe_destroy_ah(struct ib_ah *ibah, u32 flags)
 {
 	struct rxe_ah *ah = to_rah(ibah);
 
+	rxe_drop_index(ah);
 	rxe_drop_ref(ah);
 	return 0;
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index c852a9907bad4..446d14903cec5 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -48,6 +48,8 @@ struct rxe_ah {
 	struct rxe_pool_entry	pelem;
 	struct rxe_pd		*pd;
 	struct rxe_av		av;
+	bool			is_user;
+	int			ah_num;
 };
 
 struct rxe_cqe {
diff --git a/include/uapi/rdma/rdma_user_rxe.h b/include/uapi/rdma/rdma_user_rxe.h
index 2f1ebbe964345..dc9f7a5e203ae 100644
--- a/include/uapi/rdma/rdma_user_rxe.h
+++ b/include/uapi/rdma/rdma_user_rxe.h
@@ -99,7 +99,8 @@ struct rxe_send_wr {
 			__u32	remote_qkey;
 			__u16	pkey_index;
 			__u16	reserved;
-			__u32	pad[5];
+			__u32	ah_num;
+			__u32	pad[4];
 			struct rxe_av av;
 		} ud;
 		struct {
@@ -170,6 +171,11 @@ struct rxe_recv_wqe {
 	struct rxe_dma_info	dma;
 };
 
+struct rxe_create_ah_resp {
+	__u32 ah_num;
+	__u32 reserved;
+};
+
 struct rxe_create_cq_resp {
 	struct mminfo mi;
 };
-- 
2.53.0



