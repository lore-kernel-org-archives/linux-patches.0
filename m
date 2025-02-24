Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592C927701;
	Mon, 24 Feb 2025 14:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408136; cv=none; b=aXKv+R+85BvnNy6DjiJPF1pGKGgh6t5XIkwuHOsDj5U2/NsLhuUqaG2AvbH81deU2xZPac/t5jTpM4RKBtScZuEsDv1SPwBu4pgf278jDGNP1hsrJXqO6tyWtC3Rzy1gcIfOlRLj+W1czgBVSzp3CLsITkM2KJjU+b0NnjlPAHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408136; c=relaxed/simple;
	bh=V5g9xnCo7isq5odYTRziAt5TFsAsOCQTJ0tGyqs31WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmEX/glp0tl9hqN6iotMDNamI+T3Wr4Vm2ws202PqAYgOAEks493Qw7q/wVpfgUHnzjk5ljiqx5xV2x1E8lusYF3DGrWAP4k0VUEMzoRfQABSKW3Ya584dSVvfJpCZgC9E03iJ7VNuM/c+DxfVIJwyLwYaFshTQp9VeVDs1W/Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCsxtqEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCsxtqEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0987C4CED6;
	Mon, 24 Feb 2025 14:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408136;
	bh=V5g9xnCo7isq5odYTRziAt5TFsAsOCQTJ0tGyqs31WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCsxtqEoCDx8sb1IF1yzKlD4S+3rEwX+q8xPxKQA/RhFndbXNSUXxr/BjLb/ynMW6
	 6YF/S94xogk463BMC+catQ/FqDUuNGOtAIaZmndgljUArhLZh0vr0NwJkXeN/lXUrw
	 gLyuR3Vh/1T2osKGP6GrPjdwf2FJepMGAcx8bAGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Li Zetao <lizetao1@huawei.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 111/140] io_uring: prevent opcode speculation
Date: Mon, 24 Feb 2025 15:35:10 +0100
Message-ID: <20250224142607.376850762@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2176,6 +2176,8 @@ static int io_init_req(struct io_ring_ct
 		req->opcode = 0;
 		return io_init_fail_req(req, -EINVAL);
 	}
+	opcode = array_index_nospec(opcode, IORING_OP_LAST);
+
 	def = &io_issue_defs[opcode];
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */


