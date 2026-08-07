Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF84385D86;
	Fri,  7 Aug 2026 14:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114135; cv=none; b=udDxVmVU679lwl/R61oFmshydAtaN3wSnlyNMns0b/sCrzKAgqJs0TwSErvqLhyWFMjzLvFiWtmDgNcCQ6gN5efZv4Rcq0DU/S4rTdrwKql5sSB13MdSdVs76dOBOJi55spXx7lvWuNGNvmISVNuuEGrM18oKCd9nsvTYCAGPt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114135; c=relaxed/simple;
	bh=bkCq8ve4kOWj6csbfo0YxLV6QfoX7PlGv54zB3ze8Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vbv0osInLXM9160iLLXPvfrJm/cizQaadug1dLzMFIRXAxWIstYBtGOEAp5+SbNoy49GcbTJ8xU6hjb+flMF2EvRYIngTyhItarUF83T9yDucfJh1asxADhZkPCEqQSskw9weEanYmf/+YkqfikkGgJyt2Qk7t8D5GZB8A9z2vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOMJ7QG7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOMJ7QG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186241F00A3A;
	Fri,  7 Aug 2026 14:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114130;
	bh=aF5dtWHHxGOdMyGXBOEMM0XDIdeW3vOhLsXa9YqGTkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOMJ7QG7jdPjFCBKkJsePbTFj5sF8zKsXeSKG/90wgyFhjUBLZsvH6aQJkY+aQJwT
	 tjtKXbPJzFR4yPSNxC7xYmvvjAr6LBm22qpD4xLhMTVowyl8eswFtHlHU35wisDdi5
	 muD9vzYm8T9I//Y1x5SsQt6krpVj1uFW/6VggSSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 154/337] bpf: lwt: Fix dst reference leak on reroute failure
Date: Fri,  7 Aug 2026 16:35:57 +0200
Message-ID: <20260807143421.889952207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -248,8 +248,10 @@ static int bpf_lwt_xmit_reroute(struct s
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


