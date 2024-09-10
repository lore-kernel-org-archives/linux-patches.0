Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4490818FC74;
	Tue, 10 Sep 2024 10:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964555; cv=none; b=Pvu3xLt8+znPQmhRS52W4oRbNjWvVP65Hn9zKYkL5IpXEM1S8m/ug7y3ZkFDQbvLOcgS1rqZml25dXJ0wyfk1OUW2YeFtfQsr1GofezBNZ/l6JbfsNqnEx5N5jtF3a8tzcotvzP/uCIn1LRk442R6XUUhRCl43lpj5+gGw3zgM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964555; c=relaxed/simple;
	bh=tmckVvVO3z6VysHDlCTfO7qbcqnqtWk27POL4vuZJ6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHJEMI2FrTWFtoSpOUNni7Ihj6dYdoOt+e4jN76VvRFf3PPCOHbZ2BpLEHnAo+H9p2/EAEN6iTuxKrONqCXb/bDq1/MP84HCUC3EnCM5xTiOT1ZPsSOE4UPmdT932GiyZ6Oc1bTataQMS3YFhFc8Eezcq/W33qRctja4Ecch38U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIERko63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIERko63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BDFC4CEC3;
	Tue, 10 Sep 2024 10:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964555;
	bh=tmckVvVO3z6VysHDlCTfO7qbcqnqtWk27POL4vuZJ6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIERko631YHDVi3OCrIN5dxzR9b5/ek+qweFHB8eP3NAPsXWIPVhcsFm1GYWU6dHP
	 vac1zMbC/tWUD7gtXP6FLfmXOF61dhYi3ub+kSptp4Eqx7EfFQRSbE+pLWA8rgHata
	 g8NOR93QUi9qCLaMz1Mn19EjMmNE3L5zdlPJnddo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 6.6 223/269] uprobes: Use kzalloc to allocate xol area
Date: Tue, 10 Sep 2024 11:33:30 +0200
Message-ID: <20240910092615.904587557@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Sven Schnelle <svens@linux.ibm.com>

commit e240b0fde52f33670d1336697c22d90a4fe33c84 upstream.

To prevent unitialized members, use kzalloc to allocate
the xol area.

Fixes: b059a453b1cf1 ("x86/vdso: Add mremap hook to vm_special_mapping")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/20240903102313.3402529-1-svens@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/uprobes.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1480,7 +1480,7 @@ static struct xol_area *__create_xol_are
 	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
 	struct xol_area *area;
 
-	area = kmalloc(sizeof(*area), GFP_KERNEL);
+	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (unlikely(!area))
 		goto out;
 
@@ -1490,7 +1490,6 @@ static struct xol_area *__create_xol_are
 		goto free_area;
 
 	area->xol_mapping.name = "[uprobes]";
-	area->xol_mapping.fault = NULL;
 	area->xol_mapping.pages = area->pages;
 	area->pages[0] = alloc_page(GFP_HIGHUSER);
 	if (!area->pages[0])


