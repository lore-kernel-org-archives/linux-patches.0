Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0214A32AAB5;
	Fri,  9 Jan 2026 12:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961231; cv=none; b=C+1wImDZjz7Ve4lNm74ivZGr/ppUtkESkBPvjVtdpyjmXTjF4008DnVXaaLcihQt5CF9yoQijF9yunaFGlJSaNAPHHIdcvDTy/H7lY/B13f9q8jYJsV3Rm8/k+tXLYMFQDdXg8MtYUyLlzaMF+DSeZh9UkPw2Eb/W6AuBuycknY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961231; c=relaxed/simple;
	bh=wouDCOrxsWLOgQjLWg0n19PCQ7Uye3Y6aqEdWm8EcL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTQweIJXZBboS7W+zNLXzg7EhskollZXf/3ibv0X4eUn1kU8AmfBd99GFCqTijYau+kQuIC711PAETaW+9yidfJ6lQZssaSJ8KGWmFkQxzSUCkr1Zqt9Q3eJFRrdYqaePTJoQFrvhNTHUNMZf0EGd+pVD7LIuQ0V6eNRHGvHAwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqeaWEJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqeaWEJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7923CC4CEF1;
	Fri,  9 Jan 2026 12:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961230;
	bh=wouDCOrxsWLOgQjLWg0n19PCQ7Uye3Y6aqEdWm8EcL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqeaWEJY3uirT2vOU1EAxFgziwV9+0wDvyGxNhw/JovnmQtCUGD3Qe45x5GbWkYAc
	 x5fx8o5yIwIiJIo1yM6/lR0HdQF2FIRQTEkB/01QRVAUXUhO+JbFvKH2qPDUxasixL
	 bhz1tkDeG03JyOrNillvoEaTikO456Q70zQlarbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jefflexu@linux.alibaba.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Stefan Roesch <shr@devkernel.io>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 681/737] mm: fix arithmetic for bdi min_ratio
Date: Fri,  9 Jan 2026 12:43:40 +0100
Message-ID: <20260109112159.673905192@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Jingbo Xu <jefflexu@linux.alibaba.com>

commit e0646b7590084a5bf3b056d3ad871d9379d2c25a upstream.

Since now bdi->min_ratio is part per million, fix the wrong arithmetic.
Otherwise it will fail with -EINVAL when setting a reasonable min_ratio,
as it tries to set min_ratio to (min_ratio * BDI_RATIO_SCALE) in
percentage unit, which exceeds 100% anyway.

    # cat /sys/class/bdi/253\:0/min_ratio
    0
    # cat /sys/class/bdi/253\:0/max_ratio
    100
    # echo 1 > /sys/class/bdi/253\:0/min_ratio
    -bash: echo: write error: Invalid argument

Link: https://lkml.kernel.org/r/20231219142508.86265-2-jefflexu@linux.alibaba.com
Fixes: 8021fb3232f2 ("mm: split off __bdi_set_min_ratio() function")
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page-writeback.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -714,7 +714,6 @@ static int __bdi_set_min_ratio(struct ba
 
 	if (min_ratio > 100 * BDI_RATIO_SCALE)
 		return -EINVAL;
-	min_ratio *= BDI_RATIO_SCALE;
 
 	spin_lock_bh(&bdi_lock);
 	if (min_ratio > bdi->max_ratio) {


