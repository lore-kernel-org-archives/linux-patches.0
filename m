Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C0D332914;
	Fri, 17 Oct 2025 15:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715168; cv=none; b=TJxJtpxOk3hxV/etOwM1siguAP5XXD7flixPRMeQ4k7O8HcyLJawO2nf/dDhrcde9HP3tlbfWqGU24mu2HeyDpI2PNhkWrt43f7Tlk++TRsbQZ715c5T2MYJqloBZTJWP8MRVPqYrt32XkOlMwle1h2d870rH76COV5bcCMa2dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715168; c=relaxed/simple;
	bh=pS6SaHVJzV5iXS/V77q7xTh0MqlWIEVDizkKYdR4pzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnLXmaHYaFqWpfCzG2ssXVqeP44n0qIAqLLT4jg7rfxDeyaq1d2Jgxb+JhGNa2dEH0WEdH40wURu2kT1LgmFHCsl5jPEX7+8BK2DoESg82nu/nt2Wm9Y0BmXoLSa9X/0gGene3m7TDK4r2X+MzFF29p2N179U8Z01ePyY+zmAB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQ8TNWZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQ8TNWZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9142BC4CEE7;
	Fri, 17 Oct 2025 15:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715168;
	bh=pS6SaHVJzV5iXS/V77q7xTh0MqlWIEVDizkKYdR4pzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQ8TNWZIMBUJGTCpJifUzRjP1iadNVJfG7IlWJTwQ3oRpQZZtJtsDrgKdPCx94A2s
	 z8WIgD/1Wno2xR+6ZPNSxi+B/7texkwEH2dfe0ZjM+rJXdY1mf9b0M71/OJrQM7LlS
	 b00QOg8azghQlO9tXR/ZlejHwJ+NVFtniDz8FF64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 120/371] io_uring/zcrx: increment fallback loop src offset
Date: Fri, 17 Oct 2025 16:51:35 +0200
Message-ID: <20251017145206.276956328@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit e9a9dcb4ccb32446165800a9d83058e95c4833d2 ]

Don't forget to adjust the source offset in io_copy_page(), otherwise
it'll be copying into the same location in some cases for highmem
setups.

Fixes: e67645bb7f3f4 ("io_uring/zcrx: prepare fallback for larger pages")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/zcrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 643a69f9ffe2a..2035c77a16357 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -993,6 +993,7 @@ static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
 
 		cc->size -= n;
 		cc->offset += n;
+		src_offset += n;
 		len -= n;
 		copied += n;
 	}
-- 
2.51.0



