Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12C1320CC3;
	Mon, 18 Aug 2025 13:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524559; cv=none; b=sWf9CLrAMXKK1w08S73gElfjGU/9gfqo9FIXRpPd+04FP2NMqobUUctCbGVJ8pmeUgdx0RWERB39YyJuprlN6k17VdDXaku8wl9mHys/A4b6VUSJ1hFPwJqrotCEf++5XU1b7IYs8OcnrMDDYIC2XwxRr/O0avH9atbEi9G5k9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524559; c=relaxed/simple;
	bh=2Hnsjnxm/KabUOHBbrDfan+9lkfs5/8BCFV5xNufX2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlvuIvJuo0LGWE2N9pcfg3GeGL55rOqnQjk3eFznxlVZpdYJg8DijYybUAyECARxcIGtn3S0G3ghAcN1oq4A4JJCG9UC5PYqi1kBOHMxPjZu0cDGkspq0TEonqqHLkqBs6kqMXzRmDu+fbnwqTJC8erHH9RbrMklpIX5rIbXdJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9RQbkGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9RQbkGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDBBC116C6;
	Mon, 18 Aug 2025 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524559;
	bh=2Hnsjnxm/KabUOHBbrDfan+9lkfs5/8BCFV5xNufX2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9RQbkGgKHRlKKsfQFDPWEGeHPyy6rUtCwxb7YmFig+F0M98euUMhV/91Clhfw38O
	 sNoLx+iab4UlbYEgZre2BmlCemg5qZDfH7d/0DnLU3LQQIxI1Co8Py8xDCEUw/brOA
	 aXOuQf1q07xeRnzhoTdYch1j22Qed6rQ75LdkzT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 510/515] io_uring/rw: cast rw->flags assignment to rwf_t
Date: Mon, 18 Aug 2025 14:48:16 +0200
Message-ID: <20250818124518.070284924@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -284,7 +284,7 @@ static int __io_prep_rw(struct io_kiocb
 
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
-	rw->flags = READ_ONCE(sqe->rw_flags);
+	rw->flags = (__force rwf_t) READ_ONCE(sqe->rw_flags);
 
 	attr_type_mask = READ_ONCE(sqe->attr_type_mask);
 	if (attr_type_mask) {


