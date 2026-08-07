Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4A5331200;
	Fri,  7 Aug 2026 15:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115210; cv=none; b=DqcOuK3cZmWC7Y9iOJ7bQSxUW8tv0UyzWTs5TcwyjwtMcPiQrtJ6KgvKsn7UeV225/gundsaMLf8Qs9kgN2iqd8eq/qZnfBaTmFyIoq59W4A2fT6iN1CqAWJ1JdYOW97VmI41wEfZpj8QB73/GAvMU5QXzIIq69umZWf9W18PzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115210; c=relaxed/simple;
	bh=HbbifAhvb+UuXXbVhCEK5fphEPpq0aUL4XGmuFiB+ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8UGdpkC3haS5+x7+Q42nQaNwd8lPmUFQc27lLGWe6mf4EOFgSZ/SDCxjgyhBPnUvKbrMdEj/ENgv4BP23agmOaxqPj7/NsqXsQ4pZwAlzmP0nPlMAwKUlFBT6+mWmeI1XJAuiJpe5G0RVNfvvT6A6cSyw1R4uXfuvrU76JRhN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pI+ulqsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pI+ulqsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7521F000E9;
	Fri,  7 Aug 2026 15:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115208;
	bh=4nI3Vj3nCoOu837HtvDllUnfAVCZGw81ux1uOvEOzng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pI+ulqsm52ibgkFPzFRWcXUHdjaT2DJv1eUfMn2l3DQrpxIIloaTBrTtETeJvkbJ+
	 G8nsMhgRK24fDoxcvZ0c1afmfNs3t2WUjlCb7BY1T3PoZC98r7ZKPjg2IS/AQ8ZYJK
	 /NcTBOVNOczXh7JxB3hRmyxI3TE+24WxJgwsa9s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 197/396] bpf: lwt: Fix dst reference leak on reroute failure
Date: Fri,  7 Aug 2026 16:35:57 +0200
Message-ID: <20260807143428.531656164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -251,8 +251,10 @@ static int bpf_lwt_xmit_reroute(struct s
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


