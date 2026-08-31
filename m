Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3019443E47;
	Mon, 31 Aug 2026 13:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183556; cv=none; b=fqn9LCIFgUUENfP/YQ7ClagJpTMPr/Xk1gl+xxG3Vy7KR70QO4lZm+QxU64YOcZDY6/zXH+qPkJcFbOLMuOH3ChZWQ07fqI77ya3Bc5jhaLeqpDBPRjpWhR+s0EKSGkpaEYY4pm4qNgh/ok8ay7+tse620UXWjojY489vwKUsa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183556; c=relaxed/simple;
	bh=JSed16mo69WVm9U6/jhCIY3R4e4Mgae7dGWlyC6ipZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6PfPPBGypoNT3nzoOasKXfedYY2C5RvXl1TlvXdX+bxukOkAaODEvYlYKLi0UfFjMT254J27jtNRwukxMa5tA1fENCMpy9e74Z+WYIzy8cwEAzAhjzjIsOj4jiL1u3CcMxfXLHIXT2ATPg8z5U8pc52FfuyuPcZE0CaMpxxKZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSFOPwhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSFOPwhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556CE1F00A3E;
	Mon, 31 Aug 2026 13:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183553;
	bh=HZw4wzfyq+U9ca+b015kSBP0FkW/kT0L+nbqcgA/XLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSFOPwhefegnXfswWNaCo92XoOZjN69w/JADpKT0dr8axeBvMn201NbjEu4cC71z9
	 /iIf78u4E3MzGvZF8RIaoXLqOk7QbgZ9vx2e0T1qG7jqrhgOHJ/J+Nlo8BYqhEM7zB
	 4Uq8nHUH1GIQZV3C1e3pyM9Aa8f8vY2ecl7bqE4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 7.2 36/71] xfrm: ah6: validate routing header segments_left
Date: Mon, 31 Aug 2026 15:34:01 +0200
Message-ID: <20260831133400.994540106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asim Viladi Oglu Manizada <manizada@pm.me>

commit 7bad4bda74dc4713f398d3b7624ff05478e3a568 upstream.

AH6 rearranges routing-header addresses before computing or verifying the
ICV. ipv6_rearrange_rthdr() assumes that segments_left is not larger than
the number of addresses described by the routing header's hdrlen field.

That assumption does not hold for raw IPv6 HDRINCL packets. A packet with
hdrlen equal to 2 describes one address, but can carry an arbitrary
segments_left value. With segments_left equal to 255, the function moves
its address pointer 4,064 bytes backwards and passes a 4,064-byte length to
memmove(), resulting in an out-of-bounds access.

Validate the invariant locally before modifying the routing header or
performing any address-pointer arithmetic, and propagate malformed-header
errors to the existing AH6 input and output error paths.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: avom-custom-harness:gpt-5.5-qwen3.6-mod-mix
Signed-off-by: Asim Viladi Oglu Manizada <manizada@pm.me>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ah6.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -232,26 +232,28 @@ static void ipv6_rearrange_destopt(struc
  *	Rearrange the destination address in @iph and the addresses in @rthdr
  *	so that they appear in the order they will at the final destination.
  *	See Appendix A2 of RFC 2402 for details.
+ *
+ * Return: 0 on success, -EINVAL if segments_left exceeds the number of
+ * addresses described by hdrlen.
  */
-static void ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
+static int ipv6_rearrange_rthdr(struct ipv6hdr *iph, struct ipv6_rt_hdr *rthdr)
 {
-	int segments, segments_left;
+	unsigned int segments, segments_left;
 	struct in6_addr *addrs;
 	struct in6_addr final_addr;
 
 	segments_left = rthdr->segments_left;
 	if (segments_left == 0)
-		return;
-	rthdr->segments_left = 0;
+		return 0;
 
-	/* The value of rthdr->hdrlen has been verified either by the system
-	 * call if it is locally generated, or by ipv6_rthdr_rcv() for incoming
-	 * packets.  So we can assume that it is even and that segments is
-	 * greater than or equal to segments_left.
-	 *
-	 * For the same reason we can assume that this option is of type 0.
+	/* Raw locally generated packets can reach AH6 without the invariant
+	 * required by the rt0-style address rearrangement below.
 	 */
 	segments = rthdr->hdrlen >> 1;
+	if (segments_left > segments)
+		return -EINVAL;
+
+	rthdr->segments_left = 0;
 
 	addrs = ((struct rt0_hdr *)rthdr)->addr;
 	final_addr = addrs[segments - 1];
@@ -261,6 +263,8 @@ static void ipv6_rearrange_rthdr(struct
 
 	addrs[0] = iph->daddr;
 	iph->daddr = final_addr;
+
+	return 0;
 }
 
 static int ipv6_clear_mutable_options(struct ipv6hdr *iph, int len, int dir)
@@ -273,6 +277,7 @@ static int ipv6_clear_mutable_options(st
 	} exthdr = { .iph = iph };
 	char *end = exthdr.raw + len;
 	int nexthdr = iph->nexthdr;
+	int err;
 
 	exthdr.iph++;
 
@@ -292,7 +297,9 @@ static int ipv6_clear_mutable_options(st
 			break;
 
 		case NEXTHDR_ROUTING:
-			ipv6_rearrange_rthdr(iph, exthdr.rth);
+			err = ipv6_rearrange_rthdr(iph, exthdr.rth);
+			if (err)
+				return err;
 			break;
 
 		default:


