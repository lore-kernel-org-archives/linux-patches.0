Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B432D12ED;
	Fri,  7 Aug 2026 15:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116669; cv=none; b=kteFd5IlfYn9sY/uZTAXD2XfdnFv63OLyQ34gB3sMQx3Ymm/UvI6E1Lc/uzXqnGX0QJ7fMcRppf/9t9O2ovkjM6B+jZkUtgkwSNOaIAEXkJ05shFLiPGJ8Ig2ej2FgPIbZZffzuw60cuLMgVXGLU41V6GjoZYoShl+rvXV8NDeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116669; c=relaxed/simple;
	bh=Y136A5t2LTO3Rpur9TUR32enEWfbK9Y58q8u6kQ2Hq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uq/wCyExVa7pmLz3dKKjIgKFameER23Eq8G/uLe7OwQQS/z6nA+opXi1Ml08A13SbFBoVwFLKBFuufCTyT7MUeY8XNhXf5yQEVtIbV7TTVckj1Q5vXqeJQTsgbh8KDI0aS7b2dUW1AwtWxMuwRbRdhqDIEn0AUnKEUyaduOiLQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nkjvjk9h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nkjvjk9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E811F00A3A;
	Fri,  7 Aug 2026 15:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116668;
	bh=P66QabjG0p61UnpGrU5yv166k1MHbIaAN2WCBrQXCr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nkjvjk9hJ/TBPYcVrTbaJc1hitpyTAltH0VXxOMDB2EotM/JFZtQmmxpQHXP36I8L
	 5VN1873AaKaYrJkCwED/K6NraNXuK2CzQnQwJa9Preh9pS6ZwK9Bz3UtmfSU8hg7LP
	 czhW5tcRbsy7pqYEQBF8o4auioaOtXFbih+lVGIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Vincent Donnefort <vdonnefort@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 048/438] KVM: arm64: Fix potential leak in hyp_trace_buffer_alloc_bpages_backing
Date: Fri,  7 Aug 2026 16:34:04 +0200
Message-ID: <20260807143429.020491564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit df7a9d376f7a388ecfacf8dfe0b5819ddfba6972 ]

In the very unlikely event of a failure in __map_hyp, the allocated
backing pages are leaked in hyp_trace_buffer_alloc_bpages_backing(). Fix
this by freeing the pages on error.

Fixes: 3aed038aac8d ("KVM: arm64: Add trace remote for the nVHE/pKVM hyp")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Link: https://patch.msgid.link/20260710114819.2689386-2-vdonnefort@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp_trace.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index ac6a2db317323..73c1731392c74 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -154,6 +154,7 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
 	int nr_bpages = (PAGE_ALIGN(size) / PAGE_SIZE) + 1;
 	size_t backing_size;
 	void *start;
+	int ret;
 
 	backing_size = PAGE_ALIGN(sizeof(struct simple_buffer_page) * nr_bpages *
 				  num_possible_cpus());
@@ -162,10 +163,16 @@ static int hyp_trace_buffer_alloc_bpages_backing(struct hyp_trace_buffer *trace_
 	if (!start)
 		return -ENOMEM;
 
+	ret = __map_hyp(start, backing_size);
+	if (ret) {
+		free_pages_exact(start, backing_size);
+		return ret;
+	}
+
 	trace_buffer->desc->bpages_backing_start = (unsigned long)start;
 	trace_buffer->desc->bpages_backing_size = backing_size;
 
-	return __map_hyp(start, backing_size);
+	return ret;
 }
 
 static void hyp_trace_buffer_free_bpages_backing(struct hyp_trace_buffer *trace_buffer)
-- 
2.53.0



