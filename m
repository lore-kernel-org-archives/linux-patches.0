Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19196455622;
	Sat, 12 Sep 2026 13:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219889; cv=none; b=SBT5fe19ZJ1ZE63f4xic9+3k90iuYxabU3XwJ1dZjcSW2GoHDvV50TForvRvhTWQdmH9+2GGTZvrlDu/G9Xh82qCCxNE8rj8oSVdDn/qzNwdY5iQQdgLkIDJicazwdwjLI19ZA/TyoenDFxvCUDCWKIabIhG/RJGpXUD+aUPA/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219889; c=relaxed/simple;
	bh=dovCXnDmgx9n1/GruZZXgF80oHp23z3t+kMF7scrk2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/8dYUor5oUrAwikBeZ3WjOxUwYNm/YjixrYTbDrDWTtv5zfXGBCGiIg1Q5LdjFYXcl2qtrKHoTBSf0QQfONQOp4jCMT0SoXzk8XcOKVXDPx9DUVe/QNUNy/pP1yQkSRTpJDI/epUNf0w9tiQ8/zoMJZUsSw9v/DfqeMJDc/RDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWMcnkyT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWMcnkyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D954A1F000FF;
	Sat, 12 Sep 2026 13:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219887;
	bh=3F5Xs2r7ThL1y0Au8YSnzW3fSiaFCKXewShr9teeO+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWMcnkyTjQEgnAQk+5WLEttd4tuxTS1dNr3ZuNutT9NTPcnloGoxYXTKmy1IrHPlG
	 xLAwiObpqGF21qi9SEaUMRMJ9ocR9WkHKY8KeUshJB9ADIKE5Co6sJMuyYb6cN6As+
	 jEusnnXTGdXFH0o3ICyiFDcy0xQBd6GWachby4Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0063/1424] nfsd: fix XDR padding calculation in ff_encode_getdeviceinfo
Date: Sat, 12 Sep 2026 08:41:35 +0200
Message-ID: <20260912065608.718126168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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


