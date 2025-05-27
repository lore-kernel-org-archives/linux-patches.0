Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B5C2798E6;
	Tue, 27 May 2025 17:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366040; cv=none; b=hIDR6TrvmpHAbGTZRT9i0FD6ZX/2TDwD+Sh3lUu0BjydjZMOOl5UzjqqZ2XzYu/w3b++O6qhaqK23g7ZpbWQKl5oPe6PUozq7qNC83+lgb7y6hT5qAcK2DYPu/bObelaYgL9m/sdhAwUJmE9NM9bu7AfseVjEqlKmuXxLU/mE7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366040; c=relaxed/simple;
	bh=j8aH9xR+4wNE7lYOUY0jJuJoVQuezu1AISRcQXW2xb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/3P0Coll52SkKxhPPlw0mawSVNOHKSkXwAYJIhzAcSeq6m7J55kgirx3D1r41XNu8z+/mWFJ4K0Uue1pvme1UUGXtpN2xyMirfG6pajHhW3WOb55iSNXxDlQz2gbcnaVKHK4EgbFu0aqdYfgvzXz+/jB+U4NPFUFJ+koOMsTgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMo2Naaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMo2Naaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F98C4CEE9;
	Tue, 27 May 2025 17:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366040;
	bh=j8aH9xR+4wNE7lYOUY0jJuJoVQuezu1AISRcQXW2xb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMo2NaawhA6MPxUM+eKpEYZM2rilQrdsVw6aUw4AKUITVpMu3wz5CxoLh0TQDq3S+
	 5Kzj5wYLW7Lbp0Z5PuHnR1H1SspydwLIvzZ8gOfxtmVQGqC/uSmyOO7Y1rrA9sb1pg
	 btEULUle1S4fBkAAX9tEK3BdhoCUkulF2hw9AOy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Grzegorzek <dominik.grzegorzek@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 571/626] padata: do not leak refcount in reorder_work
Date: Tue, 27 May 2025 18:27:44 +0200
Message-ID: <20250527162508.164773910@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Dominik Grzegorzek <dominik.grzegorzek@oracle.com>

commit d6ebcde6d4ecf34f8495fb30516645db3aea8993 upstream.

A recent patch that addressed a UAF introduced a reference count leak:
the parallel_data refcount is incremented unconditionally, regardless
of the return value of queue_work(). If the work item is already queued,
the incremented refcount is never decremented.

Fix this by checking the return value of queue_work() and decrementing
the refcount when necessary.

Resolves:

Unreferenced object 0xffff9d9f421e3d80 (size 192):
  comm "cryptomgr_probe", pid 157, jiffies 4294694003
  hex dump (first 32 bytes):
    80 8b cf 41 9f 9d ff ff b8 97 e0 89 ff ff ff ff  ...A............
    d0 97 e0 89 ff ff ff ff 19 00 00 00 1f 88 23 00  ..............#.
  backtrace (crc 838fb36):
    __kmalloc_cache_noprof+0x284/0x320
    padata_alloc_pd+0x20/0x1e0
    padata_alloc_shell+0x3b/0xa0
    0xffffffffc040a54d
    cryptomgr_probe+0x43/0xc0
    kthread+0xf6/0x1f0
    ret_from_fork+0x2f/0x50
    ret_from_fork_asm+0x1a/0x30

Fixes: dd7d37ccf6b1 ("padata: avoid UAF for reorder_work")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dominik Grzegorzek <dominik.grzegorzek@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/padata.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -358,7 +358,8 @@ static void padata_reorder(struct parall
 		 * To avoid UAF issue, add pd ref here, and put pd ref after reorder_work finish.
 		 */
 		padata_get_pd(pd);
-		queue_work(pinst->serial_wq, &pd->reorder_work);
+		if (!queue_work(pinst->serial_wq, &pd->reorder_work))
+			padata_put_pd(pd);
 	}
 }
 


