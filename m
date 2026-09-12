Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4044F478E5D;
	Sat, 12 Sep 2026 11:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213378; cv=none; b=fQYnJLQFf2B8JmgZz9+U4kmySnL5Dp8OVoHmPfePSLb3Jfpnr4i8r+CoFxRMVMybjkhoUIlRyWnZ+vym5Rrrm2h/0MSruRK5rMxi1GLgJnQGwR0zCXKW78Dqdw1Y/5io6ybj25CrvjsQt7ZAenIPM4zPk24hgKi/znyYu0u18sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213378; c=relaxed/simple;
	bh=DgNdLe5yR4dINcclrv6M0daYT/POAAiHlVz8DfSc96Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvj8rnIJxy8WO7wX6PkTU1g7+uKtZHIyrUucvZrWhvgBmFIhV3AtF+gz4yyFqqj7f4PqnW7iPelTXh53SHzBi3nP6MNPNeJOKUxIp8cIFkjp5jmurGT7Rm795a9fnPC65J+HjylHUM+7HHlFyu5xJmpSFIf+Ln6Vxe3bq+0S9I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnlaZL5h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnlaZL5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC161F000FF;
	Sat, 12 Sep 2026 11:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213375;
	bh=gQeQIDGbcp5Zwgon/EpkBwFeWZ35USGKF+drcCmh1Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnlaZL5hLS1SwvbqUo+jvfCQ3NwJu8Y48zNkPwGcvvL0P2aih0Yda2a07lNpH/zjH
	 Q40HudgVeQH0WBGZzC+Qq2yTAowFyZJA5pt/wi/xzP0Hlv/DbX6PC/ngqqFHezwGUE
	 xohetcvUoP4z3yuPqV8UvoelylVAM5xpODwVu07o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 6.12 0092/1376] nvdimm/btt: reject an arena whose nfree is below the lane count
Date: Sat, 12 Sep 2026 08:41:58 +0200
Message-ID: <20260912065609.613227578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 6a1f2e5ed9267ca19187038ac635393c165213ac upstream.

The BTT info block's nfree field, the number of reserve free blocks, is
read from the medium without validation.  btt_freelist_init() and
btt_rtt_init() size the per-lane freelist[] and rtt[] arrays by nfree,
but the I/O path indexes them by the lane from nd_region_acquire_lane(),
which is bounded by nd_region->num_lanes (ND_MAX_LANES), not by nfree.
A crafted or foreign arena whose nfree is below the lane count makes
freelist[lane]/rtt[lane] run past the allocation: an out-of-bounds write.

btt.rst documents the nlanes = min(nfree, num_cpus) invariant, which the
code does not currently honor: num_lanes is ND_MAX_LANES regardless of
nfree.  Reject an arena whose nfree is below num_lanes at discovery,
before the per-lane arrays are allocated, enforcing that invariant.

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260620-b4-disp-88b2514b-v1-1-3834e707d232@proton.me
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/btt.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -885,6 +885,14 @@ static int discover_arenas(struct btt *b
 		arena->external_lba_start = cur_nlba;
 		parse_arena_meta(arena, super, cur_off);
 
+		if (arena->nfree < btt->nd_region->num_lanes) {
+			dev_err(to_dev(arena),
+				"nfree %u smaller than lane count %d\n",
+				arena->nfree, btt->nd_region->num_lanes);
+			ret = -ENODEV;
+			goto out;
+		}
+
 		ret = log_set_indices(arena);
 		if (ret) {
 			dev_err(to_dev(arena),


