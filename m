Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10347169AD2;
	Tue, 16 Jun 2026 18:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634893; cv=none; b=g840QBhxNqlnLmVT1+W20/1SDltE6UmP916eMBVIfBSV017VGmeHz0phPZ/yvYy4xXzBt55xCfiGwffNdG8bYW+Pss0GZggldek6gNnqObtR4aVJmVBmBcC3whACgyMvUJD3wrQXk8wJYZImZMPCtCmd2RanGZOdjLqrIOXXIlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634893; c=relaxed/simple;
	bh=kVJ4fKeJ1uUeuWUO+ttkU0eoyEIdHIXI1bOKqFuCRHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cj4dVFReM3fQid6E/1OrngVRTzHH+jIXXdLi/DhlspyFIfPxyzJ4RXltt8gUAfnWYlRcY+GV8fg80hTWoG36+WDpa9Mpjb+FRVKEd7BhxqsOjAqy3BfKrK2+yM8u1yHn6RTGCQndkX7qfYN5og3v2aAvQCqzcPNkTf4sMb8cuK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArdPP9Uk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArdPP9Uk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FFE1F000E9;
	Tue, 16 Jun 2026 18:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634892;
	bh=fxDCz/1+n/gJcEUe6BqmtlgEejLD4hTOUrNYNfe6E6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArdPP9UkCAHnwLr599BCOnqT53n0c9wbDU4+1VkmnvKkIhV3RIr30XWknrGOeciLO
	 zEx4TNOhJ+5d+zgWADZcmZcjYMEmR3ctB1ExzjvkA/AMZm/tvGjMpkYbTrdpRA3p1Z
	 QTstkrJEGBeX7Ldk+ug4JoY/8FqHQXUHznDEnlmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 351/411] ipv6: ioam: add NULL check for idev in ipv6_hop_ioam()
Date: Tue, 16 Jun 2026 20:29:49 +0530
Message-ID: <20260616145119.961729199@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Justin Iurman <justin.iurman@gmail.com>

[ Upstream commit d4ea0dfd75011b78cebf3808f98ac4c4f51a6fb9 ]

Reported by Sashiko:

The function ipv6_hop_ioam() accesses
__in6_dev_get(skb->dev)->cnf.ioam6_enabled without validating the returned
idev pointer. Because addrconf_ifdown() can concurrently clear dev->ip6_ptr
via RCU, __in6_dev_get() can return NULL during interface teardown, which
could cause a NULL pointer dereference when processing an IOAM Hop-by-Hop
option.

Let's add a check and use SKB_DROP_REASON_IPV6DISABLED accordingly.

Fixes: 9ee11f0fff20 ("ipv6: ioam: Data plane support for Pre-allocated Trace")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Iurman <justin.iurman@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260517183059.29140-1-justin.iurman@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -952,14 +952,20 @@ static bool ipv6_hop_ioam(struct sk_buff
 {
 	struct ioam6_trace_hdr *trace;
 	struct ioam6_namespace *ns;
+	struct inet6_dev *idev;
 	struct ioam6_hdr *hdr;
 
 	/* Bad alignment (must be 4n-aligned) */
 	if (optoff & 3)
 		goto drop;
 
+	/* Does the device still have IPv6 configuration? */
+	idev = __in6_dev_get(skb->dev);
+	if (!idev)
+		goto drop;
+
 	/* Ignore if IOAM is not enabled on ingress */
-	if (!READ_ONCE(__in6_dev_get(skb->dev)->cnf.ioam6_enabled))
+	if (!READ_ONCE(idev->cnf.ioam6_enabled))
 		goto ignore;
 
 	/* Truncated Option header */


