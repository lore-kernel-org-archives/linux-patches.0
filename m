Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CF035C69C;
	Sat, 12 Sep 2026 19:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240990; cv=none; b=SP+i83DekVgTyUGyHqLY0KuImxbUX3h8u6CloNeShTRm9AknV6aAuoC8k66Z9Cl7RzAZKGw+9aSl/YjTfW+0qv1PnfpMEAGpnE5DMKG2djb2Y0Q2mnSY2XZQxK+PTk6lqcheyY5gbzGoZDykLiUBPtn7DBHAbXiyVovxeyVbMEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240990; c=relaxed/simple;
	bh=1Au3jD3kuxA+Mqrg9Nr9JkLTbI4TueJm4PTJyMOawXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCGcfEf6orCH/naSV7sNm/vcKfX2WzgWSreuTn8lIbbPvt8Czi+kIJ0vo8yuPeMVsRKjayJknf9qWf6SFzwEaBrtrdJK20szSXJvuA4WgQt98moiGc+uiKcmsF6oDaIxx6FWwZnWCmjjp2bpmqG8es7vwdnFD4nDS8nBYydSr2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjamfXWv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjamfXWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4B31F000FF;
	Sat, 12 Sep 2026 19:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240989;
	bh=f6EJXzsjcljdqn8MsTwG8Uh5j0CUNYYmtVftlhRlgpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjamfXWv9mOn2RdaVNdzI7ZhV8hAGwD8GzT3Ds/468txOhS/9x5+4VpbaJw4YiWXc
	 zKg+1QgZlb2Vnh2cTYNCguXHcQ1JAs+3YA9gDXdqjfrkA1/xzPNQclT+Mo0rnAn1Zh
	 f8zflBI/g90H3QSfu3j0EwruzRR/z7HVV+lFvUgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 043/798] nfsd: fix XDR padding calculation in ff_encode_getdeviceinfo
Date: Sat, 12 Sep 2026 08:54:31 +0200
Message-ID: <20260912065517.948250667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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


