Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E8330676E;
	Sat, 30 May 2026 17:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162323; cv=none; b=m1vCkGM3PhdJtjlI/WyLTjO/mi1NwCM1KIGNLJ5TT4J4Tan03fW3tAywOTqGxifoaks6DGUiigwxYOBWO3s3gY+v5C8ZX5M/tQSGm38ooAbdAVj6p1V2E2mPNtMUxSNmuwbvLuN1l2dHTlKKwgnMNsOM3EdqaK7+XttUAIxPiXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162323; c=relaxed/simple;
	bh=7uR9PrUYEHPOkMrWZ9twOAgbNIiy7bq8T22rt5xVQeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4HaXIlBiC0a+yP0dC5MzdftjW5jHkzQYwc1H5+PvDrVJpeypgzSyuFyGx/QN9nZQYLh7ju2zB2+bW50DH9Aixd85ExcXhtisbs5oMZV9P/90fF1e2690+vw+Axtu9hf7bEJE9zRNQyUeM44NeQswbhSvS7OvJMMUY8g3tBipxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sFghGhW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sFghGhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7BF1F00893;
	Sat, 30 May 2026 17:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162321;
	bh=fjz8AcWZVeSkTfG5N95+jzuzci2FPo5cZ7ePZjL+ESk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0sFghGhWcQT2l1e8UKLKFDnh/sWtAuHSk6XRsZLSi+iDCBvkr6DDAs6G17C63yL+o
	 Rw/UXAQussqxZ8YN9oB3rtNZN1ksv6nNZ6Z4J37qbxWP8h/5m8g5sXFDVNRbFpEd0Z
	 U6mcOziQIIVsGdIQGbJcXT0lRa+1w8fw1a4ciXJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 860/969] ipv4: raw: reject IP_HDRINCL packets with ihl < 5
Date: Sat, 30 May 2026 18:06:24 +0200
Message-ID: <20260530160324.419041233@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 915fab69823a14c170dbaa3b41978768e0fe62fc upstream.

raw_send_hdrinc() validates that the caller-supplied IPv4 header
fits within the message length:

    iphlen = iph->ihl * 4;
    err = -EINVAL;
    if (iphlen > length)
        goto error_free;

    if (iphlen >= sizeof(*iph)) {
        /* fix up saddr, tot_len, id, csum, transport_header */
    }

It does not, however, reject ihl < 5.  For such a packet the
"if (iphlen >= sizeof(*iph))" branch is skipped, leaving the
crafted iphdr untouched, but the packet is still handed to
__ip_local_out() and onward.  Downstream consumers that read
iph->ihl assume a sane value: net/ipv4/ah4.c:ah_output() in
particular subtracts sizeof(struct iphdr) from top_iph->ihl * 4
and passes the (signed-int-negative, then cast to size_t)
result to memcpy(), producing an OOB access of length close to
SIZE_MAX and a host kernel panic.

An IPv4 header with ihl < 5 is malformed by definition (RFC 791:
"Internet Header Length is the length of the internet header in
32 bit words ... Note that the minimum value for a correct header
is 5.").  The kernel should not be willing to inject such a
packet into its own output path.

Reject "iphlen < sizeof(*iph)" alongside the existing
"iphlen > length" check.  This matches the principle that locally
constructed packets that re-enter the IP stack must pass the same
basic sanity tests that a foreign packet would be subjected to.

Once this lands, the "if (iphlen >= sizeof(*iph))" wrapper around
the fixup branch becomes redundant; left in place to keep the
patch minimal and backport-friendly.  A follow-up can unwrap it.

Note that commit 86f4c90a1c5c ("ipv4, ipv6: ensure raw socket
message is big enough to hold an IP header") ensures the message
buffer is large enough to hold an iphdr, but does not constrain
the self-reported iph->ihl.

Reachability: the malformed packet source is any caller with
CAP_NET_RAW, including an unprivileged process in a user+net
namespace on a kernel with CONFIG_USER_NS=y.  The reproduced AH
crash also requires a matching xfrm AH policy on the outgoing
route; a container granted CAP_NET_ADMIN can install that state
and policy in its netns.  Loopback bypasses xfrm_output, so the
trigger uses a real netdev.

Reproduced on UML + KASAN: kernel-mode fault at addr 0x0 with
memcpy_orig at the crash site.  Same shape reproduces inside a
rootless Docker container with --cap-add NET_ADMIN on a stock
distro kernel.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/77ec2b5e8111961c2c39883c92e8aa2709039c17.1778614451.git.michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/raw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -381,7 +381,7 @@ static int raw_send_hdrinc(struct sock *
 	 * in, reject the frame as invalid
 	 */
 	err = -EINVAL;
-	if (iphlen > length)
+	if (iphlen > length || iphlen < sizeof(*iph))
 		goto error_free;
 
 	if (iphlen >= sizeof(*iph)) {


