Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF88A24E4C3;
	Thu,  2 Jul 2026 17:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011741; cv=none; b=SV1ciJ/KGp1ix2A+ygSHcayVAkhzsjhYlJUHVavoqoN7VuqWm8GE4sRoqgVxib3RjOdQshMuOzu19edeLKV0FPAnifKN3Qa7eKtQoNfMkXGBbGyd1BHr0t/avKt1CbNmM9cOb64EgJchhfvGdh0Gi8sjlDyM1jeWuFxcMyUJlA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011741; c=relaxed/simple;
	bh=wTcBaRMcmlwBZk6JfFBoYYT5E8fGowDvr2RnsWFp6Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYjQttX34G6BQKJz18XY4ZXQpPwirr8fAgrM2z82UZ0zLJBrwOyKBwopqyxeyq5UsBiJwJlShnQmeWivrDwc1acqHzl7cIorQfNMSO4JyCZWyoWdEHS4EAQKwQwQiZdwuimtQb19rqwTwYP7EXABXj5Saq/DwWLYJvBDPznSZ10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuG9rmQG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuG9rmQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DE11F000E9;
	Thu,  2 Jul 2026 17:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011740;
	bh=dE0kdmJgLLdqa8wF0V1fZGEk6VgVgpdFHG+vUR2U2uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuG9rmQGh5Vm2s7DVpsc1x5Ornov/GofUihgy87KAEYXSsw5S5W+O56UDHiPTBtn2
	 8Qjz6f8kG5vH8dv30n1v2FFk0zpSqoVsY0j73cOH4HSc3OwaJHbGp+XDtPmJFRgTa/
	 7NxFO8Z5hgm2iBUKYBNpcynDCZhtG2FE09IiJ8uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.1 115/120] NFSv4/pNFS: reject zero-length r_addr in nfs4_decode_mp_ds_addr
Date: Thu,  2 Jul 2026 18:21:51 +0200
Message-ID: <20260702155115.337077689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 41fe0f7b84f0cb822ae10ab08592996a592b2a25 upstream.

nfs4_decode_mp_ds_addr() decodes the r_netid and r_addr opaques of a
netaddr4 from a GETDEVICEINFO multipath-DS body, then immediately
calls strrchr(buf, '.') to locate the port separator. Both decodes
use xdr_stream_decode_string_dup(), and the current code checks only
"nlen < 0" / "rlen < 0" before dereferencing the returned string.

When the on-wire opaque has length zero, xdr_stream_decode_opaque_inline()
returns 0 and xdr_stream_decode_string_dup() falls through to its
"*str = NULL; return ret" tail, leaving buf NULL with a return value
of 0. The "< 0" check does not catch this, and the next line is
strrchr(NULL, '.'), a kernel NULL pointer dereference reachable from
any pNFS-flexfile client mounted against a malicious or compromised
metadata server.

Reject the zero-length cases explicitly so the decoder fails with
-EBADMSG (treated as a malformed GETDEVICEINFO body) instead of
panicking the client.

Cc: stable@vger.kernel.org
Fixes: 6b7f3cf96364 ("nfs41: pull decode_ds_addr from file layout to generic pnfs")
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pnfs_nfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -1075,14 +1075,14 @@ nfs4_decode_mp_ds_addr(struct net *net,
 	/* r_netid */
 	nlen = xdr_stream_decode_string_dup(xdr, &netid, XDR_MAX_NETOBJ,
 					    gfp_flags);
-	if (unlikely(nlen < 0))
+	if (unlikely(nlen <= 0))
 		goto out_err;
 
 	/* r_addr: ip/ip6addr with port in dec octets - see RFC 5665 */
 	/* port is ".ABC.DEF", 8 chars max */
 	rlen = xdr_stream_decode_string_dup(xdr, &buf, INET6_ADDRSTRLEN +
 					    IPV6_SCOPE_ID_LEN + 8, gfp_flags);
-	if (unlikely(rlen < 0))
+	if (unlikely(rlen <= 0))
 		goto out_free_netid;
 
 	/* replace port '.' with '-' */


