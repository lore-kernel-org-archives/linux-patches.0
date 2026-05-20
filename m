Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CD42D7386;
	Wed, 20 May 2026 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296496; cv=none; b=T2f8sK36G/Pwnqm1lnnaApAdtPdEG6K4QfMXwifCYZYs4/PlEF9bj1wvQZGYSOSyD9shGzSZTEKCpXU8AR2HPifTdCCj/8Q6YoJ7LH4kY3rYX94gfC2ig30WqbKrUX9wbjr5PT5SAgEhly1YVVl1hO6lR0t6Dro2ii98J8Dl1Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296496; c=relaxed/simple;
	bh=7IcxnzKp/rC8T7mGRtXOy/17LcCqmv24EVKavi6Jj18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipqTVy6FT0Y4fkLOtmwLvMf0aVQwxa7UmxLMznjSe+kEukeA00snEtD6fzoAjEfC5IuVQt4eG7jh2yctCDxoMB91d6FDCUlI81m+6u6BidBFu2d5hpRUaMsssAD0PNPu/Yn2i6oA4DVLm9rj9Tl5ZVfxO3mPI3LAgLjzJCfOyxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSMsEePL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSMsEePL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2EE1F00893;
	Wed, 20 May 2026 17:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296495;
	bh=A5ZpKAmquhfWrTOo8I42kqcYeoWKBP+EbqhOzqIUr7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSMsEePL3bXV306cOJ0tcgYDemjYq0LC0EhQXm2w8fGkKTRAqq1wbjL+i/k/a89p/
	 RwcntjkAlnSrnC0Brok9sjGAHOKXhkHcb/tpd6IXIZ7ApIc+5vnun2vOPPA7HH8lyQ
	 8j/34CZRhiBUfPXGDw0pPo9Uk8M9H9X7md1vHnGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0819/1146] slip: reject VJ receive packets on instances with no rstate array
Date: Wed, 20 May 2026 18:17:49 +0200
Message-ID: <20260520162206.764942525@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit e76607442d5b73e1ba6768f501ef815bb58c2c0e ]

slhc_init() accepts rslots == 0 as a valid configuration, with the
documented meaning of 'no receive compression'. In that case the
allocation loop in slhc_init() is skipped, so comp->rstate stays
NULL and comp->rslot_limit stays 0 (from the kzalloc of struct
slcompress).

The receive helpers do not defend against that configuration.
slhc_uncompress() dereferences comp->rstate[x] when the VJ header
carries an explicit connection ID, and slhc_remember() later assigns
cs = &comp->rstate[...] after only comparing the packet's slot number
to comp->rslot_limit. Because rslot_limit is 0, slot 0 passes the
range check, and the code dereferences a NULL rstate.

The configuration is reachable in-tree through PPP. PPPIOCSMAXCID
stores its argument in a signed int, and (val >> 16) uses arithmetic
shift. Passing 0xffff0000 therefore sign-extends to -1, so val2 + 1
is 0 and ppp_generic.c ends up calling slhc_init(0, 1). Because
/dev/ppp open is gated by ns_capable(CAP_NET_ADMIN), the whole path
is reachable from an unprivileged user namespace. Once the malformed
VJ state is installed, any inbound VJ-compressed or VJ-uncompressed
frame that selects slot 0 crashes the kernel in softirq context:

 Oops: general protection fault, probably for non-canonical
       address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: 0010:slhc_uncompress (drivers/net/slip/slhc.c:519)
 Call Trace:
  <TASK>
  ppp_receive_nonmp_frame (drivers/net/ppp/ppp_generic.c:2466)
  ppp_input (drivers/net/ppp/ppp_generic.c:2359)
  ppp_async_process (drivers/net/ppp/ppp_async.c:492)
  tasklet_action_common (kernel/softirq.c:926)
  handle_softirqs (kernel/softirq.c:623)
  run_ksoftirqd (kernel/softirq.c:1055)
  smpboot_thread_fn (kernel/smpboot.c:160)
  kthread (kernel/kthread.c:436)
  ret_from_fork (arch/x86/kernel/process.c:164)
  </TASK>

Reject the receive side on such instances instead of touching rstate.
slhc_uncompress() falls through to its existing 'bad' label, which
bumps sls_i_error and enters the toss state. slhc_remember() mirrors
that with an explicit sls_i_error increment followed by slhc_toss();
the sls_i_runt counter is not used here because a missing rstate is
an internal configuration state, not a runt packet.

The transmit path is unaffected: the only in-tree caller that picks
rslots from userspace (ppp_generic.c) still supplies tslots >= 1, and
slip.c always calls slhc_init(16, 16), so comp->tstate remains valid
and slhc_compress() continues to work.

Fixes: 4ab42d78e37a ("ppp, slip: Validate VJ compression slot parameters completely")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260415204130.258866-2-bestswngs@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/slip/slhc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/slip/slhc.c b/drivers/net/slip/slhc.c
index e3c785da3eef3..e18a4213d10ce 100644
--- a/drivers/net/slip/slhc.c
+++ b/drivers/net/slip/slhc.c
@@ -506,6 +506,8 @@ slhc_uncompress(struct slcompress *comp, unsigned char *icp, int isize)
 		comp->sls_i_error++;
 		return 0;
 	}
+	if (!comp->rstate)
+		goto bad;
 	changes = *cp++;
 	if(changes & NEW_C){
 		/* Make sure the state index is in range, then grab the state.
@@ -649,6 +651,10 @@ slhc_remember(struct slcompress *comp, unsigned char *icp, int isize)
 	struct cstate *cs;
 	unsigned int ihl;
 
+	if (!comp->rstate) {
+		comp->sls_i_error++;
+		return slhc_toss(comp);
+	}
 	/* The packet is shorter than a legal IP header.
 	 * Also make sure isize is positive.
 	 */
-- 
2.53.0



