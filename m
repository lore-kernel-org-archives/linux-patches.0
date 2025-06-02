Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590A922CBEC;
	Mon,  2 Jun 2025 15:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876428; cv=none; b=sgFVqcysmHn+OdI3vpRs/UG6ZjfKnM284B9yl/coYinz3hJsox+khk6cyw6473HslsCzI8GyfmtuBufbaHrTe2JkOM+37akmmQ3zKX5rxYKW1liGUfG3wDeZHdx0SfRNb0kUz1DIeO1SmMOC8fgX2FNcmraFDTSJI8k0WpX7m2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876428; c=relaxed/simple;
	bh=fI2NlzGVXG1HClYJwhwOJML6YHiZYwLpg2ZkG4c1erI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qad0QMcVuKtKgHdkd9lzYENL+xWCdo6U2iMdwVUIYkkI27N8Sd+4qhejHkibVo4jgxv5/zDjrM2rP3JNAir+ewRB8nPjN5YbvizYn2VECy2NKMUil53lThPio+LdAZM0hnFkjrGoB5ocM/FV26pFMDQ5PaAB3rRxQtPyjYzpGTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIJ9lpTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIJ9lpTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65651C4CEEB;
	Mon,  2 Jun 2025 15:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876427;
	bh=fI2NlzGVXG1HClYJwhwOJML6YHiZYwLpg2ZkG4c1erI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIJ9lpTQ9jZIBZZ3xoPyiE4g0ZxpTKSW/B4W06s9ilRh89u0BQon5EIxwb9Y+DWfM
	 dHiH8ZmketBQrfjZPc6bF8HqIMTFei7MRUcpUWE10DEsImNQsqUTCjR5xjosnR8F14
	 j1jEG8oSMQ1+b+Sro4VOitP6Tbpp3N17DsBmM0dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Grzegorzek <dominik.grzegorzek@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 171/207] padata: do not leak refcount in reorder_work
Date: Mon,  2 Jun 2025 15:49:03 +0200
Message-ID: <20250602134305.443662767@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -350,7 +350,8 @@ static void padata_reorder(struct parall
 		 * To avoid UAF issue, add pd ref here, and put pd ref after reorder_work finish.
 		 */
 		padata_get_pd(pd);
-		queue_work(pinst->serial_wq, &pd->reorder_work);
+		if (!queue_work(pinst->serial_wq, &pd->reorder_work))
+			padata_put_pd(pd);
 	}
 }
 


