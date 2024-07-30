Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF211B583F;
	Tue, 30 Jul 2024 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355031; cv=none; b=dcm92H0OC54m8q9/p39rsAmlldgiMAWcWqC0Qj8uSTRV1WoNQFPgQLBUFxclfeB2VADvdqrqi6SoidcrpVT0P37Yacgii98h3jO0v3A4rpWTU8OHOo7XD/fuCDjVk/Q1H4NxuZUY2dFA3QA4b1INTiN31nyeZPNMiu6r91HY4wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355031; c=relaxed/simple;
	bh=PnjnShrL1rDisI8QQ+dVD9CPN0kaPXW7zKObTk6I7zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGRxhZh2sFmzIRrPrm/p3vTNFfEERZiMixTzQiggMsL4Ur+vKYWzZOUk4nCwoPDmOaExeo1nTYguFyv3DffX8hDjoxzsIbogI//HDkKsotG9FJUT/p/XW0DpUkHUNa1IBH9oA0q6Y1W4+PfZPXCbVHKsmrJsKbkPXQT3VsOHtms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOeaSXGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOeaSXGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33669C4AF0F;
	Tue, 30 Jul 2024 15:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355031;
	bh=PnjnShrL1rDisI8QQ+dVD9CPN0kaPXW7zKObTk6I7zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOeaSXGDzLTD41ezromRZllEUm4znDIRzBcuIfwaVwF6vjwIjA/3lkZ0vNOrbdlKJ
	 DS/GvARx8E7KE3MsQ7TZGbyXqIgyqLffMyoWEHQPtLYHsQXEwZ+kvkLThy52wk5TRl
	 XGVZ3bQswNy/vWzObdKV9j5R5qtU+wcp0WL5gTR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 013/809] io_uring: Fix probe of disabled operations
Date: Tue, 30 Jul 2024 17:38:09 +0200
Message-ID: <20240730151725.182900251@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit 3e05b222382ec67dce7358d50b6006e91d028d8b ]

io_probe checks io_issue_def->not_supported, but we never really set
that field, as we mark non-supported functions through a specific ->prep
handler.  This means we end up returning IO_URING_OP_SUPPORTED, even for
disabled operations.  Fix it by just checking the prep handler itself.

Fixes: 66f4af93da57 ("io_uring: add support for probing opcodes")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://lore.kernel.org/r/20240619020620.5301-2-krisman@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/opdef.c    | 8 ++++++++
 io_uring/opdef.h    | 4 ++--
 io_uring/register.c | 2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 2e3b7b16effb3..760006ccc4083 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -725,6 +725,14 @@ const char *io_uring_get_opcode(u8 opcode)
 	return "INVALID";
 }
 
+bool io_uring_op_supported(u8 opcode)
+{
+	if (opcode < IORING_OP_LAST &&
+	    io_issue_defs[opcode].prep != io_eopnotsupp_prep)
+		return true;
+	return false;
+}
+
 void __init io_uring_optable_init(void)
 {
 	int i;
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 7ee6f5aa90aa3..14456436ff74a 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -17,8 +17,6 @@ struct io_issue_def {
 	unsigned		poll_exclusive : 1;
 	/* op supports buffer selection */
 	unsigned		buffer_select : 1;
-	/* opcode is not supported by this kernel */
-	unsigned		not_supported : 1;
 	/* skip auditing */
 	unsigned		audit_skip : 1;
 	/* supports ioprio */
@@ -47,5 +45,7 @@ struct io_cold_def {
 extern const struct io_issue_def io_issue_defs[];
 extern const struct io_cold_def io_cold_defs[];
 
+bool io_uring_op_supported(u8 opcode);
+
 void io_uring_optable_init(void);
 #endif
diff --git a/io_uring/register.c b/io_uring/register.c
index c0010a66a6f2c..11517b34cfc8f 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -113,7 +113,7 @@ static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
 
 	for (i = 0; i < nr_args; i++) {
 		p->ops[i].op = i;
-		if (!io_issue_defs[i].not_supported)
+		if (io_uring_op_supported(i))
 			p->ops[i].flags = IO_URING_OP_SUPPORTED;
 	}
 	p->ops_len = i;
-- 
2.43.0



