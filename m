Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625328;
	b=HRA9jOYDDkzhnDLKojTMeWQpspCwrNdpdAUUZaZ8W27rtyXJ6CMtSD70JIWn9KaxMMlJ
	 Emei5+FQq8jGPIypBR8AOIyhjd/8QZyGC18BpbSSNlLo7QbLE01jlJwHkl4Y2uhj7CBuV
	 GWt6JfXL5j5snmf2fa120gA3YmgRdePVIM0VPnE5Mn+EyOk+BGMrYh9Zx3FOI1ck4ZvU1
	 qmYujeAzEte6uRMZxX+GFF3fdY+TeH9y4w0mcc0glYU6D74ZZyanGFNNoEiM9aj1/+kv8
	 8flF1/3Wnw/ym58PccWZfe2Dw6I9Ix1xH5RKPMnIss6k14al12SsWfADhognwukwuSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Afhq6mxqr5fOvgMwwYP96pNcqakGEYFL+EIMECiiJfg=;
	b=pMQ3lX6bTgc5E8v/s+g6qkmx4anR+Tpdxa0rOhN4QUt/3yWdh0T1QyaMDCKfohQS1f/9
	 NQslUFMQQogcn0owxs1KpJZKntsM6xGFQc8PPfcsTgMsJM+6e7Q492tH1jlgxaoUO/cNY
	 GLdZx/VI/Q6F35He4toQwNbizfeXJd7360MEuUOXr1qf6ilwRSMRYUi3rfDVnIdOXx+W9
	 N1ff2fdNv5EntYCOeFUDtX6GwJJQzHX9Q6YyjcZGX3TakMV3X5IbBpZ86Mlxs2YtH3Gnp
	 a7Fi0SafwqkRAhyRl/DJhffKKlL1gN0B+QlioJUnRmx5Kq/Z9MsbNX7yNEfMOS+VIRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxQShF+a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0DB606A321;
	Wed, 25 Nov 2026 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxQShF+a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1C81F000C4;
	Wed, 25 Nov 2026 16:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625328;
	bh=Afhq6mxqr5fOvgMwwYP96pNcqakGEYFL+EIMECiiJfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxQShF+au62OA+/hPlqSRz20pLmHIWHYWVMwE7ogc5Ev7je/nlCz/ZeV0faLqPveA
	 X7APAj4BD6YIuOwgVW8s37Vv6UB+iryyuJXgbePGhx4lrZBJsgrVnXzznqbMgV/WhZ
	 at+g3YwqbPUo7FvuUofbLO107duK3/KRPeg43fW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 481/816] RDMA/core: Clear driver_udata before destroying objects in rdma_core
Date: Wed, 25 Nov 2026 15:33:49 +0100
Message-ID: <20261125143900.330569126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit d37e98844afea39a9614cac0de837701263c90f7 ]

When uobject creation fails while copying user output data (i.e.,
after the HW object has been created), it calls
rdma_alloc_abort_uobject() with hw_obj_valid=true which then
invokes the object's destroy callback, but passes the
uverbs_attr_bundle from the original creation command.

The issue is that drivers are expected to validate the udata
and return an error if there's unexpected content, and data from
the wrong command counts as "unexpected content", so this ends
up causing the driver's destroy call to fail.

A similar issue exists in the rereg_mr path when a new MR
is created and the old one is destroyed.

Fix this by clearing driver_udata before invoking the driver's
destroy method.

Fixes: 6e0954b11c05 ("RDMA/uverbs: Allow drivers to create a new HW object during rereg_mr")
Fixes: 0ac8903cbbe6 ("RDMA/core: Allow the ioctl layer to abort a fully created uobject")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20261006152908.888059-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ sashal: Only the two uverbs_get_cleared_udata(attrs) calls in rdma_core.c were applied; the upstream helper move to a static inline in rdma_core.h and the create_qp() cleanup were dropped because this branch's layout differs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/rdma_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 29b1ab1d5f933..54d008e9ae85a 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -687,6 +687,7 @@ void rdma_assign_uobject(struct ib_uobject *to_uobj, struct ib_uobject *new_uobj
 	 * If this fails then the uobject is still completely valid (though with
 	 * a new ID) and we leak it until context close.
 	 */
+	uverbs_get_cleared_udata(attrs);
 	uverbs_destroy_uobject(to_uobj, RDMA_REMOVE_DESTROY, attrs);
 }
 
@@ -702,6 +703,7 @@ void rdma_alloc_abort_uobject(struct ib_uobject *uobj,
 	int ret;
 
 	if (hw_obj_valid) {
+		uverbs_get_cleared_udata(attrs);
 		ret = uobj->uapi_object->type_class->destroy_hw(
 			uobj, RDMA_REMOVE_ABORT, attrs);
 		/*
-- 
2.53.0



