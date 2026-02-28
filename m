Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE6533344A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301270; cv=none; b=cFHftkIio0uILx+JcTMhbwoQ6lWTjzPJbam8p7q+RdYmwSc/1bWrgaoAn0sU5H0B1HfZIVf5ldDyeCpg20D6rZKxMnPc5punrhX4RbgcsE7n0mH9B8XQEMbvqwnEkUWmyK97ztVMYnXDlQNhnCyMQSN9/obwYM6qQQYcvZcuDPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301270; c=relaxed/simple;
	bh=NjVMZIFF01Ct9/8k1rhQgQ8mLN3iYbuKfSR59VHi294=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUcQf+ECOf9Tf92+PuioPXbUKoQSzshUTx4jswzGYtGHu+mXjvXIfPVyNZ+fmQy8S7JHxrbPmIyuOp94QP8O0YRRjqzGa9nfbbjt4B5ecv93bF+PscJQBn3V5N9Bb7PPR+8JrhMmddhJkWAzZIpM+RUIWVlRmzFw8p9wO91DCZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=st1ohSxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="st1ohSxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BACC19424;
	Sat, 28 Feb 2026 17:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301270;
	bh=NjVMZIFF01Ct9/8k1rhQgQ8mLN3iYbuKfSR59VHi294=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=st1ohSxR6mHtJCqoMcjA3pZyOMcnnjwnzKataz47FV66rjT28oZZYmRVNcwZguoUf
	 OmJaBOuL/hc89PUhOJuXmI3q2hzzos/NVTQLxu5TDtTUc3LJiUe34aQo9PgeBCOfL6
	 ZrsNdmor1hFdLLGatJ39lKJBPa3o07nTLZpggJCn0xDa0ky5ral4T12ZYXmbDiE4uJ
	 QtEI23HbFdR6H+lPXLdMLoBog6AcSbTCxEC+uKTEElL7sbIxtaPm+Gqf2k4C6+q9PT
	 xBR1/F8JLgUxOXU7vMkPZGEGT6qcJ/H48sACh7WKexu6HNEczeTLBTjxsu5ADFivo2
	 knpOEHSj6X2RQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vahagn Vardanian <vahagn@redrays.io>,
	Florian Westphal <fw@strlen.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 454/752] netfilter: nf_conntrack_h323: fix OOB read in decode_choice()
Date: Sat, 28 Feb 2026 12:42:45 -0500
Message-ID: <20260228174750.1542406-454-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vahagn Vardanian <vahagn@redrays.io>

[ Upstream commit baed0d9ba91d4f390da12d5039128ee897253d60 ]

In decode_choice(), the boundary check before get_len() uses the
variable `len`, which is still 0 from its initialization at the top of
the function:

    unsigned int type, ext, len = 0;
    ...
    if (ext || (son->attr & OPEN)) {
        BYTE_ALIGN(bs);
        if (nf_h323_error_boundary(bs, len, 0))  /* len is 0 here */
            return H323_ERROR_BOUND;
        len = get_len(bs);                        /* OOB read */

When the bitstream is exactly consumed (bs->cur == bs->end), the check
nf_h323_error_boundary(bs, 0, 0) evaluates to (bs->cur + 0 > bs->end),
which is false.  The subsequent get_len() call then dereferences
*bs->cur++, reading 1 byte past the end of the buffer.  If that byte
has bit 7 set, get_len() reads a second byte as well.

This can be triggered remotely by sending a crafted Q.931 SETUP message
with a User-User Information Element containing exactly 2 bytes of
PER-encoded data ({0x08, 0x00}) to port 1720 through a firewall with
the nf_conntrack_h323 helper active.  The decoder fully consumes the
PER buffer before reaching this code path, resulting in a 1-2 byte
heap-buffer-overflow read confirmed by AddressSanitizer.

Fix this by checking for 2 bytes (the maximum that get_len() may read)
instead of the uninitialized `len`.  This matches the pattern used at
every other get_len() call site in the same file, where the caller
checks for 2 bytes of available data before calling get_len().

Fixes: ec8a8f3c31dd ("netfilter: nf_ct_h323: Extend nf_h323_error_boundary to work on bits as well")
Signed-off-by: Vahagn Vardanian <vahagn@redrays.io>
Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://patch.msgid.link/20260225130619.1248-2-fw@strlen.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 540d97715bd23..62aa22a078769 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -796,7 +796,7 @@ static int decode_choice(struct bitstr *bs, const struct field_t *f,
 
 	if (ext || (son->attr & OPEN)) {
 		BYTE_ALIGN(bs);
-		if (nf_h323_error_boundary(bs, len, 0))
+		if (nf_h323_error_boundary(bs, 2, 0))
 			return H323_ERROR_BOUND;
 		len = get_len(bs);
 		if (nf_h323_error_boundary(bs, len, 0))
-- 
2.51.0

