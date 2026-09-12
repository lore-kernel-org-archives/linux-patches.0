Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDD630568E;
	Sat, 12 Sep 2026 17:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232615; cv=none; b=ik4AIgUAV932hV/D2KcJ4rI+hQ9l8agdTcihJjHcVWzc8lfIGTYS1flOgMRoySpd6MZTiU6ucNrIYa8lzOIkjunSHSoc5etgcY1wAlW5rtwseR2nTxwOOvUR7jnNKv8hP1KkMua5Dekvbor+OIy8YHXODDu+qg2Ku2x6s0+0oz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232615; c=relaxed/simple;
	bh=KAd14VimcOODeIx/VnLpMoUlG2JRYuR8kNYE+6l2EYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0S5y6s7013UPvoWMHrgH352RYCAuqdR4JyaeTx8lHTdu9DPcHOneF4LUebkH3NSnSS4u/0NdCWk7HwBdPRfFsEFI64f6jtU27r4ncjvny8x4vadPyT1KAT1+cpMFT7H7foRzSy5kAuqShWqE6nyafxIZvO2Csze1rUpJx7RGrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15wYkby6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15wYkby6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0929B1F000FF;
	Sat, 12 Sep 2026 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232614;
	bh=phQxMA+TGRggq4B8DO/tPTv7LhT/1agxolNOEHKicBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15wYkby6weI40Hr3zCcCyGno7Os1EWghb3oH+yM68uS/P9bdc5iKP4+ttAn9MxwsG
	 9NADbRqd4rUC0twy9Jiam/dOz8R560uMTZ4MWHlbcuKUc7Ah39Egv/iU1LKfnlplrc
	 MFxXOg3bbuRDzMgX0KfB/H2f/GXe/o5Y6bn0/F/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 047/935] nfsd: fix XDR padding calculation in ff_encode_getdeviceinfo
Date: Sat, 12 Sep 2026 08:51:17 +0200
Message-ID: <20260912065527.918732864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 8b989aaec85e1293a871d602590c951fe44b8647 upstream.

nfsd4_ff_encode_getdeviceinfo() computes the da_addr_body reservation
as 16 + netid_len + addr_len, but the subsequent xdr_encode_opaque()
calls emit 8 + round_up(netid_len, 4) + round_up(addr_len, 4) bytes.
The mismatch means the declared da_addr_body length exceeds the actual
encoded data by 2-8 bytes on every flexfile GETDEVICEINFO reply,
leaking stale reply-page content to the client and mis-aligning the
subsequent version list decode.

Use xdr_align_size() for each string length to match what
xdr_encode_opaque() actually writes.

Fixes: efcae97fa425 ("NFSD: da_addr_body field missing in some GETDEVICEINFO replies")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260527-pnfs-fixes-v1-1-784f39dc1eca@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/flexfilelayoutxdr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/flexfilelayoutxdr.c
+++ b/fs/nfsd/flexfilelayoutxdr.c
@@ -99,7 +99,8 @@ nfsd4_ff_encode_getdeviceinfo(struct xdr
 	}
 
 	/* len + padding for two strings */
-	addr_len = 16 + da->netaddr.netid_len + da->netaddr.addr_len;
+	addr_len = 8 + xdr_align_size(da->netaddr.netid_len) +
+		   xdr_align_size(da->netaddr.addr_len);
 	ver_len = 20;
 
 	len = 4 + ver_len + 4 + addr_len;


