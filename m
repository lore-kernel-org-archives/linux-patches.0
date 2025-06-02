Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16342356BA;
	Mon,  2 Jun 2025 14:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875777; cv=none; b=fi8YJFoAv+p0hpBevZm9n1RI2uwdrltFHqF9Uf09TZD/VDlDGb8I0xgRt2TvrRjXSl/7oC4vdToL2U43EEKkwxgCfWL+EkTKnRobVzFKH0n6b0dmCJpkvw4Qsl2q7liVBTFTA8JsGcrO7ihsCMYc9SaEol9xusoF2fu2pzCobBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875777; c=relaxed/simple;
	bh=nrzWro6JFXcmeVRhkjABPYPoqQ++EPT7CRYSMfnjap0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZvOvHlx8cy08PnDawfzp8pUoMkQW5oyKKzOzrbHLVrK1XrTgfKGNlBvg5Gx4Ai8TqrD8ycbThj7AmWcbR/V67tpLbY/mbNI7/fmaY6Oj4l2mxGBHLTx/MNhxu3Aft8iQ8hQBdjGQHSuGO0mFkCEwG3iDxrvuHmf+F0kV5lMJO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aw0r3z9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aw0r3z9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F6EC4CEEE;
	Mon,  2 Jun 2025 14:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875777;
	bh=nrzWro6JFXcmeVRhkjABPYPoqQ++EPT7CRYSMfnjap0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aw0r3z9PShMglkhsk6ZpJ76wzFfSkVdmEJHLygFr7TA53cffQbo4dmMA36w4plRjr
	 9hrupnbWIwLANd2Ygp3cnJVNN/F/HWer2JBbLKBA5rZcWG7gAFgzOn7suRVO29pUCJ
	 e+2/Ey4AttXhz7Ac0j6pPMJC1vThggEjp0Xpgr0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Grzegorzek <dominik.grzegorzek@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 241/270] padata: do not leak refcount in reorder_work
Date: Mon,  2 Jun 2025 15:48:46 +0200
Message-ID: <20250602134317.182510653@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -363,7 +363,8 @@ static void padata_reorder(struct parall
 		 * To avoid UAF issue, add pd ref here, and put pd ref after reorder_work finish.
 		 */
 		padata_get_pd(pd);
-		queue_work(pinst->serial_wq, &pd->reorder_work);
+		if (!queue_work(pinst->serial_wq, &pd->reorder_work))
+			padata_put_pd(pd);
 	}
 }
 


