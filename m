Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AB631E0EB;
	Mon, 18 Aug 2025 13:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522890; cv=none; b=DGH0uBPN6fJ+RCZ8U8pxUCbYJ5I84Dlpr2nyG7ZZdI9nP0UsA7IDNZsH4eaGNIf+FitiJxPArg4zMIdAtkNhiFxNchzpyBafSpnl6DM33hgwxnFHiCnvXGABN593iQspgwuoYnTQuzfGJusVn0T5/qhtZOwLCAKC6YqCn2cp9a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522890; c=relaxed/simple;
	bh=W/4Zrd1hQb+Eac+L69A1ybUHlCd5otjsq/pQMzTIVr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Orz7tOrw5TtaCwsHPF1qHBavHnX/JzqjoyXn/GQRXhR26/IpC2FBZBYpwqncg+xVL5zlUCFsMPVzPu70BUoZKrkaO/17kYGXdVPSwe4JacOVxE+Ir/0rJh2cmE8czn+deFHzfukRV1MP1mddHBk+fc52h9OekIomI34h+MbPJto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X61PAsk0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X61PAsk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F99C4CEEB;
	Mon, 18 Aug 2025 13:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522890;
	bh=W/4Zrd1hQb+Eac+L69A1ybUHlCd5otjsq/pQMzTIVr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X61PAsk0OqKxX87MgNbgkAAtmJLRpC486h9FaJkvm+uO4NeiXuSmPyvCk/VGAZb8/
	 pDPkdqQrrfyc7Dc+iK7RuHLNu0Ld3thozwB9vtFYqkCjd19KEuAhayF9A+UKc2PrNo
	 Ol/xdigHPOl8R8UV1D6hYMiK2yr/vJ0IafKwMxfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 438/444] io_uring/rw: cast rw->flags assignment to rwf_t
Date: Mon, 18 Aug 2025 14:47:44 +0200
Message-ID: <20250818124505.388866341@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 825aea662b492571877b32aeeae13689fd9fbee4 upstream.

kernel test robot reports that a recent change of the sqe->rw_flags
field throws a sparse warning on 32-bit archs:

>> io_uring/rw.c:291:19: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __kernel_rwf_t [usertype] flags @@     got unsigned int @@
   io_uring/rw.c:291:19: sparse:     expected restricted __kernel_rwf_t [usertype] flags
   io_uring/rw.c:291:19: sparse:     got unsigned int

Force cast it to rwf_t to silence that new sparse warning.

Fixes: cf73d9970ea4 ("io_uring: don't use int for ABI")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507032211.PwSNPNSP-lkp@intel.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -282,7 +282,7 @@ static int io_prep_rw(struct io_kiocb *r
 
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
-	rw->flags = READ_ONCE(sqe->rw_flags);
+	rw->flags = (__force rwf_t) READ_ONCE(sqe->rw_flags);
 	return io_prep_rw_setup(req, ddir, do_import);
 }
 


