Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B6E3161A3;
	Sat, 30 May 2026 17:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161719; cv=none; b=S0xdDBdVQV3XAFxmFCsiEd7UnkuhIa9KteRff8e2ovyUPpI0NHyYDJT+dv95VSflQ1vDSRcRJVqBYcC2l8P6dBrCJo0//WogADJAOsQNt6mMsWuMZxNNBvhxAYFjwc5u8qazCluXrgRUt/9yjMGyu+aB4Fhrp2H+cat63m53MoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161719; c=relaxed/simple;
	bh=K5m2d8JceV5AVAAk0rfffIE1n2j4hMsyVhzQVnUE5MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oeIw0S/qP+T5yjc33bYgdNuCqBYVFp8pmWGeZCJEdssrzrxF+YEEV4slDFzuWbaNPgY2kbPnD2DqDIO7ETtQ3Yv1E0KIb4WmnWPeMVV1n3F9IL+os6o8vMVM71Ny1owAOfpa3fTL1CAGekro9ntApxjMq5uvLH8PlpIsSIi0OMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NT1WQUwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NT1WQUwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8921D1F00893;
	Sat, 30 May 2026 17:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161718;
	bh=scpuJIHigvMyEc86G7sYxtWx4z3/DFvqlIPRgDtMoG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NT1WQUwTJsIG6KKMzKoZs8082oVn1o6eqCdi8ng1dE8dAuev9tjAUHP04MhR4xhpB
	 8/aVX7a9+mMXtFHDIZScug76RGcA0qCdGD/YNvzVW3w+gh+c3Fjrl2ff8izQ3mt6Jm
	 qKCam7wuOxRfnKzN7PNrfb4Dl62X7w5RmNXjN1Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 707/969] slip: reject VJ receive packets on instances with no rstate array
Date: Sat, 30 May 2026 18:03:51 +0200
Message-ID: <20260530160320.047456349@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bf9e801cc61cc..3474792a37a67 100644
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



