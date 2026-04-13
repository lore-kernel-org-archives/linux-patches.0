Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A1E2D8364;
	Mon, 13 Apr 2026 16:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098640; cv=none; b=cOknlLDKWh7XJC2xJQVfnatIv8/s+K/Jz+Igdy0vaZh/iS9UcNEJobsPpYc0hwUtpn2YndBZ1fU6tYWPfybQe8//r/4C/3Gni4+Ia4HE2OhTzDAEf0sWdr/T1ASFb9tJnp1Bx/RPIcBDnvb0Pzw1vDgIvrOXofSQJTwxX7eKhGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098640; c=relaxed/simple;
	bh=Nz7VrJQJKl/+uozBkHDmXAx3qKrI7vhIdbab43kE6To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fT6hFrzbKQ3/xaUlFC1BEhKS3kTU/3z6pZGnjGJAL7haMtvggSajKN/rZUenP9jjRZIzk1JkHLoiCrt0uAecYuDYZVyaxOnuAT9B6D3zG7t4O11kUYThHEE3qsWh2vtNHEsuVM7hU+9my34azV8/e37im630Ej+5sGaxXily+x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SW0VkG65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SW0VkG65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E30CC2BCAF;
	Mon, 13 Apr 2026 16:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098639;
	bh=Nz7VrJQJKl/+uozBkHDmXAx3qKrI7vhIdbab43kE6To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SW0VkG65ooInNeCMx3DQc3jrJ3SSrILD+eGY6NPi65mVfD6Y5hTkS7sA+MaPs+Uu3
	 Z2fbDPVR5mK2x/s1s/IYTTyXXPtBNecu4XWgIFlmeTibjptUEbyM1dDJf5HL1z2eKh
	 EaMLNu2W6IdvhT0c2tzUXsRgYBCrxgKmHMBWu1Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.10 030/491] IB/mthca: Add missed mthca_unmap_user_db() for mthca_create_srq()
Date: Mon, 13 Apr 2026 17:54:35 +0200
Message-ID: <20260413155820.180451344@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit 117942ca43e2e3c3d121faae530989931b7f67e1 upstream.

Fix a user triggerable leak on the system call failure path.

Cc: stable@vger.kernel.org
Fixes: ec34a922d243 ("[PATCH] IB/mthca: Add SRQ implementation")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/2-v1-83e918d69e73+a9-rdma_udata_rc_jgg@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mthca/mthca_provider.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -436,6 +436,8 @@ static int mthca_create_srq(struct ib_sr
 
 	if (context && ib_copy_to_udata(udata, &srq->srqn, sizeof(__u32))) {
 		mthca_free_srq(to_mdev(ibsrq->device), srq);
+		mthca_unmap_user_db(to_mdev(ibsrq->device), &context->uar,
+				    context->db_tab, ucmd.db_index);
 		return -EFAULT;
 	}
 
@@ -444,6 +446,7 @@ static int mthca_create_srq(struct ib_sr
 
 static int mthca_destroy_srq(struct ib_srq *srq, struct ib_udata *udata)
 {
+	mthca_free_srq(to_mdev(srq->device), to_msrq(srq));
 	if (udata) {
 		struct mthca_ucontext *context =
 			rdma_udata_to_drv_context(
@@ -454,8 +457,6 @@ static int mthca_destroy_srq(struct ib_s
 		mthca_unmap_user_db(to_mdev(srq->device), &context->uar,
 				    context->db_tab, to_msrq(srq)->db_index);
 	}
-
-	mthca_free_srq(to_mdev(srq->device), to_msrq(srq));
 	return 0;
 }
 


