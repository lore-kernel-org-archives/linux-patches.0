Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C59442394;
	Mon, 17 Aug 2026 14:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976072; cv=none; b=bjMI30bOimaW0euRZljh3rhwztV7uZrW86h8hltklgJHScrmCHJrXFHi2/4JHrXAHL/gDAAykQkR/EqeM23KX8eFBPTZWYjsbEcBhW+5h0dI1OQWsvV5R/wkpDZmFUkMXWm/yzA7WZSVjdjdq+Km1zCJVF1pvSB0dpklV6j4Zf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976072; c=relaxed/simple;
	bh=LFnh63dv5x8icmImoXZ83ArmytmfUOYFLIadcAbFCVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imp7jsVrSOntZA1VQDUO2NkeQ00W6A5H0ng/qOhSGX2mjeA4MNWz12XNm5+NLBuNd/xX1qPJ7ZmkwdqIQ2KqqWZl2420AzyQxgGiT0FaErHXDKsacv7/ffU3k0Sl1/j7d1J4hZjPu3J3IQgZuMXZySATY+/oefrOPUkiocjprTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltiFv7pT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltiFv7pT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DCE1F000E9;
	Mon, 17 Aug 2026 14:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976071;
	bh=hkDjYsT5NfEZ485a1waq+xnmhWdlPNq53SLQKRxM8jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltiFv7pTBXIgjE4t2hM9g0NmGojc+B2cXw4OOsMmjvZ+mbN5HV+xjJkf1VaQThoH5
	 hXJvrsQP6rcSNHrL8OQ8eSlm4WNsDDbAfhPaRObJS2rgcbG8ZaDRMBCn4APhDf7Kom
	 YvzNkvapzdUEd76N4RQZvvE5DPiizBGEUURuclh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 248/389] bpf: lwt: Fix dst reference leak on reroute failure
Date: Mon, 17 Aug 2026 15:31:27 +0200
Message-ID: <20260817132548.938041185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 88c17de85ddb459c3fe1e3c65d61fa366b1cf0a8 upstream.

bpf_lwt_xmit_reroute() obtains a referenced dst from the route
lookup. When skb_cow_head() fails before that dst is installed on the
skb, the error path only frees the skb. The skb still owns its previous
dst, so the newly looked up dst reference is leaked.

Release the new dst reference before freeing the skb on this error
path.

Fixes: 3bd0b15281af ("bpf: add handling of BPF_LWT_REROUTE to lwt_bpf.c")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20260723060445.21926-1-xuanqiang.luo@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/lwt_bpf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -245,8 +245,10 @@ static int bpf_lwt_xmit_reroute(struct s
 	 * if there is enough header space in skb.
 	 */
 	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
-	if (unlikely(err))
+	if (unlikely(err)) {
+		dst_release(dst);
 		goto err;
+	}
 
 	skb_dst_drop(skb);
 	skb_dst_set(skb, dst);


