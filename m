Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3905730E855;
	Wed, 25 Feb 2026 06:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002707; cv=none; b=heLk2M3namZdIDTjW/HghBIAu7kMzvb9mqxxgw0PzYKXA8hy2oIWR2EJLZgOR6jPU3BDc79vOYybBO89SsW5At5CDYOVGBC55MH0NVb0DlgRJSrT7Kal7ssEvZiwZAyIpVZfCbvTrda8es3nT5RvQXluUQmxkY0queO2F+BZI50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002707; c=relaxed/simple;
	bh=YOTwB4FSfJEENOxv1381HVPZAR9/tS1JT01CIIcf5e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqMwIPcrxQh0f2m/eREuJf80keQEULAEGzol8D0gzi/dDeYXgaMKlp+ZgOe9/x8Z2gz6GVmU4v0HM3dDQAKGwH1T/VswQFbHIzLnW8FeWk8I/sy66XaOqrSSk08JBsHRgKkVOIiI5UmSUCjE19GxXrIkUD9L1DP7OpgfpvqBw6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKuTEfn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKuTEfn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12789C116D0;
	Wed, 25 Feb 2026 06:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002707;
	bh=YOTwB4FSfJEENOxv1381HVPZAR9/tS1JT01CIIcf5e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKuTEfn4MalRmEHa2zGvn5g5VwPaHLqKmrtAtcNB1hAyxr1IderivoGxT4z5xNO9N
	 vPVNluX1Eius8DXRZa4MaafhwzBszu9QhRBPCo19xG3fWj9HTF6TjLCABSZ2X9iJYC
	 wXZt80J6PMQyCtsCe+IdQwzsW+eoYglaZRZ0PnAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhouwenhao <zhouwenhao7600@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Matt Wu <wuqiang.matt@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 507/641] objpool: fix the overestimation of object pooling metadata size
Date: Tue, 24 Feb 2026 17:23:53 -0800
Message-ID: <20260225012400.809444793@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



