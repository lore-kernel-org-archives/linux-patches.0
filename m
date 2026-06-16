Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7676747AF65;
	Tue, 16 Jun 2026 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630497; cv=none; b=Tiv0a/441Jgc49ESya8HANHMRmqYHicJ5AywNwhi25X2daD20s9JEC5gO2aBUCUfzFE5/d8Uk4WW7nGd1caCn9PwbScCtMgGcLqOLhd+SZaaDj2nfygYLxtEA5f3qeSJGbtzk/W11EcvqrrtGQpjWWtu7I1tBmQDe9R4TxGQe3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630497; c=relaxed/simple;
	bh=y1eJz6OdfiGBuxMtF0enJOR80RjokB+d+78Uv739dvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkaWOcSwv0i4QUbPbWC3m1rAPusUoE9HKZfAYQ/whJ7htU6rVntpJhdY+7tSJJ0i+NrMp1usySAplXHLlEiXuoxpng0SvTFn3FWM62wONXYr6s/k7Tljv/S7o9cGSRfrC4O/QhMtngZfVo50FAGLkh+aUUshuIFgvicbjbBy/b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gO1veyp5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gO1veyp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B971F000E9;
	Tue, 16 Jun 2026 17:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630494;
	bh=muepESeyiP1EPlswzCHD0Kg51VAGrWaVoGRaXhqKDC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gO1veyp5RJPcmiuy4aC7J7ajb6vkk3E4LLkFlMaSlA0HrM9r69Wvr3NlcQ6oavDMi
	 YsNm4feEOxR1M2pyuoLOgSWvpEOBo/bzdMbKs7DIZwwsIzMebDB47d5FQHVfACJYIo
	 PPM9mFvTAeNnPh34ZZQ5LLBC/BrA8ZQsXV2IZ2j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minh Nguyen <minhnguyen.080505@gmail.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/522] net: skbuff: fix pskb_carve leaking zcopy pages
Date: Tue, 16 Jun 2026 20:23:08 +0530
Message-ID: <20260616145127.661418963@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit ff6e798c2eac3ebd0501ad7e796f583fab928de8 ]

When SKBFL_MANAGED_FRAG_REFS is set, frag pages are not refcounted but
their lifetime is controlled by the attached ubuf_info. To make a copy
of the skb_shared_info, we either should clear the flag and reference
the frags, or keep the flag and have frags unreferenced.

pskb_carve_inside_header() and pskb_carve_inside_nonlinear() don't
follow the rule and thus can leak page references. Let's clear
SKBFL_MANAGED_FRAG_REFS from the original skb to fix it. It's the
simplest way to address it, but there are more performant ways to do
that if it ever becomes a problem.

Link: https://lore.kernel.org/all/20260523085809.26331-1-nvminh232@clc.fitus.edu.vn/
Fixes: 753f1ca4e1e50 ("net: introduce managed frags infrastructure")
Reported-by: Minh Nguyen <minhnguyen.080505@gmail.com>
Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/1e2086aa69217d7f9c8da3d38f5be7160f1b4cd1.1779993185.git.asml.silence@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8bc4b26de5e538..41b2aaed7a14aa 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6232,6 +6232,11 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 	skb_copy_from_linear_data_offset(skb, off, data, new_hlen);
 	skb->len -= off;
 
+	/* Remove SKBFL_MANAGED_FRAG_REFS instead of trying to honour it
+	 * while refcounting frags below.
+	 */
+	skb_zcopy_downgrade_managed(skb);
+
 	memcpy((struct skb_shared_info *)(data + size),
 	       skb_shinfo(skb),
 	       offsetof(struct skb_shared_info,
@@ -6344,6 +6349,11 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 		return -ENOMEM;
 	size = SKB_WITH_OVERHEAD(size);
 
+	/* Remove SKBFL_MANAGED_FRAG_REFS instead of trying to honour it
+	 * while refcounting frags below.
+	 */
+	skb_zcopy_downgrade_managed(skb);
+
 	memcpy((struct skb_shared_info *)(data + size),
 	       skb_shinfo(skb), offsetof(struct skb_shared_info, frags[0]));
 	if (skb_orphan_frags(skb, gfp_mask)) {
-- 
2.53.0



