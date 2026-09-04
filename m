Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3483876CC;
	Fri,  4 Sep 2026 05:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500675; cv=none; b=EMM+UTGnDLu3D5ZY3fkfKW8XVz4A78PuwdnbM3zrXdKC9KKzk1GCONfMcVbr2cjk7FBAMbeUyuasy25xtHuri8bcfq/28VPBkJbd5b/7FI3VFq/mS+HkBTGfN5E3C20pBZhI5X9C+8a4keMJTi6yHCy0p7NNurp3xNnODIhA+rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500675; c=relaxed/simple;
	bh=Q4DocQY8si6PmuDkYHcDpDYCSv+Zmd0w7d1daMWkI/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRqBUMjue7L0SYA2AuiZdZ1FrN2bsRnFLQqjKEJtuny77USoDY9xZrNuUxUyYbhQ3678s7o2081TswDCgXPKkQzI2z5B3YO30nXIjjY9bQiNAWX4FeQS4p2VyLxslZhasT5Y7CXsO/WJnNrwNQqpTzMoYanbCY+ocMgGA0Fvej8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewBoH4Dn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewBoH4Dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEED1F00A3D;
	Fri,  4 Sep 2026 05:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500674;
	bh=zDkABiG+4RuOhRcyhte8ShDZQkduHuHa1WPGTqpy3/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewBoH4Dn5giLPJU4u5AdjsFKfy/ta/QsY1Xf2CVfF/OlyXgn+iC62FN2cv+9YLDgs
	 1AIYruF5zyXZsUPKcjE9Xo2gVeXEGZATX42UMPHCMv3GdqsY+v5BqbX4AZzy75/1xK
	 L79SKQZmt4230Sd1iOfL3xyZaGGKx3+k1U4mVRkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 140/552] nfsd: fix XDR padding calculation in ff_encode_getdeviceinfo
Date: Fri,  4 Sep 2026 06:54:57 +0200
Message-ID: <20260904045751.678284253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


