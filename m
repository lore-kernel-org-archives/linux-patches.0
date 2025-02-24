Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1379984A35;
	Mon, 24 Feb 2025 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408629; cv=none; b=qOnM1HsxJX+LN32U9KbkIeKJ3bAq54lkwsj1MR11ye0bsGJMuqNWESI158fKkKH9FN+aw0rrV4/nU/ZavO4e+BsM52K8jKkFzb0fPRW5dhehhCXyLUQ2YuTS+LiWH020KKqn06RhQGQ/tgiW9uD0YrQ9BxNE9wtqaWseexeUkGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408629; c=relaxed/simple;
	bh=zc9OTsf102lbE/wyikEB7D3BK0aKlGAKFz/hR19z8QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvfID5CFmTcsG+VvuwHKZ+el1cskdJHnw1omq9YfcP9SDEO50r4qEAliHpL1UABikIAbHEuHYqt60if6rR7QZvxc7pjINljWTm/wFxQIKPM8BYrxC64u/aetYcChg4PVc1Gl6lw+p8nEPqSvKkq5+FGNLYZUatNXvOpc7YjcAGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlZaPhe3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlZaPhe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77207C4CEE9;
	Mon, 24 Feb 2025 14:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408629;
	bh=zc9OTsf102lbE/wyikEB7D3BK0aKlGAKFz/hR19z8QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlZaPhe3Q/qJxGlmod5YKtJgpvFm7k8e8wa76hsPIhEipmc7Uyzy/9GMu0f93Aih6
	 wSZCNqLAjwK3ma6p1RLVm5J3ih4evf+D+9JJCFjQPROG2U8TMnMvCPHqQJuF01XrrC
	 SmTOq3YgKAme34rPEZvPUyv3s3ffhx3hUNdL23ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Li Zetao <lizetao1@huawei.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 113/154] io_uring: prevent opcode speculation
Date: Mon, 24 Feb 2025 15:35:12 +0100
Message-ID: <20250224142611.481940404@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit 1e988c3fe1264708f4f92109203ac5b1d65de50b upstream.

sqe->opcode is used for different tables, make sure we santitise it
against speculations.

Cc: stable@vger.kernel.org
Fixes: d3656344fea03 ("io_uring: add lookup table for various opcode needs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Li Zetao <lizetao1@huawei.com>
Link: https://lore.kernel.org/r/7eddbf31c8ca0a3947f8ed98271acc2b4349c016.1739568408.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2053,6 +2053,8 @@ static int io_init_req(struct io_ring_ct
 		req->opcode = 0;
 		return io_init_fail_req(req, -EINVAL);
 	}
+	opcode = array_index_nospec(opcode, IORING_OP_LAST);
+
 	def = &io_issue_defs[opcode];
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */


