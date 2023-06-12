Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCBD134B1
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C043C433EF;
	Mon, 12 Jun 2023 10:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566861;
	bh=zCtngt7i5ghcETzlIiSo7jb5PTvYxVu4FDBKqSlNkEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5pV0EXoal+O4+rd7SrYmwgNaek5bQHhu2G9vLLfz1JEhHfg/ybJDwCw/8VKBmewS
	 67biHE4q27MYTOY9oHkb6srD0GNJNRTS+s5Dn0/fg3C3aomrcPRpZAV0TIo1xs0Vae
	 NJ9ANOW3OAdZlV82LvV/gNBQ+OU0qbVqaAXah4+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 060/160] lib: cpu_rmap: Fix potential use-after-free in irq_cpu_rmap_release()
Date: Mon, 12 Jun 2023 12:26:32 +0200
Message-ID: <20230612101717.754949510@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit 7c5d4801ecf0564c860033d89726b99723c55146 ]

irq_cpu_rmap_release() calls cpu_rmap_put(), which may free the rmap.
So we need to clear the pointer to our glue structure in rmap before
doing that, not after.

Fixes: 4e0473f1060a ("lib: cpu_rmap: Avoid use after free on rmap->obj array entries")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/ZHo0vwquhOy3FaXc@decadent.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/cpu_rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
index e77f12bb3c774..1833ad73de6fc 100644
--- a/lib/cpu_rmap.c
+++ b/lib/cpu_rmap.c
@@ -268,8 +268,8 @@ static void irq_cpu_rmap_release(struct kref *ref)
 	struct irq_glue *glue =
 		container_of(ref, struct irq_glue, notify.kref);
 
-	cpu_rmap_put(glue->rmap);
 	glue->rmap->obj[glue->index] = NULL;
+	cpu_rmap_put(glue->rmap);
 	kfree(glue);
 }
 
-- 
2.39.2



