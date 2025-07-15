Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9EA2C327B;
	Tue, 15 Jul 2025 13:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585741; cv=none; b=lGmPzZAk9PQhhZLlEY7WRaDLpuJAPbUqoPjuN7bBcAAAdLVO482SI0I/4gNZo9eyY0XOZiTC9A3SwDAAW4an/RLBusnSediQQEMbuxI4t83ujiGZs2mkNdJ/ASvwxYGxr6dkna8OgQSHO8vTePr0Wm+ETwGvgvuTs8NCmt/iXa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585741; c=relaxed/simple;
	bh=148ksKIhFhcUaFoaSLYq47gHSA9tDatwC8RKuBe/MDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/v3gPKGkVYhEY6pivyEzjNP0yZ6ml4TUANABRrLhIXR43cNhl70E5AUmr9J0u0RuulOw9N6AltSehtsvhofkRut4tNNJThkG8+9BAogqixeFMfqvfXzEceXFe5yUXJaR1OxciJyGBpGEFpHZSjLbb2QsjSadUYEQrJFQJDIvIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMizBpW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMizBpW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAC1C4CEE3;
	Tue, 15 Jul 2025 13:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585741;
	bh=148ksKIhFhcUaFoaSLYq47gHSA9tDatwC8RKuBe/MDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMizBpW0F9AlIZ+/EbkbxxxkLid+vzCLbiYOHw7oQlbAavG2VDaAlMi1n0NWsysDw
	 O9WJ5NATUYC3uozhzQTl/YvKx8CnwCsPvkiZPcJ9iMI/f7GPLjpY+vIa624kNdbTTm
	 4inVbJX14GnbChk0Wxb4JGWm6fVXxLu0MZSqPZm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/163] erofs: fix to add missing tracepoint in erofs_readahead()
Date: Tue, 15 Jul 2025 15:13:11 +0200
Message-ID: <20250715130813.784133529@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit d53238b614e01266a3d36b417b60a502e0698504 ]

Commit 771c994ea51f ("erofs: convert all uncompressed cases to iomap")
converts to use iomap interface, it removed trace_erofs_readahead()
tracepoint in the meantime, let's add it back.

Fixes: 771c994ea51f ("erofs: convert all uncompressed cases to iomap")
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250707084832.2725677-1-chao@kernel.org
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/data.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index a2ab92ceb9325..91182d5e3a66c 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -391,6 +391,9 @@ static int erofs_read_folio(struct file *file, struct folio *folio)
 
 static void erofs_readahead(struct readahead_control *rac)
 {
+	trace_erofs_readahead(rac->mapping->host, readahead_index(rac),
+					readahead_count(rac), true);
+
 	return iomap_readahead(rac, &erofs_iomap_ops);
 }
 
-- 
2.39.5



