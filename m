Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622591;
	b=gMNMVmX+0TFBJOplaSEnRSoujK/f/k6++pfwwkalwvV38Vdl2HYX0R59k7pkMFzUkgli
	 UM8tvQt96MceVvUY2hDA8vDn2k7yX0kDe+WiKFYqwJx0WGt28Lc8zxmM/l3YsEgs5SSiN
	 INofruhDEfmFKmNSWv4hNcjeyxUFhLqcZYiwKv59m1IrEUEADNQ1QIOFAM2IfJQCKk8Tf
	 BHacwsNapibw6bV1cG6jnOboAGY4wObb7dYYwMNVRx0/E3CzGlL+muumt2fg5zvX7XE6k
	 v4A2XqpI1QYF15WiQPYcbfrmlbJaqZSb6aPJeByaDJOfaY/swEVEKjNVyi+SQrU5nTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1OpGHx6yrJX/xckgNd5beOBV1HMgwUd2Ke8leYubhlI=;
	b=yc9fhVhhy6ynzxuNAmEigvfOdABfZzJNpVFbJY1O1P/2u5bs4X7QS6ly+/T1wUigUGBg
	 +WpBHiJYfYfm9VKa+Ag42RamsGTmx9wQ+I71W4lDg7lJXWmcG1uIldwUeBYKMK4ppNX3O
	 mJ4Bx+pIYpAgYSBnbVG50ndWht1GNOB6CEwzZ7BIcFB5JJuwudckhDVeiR+oH3QegTjSk
	 fzpiNSqp3aFSh08AqRFXi32tazWGMawwVEzNOuxmHj6AyrypHhxumhpKmcGOPbmBPF2Vp
	 CZpCn1YBtDR/5sIRmFFRnrqIGy9gJafxufxEpIUvikHUkMBcgEqytKXVGHI50+PR2bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Hj/aZ7p6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2254C606A338;
	Wed, 25 Nov 2026 16:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hj/aZ7p6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C7D1F000CA;
	Wed, 25 Nov 2026 16:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622590;
	bh=1OpGHx6yrJX/xckgNd5beOBV1HMgwUd2Ke8leYubhlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hj/aZ7p6+J0l/hvTR+DB7wVJT7081ZRvdUMRsEAUnJVUjrFn3HVOAgaQ1LX+v9JJq
	 Zq0y14trUAs84MHkih7vkdK4eqiApa/Td6UlIA2Et5UodnkyQyDOHWjd+wZ//CtTLJ
	 NYJ6JyWRBBBxwUaDA/+D/cQzUPkbppFi8ILEchD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 584/990] RDMA/core: Clear driver_udata before destroying objects in rdma_core
Date: Wed, 25 Nov 2026 15:32:31 +0100
Message-ID: <20261125143835.770504065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Backport keeps only the two rdma_core.c call-site hunks and drops the helper move to an inline, the create_qp() change and the NULL-attrs handling, since the helper stays a plain function in uverbs_cmd.c here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/rdma_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 18918f4633614..9503c7e90bd87 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -688,6 +688,7 @@ void rdma_assign_uobject(struct ib_uobject *to_uobj, struct ib_uobject *new_uobj
 	 * If this fails then the uobject is still completely valid (though with
 	 * a new ID) and we leak it until context close.
 	 */
+	uverbs_get_cleared_udata(attrs);
 	uverbs_destroy_uobject(to_uobj, RDMA_REMOVE_DESTROY, attrs);
 }
 
@@ -703,6 +704,7 @@ void rdma_alloc_abort_uobject(struct ib_uobject *uobj,
 	int ret;
 
 	if (hw_obj_valid) {
+		uverbs_get_cleared_udata(attrs);
 		ret = uobj->uapi_object->type_class->destroy_hw(
 			uobj, RDMA_REMOVE_ABORT, attrs);
 		/*
-- 
2.53.0



