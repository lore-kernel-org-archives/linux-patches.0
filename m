Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F9B14AD15;
	Tue, 20 Feb 2024 21:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463287; cv=none; b=mA2uSr7jUlRTD9pJNVblKRHYy33KoH+2s7iVSzgVVmCGUkdQmfFJj7QgkJTJBFR2Srnr6R4czMsmR/PQC5NqGMSvjUtXKWdMGjRPjjfF93svTNKaw2WrhMnrHKtNidyuM8E9N+4vgujiahc29nBy5kevSiJNDpihOIVxkpVpZ9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463287; c=relaxed/simple;
	bh=daPKbMhaGqnwPC+Rg3mROiv26YQyqZCNfsDXzjdd0pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIazGQXD794n0v8Rnd9OnT7mRipupf5/LwAcMKBLUv7tOP4gHL/h/oe5pFdlpHiPXcRzCA1xIiPRahEdqWlP3ZdwORF727LmtFMFvAQR05M614RNWTJI/TM0eVSdqhVqd32Bhlc60y3EH0jryjwsm+OjBY74nxZdHLmx5byVA5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFA7jgEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFA7jgEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4D0C433C7;
	Tue, 20 Feb 2024 21:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463287;
	bh=daPKbMhaGqnwPC+Rg3mROiv26YQyqZCNfsDXzjdd0pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFA7jgEwLGNYG7TRLIIqDLs3bsva0as9GZl9YuTbGQ9/VoXpr1shHW+JR+uEdtkkf
	 tRzXaXrAz9SRQpao2gZt7aHzPHFZ8KE+Y946jelBgYCtgRaR3Zc0unzARb363SXp+p
	 GoJ5LY8KElxR3ucXP7VYnxSr8ncoJ92nimAsXzvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 167/197] xfrm: Use xfrm_state selector for BEET input
Date: Tue, 20 Feb 2024 21:52:06 +0100
Message-ID: <20240220204846.070565693@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 842665a9008a53ff13ac22a4e4b8ae2f10e92aca upstream.

For BEET the inner address and therefore family is stored in the
xfrm_state selector.  Use that when decapsulating an input packet
instead of incorrectly relying on a non-existent tunnel protocol.

Fixes: 5f24f41e8ea6 ("xfrm: Remove inner/outer modes from input path")
Reported-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_input.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -331,11 +331,10 @@ xfrm_inner_mode_encap_remove(struct xfrm
 {
 	switch (x->props.mode) {
 	case XFRM_MODE_BEET:
-		switch (XFRM_MODE_SKB_CB(skb)->protocol) {
-		case IPPROTO_IPIP:
-		case IPPROTO_BEETPH:
+		switch (x->sel.family) {
+		case AF_INET:
 			return xfrm4_remove_beet_encap(x, skb);
-		case IPPROTO_IPV6:
+		case AF_INET6:
 			return xfrm6_remove_beet_encap(x, skb);
 		}
 		break;


