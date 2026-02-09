Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C13A1DE8AD;
	Mon,  9 Feb 2026 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647557; cv=none; b=bHOSrmtKOk/vpKZfjcLv9CIDagkl20tZ/WVF7zMz/WAQUvGLWzDeQkBrY/4SuvEY81AZztyCA2lZna46lquDglbqBtlGTmCS8MW8Uzm8FWUwYvxOwBg6+HDU4lENCYN8dmSvpTsvJRmi9+o1yUaaF4Mj7PhfDQucE3R+SRlTbN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647557; c=relaxed/simple;
	bh=FPpIEBsdHxChug1qsevlscgATnk0bngBVPXcBjYN544=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYQFulsC4j+dyrn1HTpyciyQHa3GLZYOF+xg0mV6lv5LkLe6gZlYhiY4K9ZUEcrcDiNNH9XedQfCcI6fAZ+0xKN+qA8ET7b3E3ZK1xJ3Gz4quL5T930T066qt97K9C25HFZADkGjlAhUWSVG2sWIco+O119itJuLWfRNA38HpPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIYrsdM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIYrsdM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6644C116C6;
	Mon,  9 Feb 2026 14:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647557;
	bh=FPpIEBsdHxChug1qsevlscgATnk0bngBVPXcBjYN544=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIYrsdM73QzI7jcwSyfhD45Yhz5Qm0aG6uWHO298UuENgd1zX18wwkgxmBNFLfSPl
	 2whetJp+iZZN6i5prdcT7eoHDUhHPFLAwDOuC5/b86JLVQ6Cj6/icbXvqccXKvWlmr
	 kyHHfCXUfi8eIBNZ8S+oYaVFYFMUuO1R01YFxcV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/175] io_uring/zcrx: fix page array leak
Date: Mon,  9 Feb 2026 15:23:29 +0100
Message-ID: <20260209142325.402912791@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 0ae91d8ab70922fb74c22c20bedcb69459579b1c ]

d9f595b9a65e ("io_uring/zcrx: fix leaking pages on sg init fail") fixed
a page leakage but didn't free the page array, release it as well.

Fixes: b84621d96ee02 ("io_uring/zcrx: allocate sgtable for umem areas")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/zcrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 875ad40cf6591..03396769c775d 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -196,6 +196,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 					GFP_KERNEL_ACCOUNT);
 	if (ret) {
 		unpin_user_pages(pages, nr_pages);
+		kvfree(pages);
 		return ret;
 	}
 
-- 
2.51.0



