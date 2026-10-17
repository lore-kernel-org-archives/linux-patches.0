Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0D718787A;
	Sat, 17 Oct 2026 15:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252654; cv=none; b=aPZeGe5eWYMHu+gVfrHh3yQXUUSCs2CYRA48Etx36+SGwzZLjK6FcO5fzpw+rXjkaSR54u/iUwA0VIMsOtRUSJc6k8qiTOfiM2UA54js6h4TaczUHs/WaW7lPWBFufuYV65ksFeUNMm1LbLxkqQeWKMza1z47E+UhjtT3Pvimao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252654; c=relaxed/simple;
	bh=MWThTC7v+BRFsYmT15hxq4S2a0TYdSxm0FjL7SJWF3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHN7n6MoBJiuLOnlygHcVTm64s8INtlefvPrZpg7W5MBU7fUBuCH2nQsMSxrxAkbixnLgy5Ub+LA8+uD/fSgxLoswFs5TKTuZ71YBAUtEIEQvBcUc9bIAp6dwBIkIUUh1XNWwNrtbdfyLbtLy5inE42jr4+cZP+opdiRUvr2A/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDgyzw5+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDgyzw5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8FB1F000C4;
	Sat, 17 Oct 2026 15:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252653;
	bh=YK11KcROY37mQBnONxmISmUB2cCmV3hylSZ7B7tpe/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tDgyzw5+e3JIlpoo0ZKpKwjPoELILZQ1HKWp2MuAFJbm8//La2ol6qo8IV3asm9MN
	 z3zAVHJlTbXgJazrEp+irOoDWE34w36LVaZJckjhxABxve7HFNoeb4O2fGvDOhfsoG
	 afjBKnoAKZmr0iNi7rxeeEqMuHAW87vEfW6vqwsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Federico Parola <fparola@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 50/52] kho: free chunks using free_page() instead of kfree()
Date: Sat, 17 Oct 2026 17:54:51 +0200
Message-ID: <20261017155106.454608354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

From: Pratyush Yadav <pratyush@kernel.org>

[ Upstream commit b15515155af735a86e5bcd67ed739162f0de27f5 ]

Before commit fa759cd75bce5 ("kho: allocate metadata directly from the
buddy allocator"), the chunks were allocated from the slab allocator using
kzalloc().  Those were rightly freed using kfree().

When the commit switched to using the buddy allocator directly, it missed
updating kho_mem_ser_free() to use free_page() instead of kfree().

Link: https://lkml.kernel.org/r/20251118182218.63044-1-pratyush@kernel.org
Fixes: fa759cd75bce5 ("kho: allocate metadata directly from the buddy allocator")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Federico Parola <fparola@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index ac9fa7727b5ff..9fe5d14f1ec54 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -365,7 +365,7 @@ static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
 		struct khoser_mem_chunk *tmp = chunk;
 
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		kfree(tmp);
+		free_page((unsigned long)tmp);
 	}
 }
 
-- 
2.53.0



