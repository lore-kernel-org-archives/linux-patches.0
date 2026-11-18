Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017861;
	b=z2q33zMuOha+o9/gsOmSH0fWazqXAhzQD40rwQzJu4pmn93Jne7dn0vDvqjn1L/MmGW8
	 xRiWjxBlfkJ+9fOsWxxsg00FxeJhwPAGCg2rInJepKAQzqVTCQYMsjEnUhmPp24MIbF+e
	 +xMnpm3i0haiH66xdqw+FguouwZTKMJIh6lJrbmq6X9qYPUfwXrN/0VXyTplghK+3zoIU
	 70NG/cnR8UHYQ/8UQGgO+ggxy/nmnaKAEIXiL7OzAt1HZgP+rHepoxXX7KBsggBEBKEXX
	 l8mq9q/wh49OtcPHZZFxLD5OUpUMkXmqvf4PR+hoMblFmTyKgorS5VZ4U5A21c8+jXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lI/N+d1IiuRs2uQfPveDVmSUsUeepxDuWrbWWPT+EL4=;
	b=Il2AsiqCR0IpC+AGsz2fsc1t5ItM2N7rq/FD+JOU+B+X8JgaVMcLvvuycsM8CsS/Fy1I
	 l+g1bV6VjcF1veMF/9I+oi3WqWLifJv28Dd2oPmtrNLpLbmbmeg+XGAa5j/9Gti93HTV0
	 Oqp+BYs2bXlaakwmr7Wee/RQ4PxR1lHjiQQp8TvTUj8OAQluxSG3Be+434VJdXtXyjzbH
	 SDYi5rIF00YVgdIgsfFxErsFfLWXara53XGpCAE/OwWcNfhCbmCDzDgh1XsmEMwyGpWj+
	 2KAsnZAOX5J+J/5SPWtsdIu5+FYnvcp5+gg1QQbIwcluBHrJhkIlyHcofXQC3Foioug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CIuraUWS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0187606A31C;
	Wed, 18 Nov 2026 16:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CIuraUWS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E821F000C4;
	Wed, 18 Nov 2026 16:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017861;
	bh=lI/N+d1IiuRs2uQfPveDVmSUsUeepxDuWrbWWPT+EL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIuraUWSx0UnLp1iATQb2eH65Czq7DNPP1wKR3z3Z/GR6JLZ84cIs/hdrpl9z5kXL
	 /1Am98Kzd0cyxKaOa7Kpj1TXTv7NTynub2Mky9dpAYIazGFVeb7p7v36D2s2frkdyW
	 79o73fhsuFjhCIkWCLjEZR5me45IHyQQ9MNFvrns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yili Zhang <zhangyili01@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1034/2651] RDMA/nldev: Fix NULL deref in dumps of objects abandoned by DRIVER_FAILURE
Date: Wed, 18 Nov 2026 15:37:54 +0100
Message-ID: <20261118150325.192116170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yili Zhang <zhangyili01@baidu.com>

[ Upstream commit 9f4c322be27bf617cad2f4a15f6c6024a69e220c ]

fill_res_cq_entry() dereferences cq->uobject->uevent.uobject.context->res.id
unconditionally for user resources.

This is normally safe by ordering: destroy_hw() removes the resource
from the restrack before uverbs_destroy_uobject() clears ->context,
and the XA_ZERO_ENTRY marker set by rdma_restrack_begin_del() hides
the entry from concurrent netlink dumps.

The ordering breaks when a driver keeps failing to destroy an object
during ucontext teardown. uverbs_destroy_ufile_hw() then falls back to
__uverbs_cleanup_ufile(RDMA_REMOVE_DRIVER_FAILURE), which
abandons the object in place: the HW object and its restrack entry
are intentionally leaked, while the uobject bookkeeping is torn down
and ->context is explicitly set to NULL by uverbs_destroy_uobject().
rdma_restrack_del() is never reached, so the orphaned entry stays in
the device restrack with a valid kref, reachable by any subsequent
netlink dump.

Observed on 6.1.52 with MLNX_OFED 24.10, after an mlx5 FW failure
left a process unable to tear down its CQ (destroy_cq FW command
failing during FD close):

  WARNING: ... uverbs_destroy_ufile_hw+0xe3/0x100
  BUG: kernel NULL pointer dereference, address: 0000000000000058
  RIP: 0010:fill_res_cq_entry+0x15e/0x180 [ib_core]
   res_get_common_dumpit+0x304/0x530 [ib_core]
   nldev_res_get_cq_dumpit+0x1a/0x20 [ib_core]

The faulting chain maps to the source (CR2 = 0x58):
  cq->uobject            (struct ib_cq +0x08, res at +0x98)
  uobject->context       (struct ib_uobject +0x10, NULL after abandon)
  context->res.id        (struct ib_ucontext +0x58)

The recent restrack rework (8d186210677c and its series) moved the
restrack deletion to the start of the destroy flow and thus fences
concurrent dumps from an object being destroyed, but it does not
cover this case: when destroy fails, rdma_restrack_abort_del()
restores the entry, and the RDMA_REMOVE_DRIVER_FAILURE sweep still
never removes it from the restrack.

>From the fallback until the device is unregistered, any "rdma res
show cq" deterministically takes the NULL pointer dereference; this
is a long-lived state, NOT A RACE. The dump path holds neither the
restrack lock (dropped before the fill callback runs) nor
ufile->hw_destroy_rwsem, and rdma_restrack_get() only guarantees
that the res memory stays alive, not that ->context is still valid.

Fix the dump side: check the uobject context directly instead of the
rdma_is_kernel_res() marker. A non-NULL uobject already implies a
user resource, so kernel resources keep being skipped, and the
additional ->context check skips the RES_CTXN attribute for
orphaned entries instead of crashing the dump. The orphaned resource
itself remains visible in "rdma res show" (cqn/cqe/usecnt/pid),
which is what an operator needs after the accompanying uverbs WARN
to diagnose the driver destroy failure.

fill_res_pd_entry() has the same pattern (pd->uobject->context->res.id)
and is fixed the same way; a PD can even reach the fallback without
its own driver callback failing, e.g. uverbs_free_pd() returns -EBUSY
while another object that failed to destroy still holds the PD usecnt.

Fixes: c3d02788b45a ("RDMA/nldev: Provide parent IDs for PD, MR and QP objects")
Signed-off-by: Yili Zhang <zhangyili01@baidu.com>
Link: https://patch.msgid.link/20260923131239.6521-1-zhangyili01@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 3f715a1faaeca..849a5db54e1cb 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -700,7 +700,8 @@ static int fill_res_cq_entry(struct sk_buff *msg, bool has_cap_net_admin,
 
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CQN, res->id))
 		return -EMSGSIZE;
-	if (!rdma_is_kernel_res(res) &&
+
+	if (cq->uobject && cq->uobject->uevent.uobject.context &&
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CTXN,
 			cq->uobject->uevent.uobject.context->res.id))
 		return -EMSGSIZE;
@@ -790,7 +791,7 @@ static int fill_res_pd_entry(struct sk_buff *msg, bool has_cap_net_admin,
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PDN, res->id))
 		goto err;
 
-	if (!rdma_is_kernel_res(res) &&
+	if (pd->uobject && pd->uobject->context &&
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CTXN,
 			pd->uobject->context->res.id))
 		goto err;
-- 
2.53.0



