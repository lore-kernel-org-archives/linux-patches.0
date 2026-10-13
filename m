Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE88F282F2A;
	Tue, 13 Oct 2026 12:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894634; cv=none; b=Lt95aE6faCVziyx5mpNkNMxUxYEXBzK3/rWGFcPVSJARN7sQT42RMohsAEDpWtENuV/6iX+MHFvy1ypxX9eQ8OpJA6rvW9isXs63jDeiQfKLMedbNj7B/LI0l67zdsUFUV/zkYxe7UnJ1br2SDsX8SFj3E/b6otI+KwxgtFiGgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894634; c=relaxed/simple;
	bh=+yqNQRbKSLJTOdgbVGC6X6f+nMoqRswqItuE2y7IZG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYNlIKxAnGfJYhtHSb7cpe52vygEM271YZqyqvMFVDPHDpG4P0kYGH9+lpI0esps+q0JDaskygE85jiNgwCRRqkZ7dv/QCLlCOzsi4Lw3Nlilv62YcsMUgpXAGtO3owhOknpFxX21CoGzBEox10zcp+e9tUZc68qoPGEjh27WA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqpXvOAX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqpXvOAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F761F000FF;
	Tue, 13 Oct 2026 12:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894632;
	bh=doduISBU8cN+F7mNlmTX1yDHzgNN14yso9/pA2FkXmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqpXvOAX5gGuFnr8kSaCIu2yGFxondcx57ysvHaD1GEzFtpUgKjIbODXlipo/8Ybw
	 aaUDl96qw/v9kljAkFH1ECT+bfbcTPiIMPBHTsCT7lPyOPBVK/fjuTldf30sX8SxM1
	 QSKFgWvkrRUFQ09EWXj4gTkWJcuiQDtKblJiwXqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 583/621] net/sched: cls_route: reject change with no routing attribute
Date: Tue, 13 Oct 2026 13:39:38 +0200
Message-ID: <20261013112934.639206000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit b72e025ac556984766392001e74b7587e145bcd0 ]

route4_change on a filter change that supplies no routing attribute
at all (no to/from/iif) reaches route4_set_parms with fold set, so the
handle-mismatch check -- which only fires when creating -- is skipped.
nhandle is built as the all-wildcard bucket (0x8000 | 0xFFFF << 16) and
the filter is rekeyed to 0xFFFF8000, so the handle userspace already
stored no longer addresses the filter. (The netlink reply carries the
new handle; what goes stale is the handle the caller holds.)

The rekey actually misclassifies the packets. The new handle's from_hash
is the wildcard chain (route4_hash_wild), whose filters route4_classify
applies without any id/iif comparison, and its bucket (256) is reached
by every packet through the h < 256 restart. A filter that matched only
a specific realm therefore becomes an unconditional catch-all that applies
its classid and actions to all otherwise-unmatched traffic.

Reject a change that would rekey the filter this way, with the
routing-attributes-required error. A change that names at least one of
to/from/iif, and an in-place replace that keeps the routing identity via
a supplied attribute, are unaffected. A change of a filter that already
sits at the wildcard handle is a metadata-only update and remains valid,
so only a change that actually moves the handle is rejected.

This is a follow-up to commit 41e85e54e564 ("net/sched: cls_route: Fix
in-place replace"); this patch closes the no-routing-attribute variant
that the parent series did not address.

Conditions to recreate the bug:
  tc qdisc add dev lo clsact
  tc filter add dev lo ingress protocol ip pref 100 route from 1 to 1
  tc filter change dev lo ingress protocol ip pref 100 handle 0x10001 \
      route classid 1:2
  tc filter show dev lo ingress   # handle became 0xffff8000; iproute2's
                                  # stored 0x10001 no longer addresses it

A change of a filter already at the wildcard handle, e.g. one created by
"tc filter add dev lo ingress protocol ip pref 100 route classid 1:1"
(iproute2 defaults the handle to 0xffff8000), stays a valid metadata-only
update.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260907192133.2639067-1-victor@mojatatu.com
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/QDISC-0JB3.v1.20260929143022@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_route.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index ac32c083f6335..1a41237d07aac 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -434,6 +434,12 @@ static int route4_set_parms(struct net *net, struct tcf_proto *tp,
 	if (handle && (!fold || nhandle == (handle & ~0x7F00)))
 		nhandle |= handle & 0x7F00;
 
+	if (fold && !tb[TCA_ROUTE4_TO] && !tb[TCA_ROUTE4_FROM] &&
+	    !tb[TCA_ROUTE4_IIF] && nhandle != fold->handle) {
+		NL_SET_ERR_MSG(extack, "Routing attributes required");
+		return -EINVAL;
+	}
+
 	if (handle && !fold && nhandle != handle) {
 		NL_SET_ERR_MSG_FMT(extack,
 				   "Handle mismatch constructed: %x (expected: %x)",
-- 
2.53.0



