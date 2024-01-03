Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FF61C284;
	Wed,  3 Jan 2024 17:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hh3NewG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE613C433C7;
	Wed,  3 Jan 2024 17:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302086;
	bh=I6y8MH6/c2bvRDY5FW9B0NNptDfGXaomRpYoaLCSJiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hh3NewG//EvnAWu+pvnc7dH5VfwWfk0hODHMygUL0kT/NCYz6uoaUONBa2+TjMjD6
	 wDw7wH85x82wzys+K+9ySIiJP0TUbAxyWABcmZatCFnrLlRz6TB4GEjv8Hsx+VJLka
	 4NBdlfKpwTNUsOhhPtgwWMeGPrwwfwej3MGGymLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 41/49] mm/memory-failure: cast index to loff_t before shifting it
Date: Wed,  3 Jan 2024 17:56:01 +0100
Message-ID: <20240103164841.369942969@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 39ebd6dce62d8cfe3864e16148927a139f11bc9a upstream.

On 32-bit systems, we'll lose the top bits of index because arithmetic
will be performed in unsigned long instead of unsigned long long.  This
affects files over 4GB in size.

Link: https://lkml.kernel.org/r/20231218135837.3310403-4-willy@infradead.org
Fixes: 6100e34b2526 ("mm, memory_failure: Teach memory_failure() about dev_pagemap pages")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1705,7 +1705,7 @@ static void unmap_and_kill(struct list_h
 		 * mapping being torn down is communicated in siginfo, see
 		 * kill_proc()
 		 */
-		loff_t start = (index << PAGE_SHIFT) & ~(size - 1);
+		loff_t start = ((loff_t)index << PAGE_SHIFT) & ~(size - 1);
 
 		unmap_mapping_range(mapping, start, size, 0);
 	}


