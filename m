Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29924320CB6;
	Fri,  9 Jan 2026 12:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960632; cv=none; b=m+Sm3f5olni4+frMRfBoEnSC4UOaXWJRrMvevA/O/7WXWZpdhzmHstafyj42nw9NcW+lPj1fg4uaQRtS8r3NL+iuOvDgeRgp/yu+LgulRntIQoqzmZaj8Sun/Lwtn8ijf1XtWPZz0/avlAdRTZSpp53JzvB6zoMiRtKU4wzdu0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960632; c=relaxed/simple;
	bh=LKla7+glKh9Z3oiK6f2CGXEQ6Nx/zj7F8JQPW5dWgkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tb2aCtEiZQLy31T4eeLHTUF6MQjf4Dsd60Pv0kM4XMsexnYuQRawgYsaD++DJicQ/xL8NSOw7Gnz4GLNbd/VPaymKQnOZKUinDViM3/33LWG9OhTbVOVGA/jBA/FYcOwz6HCDdBwzFAjGIUl0/RFyfoFOFwE09ZpEilPIi6TY9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+B+bFW2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+B+bFW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD75C19425;
	Fri,  9 Jan 2026 12:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960632;
	bh=LKla7+glKh9Z3oiK6f2CGXEQ6Nx/zj7F8JQPW5dWgkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+B+bFW2kgE4JhXMRRjMKaPfVOgL9G3G7Xq+s1+CCDDAf/nHuS3MaonCekQXGMv/M
	 t9O2Swup6VeLCSKczhI+rqX4VJdWwGm2YTgusMm5hXAWhocFf8mBRFI6/NY1A3T06k
	 FnxybSvch1S7cwuSOH2KoZITFo1hEk6neWckopRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 471/737] xfs: fix a memory leak in xfs_buf_item_init()
Date: Fri,  9 Jan 2026 12:40:10 +0100
Message-ID: <20260109112151.705509082@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit fc40459de82543b565ebc839dca8f7987f16f62e upstream.

xfs_buf_item_get_format() may allocate memory for bip->bli_formats,
free the memory in the error path.

Fixes: c3d5f0c2fb85 ("xfs: complain if anyone tries to create a too-large buffer log item")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf_item.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -900,6 +900,7 @@ xfs_buf_item_init(
 		map_size = DIV_ROUND_UP(chunks, NBWORD);
 
 		if (map_size > XFS_BLF_DATAMAP_SIZE) {
+			xfs_buf_item_free_format(bip);
 			kmem_cache_free(xfs_buf_item_cache, bip);
 			xfs_err(mp,
 	"buffer item dirty bitmap (%u uints) too small to reflect %u bytes!",


