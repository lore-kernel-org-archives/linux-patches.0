Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A83E278161;
	Sat, 12 Sep 2026 15:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226825; cv=none; b=DhF7hW00nG2xEdts+yNJkut9VLC9VS45+7G4P/bkt9dPZDo4/BYcpVfjENfq5FS3dh7v1J8qg2t2pAEC6i4BZZje2aVh4XfNGFG5jPC3qETnVXFbIBeKC0i1kS96+J7Kg9XG9BYaM7XVviIF6IryJmXoTq3pt1zVeYGRIWWcIyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226825; c=relaxed/simple;
	bh=2DvrRqKHGjEmgA3CcwFzD2SqFWxSQ7qVOECwB+Awdpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmyQKRrmf+w257Ma9Yf6XTvaWcPQrxlEozFlw7HuEjXPysE/GqNL8TaDz9NTE/IlHKp2ExlFuBDA81PXl3RaoNxBO/QhUUg/XkFwp8nSbSi5kIp6buj2G4RZAZ1JWBLqMFaEPE2+7kj/PiFWsoVdnWw0OrvchI34GprqI46rNU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrGL0O4F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrGL0O4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF2F1F000FF;
	Sat, 12 Sep 2026 15:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226823;
	bh=YLsl2/n8IFL4dwl7gRL1Fvw4VwsTJsCkTLMvaEOekb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrGL0O4FdjqvMele7V/p2HhY0ejyHHwm5xiAE1LTSSBzN/TGRyqiYhjSG7ZeBbyAF
	 6eQ98fIKtWECaJszssBsvm8QCmh8iE08T0CyPBtiq3Kjmgv8b6nqril4c1pziNp/6K
	 hkPg419OOPtDmOVYaFQjQUfFChkmHzNXuXvxRWDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 0054/1191] nfsd: fix XDR padding calculation in ff_encode_getdeviceinfo
Date: Sat, 12 Sep 2026 08:46:22 +0200
Message-ID: <20260912065549.361963886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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


