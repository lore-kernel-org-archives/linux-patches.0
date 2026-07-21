Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D6A3B6C06;
	Tue, 21 Jul 2026 20:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666807; cv=none; b=hzC5RpGwx9p82Yvx+I3n8w2RBddb3KTN9UEwg1zMCfpVCJFsRSfwUz/mTJTKqCrx7FC2YpIqHurR7Ot9RHw6eTOAZG/8sX7Wi5I5gTfs0G5reUABHWmalpn2CPOhedSjGTYMnZ8Ih8auptdS2UEz+YMy/Dk0SvKyFmb6f9XitEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666807; c=relaxed/simple;
	bh=BYN7eeJ0sGWwk/PXY5wEOiNkWOytYfrgOL1icxQOq3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuErrMnH2uMhJn+kJ8niiyscRhN2eTZodHBPEyrAMh4ze9adq3urfyJT3913RZPNDgqWYLDoF8Qvy00lzLtioJl6mEvlvNY3Hw0rVDqTXQgNUSnXjy4GH4IghToedYQdj5J/CeyvHl88y+Sn/4azJIo8/7T9NA5MGzpH60Q3c28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDF4j3Qm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDF4j3Qm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61631F000E9;
	Tue, 21 Jul 2026 20:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666805;
	bh=sBd25uaRAHTuZnhfzhG2kchS5FHoijQr/tGZC41UrjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDF4j3QmJ87zueZikDeT/6HMD6G66Nh58j8IA2prhRQMdU0yll00bkEVQVrIawN5W
	 s1nplxS589U5VgD75aqsv2gQeykVXA+QNhGE7YuRKpBtqgFcgbE+G0wU2E9fcn9rbT
	 CRzzfmwh5pFg7zvvPbdgH72x/F9O3txsn1hSqcTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Markov <markov.gi@npc-ksb.ru>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0820/1266] cxgb4: Fix decode strings dump for T6 adapters
Date: Tue, 21 Jul 2026 17:20:57 +0200
Message-ID: <20260721152500.208363139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gleb Markov <markov.gi@npc-ksb.ru>

[ Upstream commit 5d6dc22d62682d93f5f55f145ad792f2891de911 ]

Depending on the value of chip_version, the correct decode set is selected.
However, the subsequent matching with the t4 encoding type in the if-else
block results in a reassignment, which leads to the loss of support for
t6_decode as well as reinitializing of values t4_decode and t5_decode.

The component history shows that the if-else block previously used for
this purpose, as well as the execution order, was not affected by the
change.
Furthermore, it is suggested by the execution order that the scenario with
overwriting and loss of support will be implemented.

Delete the if-else block.

Fixes: 6df397539cb0 ("cxgb4: Update correct encoding of SGE Ingress DMA States for T6 adapter")
Signed-off-by: Gleb Markov <markov.gi@npc-ksb.ru>
Reviewed-by: Potnuri Bharat Teja <bharat@chelsio.com>
Link: https://patch.msgid.link/20260629130856.1168-1-markov.gi@npc-ksb.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 175bf9b1305888..1b8247bd9e9bf6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -6737,14 +6737,6 @@ void t4_sge_decode_idma_state(struct adapter *adapter, int state)
 		return;
 	}
 
-	if (is_t4(adapter->params.chip)) {
-		sge_idma_decode = (const char **)t4_decode;
-		sge_idma_decode_nstates = ARRAY_SIZE(t4_decode);
-	} else {
-		sge_idma_decode = (const char **)t5_decode;
-		sge_idma_decode_nstates = ARRAY_SIZE(t5_decode);
-	}
-
 	if (state < sge_idma_decode_nstates)
 		CH_WARN(adapter, "idma state %s\n", sge_idma_decode[state]);
 	else
-- 
2.53.0



