Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4A53F1AA1;
	Mon, 17 Aug 2026 14:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977362; cv=none; b=lrmM1v6JK3QrwAwoDNtOK3BoIX74aW/+cN8Z4DgCTH4czHfDHLDM3Fnqgh4/Emqy6AjsI0a6DKXQuJo4FjnjdrXjbsa+7HyelmapEXT5yZ8ICOClkf18Vkyck//kyLlOPP24NovPcQcpX4BPnSa3qH8gUBNCRAxv8hPmwzwN7ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977362; c=relaxed/simple;
	bh=5u0wZx5iqVM4kqY2kmPlUF6qsme6ope3rNL14E01Mzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uda9s/2QcGQDkousJ+/sRgIKOYboxXysKO8NtLsDucU1aEGTg3y5sCByb0Px9/SOoeX9dngTT6eEyExVkAA4c6azunNUVJxWbusunXypo/smeo82ByIq/Ox1eVi5T/i5w5lmI1qYVGO9c4D3bbi9OGF7uou+e3yPPZulD88q+00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyChkyPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyChkyPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75BE1F000E9;
	Mon, 17 Aug 2026 14:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977357;
	bh=I+5ZdN7BHKforjvuYc/PT/epLHdenLQt9xWttSVAm58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyChkyPu7hbw4Fn0MGt6gNrAlh75NaMC6j4gn9XzpqWQLIaeoMROhBH9HPO9M9gW+
	 TuhoaKATXVv/53NfdrhRCRPumqwRtZujP9ad6+BBgZG35GkQeD6ovtJU145z7P58Q+
	 8BufMu69hOtVdKYpMprL4mhOA2eMsh0RDxzFR7fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 300/456] bpf: lwt: Fix dst reference leak on reroute failure
Date: Mon, 17 Aug 2026 15:31:30 +0200
Message-ID: <20260817132551.555309891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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


