Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB171D5141;
	Wed, 25 Feb 2026 01:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983521; cv=none; b=cCeV0ab67b+84vhXdghpS1IT7GMX0+loDMyDcYb6yzBr+23fodEEwYJFSz9U+LWFQK9Q4a1i75FAOrds6Dbfr0Kp5AdehsRYo4uhjKhYjil93o74Un4HZ8Plrcn0jlxGNRBIV4f63/HB2C6FxmhD191nwuUY8MdU+L3P8F8pVms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983521; c=relaxed/simple;
	bh=8hncPO2sbcneZUpdcMiI0mQQpK3cC0DZ9xEtPAu9Lvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0V4SWr0oH9126muZYZAEmLEK4sC0rKPwDbb3Tgu/pnAjfgQpgklFfjzYCsJF7w2O9CtQmFuw3LF5/f6Hw8DZxZRvgvzc2f6aHS2qfjWpmFv6LIyNtcqgwHrmalvmisk8LzBlfTXIrKxj6mW4UkBgSoF8ZEcVBTAHwmuvOGgvVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iD3naZzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iD3naZzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076F0C116D0;
	Wed, 25 Feb 2026 01:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983521;
	bh=8hncPO2sbcneZUpdcMiI0mQQpK3cC0DZ9xEtPAu9Lvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iD3naZzYlJfkzCJI8qx1LfcHew8JbD5stmHx+ik23+AconmbsUzKEuW9/R13cxp72
	 AJsX/8qSUxWWg9y02QRMNwDlnGNQ7KYoplmxXBCa3BYLAhyHGAuqw1lsdnE+dM6rOn
	 TyDUg7c7mYnkjpys9o4S75A6RCdbRB7f0f3UYykc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhouwenhao <zhouwenhao7600@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Matt Wu <wuqiang.matt@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 629/781] objpool: fix the overestimation of object pooling metadata size
Date: Tue, 24 Feb 2026 17:22:18 -0800
Message-ID: <20260225012415.239930340@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhouwenhao <zhouwenhao7600@gmail.com>

[ Upstream commit 5ed4b6b37c647d168ae31035b3f61b705997e043 ]

objpool uses struct objpool_head to store metadata information, and its
cpu_slots member points to an array of pointers that store the addresses
of the percpu ring arrays.  However, the memory size allocated during the
initialization of cpu_slots is nr_cpu_ids * sizeof(struct objpool_slot).
On a 64-bit machine, the size of struct objpool_slot is 16 bytes, which is
twice the size of the actual pointer required, and the extra memory is
never be used, resulting in a waste of memory.  Therefore, the memory size
required for cpu_slots needs to be corrected.

Link: https://lkml.kernel.org/r/20260202132846.68257-1-zhouwenhao7600@gmail.com
Fixes: b4edb8d2d464 ("lib: objpool added: ring-array based lockless MPMC")
Signed-off-by: zhouwenhao <zhouwenhao7600@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matt Wu <wuqiang.matt@bytedance.com>
Cc: wuqiang.matt <wuqiang.matt@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/objpool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/objpool.c b/lib/objpool.c
index b998b720c7329..d98fadf1de169 100644
--- a/lib/objpool.c
+++ b/lib/objpool.c
@@ -142,7 +142,7 @@ int objpool_init(struct objpool_head *pool, int nr_objs, int object_size,
 	pool->gfp = gfp & ~__GFP_ZERO;
 	pool->context = context;
 	pool->release = release;
-	slot_size = nr_cpu_ids * sizeof(struct objpool_slot);
+	slot_size = nr_cpu_ids * sizeof(struct objpool_slot *);
 	pool->cpu_slots = kzalloc(slot_size, pool->gfp);
 	if (!pool->cpu_slots)
 		return -ENOMEM;
-- 
2.51.0



