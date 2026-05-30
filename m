Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1181217704;
	Sat, 30 May 2026 18:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165354; cv=none; b=gb3GHbOVX7ke5mRASAxn0OryctXCt581/Ak3bfYadWi3K5Tc6+U3DPRVZiC13GsAPOQxKNigPV9+rsRk0IiywSrHjPxTlbxDSAt0jgGiwgkcY5gDnbjPG3ELTh50kTjDjkc6jNT6Zps9OGMoWI3aJ2aMOrsZYGy9bRUaytWq8XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165354; c=relaxed/simple;
	bh=0aSysfY0QNO4MQ+uM+Ef66pYSQ/MQyhCgo4iujUZ3+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/VVh7u98sBD6myrk+r2c21zdGWzm4As0fGaW/kJ7Cz3Ar1bxAaQAfNEAm5hl0NwKEg506nQ5gNmnX2XL2jVZmwByUiUowUZKwp5v3JNEfgfvknxVdt10QuSpu/MGL5KfzzpIf6NTnasgGhQaJq3x+58uRa3nFoVGB8tTYJpkBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fg1Y/yvc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fg1Y/yvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BB71F00893;
	Sat, 30 May 2026 18:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165353;
	bh=djMas0v1UMkTQ+r2rTXTEy4L/wg97MWH3utA0AHIDDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fg1Y/yvcQEI3s9Q1QDWD+O7mLjmAf6SOl2Fw2pcZx8Nl/SBf0k4pZqacuU3yUrb8+
	 M8XZ3taYwxLQ6C38LB9jihp/tUhbjFjhQ/SeJlx93Qei5PyQB+BOmu3qcFDmBLHeWG
	 0G58CxdwMnG2kdReQq4rahcQxqpkGh7I3q3KYeO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 053/589] usb: gadget: f_ncm: validate minimum block_len in ncm_unwrap_ntb()
Date: Sat, 30 May 2026 17:58:54 +0200
Message-ID: <20260530160225.986715297@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8f993d30b95dc9557a8a96ceca11abed674c8acb upstream.

The block_len read from the host-supplied NTB header is checked against
ntb_max but has no lower bound. When block_len is smaller than
opts->ndp_size, the bounds check of:
	ndp_index > (block_len - opts->ndp_size)
will underflow producing a huge unsigned value that ndp_index can never
exceed, defeating the check entirely.

The same underflow occurs in the datagram index checks against block_len
- opts->dpe_size.  With those checks neutered, a malicious USB host can
choose ndp_index and datagram offsets that point past the actual
transfer, and the skb_put_data() copies adjacent kernel memory into the
network skb.

Fix this by rejecting block lengths that cannot hold at least the NTB
header plus one NDP.  This will make block_len - opts->ndp_size and
block_len - opts->dpe_size both well-defined.

Commit 8d2b1a1ec9f5 ("CDC-NCM: avoid overflow in sanity checking") fixed
a related class of issues on the host side of NCM.

Fixes: 2b74b0a04d3e ("USB: gadget: f_ncm: add bounds checks to ncm_unwrap_ntb()")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Link: https://patch.msgid.link/2026040753-baffle-handheld-624d@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ncm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1218,8 +1218,8 @@ parse_ntb:
 
 	block_len = get_ncm(&tmp, opts->block_length);
 	/* (d)wBlockLength */
-	if (block_len > ntb_max) {
-		INFO(port->func.config->cdev, "OUT size exceeded\n");
+	if ((block_len < opts->nth_size + opts->ndp_size) || (block_len > ntb_max)) {
+		INFO(port->func.config->cdev, "Bad block length: %#X\n", block_len);
 		goto err;
 	}
 


