Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616032690D5;
	Tue,  8 Apr 2025 11:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110530; cv=none; b=c6KGqOp2z1fJW/uyzwuQg5t1eheOtjDfViMe2gtMA3IVqvmOtlnXRbje0rs7z3366Va3nu7GsjSp6V5gYfUewc8GRYDSjyPfQScCua2jUyODBhrEzbmTixR3ae+pFOAjIjocQxEUQg0DIXcCei1FuC3gQLvr4sTJMnO326D9A+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110530; c=relaxed/simple;
	bh=S+OdsDACiLO4a9kq9TlDHcWF6dFhNKP4wI9nfmyCspU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQRLkZC6DO3TrHfDsgVIbV4wZbvqBQ/6urONMAQQFBXfat2n5CJAfQv3LvZRvS1t0sNiwwdgSSYgafNTKtf/Yz7s1FEGb1hvaJWYxiffeKlbIrrjzsYpX4+Y01Um51aFM1YDuToScGOenKSooafriNXuGHW8MTvLqx73kqtRgWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHJOVfOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHJOVfOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E67C4CEEA;
	Tue,  8 Apr 2025 11:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110530;
	bh=S+OdsDACiLO4a9kq9TlDHcWF6dFhNKP4wI9nfmyCspU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHJOVfOFjw8F1rzrT2c6aYTzRJckKmXyMlioY9NYBCRSgHbUTDsZTmkxEm8dInWfc
	 bpdXLBO6FMlKZX4+nt50zFvZtYxLmPvNqUlfO1LppqZ1bye5Cs2dQePsiyZA0nwhFD
	 o7fWMV8hcD5l2pgDbclkDR47D1rgMLAfcqSAUCxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 099/731] io_uring: check for iowq alloc_workqueue failure
Date: Tue,  8 Apr 2025 12:39:56 +0200
Message-ID: <20250408104916.571483495@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 7215469659cb9751a9bf80e43b24a48749004d26 ]

alloc_workqueue() can fail even during init in io_uring_init(), check
the result and panic if anything went wrong.

Fixes: 73eaa2b583493 ("io_uring: use private workqueue for exit work")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/3a046063902f888f66151f89fa42f84063b9727b.1738343083.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f7acae5f7e1d0..573b3f542b82a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3922,6 +3922,7 @@ static int __init io_uring_init(void)
 					  SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
 
 	iou_wq = alloc_workqueue("iou_exit", WQ_UNBOUND, 64);
+	BUG_ON(!iou_wq);
 
 #ifdef CONFIG_SYSCTL
 	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
-- 
2.39.5



