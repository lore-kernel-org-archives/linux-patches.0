Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040546;
	b=viC0xAy76ynDwLBnL2w3g8bjqc3UD3ZsRr6266arq8mF436cc2SBLGukKBMZqbVsAly/
	 DbjhzyuTkUX5IJ5Pv0RQMEaxU6AeNy4Fm6CNnNpRcDdUbTOz/vbkuD5WE0mLtQJLYQf+Q
	 ymwhQtZ6+OwhowepKJW25JAEvFhybxUoEMAv+CJGCBRnE7R+4N6sK96Z4PmjhhyY/bMD9
	 s+hGZaAVidGRJMtwTVhouLMVbDo0SF3ql1Yl8fMSrDMg1G7kqkoe57HaTteFouTwl0hMZ
	 Am6ue9gNkFc0K0mVwdJzIxUgYoeQLxltv3GsXoiZMxLo1hfbwfUsh2p4xDM+YfHSwHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8oDphVmYbKUwn3BHAFLPk9YvM4HG45yCuUGjo55/HJg=;
	b=dBXWL9gigilkNjQo/QN6WABVOK71IvT8SfHYtkACGcUivTe6NLnAYe8q/uY7uDQpgLa3
	 0wO6nZPa90sNtiby3fJI4nwwie9qDWBQyo52U9N74q7AOdCc+J4IpMnCXit2n9rXV2AUo
	 T5u699F5PvjmKTLtQAmCVRfXz+jQcPPAWI882W9D4h7qHx38FqfgwQrMKBpynw0KsuqWS
	 a7ALfzdZGDEt+bHw77tNe4hl1KQH8meVSIepf4KiWHLVBOQM+SxkiWwlLKiKjfeYG1PtV
	 YMEt059UAf4VG+L84BnOoxAceWmoqFfee+nh7gyzI0QnTI+fpAWKIwpeIpKAHSfNnqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oP7KSjxD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE5A606A320;
	Wed, 18 Nov 2026 22:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oP7KSjxD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444291F000C4;
	Wed, 18 Nov 2026 22:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040546;
	bh=8oDphVmYbKUwn3BHAFLPk9YvM4HG45yCuUGjo55/HJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oP7KSjxDR+7cmEdbvCYOT2tofIICMX0olOHY7sHv0ZahunkYsy3ydbIElzQ/LAhsT
	 AhXB32e1hc6+i8ON+PETQxTbyKTTxRibDRI/8V6CED41AJR/Jkl2bgc+nQBcytC6xf
	 A6AlWGrSZFSYK0GuMJ6nFNi2bAl7R2iRR9kD9uU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yili Zhang <zhangyili01@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2455/3318] RDMA/nldev: Fix NULL deref in dumps of objects abandoned by DRIVER_FAILURE
Date: Wed, 18 Nov 2026 15:51:17 +0100
Message-ID: <20261118150435.086198530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7607aee5994eb..60727e5a3c749 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -635,7 +635,8 @@ static int fill_res_cq_entry(struct sk_buff *msg, bool has_cap_net_admin,
 
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CQN, res->id))
 		return -EMSGSIZE;
-	if (!rdma_is_kernel_res(res) &&
+
+	if (cq->uobject && cq->uobject->uevent.uobject.context &&
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CTXN,
 			cq->uobject->uevent.uobject.context->res.id))
 		return -EMSGSIZE;
@@ -725,7 +726,7 @@ static int fill_res_pd_entry(struct sk_buff *msg, bool has_cap_net_admin,
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PDN, res->id))
 		goto err;
 
-	if (!rdma_is_kernel_res(res) &&
+	if (pd->uobject && pd->uobject->context &&
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CTXN,
 			pd->uobject->context->res.id))
 		goto err;
-- 
2.53.0



