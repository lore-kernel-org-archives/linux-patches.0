Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B036747A0DA;
	Tue, 16 Jun 2026 17:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631032; cv=none; b=uaT6kWiBkFl0kDywe8Md2ZYNfcDlEu+XsOp4AK5r2lJ8oZYnhvotpDAAR6cpj2f9lA8u83DhdC4am9HwY9PERZqYqfeerG3UY/T8NjwpoTwvac7u08Y2yi5fRRRlTxpWLjhyxQGIC10LywQyvhzDjnm2Xc5FJU6yw7STGeTsht0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631032; c=relaxed/simple;
	bh=px0VwtdSXaiRShaSErHxCDq0Z6ZTtocOgXmYiWV/mtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuVvPrkzwi3c0S1uk7ENuZIoUaov7D5XPUkZO3fxX1Ctps1idOcrBq5g9EvNiJgqQU7IcwSATmIH/F+UZuYqqu6AwfmBHxNRzdRN7UNOJZl58Lq39BraSdaQ4aXjC33+PWlqXCbwvdm487KJvyGND9qGvvNlYRiN167YG5Qxpds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JASChh3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JASChh3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80D71F000E9;
	Tue, 16 Jun 2026 17:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631031;
	bh=F0rBx4AhUHcRl0X5hiPfRzQ/AzcEVcN+FGMC86IV9No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JASChh3hqq0Tm6NKR+uZJpdJJutPhq5p48uBvufLX1YObGbkk6+nfDUXXe+ilN/ye
	 HQeNNOF6IekAJnb6HrxFUMxvBSaIqEMRt0aPCr5o9/6g631yACe42HM/J15E3Pf+hW
	 NXbB3vHUc7BOTdNwf/KnPoR+C3EO3axpE3E0NfeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <malin89@huawei.com>,
	Chenyuan Mi <michenyuan@huawei.com>,
	Jingguo Tan <tanjingguo@huawei.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.1 136/522] xfrm: esp: restore combined single-frag length gate
Date: Tue, 16 Jun 2026 20:24:43 +0530
Message-ID: <20260616145132.466217757@linuxfoundation.org>
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

From: Jingguo Tan <tanjingguo@huawei.com>

commit dfa0d7b0ff1eb6b2c416b8fdb9b4f2cefba57a40 upstream.

The ESP out-of-place fast path appends the trailer in esp_output_head()
before esp_output_tail() allocates the destination page frag. The
head-side gate currently checks skb->data_len and tailen separately, but
the tail code allocates a single destination frag from the combined
post-trailer skb->data_len.

Reject the page-frag fast path when the combined aligned length exceeds a
page. Otherwise skb_page_frag_refill() may fall back to a single page while
the destination sg still spans the combined skb->data_len.

Restore this combined-length page gate for both IPv4 and IPv6.

Fixes: 5bd8baab087d ("esp: limit skb_page_frag_refill use to a single page")
Cc: stable@vger.kernel.org
Signed-off-by: Lin Ma <malin89@huawei.com>
Signed-off-by: Chenyuan Mi <michenyuan@huawei.com>
Signed-off-by: Jingguo Tan <tanjingguo@huawei.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/esp4.c |    4 ++--
 net/ipv6/esp6.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -419,8 +419,8 @@ int esp_output_head(struct xfrm_state *x
 			return err;
 	}
 
-	if (ALIGN(tailen, L1_CACHE_BYTES) > PAGE_SIZE ||
-	    ALIGN(skb->data_len, L1_CACHE_BYTES) > PAGE_SIZE)
+	if (ALIGN(skb->data_len + tailen, L1_CACHE_BYTES) >
+	    PAGE_SIZE)
 		goto cow;
 
 	if (!skb_cloned(skb)) {
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -454,8 +454,8 @@ int esp6_output_head(struct xfrm_state *
 			return err;
 	}
 
-	if (ALIGN(tailen, L1_CACHE_BYTES) > PAGE_SIZE ||
-	    ALIGN(skb->data_len, L1_CACHE_BYTES) > PAGE_SIZE)
+	if (ALIGN(skb->data_len + tailen, L1_CACHE_BYTES) >
+	    PAGE_SIZE)
 		goto cow;
 
 	if (!skb_cloned(skb)) {


