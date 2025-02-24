Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98D338DD8;
	Mon, 24 Feb 2025 15:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409205; cv=none; b=ZgRfb956ZFsUn4FKEUmqop9VxfsE16yigQNJZnqGAm//wyvsU3JJGbbJm3/5ynTksK07c6sxLaLpgYDMQyL1hBjsCDhlgZuWu+K+kpYCYnHOxXknE4sgktNgm2av2QqwjET5hM2RPuO1ifbx2s99MJaZPkM2/szwdmfsEdgx72M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409205; c=relaxed/simple;
	bh=NTMiOfpWSN/c7L1S5SJIapGixZggaEfFR+qVg+2lZRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rd/Zu7FQdR0jf+VJq/DZ1H2OkvMyYp4wW/D8tENXaCV8L5RlHyWglkpXkTp+8lR0LOyDUdV1mdtk9Efa96yLVdr2Oj4xDBPem7lWhKqKBCk1ThM0f/2LLHkucpB0KJupLXu/zDslPD+qOc87AwPhZw9kuWwRTgO0D97fJQUjduU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxMzJssA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxMzJssA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2542FC4CED6;
	Mon, 24 Feb 2025 15:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409205;
	bh=NTMiOfpWSN/c7L1S5SJIapGixZggaEfFR+qVg+2lZRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxMzJssAun+rVl4CZTpyDHjJMAMV2fqx8q+SZrvAlFsY4z9Ghs0lqyWNu28WXrmTU
	 0T7GXqFXpFq5+YWyPCFLCCPZEu6gh4VM4snbJBknUcGZg7xaYSE3W4JWQMKJ8uj2YM
	 gCvmqoZYT3BkRtxFsax98/RRA0ghEfRZhHEldEMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Li Zetao <lizetao1@huawei.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.13 096/138] io_uring: prevent opcode speculation
Date: Mon, 24 Feb 2025 15:35:26 +0100
Message-ID: <20250224142608.252309410@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2045,6 +2045,8 @@ static int io_init_req(struct io_ring_ct
 		req->opcode = 0;
 		return io_init_fail_req(req, -EINVAL);
 	}
+	opcode = array_index_nospec(opcode, IORING_OP_LAST);
+
 	def = &io_issue_defs[opcode];
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */


