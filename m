Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3214C35A280;
	Mon, 18 Aug 2025 14:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526459; cv=none; b=ZJqORaCYuUoJqDooz3qBFTL0BcsQ8mkYbqTGztQorSZqDkhw4KNYjjifTxWVtSFYj2JaljYFnW4zhuMHfSIosavROZRdiW0DiR0EsFrXSwQ/zLXNk7Lc99tdcVZwQJhmxRfMZehMWNCeZgCqFVIwUoRckq3oPz8n2sm7f1Dd0uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526459; c=relaxed/simple;
	bh=sNpkr7l/aTy1ihK1yKnKrWtXrF9Zg+eR47DmaeZluUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKXyBhhHq6M2WYMfPQOCkbCCikYWJpy11sQMMkmsTm0u1G/srdk3c10heQQKLN6vYBU7ZSoJ4RUP/7075W9E7gDN2IVSLUwrdr5XlGQcB3U4e/2vOW39pWm2E3t/t3UVQvs1xuMuQD/0RQVtcYK3jKUpiJN98id1lC3yQd/40sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqWeJav/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqWeJav/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4BCC4CEEB;
	Mon, 18 Aug 2025 14:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526459;
	bh=sNpkr7l/aTy1ihK1yKnKrWtXrF9Zg+eR47DmaeZluUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqWeJav/SfVvyRgE+1ClXXIjFFW/hTmXfNVa5AEBDB0Duwk2JcGOWqB7Rdogj2IZM
	 fWNSmF+2SL+5SyfzfXGiv6/h40626iKmn5OC5LGZaaeaE3gMQr8NOpcsn9OH4Y3cac
	 j+rTBOOvRv34Nu/3ld+pxnQ/chDWFTTbTFtOflEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.16 562/570] io_uring/rw: cast rw->flags assignment to rwf_t
Date: Mon, 18 Aug 2025 14:49:09 +0200
Message-ID: <20250818124527.528312326@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -288,7 +288,7 @@ static int __io_prep_rw(struct io_kiocb
 
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
-	rw->flags = READ_ONCE(sqe->rw_flags);
+	rw->flags = (__force rwf_t) READ_ONCE(sqe->rw_flags);
 
 	attr_type_mask = READ_ONCE(sqe->attr_type_mask);
 	if (attr_type_mask) {


