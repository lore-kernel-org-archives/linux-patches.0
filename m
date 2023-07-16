Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BD08F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F848C433C7;
	Sun, 16 Jul 2023 20:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541035;
	bh=onCFm98c81/Vnl+zEOGckQqZnJ1rAGitlR8pEVSZX18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/V8VK1Da77zcRkoCUffbAM14sXbboRWNzU0ZuSlvIRc/xxdfGNeXsUTe9C5rJvQC
	 szql7EjMVei1Z9XsITfSqNPTQ5DHroWVXFXj7sayWWXcPENjuSbLS8/BvnfOJdZqIR
	 iSrEuXNzTpcGxle6o0wBaNJpbDCwCfzxsl376KdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hsu <John.Hsu@mediatek.com>,
	linux-mm@kvack.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 576/591] mm/mmap: Fix extra maple tree write
Date: Sun, 16 Jul 2023 21:51:55 +0200
Message-ID: <20230716194938.761629385@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Liam R. Howlett" <Liam.Howlett@oracle.com>

based on commit 0503ea8f5ba73eb3ab13a81c1eefbaf51405385a upstream.

This was inadvertently fixed during the removal of __vma_adjust().

When __vma_adjust() is adjusting next with a negative value (pushing
vma->vm_end lower), there would be two writes to the maple tree.  The
first write is unnecessary and uses all allocated nodes in the maple
state.  The second write is necessary but will need to allocate nodes
since the first write has used the allocated nodes.  This may be a
problem as it may not be safe to allocate at this time, such as a low
memory situation.  Fix the issue by avoiding the first write and only
write the adjusted "next" VMA.

Reported-by: John Hsu <John.Hsu@mediatek.com>
Link: https://lore.kernel.org/lkml/9cb8c599b1d7f9c1c300d1a334d5eb70ec4d7357.camel@mediatek.com/
Cc: stable@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -767,7 +767,8 @@ int __vma_adjust(struct vm_area_struct *
 	}
 	if (end != vma->vm_end) {
 		if (vma->vm_end > end) {
-			if (!insert || (insert->vm_start != end)) {
+			if ((vma->vm_end + adjust_next != end) &&
+			    (!insert || (insert->vm_start != end))) {
 				vma_mas_szero(&mas, end, vma->vm_end);
 				mas_reset(&mas);
 				VM_WARN_ON(insert &&


