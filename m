Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A343264D6;
	Fri,  7 Aug 2026 15:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116094; cv=none; b=Ugi3FixgIvDMuKz6DKr8Au8/gKvrCqfXNRzpxUr1aLPjRfeEMq0v+x9cI6riJNKrpPeHdPyuZUX6NdeNr2a9d33Ogx8CwRXkHiXTR6ya5aPPiX/TlLNdvnj6+/hiqgTrbVVGQIQdsMfZMIF/5QpeDJpIJd5yoC1vXF1qIzFPX+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116094; c=relaxed/simple;
	bh=hMKLi2qYA7ZErstP3g2vr0QEgyekN5nsYP0FX/FFnbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSB3857OjoDy99b41NgCWfkT+KEM9bA0eOdSSvqSYf381LRsxQIVfDZYAxCv1+q6FDEGmuI4SBPYhd3G6cCg0a+IAdE3UElMZTznQCH/xRkSDkocIJmP6ub9vA6bWLfI9JIPuLmW4ecQdqltZnlBVETzYnktN46BdjIErzm5J44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpFXcRcC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpFXcRcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008A41F000E9;
	Fri,  7 Aug 2026 15:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116093;
	bh=qlrbyTanm6DwXhw8+rsKh1OsitJBKbgcUAUZZDrUjQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpFXcRcCeTIHA3553h3p3b39kGKTzEl2/BUBGMBNYfq+OyfZY7GYs99mpLz4T5pP7
	 gF2IhIIpy2sUeKj5vokjwTmMJXfPe9TQYZIT136zF9sFh+AiYKRCIjAv6EL5Wr5XPx
	 nDzD6PBLJb/xoNclGBN4ve4V5bkN6LpPq0gZC0Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 108/261] bpf: lwt: Fix dst reference leak on reroute failure
Date: Fri,  7 Aug 2026 16:37:45 +0200
Message-ID: <20260807143417.710777361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
@@ -246,8 +246,10 @@ static int bpf_lwt_xmit_reroute(struct s
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


