Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2A81F470A;
	Tue, 21 Jan 2025 18:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482548; cv=none; b=XI5dqkIn3R9TX9LnaIFmI+p3l4qpaxDLh+qWaOg+Upm3MAHxyf+/gzcfC5488KWSemc/aHNywGRyOMRYBkA71guaRzIOPUvPqtQMPxK6EOwhKc2mBF1V4m96rcbk3Y50eZmhydRkyqW2epZw/3luPod6rZf/KePrH94yxFL4oww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482548; c=relaxed/simple;
	bh=B1J8AQznSYd5T+zmW7jCeVGkZWIY3Dwy6vG2YS/MeZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYf5ihPmpLBDRcyWj2Lp1SPQ8va/GTSG49vHn5pyHDadvkRxxIe+kqXVOa2YXNfz1f2w2f16ds5G3bJfqrCoVZqrqJX/iMRhC1KIl7QjfOB4VMWZshsKTuiMQO8MT+EzIxG1rphEqImW779WA7aDs/NldA1nEgtxnrAEpGbJAr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0Tj0z5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0Tj0z5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF43EC4CEDF;
	Tue, 21 Jan 2025 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482548;
	bh=B1J8AQznSYd5T+zmW7jCeVGkZWIY3Dwy6vG2YS/MeZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0Tj0z5i+17rwbCitArHOUQuONb+WS7/hbE+kJlUiBPKcz8noGytwdkfzq/j2/Duh
	 epVSnP25zyo2X1QomMcGLC2ZCi94VqeV6IN1cQBE9Q/j0bzOyDKQSTd9PA5YtE77kv
	 sSVKhTJp1rcss2RB7Sncnczyot2zNYa1AbruVwGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Weikang <guoweikang.kernel@gmail.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 097/122] mm/kmemleak: fix percpu memory leak detection failure
Date: Tue, 21 Jan 2025 18:52:25 +0100
Message-ID: <20250121174536.769890528@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Guo Weikang <guoweikang.kernel@gmail.com>

commit 76d5d4c53e68719c018691b19a961e78524a155c upstream.

kmemleak_alloc_percpu gives an incorrect min_count parameter, causing
percpu memory to be considered a gray object.

Link: https://lkml.kernel.org/r/20241227092311.3572500-1-guoweikang.kernel@gmail.com
Fixes: 8c8685928910 ("mm/kmemleak: use IS_ERR_PCPU() for pointer in the percpu address space")
Signed-off-by: Guo Weikang <guoweikang.kernel@gmail.com>
Acked-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1071,7 +1071,7 @@ void __ref kmemleak_alloc_percpu(const v
 	pr_debug("%s(0x%px, %zu)\n", __func__, ptr, size);
 
 	if (kmemleak_enabled && ptr && !IS_ERR_PCPU(ptr))
-		create_object_percpu((__force unsigned long)ptr, size, 0, gfp);
+		create_object_percpu((__force unsigned long)ptr, size, 1, gfp);
 }
 EXPORT_SYMBOL_GPL(kmemleak_alloc_percpu);
 


